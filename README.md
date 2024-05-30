## BibTeX filtering functions
This repository contains a set of R functions designed to filter and process BibTeX files based on specified keyword criteria. These functions facilitate the extraction of relevant bibliographic entries from large datasets, making it easier to manage and analyze academic literature. Below is an overview of the primary functions included in this repository:

### Description of Functions
### bib_to_filtered
Purpose: This function filters a BibTeX file based on a vector of keywords.

#### Arguments:
_bib_data_: A BibTeX file (as a character string or BibEntry object) containing at least 'abstract' and 'title' fields.
_keywords_: A vector of keywords to filter the data frame. These keywords will be searched in the 'title' and 'abstract' columns. _it also could be indicated searches in other sections_
_Details_:
The function reads the BibTeX file and converts it to a data frame. It then constructs a keyword pattern from the keywords vector and filters the entries where at least one keyword appears in either the 'title' or 'abstract'. The result is a filtered data frame with the relevant entries.

### process_bib_files
Purpose: This function processes all BibTeX files in the current directory, applying keyword filtering and removing duplicate entries based on the DOI.

#### Arguments:
_keywords_: A vector of keywords used for filtering.
_Details_:
The function lists all .bib files in the current directory and applies the bib_to_filtered function to each file. It combines the filtered results and removes duplicate entries based on the DOI, resulting in a combined data frame.

### other_seq
_Purpose_: This function filters a given data frame based on a vector of keywords.

#### Arguments:
_data_: A data frame to be filtered.
_keywords_: A vector of keywords used for filtering.
_Details_:
The function constructs a keyword pattern from the keywords vector and filters the entries in the data frame where at least one keyword appears in either the 'title' or 'abstract'. The result is a filtered data frame with the relevant entries.

### all_bib_to_df
_Purpose_: This function processes BibTeX files to filter entries based on a list of keyword vectors, applying multiple sequences of keywords.

_Arguments_:
keywords_list: A list of keyword vectors. Each vector represents a sequence of words connected by an OR boolean operator, and the list represents sequences connected by an AND boolean operator.
_Details_:
The function all_bib_to_df processes BibTeX files to filter entries based on a list of keywords. The function operates in two main steps:
Keyword List Format: The keyword list should be a list of word vectors. Each vector represents a sequence of words connected by an OR boolean operator (represented by commas within the vector). The combination of these vectors in the list is connected by an AND boolean operator. This means the function will filter all BibTeX files within the same directory as the script, including an entry if at least one word from each vector is present in either the 'abstract' or 'title'. Entries not meeting this criterion are excluded.
 
_Function Implementation_: The function utilizes packages such as 'dplyr', 'stringr', and 'RefManageR'. It also uses an auxiliary function bib_to_filtered to handle the filtering process. The function reads all BibTeX files in the directory, applies the keyword filtering, and combines the results into a single filtered data frame. The filtering is performed iteratively to ensure each keyword vector's criteria are met.
The function reads all BibTeX files in the current directory and applies the bib_to_filtered function using the first set of keywords from keywords_list. It then iteratively filters the combined data frame using the remaining sets of keywords. The result is a combined and filtered data frame containing entries that match all keyword sequences.
