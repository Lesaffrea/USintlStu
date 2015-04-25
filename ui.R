library(shiny)

shinyUI(fluidPage(
    titlePanel("Trends of International Students in US"),
    sidebarLayout(
        sidebarPanel(
            helpText("Where do the international students in US come from?"),
            sliderInput("year", 
                        label = "Choose a year to display", 
                        min=2001, max=2014, value=2014,  step=1, animate=TRUE),
            
            helpText("How has the number of international students evolved over last 10 years?"),
            uiOutput("countrybox")
        ),
        mainPanel(
            h3(textOutput("gvisTitle")),    
            htmlOutput("gvmap"),            
#             htmlOutput("top10tab"),
#             htmlOutput("temp"),
#             htmlOutput("temp2"),
            h3("Trend of International Students by Country"),
            htmlOutput("lines"),
            htmlOutput("countrytab")
        )        
    )    
))