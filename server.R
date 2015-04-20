library(shiny)
library(googleVis)
#suppressPackageStartupMessages(require(googleVis))

topcountries <- read.csv("data/topcountries2014.csv", header=F, skip=2,
                         colClasses=c("factor",rep("character",3),rep("numeric",3)), 
                         col.names=c("Rank","Country","prevSt","Students","Percent","Change","Year"))
topcountries[,3:4] <- lapply(topcountries[,3:4],function(x){as.numeric(gsub(",", "", x))})

shinyServer(
    function(input, output) {
        topOrg <- reactive({
            input$numOrg
        })
        
        output$gvisTitle <- renderText({ 
            paste("Top", topOrg(), "Places of Origin in 2013/14")
        })
        
        ## draw map
        output$gvmap <- renderGvis({
            gvisGeoChart(topcountries,
                         locationvar="Country", colorvar="Students",
                         options=list(region="world", displayMode="regions", 
                                      resolution="countries",
                                      width=800, height=600,
                                      colorAxis="{colors:['#ece7f2', '#a6bddb', '#2b8cbe']}"
                         ))     
        })
        
        output$temp <- renderTable({
            head(topcountries)
        })
        
        output$countries <- renderText({ 
            paste("You have chosen",
                  input$countries)
        })
        
    }
)