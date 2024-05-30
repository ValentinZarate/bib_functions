
# For the first function, the first argument should be a 'bib' format file that contains at least one column with 'abstract' and 
# another with 'title'. The second argument must be a vector of keywords that will be used to filter the data frame. 
# These keywords will be searched in the 'title' and 'abstract' columns.

bib_to_filtered <- function(bib_data, keywords) {
  
  if (is.character(bib_data)) {
    
    bib_data <- ReadBib(bib_data)
  }
  
  bib_df <- as.data.frame(bib_data)
  
  rownames(bib_df) <- NULL
  
  keyword_pattern <- paste(keywords, collapse = "|")
  
  
  filtered_df <- bib_df %>%
    mutate(keyword_detected = if_else(
      str_detect(title,
                 keyword_pattern) |
        str_detect(abstract, 
                   keyword_pattern),
      "yes",
      "no" )) %>%
    
    filter(keyword_detected == "yes") %>%
    
    select(-keyword_detected)
  
  return(filtered_df)
}


# This function uses the first function, 'bib_to_filtered'. In this case, it can create a data frame using all the 'bib' files
# that are in the same folder as the script, meaning they have the same directory. Additionally, it removes duplicate rows based 
# on the DOI.

process_bib_files <- function(keywords) {
  
  directory <- getwd()
  
  bib_files <- list.files(path = directory, pattern = "*.bib", full.names = TRUE)
  
  filtered_dfs <- lapply(bib_files, bib_to_filtered, keywords)
 
  combined_df <- bind_rows(filtered_dfs) %>%
    distinct(doi, .keep_all = TRUE)
  
  return(combined_df)
}


# Incorporating a data frame and a sequence of keywords (keyword vector). The idea is to incorporate the resulting data frame from
# the previous functions. For example, df <- process_bib_files(keywords) or df <- bib_to_filtered(bib_data, keywords).

other_seq <- function(data, keywords) {
  
  keyword_pattern <- paste(keywords, collapse = "|")
  
  filtered_df <- data %>%
    mutate(keyword_detected = if_else(
      str_detect(title, keyword_pattern) | str_detect(abstract, keyword_pattern),
      "yes",
      "no")) %>%
    filter(keyword_detected == "yes") %>%
    select(-keyword_detected)
  
  return(filtered_df)
}


##### 1 in one step. There are two important steps in the application of this function. 1) the keyword list should present the format
# of a list of word vectors, each vector represents a sequence of words connected by an OR boolean operator, 
# but should be represented as ','. The union of each vector into the list is represented by an 'AND' boolean operator.
# That is, the function will filter all bibs. files inside the same folder as the script. this filtering will based on the
# condition that 'abstract' or 'title' have at least one word of each word vector, but if the article does not have at least
# one word of one vector it will be excluded. The output is a filtered data frame. These functions used functions of 'dplyr' package, 
# 'stringr' and RefManager', and also it uses an auxiliary functions 'bib_to_filtered'

all_bib2df <- function(keywords_list) {
  
  required_packages <- c("dplyr", "stringr", "RefManageR")
  lapply(required_packages, require, character.only = TRUE)

  bib_to_filtered <- function(bib_data, keywords) {
    if (is.character(bib_data)) {
      bib_data <- ReadBib(bib_data)
    }
    
    bib_df <- as.data.frame(bib_data)
    rownames(bib_df) <- NULL
    
    # Create the keyword pattern, as they were separated by 'OR'
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
  
  # I use the lapply function to apply the bib_to_filtered function to each .bib file in bib_files, using the first set of keywords 
  # from keywords_list
  
  filtered_dfs <- lapply(bib_files, bib_to_filtered, keywords_list[[1]])
  combined_df <- bind_rows(filtered_dfs) %>%
    distinct(doi, .keep_all = TRUE)
  
  # The 'for' loop (for (i in 2:length(keywords_list))) will iterate over all the vectors within keywords_list, starting from
  # the second vector to the end of the list. In this case, it only does it twice, but if I had many ANDs in my search sequence,
  # it would do it that many times.
  
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

# The function requires a list of 'keywords', each element of the list must contain a search sequence with keywords that are
# separated by OR. Each sequence will be filtered separately as if they were separated by AND (mandatory inclusion).
# The function will then include all Bib files that are in the same folder as the script. 

keywords1 <- c("human", "humans", "fragmentation", "fragmented", "agricultural",
               "agriculture", "crop", "crops", "plantation", "plantations",
               "human-dominated", "human-modified","forestry", "production", 
               "commercial","harvested", "fragment", "fragments", "management",
               "land use", "athropogenic","logging", "managed", "anthropogenically", 
               "mosaic", "rural", "agriculture", "agroecosystem", "timber", "agro-forestry")

keywords2 <- c("mammal", "mammals", "mammalian")

keywords3 <- c("home range", "home ranges", "home-ranges", "home-range", 
               "ranging behavior", "kernel", "fixed-kernel", "kernel-density")

# keyword sequence, each vector is separated by 'AND' boolean operators.

keywords_list <- list(keywords1, keywords2, keywords3)

result <- all_bib2df(keywords_list)
