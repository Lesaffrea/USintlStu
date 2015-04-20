library(shiny)

shinyUI(fluidPage(
    titlePanel("Trends of International Students in US"),
    sidebarLayout(
        sidebarPanel(
            helpText("In 2013/14, where do the international students in US come from?"),
            sliderInput("numOrg", 
                        label = "Choose the number of top places of origin", 
                        min=1, max=25, value=5,  step=1, animate=TRUE),
            
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
