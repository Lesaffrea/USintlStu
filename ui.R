library(shiny)

shinyUI(fluidPage(
    titlePanel("Trends of International Students in US"),
    sidebarLayout(
        sidebarPanel(
            h4("Where do the international students in US come from?"),
            helpText("Move the slider to choose the year for display. \n Click the play button to show animation."),
            sliderInput("year", 
                        label = "Choose a year to display", 
                        min=2001, max=2014, value=2014,  step=1, animate=TRUE),
            
            h4("How has the number of international students evolved over last 10 years?"),
            uiOutput("countrybox")
        ),
        mainPanel(
            h3(textOutput("gvisTitle")),    
            htmlOutput("gvmap"),            
#             htmlOutput("top10tab"),
#             htmlOutput("temp"),
#             htmlOutput("temp2"),
            h3("Trend of International Students by Country"),
            helpText("Tick the checkboxes on the left to select the countries for plotting lines."),
            htmlOutput("lines"),
            htmlOutput("countrytab")
        )        
    )    
))