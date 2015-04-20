library(shiny)
library(googleVis)
#suppressPackageStartupMessages(require(googleVis))

files <- list.files("data", full.names=T)
topcountries <- data.frame()
for (i in 1:length(files)) {
    data <- read.csv(files[i], header=F, skip=2,
                             colClasses=c("factor",rep("character",3),rep("numeric",3)), 
                             col.names=c("Rank","Country","prevSt","Students","Percent","Change","Year"))
    topcountries <- rbind(topcountries, data)
}

topcountries[,3:4] <- lapply(topcountries[,3:4],function(x){as.numeric(gsub(",", "", x))})

shinyServer(
    function(input, output) {
        myYear <- reactive({
            input$year
        })
        
        output$gvisTitle <- renderText({ 
            paste("Top 25 Places of Origin in", myYear())
        })
        
        ## draw map
        output$gvmap <- renderGvis({
            myData <- subset(topcountries, Year==myYear())
            gvisGeoChart(myData,
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