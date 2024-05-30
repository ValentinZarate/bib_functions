
# primera función, se le debe ingresar un archivo formato 'bib' en el primer argumento que tenga al menos una columna con 'abstract' y otra 'title'. el segundo argumento tiene que ser un vector de palabras clave que se utilizarán para filtrar el dataframe. Estas palabras clave se buscarán en las columnas title y abstract.

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


# esta función utiliza la primera 'bib_to_filtered'. En este caso puede hacer una df utilizando todos los archivos 'bib' que esten en la misma carpeta que el script, es decir que tengan el mismo directorio. Además, eliminar las filas repetidas basandose en el doi.

process_bib_files <- function(keywords) {
  
  directory <- getwd()
  
  bib_files <- list.files(path = directory, pattern = "*.bib", full.names = TRUE)
  
  filtered_dfs <- lapply(bib_files, bib_to_filtered, keywords)
 
  combined_df <- bind_rows(filtered_dfs) %>%
    distinct(doi, .keep_all = TRUE)
  
  return(combined_df)
}


# incorporando una data frame y una secuencia de keywords (vector de palabras). La idea es incoprporar la df resultante de las funciones anteriores. Es decir df <- process_bib_files(keywords) o df <- bib_to_filtered(bib_data, keywords)

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


##### 1 in one step. There are two importants steps in the application of this function. 1) the keyword list should present the format of a list of word vectors, each vector represent a sequence of words connected by a OR boolean operator, but should be represented as ','. The union of each vection into the list is represented by an 'AND' boolean operator. That is, the function will filter all bib. files inside the same folder as the script. this filtering will based on the condition that 'abstract' or 'title' at least one word of each word vector, but if the article do not have at least one word of one vector it will be excluded. The output is a filtered dataframe. This functions used functions of 'dplyr' package, 'stringr' and RefManager', and also it uses an auxiliar functions 'bib_to_filtered'

all_bib2df <- function(keywords_list) {
  
  required_packages <- c("dplyr", "stringr", "RefManageR")
  lapply(required_packages, require, character.only = TRUE)

  bib_to_filtered <- function(bib_data, keywords) {
    if (is.character(bib_data)) {
      bib_data <- ReadBib(bib_data)
    }
    
    bib_df <- as.data.frame(bib_data)
    rownames(bib_df) <- NULL
    
    # Crear el patrón de palabras clave considerando OR
    keyword_pattern <- paste(keywords, collapse = "|")
    
    # Filtrar el DataFrame según el patrón de palabras clave
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
  
  # uso el coso lapply para aplicar la función bib_to_filtered a cada archivo .bib en bib_files, utilizando el primer conjunto de palabras clave de keywords_list
  
  filtered_dfs <- lapply(bib_files, bib_to_filtered, keywords_list[[1]])
  combined_df <- bind_rows(filtered_dfs) %>%
    distinct(doi, .keep_all = TRUE)
  
  # el bucle 'for' (i in 2:length(keywords_list)) iterará sobre todos los vectores dentro de keywords_list empezando desde el segundo vector hasta el final de la lista. En este caso lo hace dos veces nomas, pero si tuviese muchos AND en mi secuencia de busqueda entonces lo haría todas esas veces.
  
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

# A la funcion se le debe introducir una lista de 'keywords', cada elemento de la lista tiene que tener la secuencia de búsqueda con palabras clave que quieran ser separadas con OR. Cada secunecia sera filtrada por separado como si estuviesen separadas por AND (inclusion obligatoria). La funcion luego va a incluir todo el listado de archivos Bib que esten en la misma carpeta que el script. 

keywords1 <- c("human", "humans", "fragmentation", "fragmented", "agricultural",
               "agriculture", "crop", "crops", "plantation", "plantations","human-dominated", "human-modified","forestry", "production", "commercial","harvested", "fragment", "fragments", "management", "land use", "athropogenic","logging", "managed", "anthropogenically", "mosaic", "rural", "agriculture", "agroecosystem", "timber", "agro-forestry")

keywords2 <- c("mammal", "mammals", "mammalian")

keywords3 <- c("home range", "home ranges", "home-ranges", "home-range", "ranging behavior", "kernel", "fixed-kernel", "kernel-density")

# Lista de secuencias de búsqueda
keywords_list <- list(keywords1, keywords2, keywords3)

result <- all_bib2df(keywords_list)
