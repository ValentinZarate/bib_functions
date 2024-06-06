# Cycle for searching studies using [Research Rabbit](https://researchrabbitapp.com/home) and [`all_bib_to_df`](./'all_bib_to_df'%20function)

<div style="font-size: 13px; font-weight: normal;">
  <i>This cyclic workflow is for expanding and filtering a dataset of studies. The expansion phase uses AI tools like Research Rabbit or <a href="https://www.litmaps.com/">Litmaps</a>, and the filtering phase employs custom R filtering functions. The goal of this workflow is to exhaust all studies using a keyword sequence. Additionally, it allows for the exhaustive examination of references using only <i>free</i> search engines and AI tools.</i>
</div>

### Here are the steps involved:

#### 1. **Initial Seed Studies dataset:**
   - Create the seed studies dataset using traditional search methods. Employ a keyword sequence (with boolean operators and truncation, for example) and search engines like Scopus, Web of Science, and Google Scholar. This will give you a first and quickly filtered (by title, abstract and keywords for example) dataset of studies, it is not a problem if studies are missing. 
   - This initial dataset will be called Seed Studies '0' (SS<sub>0</sub>). These studies should be organized in a reference manager software like Zotero, Mendeley, or EndNote to provide the correct format (BibTeX) for the next steps.
   - (SS<sub>0</sub>) dataset will be included in the final dataset (FD), which will be used for the systematic analysis.

#### 2. **Expand Seed Studies:**
   - Import the SS<sub>0</sub> studies as BibTeX to [Research Rabbit](https://researchrabbitapp.com/home).
   - Research Rabbit will retrieve all its references (studies cited by the seed study; previous studies) and citations (studies that cite each seed study; posterior studies) for each study included in SS<sub>0</sub> dataset. For each seed study inside SS<sub>0</sub>, we will have 2 BibTeX files: one for 'references' and one for 'citations'. All BibTeX files should be saved in the same directory (see why in step 3).
   - This expansion produces a new, larger set of studies called Expanded Studies (ES).

#### 3. **Filter Expanded Studies:**
   - We will use the same keyword sequence from 'step 1' (the one used to obtain SS<sub>0</sub>) to filter the ES dataset using the [`all_bib_to_df`](./'all_bib_to_df'%20function). This function requires that all BibTeX files are in the same working directory where the R script will be run.
   - The R function will remove all studies from ES that do not satisfy the keyword sequence, using their 'keywords', 'title', and 'abstract'. ES probably includes a lot of duplicate studies, so [`all_bib_to_df`](./'all_bib_to_df'%20function) also removes those redundant studies. The result of this filtering will be a smaller and filtered dataset called Filtered Studies (FS).

#### 4. **Keep Unique Studies:**
   - It is likely that FS contain a lot of studies already present in SS<sub>0</sub>, and thus in FD. therefore, the FS dataset will be overlapped with SS<sub>0</sub> to keep only the new studies provided by the expansion and filtering steps (steps 2 and 3). This new dataset of studies will be composed by all studies present in FS but not in the initial dataset SS<sub>0</sub>.
   - This new dataset will be called New Seed Studies (NSS), and will be added to the final dataset FD, together with all studies included in SS<sub>0</sub>.

#### 5. **Repeat the Cycle:**
   - The NSS will reinitiate the cycle, just like SS<sub>0</sub>. NSS<sub>1</sub>, sub-index '1', indicates that this dataset was created by one expanding-filtering cycle.
   - NSS<sub>1</sub> will be expanded with Research Rabbit, creating an ES<sub>1</sub> dataset (step 2).
   - ES<sub>1</sub> will be filtered with the [`all_bib_to_df`](./'all_bib_to_df'%20function) function, creating an FS<sub>1</sub> dataset (step 3).
   - The FS<sub>1</sub> dataset will be overlapped with the union of SS<sub>0</sub> and NSS<sub>1</sub> to find all unique studies and create the new seed studies dataset NSS<sub>2</sub>. NSS<sub>2</sub> will be added to the final dataset FD (together with SS<sub>0</sub> and NSS<sub>1</sub> studies) and reinitiate the cycle starting from step 2.
   - This cycle will be repeated 'n' times until NSS<sub>n</sub> is empty.

**Note:** The 4th step, which needs to unify FS<sub>i</sub> (i goes from 1 to n cycles) with the union of previous seed study datasets (NSS<sub>1:i</sub> = (SS<sub>0</sub> ∪ NSS<sub>1</sub> ∪ NSS<sub>2</sub> ∪ ... ∪ NSS<sub>n</sub>)) can be done in R using the `anti_join` function of the `dplyr` package, using the 'doi' and 'title' to detect duplicates. Example:

   ```r
   SSi_plus_1 <- anti_join(FSi, bind_rows(SS0, NSS1, ..., NSSn), by = c("doi", "title"))
   ```

**This process is iterative, allowing for continuous refinement and expansion of the dataset, facilitating comprehensive meta-analyses and reviews. The workflow of this search method is summarized in the diagram:**

<p align="center">
  <img src="../images/cycle_complete.png" alt="Diagrama de flujo" width="600"/>
</p>

_This diagram represents the workflow of the 5 steps of the cycle for expanding and filtering studies using Research Rabbit and the 'all_bib_to_df' R function. SS<sub>0</sub> is the seed studies dataset obtained from search engines and a keyword sequence (traditional approach); FD is the final dataset of studies that will result in the table used to continue with the meta-analysis; ES is the expanded dataset created from a seed studies dataset (SS<sub>0</sub> or NSS). FS is the dataset resulting from filtering ES with the 'all_bib_to_df' function and the keyword sequence; NSS is the new dataset of studies resulting from extracting unique studies from FS. NSS will be added to the FD and will also reinitiate the expanding-filtering cycle (blue)_
 
## When to stop?

The main objective of this cycle is to exhaust all references linked to the initial 'keyword sequence'. The novelty is the inclusion of powerful and free tools such as Research Rabbit (which could be applied to [Litmaps](https://www.litmaps.com/) as well). The final number of cycles 'n' needed to exhaust all references is unknown and will depend on the keyword sequences and topic of research. However, we can assume that 'i' has reached 'n' when SS<sub>i+1</sub> (SSi_plus_1 <- anti_join(FSi, SSi, by = c("doi", "title")) is empty.

