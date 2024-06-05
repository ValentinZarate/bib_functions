# Cycle for searching studies using [Research Rabbit](https://researchrabbitapp.com/home) and [`all_bib_to_df`](./'all_bib_to_df'%20function)

## The cycle uses Research Rabbit and custom R filtering functions. The diagram should be simple and clear. 
### Here are the steps involved:

#### 1. **Create Seed Studies (SS<sub>i</sub>):**
   - Use traditional search engines like Scopus and Google Scholar.
   - Employ search sequences with Boolean operators to compile an initial set of studies. This dataset of will be called Seed Studies (SS<sub>1</sub>). Sub-index 'i' represents the 'i cycle of search'. For the first cycle of search SS<sub>1</sub> will be created using the traditional search engines, but in the second cycle (i.e., i= 2), SS<sub>2</sub> will be created from overlapping FS <sub>1</sub> and SS<sub>1</sub>, and extracting unique studies only present in FS<sub>1</sub> (see [step 4](####4-remove-duplicates-and-create-new-seed-studies-sssubisub)). This will be repeated for all posterior cycles of search.

#### 2. **Expand Seed Studies (ES<sub>i</sub>):**
   - Import the SS<sub>i</sub> studies as BibTeX to [Research Rabbit](https://researchrabbitapp.com/home).
   - For each SS<sub>i</sub>, Research Rabbit will retrieve all its references and citations and is needed to export each group of references as BibTeX. We will end up with 2 BibTeX files per study inside the SS<sub>i</sub> dataset, one for references and one for citations of each study inside the SS<sub>i</sub> dataset. All BibTex files should be saved in the same directory of the R script in which [`all_bib_to_df Function`](./'all_bib_to_df'%20function) will be run.
   - This expansion produces a new, larger set of studies called Expanded Studies (ES<sub>i</sub>). 

#### 3. **Filter Expanded Studies (FS<sub>i</sub>):**
   - Use a search sequence (the same used to create SS<sub>1</sub>) to filter the ES<sub>1</sub> dataset using the [`all_bib_to_df`](./'all_bib_to_df'%20function).
   - The function will remove all studies that aren't useful using the function, including duplicates inside the large (ES<sub>i</sub>) dataset. This will result in a Filtered Studies (FS<sub>i</sub>) dataset.

#### 4. **Remove Duplicates and Create New Seed Studies (SS<sub>i</sub>):**
   - Overlap the FS<sub>1</sub> dataset with the SS<sub>0</sub> dataset to create a New Seed Studies (SS<sub>1</sub>) dataset, that only contains new studies, that is, all studies present in FS<sub>1</sub> but not in SS<sub>0</sub>. this can be done easily in R using the 'anti_join' function of the 'dyplr' package. Example: SSi_plus_1 <- anti_join(FSi, SSi, by = c("doi", "title"))

#### 5. **Repeat the Cycle:**
   - Repeat the cycle for SS<sub>i+1</sub>, starting from step 2. That is, the SS<sub>i+1</sub> dataset should be expanded using Research Rabbit (obtaining ES<sub>i+1</sub>), filtered (obtaining FS<sub>i+1</sub>) and then non-unique studies should be removed using SS<sub>i+1</sub> as the background dataset. This will result in a new dataset SS<sub>i+2</sub>. SS<sub>i+2</sub> will be reentry the cylce in step 2 and so on, until reaching SS<sub>n</sub>.

**This process is iterative, allowing for continuous refinement and expansion of the dataset, facilitating comprehensive meta-analysis and reviews. The workflow of this search method is summarized in the diagram:**

<img src="./images/cycle.png" alt="Diagrama de flujo" width="600"/>

## When stop?

