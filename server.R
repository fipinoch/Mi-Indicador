server <- function(input, output, session){
    df <- reactive({
        df <- df_datos %>%
            filter(nombre == input$indicador,
                   fecha >= input$daterange[1], fecha <= input$daterange[2])
    })
    
    output$grafico <- plotly::renderPlotly({
        plotly::ggplotly(
            df() %>%
                ggplot2::ggplot(ggplot2::aes(x = fecha, y = valor)) +
                ggplot2::geom_line() +
                ggplot2::labs(x = '',
                              y = df_var$unidad_medida[df_var$nombre == input$indicador],
                              title = input$indicador)
        )
    })
    
    output$datos <- renderDataTable({df()})
    
    output$downloaddatos <- downloadHandler(
        filename = function(){
            paste0(input$indicador, '.csv')
        },
        content = function(file){
            write.csv(df(), file, row.names = FALSE, fileEncoding = 'latin1')
        }
    )
}