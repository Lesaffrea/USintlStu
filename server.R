library(shiny)
library(googleVis)
library(reshape2)
#suppressPackageStartupMessages(require(googleVis))

files <- list.files("data", full.names=T)
topcountries <- data.frame()
for (i in 1:length(files)) {
    data <- read.csv(files[i], header=F, skip=2,
                             colClasses=c("factor",rep("character",3),rep("numeric",2),"factor"), 
                             col.names=c("Rank","Country","prevSt","Students","Percent","Change","Year"))
    topcountries <- rbind(topcountries, data)
}

topcountries[,3:4] <- lapply(topcountries[,3:4],function(x){as.numeric(gsub(",", "", x))})
## standardize country names in prepare for mapping
topcountries$Country <- gsub("China.*", "China", topcountries$Country)
topcountries$Country <- gsub("Hong Kong.*", "Hong Kong", topcountries$Country)
topcountries$Country <- gsub("^Korea.*", "South Korea", topcountries$Country)

## list the countries that have always been on the top list 
toplist <- unique(topcountries$Country)

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
                                      colorAxis="{colors:['#feb24c', '#fc4e2a', '#b10026']}"
                         ))     
        })
        
        output$top10tab <- renderTable({
            myData <- subset(topcountries, Year==myYear())
            head(myData, 10)
        })
        
        # Create the checkboxes and select them all by default
        output$countrybox <- renderUI({
        checkboxGroupInput("countries", 
                           label = "Choose the countries of origin", 
                           choices = toplist,
                           selected = toplist[1:3])
        })
        
        countryList <- reactive ({
            input$countries
        })
        
        output$countries <- renderText({ 
            paste("You have chosen",
                  input$countries)
        })
                
        output$lines <- renderGvis({
            linedata <- topcountries[,c("Country","Students","Year")]
            linedata <- melt(linedata, id.var=c("Year", "Country"))
            linedata <- dcast(linedata, Year ~ Country, value.var="value")
            gvisLineChart(linedata,
                          options=list(width=800, height=800)
                          
            )
            
        })
        
    }
)