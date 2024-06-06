## 1<sup>era</sup> función 'bib_to_filtered'
_se le debe ingresar un archivo formato 'bib' en el primer argumento que tenga al menos una columna con 'abstract' y otra 'title'. el segundo argumento tiene que ser un vector de palabras clave que se utilizarán para filtrar el dataframe. Estas palabras clave se buscarán en las columnas title y abstract._

```r
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
```

## 2<sup>da</sup> función 'process_bib_files'.
_Esta función utiliza la primera 'bib_to_filtered'. En este caso puede hacer una df utilizando todos los archivos 'bib' que esten en la misma carpeta que el script, es decir que tengan el mismo directorio. Además, eliminar las filas repetidas basandose en el doi._

```r
process_bib_files <- function(keywords) {
  
  directory <- getwd()
  
  bib_files <- list.files(path = directory, pattern = "*.bib", full.names = TRUE)
  
  filtered_dfs <- lapply(bib_files, bib_to_filtered, keywords)
 
  combined_df <- bind_rows(filtered_dfs) %>%
    distinct(doi, .keep_all = TRUE)
  
  return(combined_df)
}
```

## 3<sup>ra</sup> función 'other_seq'.
_incorporando una data frame y una secuencia de keywords (vector de palabras). La idea es incoprporar la df resultante de las funciones anteriores. Es decir df <- process_bib_files(keywords) o df <- bib_to_filtered(bib_data, keywords)_
```r
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
```
