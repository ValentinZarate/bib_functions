## The `all_bib_to_df` function 
### This function processes BibTeX files to filter entries based on a list of keywords. It operates in two main steps:

1. **Keyword List Format**: The keyword list should be a list of word vectors. Each vector represents a sequence of words connected by an OR boolean operator (represented by commas within the vector). The combination of these vectors in the list is connected by an AND boolean operator. This means the function will filter all BibTeX files within the same directory as the script, including an entry if at least one word from each vector is present in either the 'abstract' or 'title'. Entries not meeting this criterion are excluded.

2. **Function Implementation**: The function utilizes funtcions of the packages `dplyr`, `stringr`, and `RefManageR`. It also uses an customize auxiliary function `bib_to_filtered` to handle the filtering process. The function reads all BibTeX files in the directory, applies the keyword filtering, and combines the results into a single filtered data frame. The filtering is performed iteratively to ensure each keyword vector's criteria are met.

```r
all_bib_to_df <- function(keywords_list) {
  
  required_packages <- c("dplyr", "stringr", "RefManageR")
  lapply(required_packages, require, character.only = TRUE)

  bib_to_filtered <- function(bib_data, keywords) {
    if (is.character(bib_data)) {
      bib_data <- ReadBib(bib_data)
    }
    
    bib_df <- as.data.frame(bib_data)
    rownames(bib_df) <- NULL
    
    # Create the OR pattern
    
    keyword_pattern <- paste(keywords, collapse = "|")
    
    
    filtered_df <- bib_df %>%
      mutate(keyword_detected = if_else(
        str_detect(title, keyword_pattern) |
          str_detect(abstract, keyword_pattern),
        "yes",
        "no"
      )) %>%
      filter(keyword_detected == "yes") %>%
      select(-keyword_detected)
    
    return(filtered_df)
  }
  
  directory <- getwd()
  bib_files <- list.files(path = directory, pattern = "*.bib", full.names = TRUE)
  
  # The lapply function apply the bib_to_filtered function to each file that end with '.bib' in bib_files, using the first set of keywords from keywords_list.
  
  filtered_dfs <- lapply(bib_files, bib_to_filtered, keywords_list[[1]])
  combined_df <- bind_rows(filtered_dfs) %>%
    distinct(doi, .keep_all = TRUE)
  
  # This loop (i in 2:length(keywords_list)) will iterate over all the vectors within keywords_list, starting from the second vector to the end of the list. In this case, it only does it twice, but if I had 50 ANDs in my search sequence, it would do it 50 times.
  
  for (i in 2:length(keywords_list)) {
    keyword_pattern <- paste(keywords_list[[i]], collapse = "|")
    
    combined_df <- combined_df %>%
      mutate(keyword_detected = if_else(
        str_detect(title, keyword_pattern) | str_detect(abstract, keyword_pattern),
        "yes",
        "no")) %>%
      filter(keyword_detected == "yes") %>%
      select(-keyword_detected)
  }
  
  return(combined_df)
}
```
_This function reads all BibTeX files in the working directory, filters them based on the specified keyword criteria, and returns a combined and filtered data frame. Adjust the keywords_list according to your specific keyword sequences._

### example of keywords
```r 
keywords1 <- c("primate", "primates", "monkey", "monkeys", "ape", "apes")
keywords2 <- c(
  "sleep", "sleeps", "sleeping", 
  "roost", "roosts", "roosting",
  "nest", "nests", "nesting",
  "sleeping site", "sleep site", "sleeping tree", 
  "night site", "night sites"
)
```
### From those vector we create a list.

```r
keywords_list <- list(keywords1, keywords2)
```
### the list will be applyied to all bib files in the working directory
```r
result <- all_bib_to_df (keywords_list)
```
