library(shiny)
library(googleVis)
library(reshape2)
#suppressPackageStartupMessages(require(googleVis))

files <- list.files("data", full.names=T)
topcountries <- data.frame()
for (i in 1:length(files)) {
    data <- read.csv(files[i], header=F, skip=2,
                     colClasses=c("factor",rep("character",3),rep("numeric",2),"integer"), 
                     col.names=c("Rank","Country","prevSt","Students","Percent","Change","Year"))
    topcountries <- rbind(topcountries, data)
}

topcountries[,3:4] <- lapply(topcountries[,3:4],function(x){as.integer(gsub(",", "", x))})
## standardize country names in prepare for google geochart
topcountries$Country <- gsub("China.*", "China", topcountries$Country)
topcountries$Country <- gsub("Hong Kong.*", "Hong Kong", topcountries$Country)
topcountries$Country <- gsub("^Korea.*", "South Korea", topcountries$Country)

linedata <- topcountries[,c("Country","Students","Year")]
linedata <- melt(linedata, id.var=c("Year", "Country"))
linedata <- dcast(linedata, Year ~ Country, value.var="value")

countrylist <- names(linedata)[-1]

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
                               choices = countrylist,
                               selected = c("China","India","Japan")
                               )
        })
        
        mycountries <- reactive ({
            input$countries
        })
        
        output$countrytab <- renderTable({ 
            mylines <- linedata[, c("Year",input$countries), drop = FALSE]
            #mylines <- select(linedata, Year, input$countries)
            mylines
        })
        

        output$lines <- renderGvis({
            mylines <- linedata[, c("Year",input$countries), drop = FALSE]
            gvisLineChart(mylines,
                          options=list(width=800, height=600)
            )
        })
        
    }
)