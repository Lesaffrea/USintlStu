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
            helpText('Navigate to "Trend Analysis" tab to view charts'),
            uiOutput("countrybox")
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Top Places of Origin", 
                    h3(textOutput("gvisTitle")),    
                    htmlOutput("gvmap") 
                ),
                tabPanel("Trend analysis",
                    h3("Trend of International Students by Country"),
                    helpText("Tick the checkboxes on the left to select the countries for plotting lines."),
                    htmlOutput("lines"),
                    helpText("Missing data may due to the fact that the country was not in the top 25 for that year."),
                    htmlOutput("countrytab")
                )
            )
        )        
    )    
))