if(1==2){
  myLHJ="CALIFORNIA" 
  myCause="0"
  myMeasure = "Ndeaths"
  mySex   = "Total"
  myYearGrouping ="One"
}


trendGeneric <- function(myLHJ="CALIFORNIA",myCause="A",myMeasure = "YLL", myTab, myYearGrouping=1, myYearGrouping_race_age=3, myLogTrans=FALSE, myMultiRace=FALSE) {

  # ----- sexTrendTab ---------------------------------------------------------
  
  
    if (myTab == "sexTrendTab") {
      
        myVARIABLE <- "sex"
     
        if (myYearGrouping == 1) {
         inDat    <- datCounty  
         myBreaks <- minYear:maxYear
         myLabels <- myBreaks                                   }
    
        if (myYearGrouping == 3)  {
         inDat <- datCounty_3year 
         chartYearMap  <-  chartYearMap %>%
          select(yearGroup3,midYear3)   %>%
          filter(!is.na(midYear3))      %>%   unique()
         myLabels   <- chartYearMap$yearGroup3
         myBreaks   <- chartYearMap$midYear3
         inDat$year <- myBreaks[match(inDat$yearG3,myLabels)]   }
    
        if (myYearGrouping == 5) {
         inDat <- datCounty_5year 
         chartYearMap    <-  chartYearMap %>%
          select(yearGroup5,midYear5)     %>%
          filter(!is.na(midYear5))        %>%    unique()
         myLabels   <- chartYearMap$yearGroup5
         myBreaks   <- chartYearMap$midYear5
         inDat$year <- myBreaks[match(inDat$yearG5,myLabels)]   }
    
     
        dat.1   <- filter(inDat,county == myLHJ,causeCode == myCause) %>%
                     left_join(  select(deathCauseLink,causeCode,causeName, causeNameShort),by="causeCode") %>% # JASPO
          mutate(causeNameShort = ifelse(!is.na(causeNameShort), causeNameShort, causeName))
        
    
        myTitle <- paste0("Trend in ",deathMeasuresNames[deathMeasures == myMeasure],
                             " of ",dat.1[1,"causeNameShort"], # JASPO
                             " in ",myLHJ,", ",myLabels[1]," to ",myLabels[length(myLabels)])
    
        myLineLabel <- myVARIABLE
        
        myTrans    <- ifelse(myLogTrans,'log2','identity')
        myMin      <- ifelse(myLogTrans,NA,0)   
    
    
        if (nrow(dat.1)==0) stop("Sorry friend, data are suppressed per the California Health and Human Services Agency Data De-Identification Guidelines, or there are no cases that meet this criteria.")
    
        varsIn  <- c("causeNameShort","county","year","sex",myMeasure) 
        tabDat  <- dat.1 %>% select(varsIn)
        dat.1$strata <- dat.1$sex
        
 
  }
  
  # ----- ageTrendTab ---------------------------------------------------------
  
  if (myTab == "ageTrendTab") {
    
    if (myLHJ != "CALIFORNIA") myYearGrouping_race_age <- 3
    
    if (myYearGrouping_race_age == 1) {
      inDat    <- datState_AGE 
      myBreaks <- minYear:maxYear
      myLabels <- myBreaks                                   }
    
    if (myYearGrouping_race_age == 3)  {
      inDat <- datCounty_AGE_3year
      chartYearMap  <-  chartYearMap %>%
        select(yearGroup3,midYear3)   %>%
        filter(!is.na(midYear3))      %>%   unique()
      myLabels   <- chartYearMap$yearGroup3
      myBreaks   <- chartYearMap$midYear3
      inDat$year <- myBreaks[match(inDat$yearG3,myLabels)]   }
    
     myVARIABLE <- "ageGroup"
    
      dat.1 <- filter(inDat,county == myLHJ,causeCode == myCause, sex=="Total", !is.na(ageGroup)) %>%
        left_join(  select(deathCauseLink,causeCode,causeName, causeNameShort),by="causeCode") %>% # JASPO
        mutate(causeNameShort = ifelse(!is.na(causeNameShort), causeNameShort, causeName))
      
      if (nrow(dat.1)==0) stop("Sorry friend, data are suppressed per the California Health and Human Services Agency Data De-Identification Guidelines, or there are no cases that meet this criteria.")
  
      myTitle <- paste0("Trend in ",deathMeasuresNames[deathMeasures == myMeasure],
                        " of ",dat.1[1,"causeNameShort"], # JASPO
                        " in ",myLHJ," by AGE GROUP, ",myLabels[1]," to ",myLabels[length(myLabels)])
      
      # yRange     <- chartYearMap$yearGroup3
      # yMid       <- chartYearMap$midYear3
      # myLabels   <- yRange
      # myBreaks   <- yMid
      # dat.1$year <- yMid[match(dat.1$yearG3,yRange)]
      # 
      # yearBit <- dat.1 %>% filter(!is.na(year)) %>% pull(yearG3)  
      # yearBit <- paste(min(yearBit),"to",max(yearBit))
      # 
      # myTitle <- paste0("Trend in ",deathMeasuresNames[deathMeasures == myMeasure],
      #                    " of ",deathCauseLink$causeName[deathCauseLink$causeCode== myCause], # JASPO
      #                    " in ",myLHJ," by AGE GROUP, ",yearBit)
      
      myTitle <-  wrap.labels(myTitle,myWrapNumber)
      
      myLineLabel <- myVARIABLE
      
      myTrans    <- ifelse(myLogTrans,'log2','identity')
      myMin      <- ifelse(myLogTrans,NA,0)
      
      # dat.1 <- mutate(dat.1,ageGroup = ifelse(ageGroup == "85 - 999","85+",ageGroup))  ###FIX THIS A TTTTOP LEVEL!
      
      
      varsIn  <- c("causeNameShort","county","year","ageGroup",myMeasure) 
      tabDat  <- dat.1 %>% select(varsIn)
      dat.1$strata <- dat.1$ageGroup
      
  }
  
  # ----- raceTrendTab -----------------------------------------------------------
  
  if (myTab == "raceTrendTab") {
    
    myVARIABLE <- "raceNameShort"
    
    if (myLHJ != "CALIFORNIA") myYearGrouping_race_age <- 3
    
    if (myYearGrouping_race_age == 1) {
      inDat    <- datState_RE 
      myBreaks <- minYear:maxYear
      myLabels <- myBreaks                                   }
    
    if (myYearGrouping_race_age == 3)  {
      inDat <- datCounty_RE
      chartYearMap  <-  chartYearMap %>%
        select(yearGroup3,midYear3)   %>%
        filter(!is.na(midYear3))      %>%   unique()
      myLabels   <- chartYearMap$yearGroup3
      myBreaks   <- chartYearMap$midYear3
      inDat$year <- myBreaks[match(inDat$yearG3,myLabels)]   }
    
    
     dat.1 <- filter(inDat,county == myLHJ,causeCode == myCause, sex=="Total")  %>%
               left_join(  select(deathCauseLink,causeCode,causeName, causeNameShort),by="causeCode") %>% # JASPO
       mutate(causeNameShort = ifelse(!is.na(causeNameShort), causeNameShort, causeName))
     dat.1 <- left_join(dat.1,raceLink,by="raceCode")
    
    if (!myMultiRace) dat.1 <- filter(dat.1,raceName != "Multi-Race")
    
    if (nrow(dat.1)==0) stop("Sorry friend, data are suppressed per the California Health and Human Services Agency Data De-Identification Guidelines, or there are no cases that meet this criteria.")
    
    # yRange     <- chartYearMap$yearGroup3
    # yMid       <- chartYearMap$midYear3
    # myLabels   <- yRange
    # myBreaks   <- yMid
    # dat.1$year <- yMid[match(dat.1$yearG3,yRange)]
    
    
    myLineLabel <- "raceNameShort" # Changed to raceCode
    
    myTrans    <- ifelse(myLogTrans,'log2','identity')
    myMin      <- ifelse(myLogTrans,NA,0)    
    
    tabDat <- dat.1
    
    # yearBit <- dat.1 %>% filter(!is.na(year)) %>% pull(yearG3)  
    # yearBit <- paste(min(yearBit),"to",max(yearBit))
    
    myTitle <- paste0("Trend in ",deathMeasuresNames[deathMeasures == myMeasure],
                      " of ",deathCauseLink$causeName[deathCauseLink$causeCode== myCause], # JASPO
                      " in ",myLHJ," by RACE/ETHNIC Group*, ",myLabels[1]," to ",myLabels[length(myLabels)])
    
    
    # myTitle <- paste0("Trend in ",deathMeasuresNames[deathMeasures == myMeasure],
    #                   " of ",deathCauseLink$causeName[deathCauseLink$causeCode== myCause], # JASPO 
    #                   " in ",myLHJ," by RACE/ETHNIC Group*, ",yearBit)
    
    myTitle <-  wrap.labels(myTitle,myWrapNumber)
    
    varsIn  <- c("causeNameShort","county","year","raceCode",myMeasure) # JASPO
    tabDat  <- dat.1 %>% select(varsIn)
    dat.1$strata <- dat.1$raceCode
    
  }

  
 
#### Generic Part Here =====================================================================================

myTitle <-  wrap.labels(myTitle,myWrapNumber)

dat.1[, myMeasure] <- round(dat.1[, myMeasure], 1)

tplot <-  ggplot(data=dat.1, 
                  aes(x=year, y=get(myMeasure), color=get(myVARIABLE))) +
          
          geom_line(size=myLineSize, show.legend=FALSE)  +
          geom_point(shape = myPointShape, size=myPointSize, show.legend=FALSE)  +
          #geom_dl(method = list(box.color = NA, "angled.boxes")) +
          scale_x_continuous(minor_breaks=myBreaks, 
                             breaks=myBreaks, 
                             # expand=c(0,3), 
                             labels=myLabels, 
                             expand = expansion(mult = c(0, 0), add = c(1, 3))) +
          scale_y_continuous(trans = myTrans, limits = c(myMin, NA)) +

          geom_dl(aes(label = get(myLineLabel)), method = list(dl.trans(x = x + 0.2), "last.points", cex = myLineLabelCex, 'last.bumpup',font="bold")) +
          # geom_dl(aes(label = get(myLineLabel)), method = list(dl.trans(x = x - 0.2), "first.points",size = myLineLabelSize,'first.bumpup' ,font="bold"))  +
  
          labs(y = deathMeasuresNames[deathMeasures == myMeasure], x = "Year"
               ) +
          labs(title = myTitle) +
          theme_bw(
            base_size   = myAxisSize) +
          theme(
            plot.title  = element_text(family='', face='bold', colour=myTitleColor, size=myTitleSize),
            axis.title  = element_text(face="bold",size=myTextSize3),
            axis.text   = element_text(size=myTextSize2),
            axis.text.x = element_text(angle = 90,vjust = 0.5, hjust=1,)
            ) 


if (myTab == "raceTrendTab") tplot <- tplot + scale_color_manual(values = raceNameShortColors)

# Interactive plot ---------------------------------------------------------------------------------------------------------------------------------------
tplot_interactive <- plot_ly(dat.1, x = ~year, y = ~get(myMeasure), color = ~get(myVARIABLE), 
                             type = "scatter", mode = "lines+markers") %>% 
  layout(hovermode="x unified")

tplot_interactive <- plotly_layout(tplot_interactive, myTitle = NULL, myTitleX = "Year", myTitleY = deathMeasuresNames[deathMeasures == myMeasure])

if (myLogTrans) tplot_interactive <- tplot_interactive %>% layout(yaxis = list(type = "log", dtick = 0.30102999566))

# if (myTab %in% c("raceTrendTab", "ageTrendTab") & myLogTrans) tplot <- tplot + scale_y_continuous(trans='log2') # JASPO - USE THIS, OR myTrans + myMin variables in ggplot?

 list(plotL = tplot, plotL_interactive = tplot_interactive, dataL = tabDat)

}





#-----------------------------------------------------------


# aes(x=year, y=eval(parse(text=paste0(myMeasure))),  OLD WAY!
# aes(x=year, y=get(myMeasure),                       NEW WAY!     




