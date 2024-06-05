*The cycle uses Research Rabbit and custom R filtering functions. The diagram should be simple and clear. Here are the steps involved:*

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
