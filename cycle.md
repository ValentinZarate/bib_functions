# Cycle for searching studies using [Research Rabbit](https://researchrabbitapp.com/home) and [`all_bib_to_df`](./'all_bib_to_df'%20function)

## The cycle uses Research Rabbit and custom R filtering functions. The diagram should be simple and clear. 
### Here are the steps involved:

1. **Create Seed Studies (SS<sub>0</sub>):**
   - Use traditional search engines like Scopus and Google Scholar.
   - Employ search sequences with Boolean operators to compile an initial set of studies, called Seed Studies (SS<sub>0</sub>). Sub-index '0' representing the '0 cycle of search'.

2. **Expand Seed Studies (ES<sub>i</sub>):**
   - Import the SS<sub>0</sub> studies as BibTeX into Research Rabbit, the artificial intelligence platform.
   - For each Seed Study, Research Rabbit will retrieve all its references and citations, then export each of these as BibTeX. We will end up with 2 x SS<sub>0</sub> BibTeX files, one for references and one for citations of each SS.
   - This expansion produces a new, larger set of studies called Expanded Studies (ES<sub>1</sub>). In this case, the sub-index '1' indicates that this set is in the first search cycle. 

3. **Filter Expanded Studies (FS<sub>i</sub>):**
   - Use a search sequence (the same used to create SS<sub>0</sub>) to filter the ES<sub>1</sub> dataset.
   - Remove all studies that aren't useful using the function [`all_bib_to_df`](./'all_bib_to_df'%20function), resulting in a Filtered Studies (FS<sub>1</sub>) dataset, with a sub-index '1', similar to ES<sub>1</sub>.

4. **Remove Duplicates and Create New Seed Studies (SS<sub>i</sub>):**
   - Overlap the FS<sub>1</sub> dataset with the SS<sub>0</sub> dataset to create a New Seed Studies (SS<sub>1</sub>) dataset, that only contains new studies, that is, all studies present in FS<sub>1</sub> but not in SS<sub>0</sub>.

5. **Repeat the Cycle:**
   - Repeat the cycle for SS<sub>1</sub>, starting from step 2. That is, the SS<sub>1</sub> dataset should be expanded using Research Rabbit (obtaining ES<sub>2</sub>), filtered (obtaining FS<sub>2</sub>) and then duplicates should be removed using SS<sub>1</sub> as the background dataset.

**This process is iterative, allowing for continuous refinement and expansion of the dataset, facilitating comprehensive meta-analysis and reviews. The workflow of this search method is summarized in the diagram:**

<img src="./images/cycle.png" alt="Diagrama de flujo" width="400"/>
