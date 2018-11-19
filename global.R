library(dplyr)
library(shiny)

indicador <- c('uf', 'ivp', 'dolar', 'dolar_intercambio', 'euro',
               'ipc', 'utm', 'imacec', 'tpm', 'libra_cobre', 'tasa_desempleo', 'bitcoin')

get_data <- function(ano_in = 2010, ano_fin = 2018){
    
    year_range <- seq(ano_in, ano_fin)
    df <- data.frame()
    
    for(ind in indicador){
        print(ind)
        pb <- txtProgressBar(min = 1, max = length(year_range), style = 3)
        it <- 1
        for(year in year_range){
            setTxtProgressBar(pb, it)
            file <- paste0('https://mindicador.cl/api/', ind, '/', year)
            json_aux <- jsonlite::fromJSON(file)
            if(!is.null(nrow(json_aux$serie))){
                df_aux <- json_aux$serie
                df_aux$fecha <- as.Date(df_aux$fecha, format = '%Y-%m-%d')
                df_aux$codigo <- json_aux$codigo
                df_aux$nombre <- json_aux$nombre
                df_aux$unidad_medida <- json_aux$unidad_medida
                df <- bind_rows(df, df_aux)
            }
            it <- it + 1
        }
        close(pb)
    }
    
    return(df)
}

df_datos <- get_data(2000, 2018)

df_var <- df_datos %>%
    group_by(codigo, nombre, unidad_medida) %>%
    summarise(count = n()) %>%
    dplyr::select(codigo, nombre, unidad_medida)