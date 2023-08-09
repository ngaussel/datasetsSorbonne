library(shiny)
library(shinyWidgets)
library(dplyr)
library(purrr)
library(ggplot2)
library(plotly)
source("R/helper.R")



ui <- fluidPage(
  tags$style(HTML("div.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  z-index: 1;
}")),
  tagAppendAttributes(
    titlePanel("US Stocks cross Section analysis"),
    class="sticky"),
  sidebarLayout(
    tagAppendAttributes(
      sidebarPanel(
      style = "height: 90vh; overflow-y: auto;", 
      sliderInput("factor", "PCA Factor number", min = 1, max = 20, value = 1,step = 1),
      br(),
      selectInput("criteria","Criteria",choices = c("sector","marketCap_C","PE_C","Div_C"),selected = "sector")
      ),class = "sticky"),
    mainPanel(
      h2("Spectrum"),
      fluidRow( 
        column(4,sliderInput("nBins", "Number of Bins for EigenV", min = 20, max = 200, value = 30,step = 2)),
        column(4,sliderInput("ymax", "Maximum y", min = 2, max = 500, value = 500,step = 2))
      ),
      plotlyOutput("eigenPlot",height = "200px"),
      br(),
      h2("Principal components"),
      plotOutput("factorPlot",height = "500px"),
      br(),
      h2("Regression results"),
      fluidRow( 
        column(4,selectInput("var", "Regression parameter", choices = c("r2","alpha","beta"),selected = "beta")
               ),
      plotOutput("regressionPlot",height = "500px"),
    )
    
  )
)
)


server <- function(input, output) {
  
  load(file = "shiny.rdata")
  load(file = "bulkRegression.rdata")

  
    output$eigenPlot <- renderPlotly({
      
      n_assets <- length(eigenV)
      
      ymax <- ifelse(input$ymax==500,NA,input$ymax)
      
      ee <- tibble(value=eigenV/n_assets,n=seq_len(n_assets)) |> 
        ggplot()+
        aes(x=value) +
        geom_histogram(bins = input$nBins)  +
        labs(title = "Factor eigen value") +
        coord_cartesian(ylim=c(0,ymax ))
        

      ggplotly(ee)
      
    })
    
    output$factorPlot <- renderPlot({
      
      pp <- stockFactors |> 
        group_by(!!sym(input$criteria)) |> 
        summarise(across(.cols=(input$factor+1),sum,.names="value")) |>
        drop_na() |> 
        ggplot() +
        aes(x=!!sym(input$criteria),y=-value,fill=!!sym(input$criteria)) +
        geom_col() +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1,size = 12),
              legend.position = "none") +
        labs(title = "Factor loading depending on criteria",
             y = "loading")
      
      pp
      
      
    })

    output$regressionPlot <- renderPlot({
      
    
      testR2<- bulkRegression |>
        filter(term=="r2") |> 
        group_by(!!sym(input$criteria)) |> 
        summarise(r2=mean(estimate)) |>
        drop_na()
      
      testAlpha<- bulkRegression |>
        filter(term=="alpha") |> 
        group_by(!!sym(input$criteria)) |> 
        summarise(alpha=mean(estimate)) |>
        drop_na()
      
      testBeta<- bulkRegression |>
        filter(term=="beta") |> 
        group_by(!!sym(input$criteria)) |> 
        summarise(beta=mean(estimate)) |>
        drop_na()
      
      resu <- testR2 |> 
        left_join(testAlpha) |> 
        left_join(testBeta)
      
      
      rr <- resu |> 
        ggplot() +
        aes(x=!!sym(input$criteria),y=!!sym(input$var),fill=!!sym(input$criteria)) +
        geom_col() +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1,size = 12),
              legend.position = "none") +
        labs(title = "regression results / categorie")
      
      
      rr
      
      
      
    })
    
    
     
    
}



shinyApp(ui = ui, server = server)