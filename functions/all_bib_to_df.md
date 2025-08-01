## The `all_bib_to_df` function 
### This function processes BibTeX files to filter entries based on a list of keywords. It operates in two main steps:

1. **Keyword List Format**: The keyword list should be a list of word vectors. Each vector represents a sequence of words connected by an OR boolean operator (represented by commas within the vector). The combination of these vectors in the list is connected by an AND boolean operator. This means the function will filter all BibTeX files within the same directory as the script, including an entry if at least one word from each vector is present in either the 'abstract' or 'title'. Entries not meeting this criterion are excluded.

2. **Function Implementation**: The function utilizes funtcions of the packages `dplyr`, `stringr`, and `RefManageR`. It also uses an customize auxiliary function `bib_to_filtered` to handle the filtering process. The function reads all BibTeX files in the directory, applies the keyword filtering, and combines the results into a single filtered data frame. The filtering is performed iteratively to ensure each keyword vector's criteria are met.

```r
all_bib_to_df <- function(keywords_list, cycle_num) {
  required_packages <- c("dplyr", "stringr", "RefManageR")
  lapply(required_packages, require, character.only = TRUE)

  cycle_folder <- paste0("cycle", cycle_num)
  directory <- file.path(getwd(), cycle_folder)
  
  bib_files <- list.files(path = directory, pattern = "\\.bib$", full.names = TRUE)
  if(length(bib_files) == 0) {
    stop("No se encontraron archivos .bib en la carpeta: ", cycle_folder)
  }

  bib_to_filtered <- function(bib_data, keywords) {
    if (is.character(bib_data)) {
      bib_data <- RefManageR::ReadBib(bib_data)
    }
    bib_df <- as.data.frame(bib_data)
    rownames(bib_df) <- NULL

    if (!"title" %in% names(bib_df)) bib_df$title <- ""
    if (!"abstract" %in% names(bib_df)) bib_df$abstract <- ""

    keyword_pattern <- paste(keywords, collapse = "|")
    filtered_df <- bib_df %>%
      mutate(keyword_detected = if_else(
        str_detect(title, regex(keyword_pattern, ignore_case = TRUE)) |
        str_detect(abstract, regex(keyword_pattern, ignore_case = TRUE)),
        "yes", "no"
      )) %>%
      filter(keyword_detected == "yes") %>%
      select(-keyword_detected)
    return(filtered_df)
  }

  filtered_dfs <- lapply(bib_files, bib_to_filtered, keywords_list[[1]])
  combined_df <- bind_rows(filtered_dfs) %>% distinct(doi, .keep_all = TRUE)

  for (i in 2:length(keywords_list)) {
    keyword_pattern <- paste(keywords_list[[i]], collapse = "|")
    combined_df <- combined_df %>%
      mutate(keyword_detected = if_else(
        str_detect(title, regex(keyword_pattern, ignore_case = TRUE)) |
        str_detect(abstract, regex(keyword_pattern, ignore_case = TRUE)),
        "yes", "no")) %>%
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
keywords2 <- c("sleep", "sleeps", "sleeping", "roost", "roosts", "roosting","nest", "nests", "nesting","sleeping site", "sleep site", "sleeping tree", "night site", "night sites")
```
### From those vector we create a list.

```r
keywords_list <- list(keywords1, keywords2)
```
### the list will be applyied to all bib files in the working directory
```r
result <- all_bib_to_df (keywords_list, cycle)
```
