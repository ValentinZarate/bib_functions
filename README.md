**The cycle uses Research Rabbit and custom R filtering functions. The diagram should be simple and clear. Here are the steps involved:**

1. **Create Seed Studies (SS0):**
   - Use traditional search engines like Scopus and Google Scholar.
   - Employ search sequences with Boolean operators to compile an initial set of studies, called Seed Studies (SS0). Sub-index '0' representing the '0 cycle of search'.

2. **Expand Seed Studies (ESi):**
   - Import the SS0 studies as BibTeX into Research Rabbit, the artificial intelligence platform.
   - For each Seed Study, Research Rabbit will retrieve all its references and citations, and then export each of these as BibTeX. We will end up with 2 x SS0 BibTeX files, one for references and one for citations of each SS.
   - This expansion produces a new, larger set of studies called Expanded Studies (ES1). In this case, the sub-index '1' indicates that this set is in the first search cycle. 

3. **Filter Expanded Studies (FSi):**
   - Use a search sequence (the same used to create SS0) to filter the ES1 dataset.
   - Remove all studies that aren't useful using the function [`all_bib_to_df`](./'all_bib_to_df'%20function), resulting in a Filtered Studies (FS1) dataset, with a sub-index '1', similar to ES1.

4. **Remove Duplicates and Create New Seed Studies (SSi):**
   - Overlap the FS1 dataset with the SS0 dataset to create a New Seed Studies (SS1) dataset, that only contains new studies, that is, all studies present in FS1 but not in SS0.

5. **Repeat the Cycle:**
   - Repeat the cycle for SS1, starting from step 2. That is, the SS1 dataset should be expanded using Research Rabbit (obtaining ES2), filtered (obtaining FS2) and then duplicates should be removed using SS1 as the background dataset.

**This process is iterative, allowing for continuous refinement and expansion of the dataset, facilitating comprehensive meta-analysis and reviews. The workflow of this search method is summarized in the diagram:**



## BibTeX filtering functions
This repository contains a set of R functions designed to filter and process BibTeX files based on specified keyword criteria. These functions facilitate the extraction of relevant bibliographic entries from large datasets, making it easier to manage and analyze academic literature. Below is an overview of the primary functions included in this repository:

### Description of Functions
### _bib_to_filtered_
Purpose: This function filters a BibTeX file based on a vector of keywords.

#### Arguments:
_bib_data_: A BibTeX file (as a character string or BibEntry object) containing at least 'abstract' and 'title' fields.
_keywords_: A vector of keywords to filter the data frame. These keywords will be searched in the 'title' and 'abstract' columns. _it also could be indicated searches in other sections_

#### Details:
The function reads the BibTeX file and converts it to a data frame. It then constructs a keyword pattern from the keywords vector and filters the entries where at least one keyword appears in either the 'title' or 'abstract'. The result is a filtered data frame with the relevant entries.

### _process_bib_files_
Purpose: This function processes all BibTeX files in the current directory, applying keyword filtering and removing duplicate entries based on the DOI.

#### Arguments:
_keywords_: A vector of keywords used for filtering.

#### Details:
The function lists all .bib files in the current directory and applies the bib_to_filtered function to each file. It combines the filtered results and removes duplicate entries based on the DOI, resulting in a combined data frame.

### _other_seq_
_Purpose_: This function filters a given data frame based on a vector of keywords.

#### Arguments:
_data_: A data frame to be filtered.
_keywords_: A vector of keywords used for filtering.

#### Details:
The function constructs a keyword pattern from the keywords vector and filters the entries in the data frame where at least one keyword appears in either the 'title' or 'abstract'. The result is a filtered data frame with the relevant entries.

### _all_bib_to_df_
Purpose: This function processes BibTeX files to filter entries based on a list of keyword vectors, applying multiple sequences of keywords.

#### Arguments:
_keywords_list_: A list of keyword vectors. Each vector represents a sequence of words connected by an OR boolean operator, and the list represents a group of sequences (each vector) connected by an AND boolean operator.

#### Details:
The function all_bib_to_df processes BibTeX files to filter entries based on a list of keywords. It will apply the keyword list to all BibTeX in the working directory.
Keyword List Format: The keyword list should be a list of word vectors. Each vector represents a sequence of words connected by an OR boolean operator (represented by commas within the vector). The union among each vector into the list will be assumed as an AND boolean operator. .
 
#### _Function Implementation_: 
The function utilizes packages such as 'dplyr', 'stringr', and 'RefManageR'. It also uses a helper function _bib_to_filtered_ to handle the filtering process. The function reads all BibTeX files in the working directory, applies the keyword filtering, and combines the results into a single filtered data frame. The filtering is performed iteratively to ensure each keyword vector's criteria are met.
The function reads all BibTeX files in the current directory and applies the bib_to_filtered function using the first set of keywords from keywords_list. It then iteratively filters the combined data frame using the remaining sets of keywords. The result is a combined and filtered data frame containing entries that match all keyword sequences.

#### Detailed Explanation (_steps_):

##### _Load Required Packages_:
The function begins by loading the required packages: dplyr, stringr, and RefManageR.

##### _Define Helper Function_:
_bib_to_filtered_ is a helper function that reads and processes a single BibTeX file, filtering entries based on a given set of keywords.

##### Converts BibTeX data to a data frame.
Creates a keyword pattern for the OR condition.
Filters entries where the 'title' or 'abstract' contains any of the keywords.
##### Get BibTeX Files:
The function lists all .bib files in the working directory.

##### Initial Filtering:
Applies the _bib_to_filtered_ function to each BibTeX file using the first set of keywords. Combines and deduplicates the filtered data frames.

##### Iterate Over Keyword Vectors:
For each remaining set of keywords, it further filters the combined data frame to include only entries that match the current set of keywords.

##### Return Result:
The final filtered data frame is returned.
