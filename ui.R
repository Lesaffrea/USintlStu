library(shiny)

shinyUI(fluidPage(
    titlePanel("Trends of International Students in US"),
    sidebarLayout(
        sidebarPanel(
            helpText("Where do the international students in US come from?"),
            sliderInput("year", 
                        label = "Choose a year to display", 
                        min=2011, max=2014, value=2014,  step=1, animate=TRUE),
            
            helpText("How has the number of international students evolved over last 10 years?"),
            checkboxGroupInput("countries", 
                label = "Choose the countries of origin", 
                choices = list("China" = 1, "India" = 2, "Vietnam" = 3),
                        selected = 1)
        ),
        mainPanel(
            h3(textOutput("gvisTitle")),    
            htmlOutput("gvmap"),            
            htmlOutput("temp"),
            textOutput("countries")
        )        
    )    
))
