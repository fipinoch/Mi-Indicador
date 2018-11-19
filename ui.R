ui <- fluidPage(
    titlePanel('Mi Indicador'),
    sidebarLayout(
        sidebarPanel(
            radioButtons(inputId = 'indicador', 
                         label = 'Indicador', 
                         choices = unique(df_datos$nombre),
                         selected = NULL,
                         inline = FALSE),
            dateRangeInput(inputId = 'daterange',
                           label = 'Rango de fechas',
                           start = min(df_datos$fecha),
                           end = max(df_datos$fecha),
                           min = min(df_datos$fecha),
                           max = max(df_datos$fecha)),
            downloadButton(outputId = 'downloaddatos',
                           label = 'Descargar Datos')
        ),
        mainPanel(
            tabsetPanel(
                tabPanel('Grafico',
                         plotly::plotlyOutput('grafico')
                ),
                tabPanel('Datos',
                         dataTableOutput('datos'))
            )
        )
    )
)