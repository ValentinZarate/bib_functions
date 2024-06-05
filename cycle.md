# Cycle for searching studies using [Research Rabbit](https://researchrabbitapp.com/home) and [`all_bib_to_df`](./'all_bib_to_df'%20function)

## The cycle uses Research Rabbit and custom R filtering functions. The diagram should be simple and clear.

### Here are the steps involved:

#### 1. **Create Seed Studies (SS<sub>i</sub>):**
   - Use traditional search engines like Scopus and Google Scholar.
   - Employ search sequences with Boolean operators to compile an initial set of studies. This dataset will be called Seed Studies (SS<sub>1</sub>). Sub-index 'i' represents the 'i-th cycle of search'. For the first cycle of search, SS<sub>1</sub> will be created using the traditional search engines, but in the second cycle (i.e., i = 2), SS<sub>2</sub> will be created from overlapping FS<sub>1</sub> and SS<sub>1</sub>, and extracting unique studies only present in FS<sub>1</sub> (see [step 4](#4-remove-duplicates-and-create-new-seed-studies-sssubisub)). This will be repeated for all subsequent cycles of search.

#### 2. **Expand Seed Studies (ES<sub>i</sub>):**
   - Import the SS<sub>i</sub> studies as BibTeX to [Research Rabbit](https://researchrabbitapp.com/home).
   - For each SS<sub>i</sub>, Research Rabbit will retrieve all its references and citations and you need to export each group of references as BibTeX. We will end up with 2 BibTeX files per study inside the SS<sub>i</sub> dataset, one for references and one for citations of each study inside the SS<sub>i</sub> dataset. All BibTeX files should be saved in the same directory as the R script in which [`all_bib_to_df`](./'all_bib_to_df'%20function) will be run.
   - This expansion produces a new, larger set of studies called Expanded Studies (ES<sub>i</sub>).

#### 3. **Filter Expanded Studies (FS<sub>i</sub>):**
   - Use a search sequence (the same used to create SS<sub>1</sub>) to filter the ES<sub>1</sub> dataset using the [`all_bib_to_df`](./'all_bib_to_df'%20function).
   - The function will remove all studies that aren't useful, including duplicates inside the large (ES<sub>i</sub>) dataset. This will result in a Filtered Studies (FS<sub>i</sub>) dataset.

#### 4. **Remove Duplicates and Create New Seed Studies (SS<sub>i+1</sub>):**
   - Overlap the FS<sub>i</sub> dataset with a combined dataset of all previous Seed Studies (SS<sub>1</sub> + SS<sub>2</sub> + ... + SS<sub>i</sub>). This combined dataset will be referred to as SS<sub>1:i</sub>.
   - The goal is to create a New Seed Studies dataset (SS<sub>i+1</sub>) that only contains studies present in FS<sub>i</sub> but not in SS<sub>1:i</sub>.
   - This can be done easily in R using the `anti_join` function of the `dplyr` package. Example:
     ```r
     SSi_plus_1 <- anti_join(FSi, bind_rows(SS1, SS2, SS3, ..., SSi), by = c("doi", "title"))
     ```

#### 5. **Repeat the Cycle:**
   - Repeat the cycle for SS<sub>i+1</sub>, starting from step 2. That is, the SS<sub>i+1</sub> dataset should be expanded using Research Rabbit (obtaining ES<sub>i+1</sub>), filtered (obtaining FS<sub>i+1</sub>), and then non-unique studies should be removed using SS<sub>i+1</sub> as the background dataset. This will result in a new dataset SS<sub>i+2</sub>. SS<sub>i+2</sub> will re-enter the cycle at step 2 and so on, until reaching SS<sub>n</sub>.

**This process is iterative, allowing for continuous refinement and expansion of the dataset, facilitating comprehensive meta-analysis and reviews. The workflow of this search method is summarized in the diagram:**

<div style="text-align: center;">
  <img src="./images/cycle.png" alt="Diagrama de flujo" width="600"/>
</div>

## When to stop?

The main objective of this cycle is to exhaust all references linked to the initial 'keyword sequence'. The novelty is the inclusion of powerful and free tools such as Research Rabbit (which could be applied to [Litmaps](https://www.litmaps.com/) as well). The final number of cycles 'n' needed to exhaust all references is unknown and will depend on the keyword sequences and topic of research. However, we can assume that 'i' has reached 'n' when SS<sub>i+1</sub> (SSi_plus_1 <- anti_join(FSi, SSi, by = c("doi", "title")) is empty.

