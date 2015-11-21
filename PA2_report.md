# Reproducible Research: Peer Assessment 2
Dave Richards  
November 21, 2015  

## Synopsis
Data from the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database was analyzed to determine the types of weather events that have been most harmful with respect to human health, as well as the types that have had the greatest economic consequences. While the data goes back as far as 1950, it was discovered that the current list of 48 event types was instituted in 1996, and that it appears to have been fully implemented in 2003. Therefore, events that occurred before 2003 have not been considered. Further, we saw that, even after 2003, data was not tabulated consistently. In particular, fatalities and injuries resulting from Hurricane Katrina (2005) were not recorded in the expected fields. Some of the missing data may have been included in the remarks field; this analysis did not attempt to parse the remarks for additonal data.

The analysis found that, between 2003 and 2011, tornadoes were responsible for more deaths and injuries than any other type of weather event. It was also found that hurricanes caused more economic damage to property and crops than other event types.



## Data Processing

### Download and clean

First, data was downloaded from the course website and downloaded into R.


```r
# download data and extract
url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
download.file(url, destfile = "storm.csv.bz2", method="curl")
storm <- read.csv("storm.csv.bz2")
```

A first look at the data 

```r
dim(storm)
```

```
## [1] 902297     37
```

```r
str(storm)
```

```
## 'data.frame':	902297 obs. of  37 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : Factor w/ 16335 levels "1/1/1966 0:00:00",..: 6523 6523 4242 11116 2224 2224 2260 383 3980 3980 ...
##  $ BGN_TIME  : Factor w/ 3608 levels "00:00:00 AM",..: 272 287 2705 1683 2584 3186 242 1683 3186 3186 ...
##  $ TIME_ZONE : Factor w/ 22 levels "ADT","AKS","AST",..: 7 7 7 7 7 7 7 7 7 7 ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: Factor w/ 29601 levels "","5NM E OF MACKINAC BRIDGE TO PRESQUE ISLE LT MI",..: 13513 1873 4598 10592 4372 10094 1973 23873 24418 4598 ...
##  $ STATE     : Factor w/ 72 levels "AK","AL","AM",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : Factor w/ 35 levels "","  N"," NW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_LOCATI: Factor w/ 54429 levels "","- 1 N Albion",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_DATE  : Factor w/ 6663 levels "","1/1/1993 0:00:00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_TIME  : Factor w/ 3647 levels ""," 0900CST",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : Factor w/ 24 levels "","E","ENE","ESE",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_LOCATI: Factor w/ 34506 levels "","- .5 NNW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: Factor w/ 19 levels "","-","?","+",..: 17 17 17 17 17 17 17 17 17 17 ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: Factor w/ 9 levels "","?","0","2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ WFO       : Factor w/ 542 levels ""," CI","$AC",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ STATEOFFIC: Factor w/ 250 levels "","ALABAMA, Central",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ ZONENAMES : Factor w/ 25112 levels "","                                                                                                                               "| __truncated__,..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : Factor w/ 436781 levels "","-2 at Deer Park\n",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10 ...
```

```r
head(storm)
```

```
##   STATE__           BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1       1  4/18/1950 0:00:00     0130       CST     97     MOBILE    AL
## 2       1  4/18/1950 0:00:00     0145       CST      3    BALDWIN    AL
## 3       1  2/20/1951 0:00:00     1600       CST     57    FAYETTE    AL
## 4       1   6/8/1951 0:00:00     0900       CST     89    MADISON    AL
## 5       1 11/15/1951 0:00:00     1500       CST     43    CULLMAN    AL
## 6       1 11/15/1951 0:00:00     2000       CST     77 LAUDERDALE    AL
##    EVTYPE BGN_RANGE BGN_AZI BGN_LOCATI END_DATE END_TIME COUNTY_END
## 1 TORNADO         0                                               0
## 2 TORNADO         0                                               0
## 3 TORNADO         0                                               0
## 4 TORNADO         0                                               0
## 5 TORNADO         0                                               0
## 6 TORNADO         0                                               0
##   COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH F MAG FATALITIES
## 1         NA         0                      14.0   100 3   0          0
## 2         NA         0                       2.0   150 2   0          0
## 3         NA         0                       0.1   123 2   0          0
## 4         NA         0                       0.0   100 2   0          0
## 5         NA         0                       0.0   150 2   0          0
## 6         NA         0                       1.5   177 2   0          0
##   INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO STATEOFFIC ZONENAMES
## 1       15    25.0          K       0                                    
## 2        0     2.5          K       0                                    
## 3        2    25.0          K       0                                    
## 4        2     2.5          K       0                                    
## 5        2     2.5          K       0                                    
## 6        6     2.5          K       0                                    
##   LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM
## 1     3040      8812       3051       8806              1
## 2     3042      8755          0          0              2
## 3     3340      8742          0          0              3
## 4     3458      8626          0          0              4
## 5     3412      8642          0          0              5
## 6     3450      8748          0          0              6
```

```r
tail(storm)
```

```
##        STATE__           BGN_DATE    BGN_TIME TIME_ZONE COUNTY
## 902292      47 11/28/2011 0:00:00 03:00:00 PM       CST     21
## 902293      56 11/30/2011 0:00:00 10:30:00 PM       MST      7
## 902294      30 11/10/2011 0:00:00 02:48:00 PM       MST      9
## 902295       2  11/8/2011 0:00:00 02:58:00 PM       AKS    213
## 902296       2  11/9/2011 0:00:00 10:21:00 AM       AKS    202
## 902297       1 11/28/2011 0:00:00 08:00:00 PM       CST      6
##                                  COUNTYNAME STATE         EVTYPE BGN_RANGE
## 902292 TNZ001>004 - 019>021 - 048>055 - 088    TN WINTER WEATHER         0
## 902293                         WYZ007 - 017    WY      HIGH WIND         0
## 902294                         MTZ009 - 010    MT      HIGH WIND         0
## 902295                               AKZ213    AK      HIGH WIND         0
## 902296                               AKZ202    AK       BLIZZARD         0
## 902297                               ALZ006    AL     HEAVY SNOW         0
##        BGN_AZI BGN_LOCATI           END_DATE    END_TIME COUNTY_END
## 902292                    11/29/2011 0:00:00 12:00:00 PM          0
## 902293                    11/30/2011 0:00:00 10:30:00 PM          0
## 902294                    11/10/2011 0:00:00 02:48:00 PM          0
## 902295                     11/9/2011 0:00:00 01:15:00 PM          0
## 902296                     11/9/2011 0:00:00 05:00:00 PM          0
## 902297                    11/29/2011 0:00:00 04:00:00 AM          0
##        COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH  F MAG
## 902292         NA         0                         0     0 NA   0
## 902293         NA         0                         0     0 NA  66
## 902294         NA         0                         0     0 NA  52
## 902295         NA         0                         0     0 NA  81
## 902296         NA         0                         0     0 NA   0
## 902297         NA         0                         0     0 NA   0
##        FATALITIES INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO
## 902292          0        0       0          K       0          K MEG
## 902293          0        0       0          K       0          K RIW
## 902294          0        0       0          K       0          K TFX
## 902295          0        0       0          K       0          K AFG
## 902296          0        0       0          K       0          K AFG
## 902297          0        0       0          K       0          K HUN
##                       STATEOFFIC
## 902292           TENNESSEE, West
## 902293 WYOMING, Central and West
## 902294          MONTANA, Central
## 902295          ALASKA, Northern
## 902296          ALASKA, Northern
## 902297            ALABAMA, North
##                                                                                                                                                            ZONENAMES
## 902292 LAKE - LAKE - OBION - WEAKLEY - HENRY - DYER - GIBSON - CARROLL - LAUDERDALE - TIPTON - HAYWOOD - CROCKETT - MADISON - CHESTER - HENDERSON - DECATUR - SHELBY
## 902293                                                                              OWL CREEK & BRIDGER MOUNTAINS - OWL CREEK & BRIDGER MOUNTAINS - WIND RIVER BASIN
## 902294                                                                                     NORTH ROCKY MOUNTAIN FRONT - NORTH ROCKY MOUNTAIN FRONT - EASTERN GLACIER
## 902295                                                                                                 ST LAWRENCE IS. BERING STRAIT - ST LAWRENCE IS. BERING STRAIT
## 902296                                                                                                                 NORTHERN ARCTIC COAST - NORTHERN ARCTIC COAST
## 902297                                                                                                                                             MADISON - MADISON
##        LATITUDE LONGITUDE LATITUDE_E LONGITUDE_
## 902292        0         0          0          0
## 902293        0         0          0          0
## 902294        0         0          0          0
## 902295        0         0          0          0
## 902296        0         0          0          0
## 902297        0         0          0          0
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        REMARKS
## 902292                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    EPISODE NARRATIVE: A powerful upper level low pressure system brought snow to portions of Northeast Arkansas, the Missouri Bootheel, West Tennessee and extreme north Mississippi. Most areas picked up between 1 and 3 inches of with areas of Northeast Arkansas and the Missouri Bootheel receiving between 4 and 6 inches of snow.EVENT NARRATIVE: Around 1 inch of snow fell in Carroll County.
## 902293                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           EPISODE NARRATIVE: A strong cold front moved south through north central Wyoming bringing high wind to the Meeteetse area and along the south slopes of the western Owl Creek Range. Wind gusts to 76 mph were recorded at Madden Reservoir.EVENT NARRATIVE: 
## 902294                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      EPISODE NARRATIVE: A strong westerly flow aloft produced gusty winds at the surface along the Rocky Mountain front and over the plains of Central Montana. Wind gusts in excess of 60 mph were reported.EVENT NARRATIVE: A wind gust to 60 mph was reported at East Glacier Park 1ENE (the Two Medicine DOT site).
## 902295 EPISODE NARRATIVE: A 960 mb low over the southern Aleutians at 0300AKST on the 8th intensified to 945 mb near the Gulf of Anadyr by 2100AKST on the 8th. The low crossed the Chukotsk Peninsula as a 956 mb low at 0900AKST on the 9th, and moved into the southern Chukchi Sea as a 958 mb low by 2100AKST on the 9th. The low then tracked to the northwest and weakened to 975 mb about 150 miles north of Wrangel Island by 1500AKST on the 10th. The storm was one of the strongest storms to impact the west coast of Alaska since November 1974. \n\nZone 201: Blizzard conditions were observed at Wainwright from approximately 1153AKST through 1611AKST on the 9th. The visibility was frequently reduced to one quarter mile in snow and blowing snow. There was a peak wind gust to 43kt (50 mph) at the Wainwright ASOS. During this event, there was also a peak wind gust to \n68 kt (78 mph) at the Cape Lisburne AWOS. \n\nZone 202: Blizzard conditions were observed at Barrow from approximately 1021AKST through 1700AKST on the 9th. The visibility was frequently reduced to one quarter mile or less in blowing snow. There was a peak wind gust to 46 kt (53 mph) at the Barrow ASOS. \n\nZone 207: Blizzard conditions were observed at Kivalina from approximately 0400AKST through 1230AKST on the 9th. The visibility was frequently reduced to one quarter of a mile in snow and blowing snow. There was a peak wind gust to 61 kt (70 mph) at the Kivalina ASOS.  The doors to the village transportation shed were blown out to sea.  Many homes lost portions of their tin roofing, and satellite dishes were ripped off of roofs. One home had its door blown off.  At Point Hope, severe blizzard conditions were observed. There was a peak wind gust of 68 kt (78 mph) at the Point Hope AWOS before power was lost to the AWOS. It was estimated that the wind gusted as high as 85 mph in the village during the height of the storm during the morning and early afternoon hours on the 9th. Five power poles were knocked down in the storm EVENT NARRATIVE: 
## 902296 EPISODE NARRATIVE: A 960 mb low over the southern Aleutians at 0300AKST on the 8th intensified to 945 mb near the Gulf of Anadyr by 2100AKST on the 8th. The low crossed the Chukotsk Peninsula as a 956 mb low at 0900AKST on the 9th, and moved into the southern Chukchi Sea as a 958 mb low by 2100AKST on the 9th. The low then tracked to the northwest and weakened to 975 mb about 150 miles north of Wrangel Island by 1500AKST on the 10th. The storm was one of the strongest storms to impact the west coast of Alaska since November 1974. \n\nZone 201: Blizzard conditions were observed at Wainwright from approximately 1153AKST through 1611AKST on the 9th. The visibility was frequently reduced to one quarter mile in snow and blowing snow. There was a peak wind gust to 43kt (50 mph) at the Wainwright ASOS. During this event, there was also a peak wind gust to \n68 kt (78 mph) at the Cape Lisburne AWOS. \n\nZone 202: Blizzard conditions were observed at Barrow from approximately 1021AKST through 1700AKST on the 9th. The visibility was frequently reduced to one quarter mile or less in blowing snow. There was a peak wind gust to 46 kt (53 mph) at the Barrow ASOS. \n\nZone 207: Blizzard conditions were observed at Kivalina from approximately 0400AKST through 1230AKST on the 9th. The visibility was frequently reduced to one quarter of a mile in snow and blowing snow. There was a peak wind gust to 61 kt (70 mph) at the Kivalina ASOS.  The doors to the village transportation shed were blown out to sea.  Many homes lost portions of their tin roofing, and satellite dishes were ripped off of roofs. One home had its door blown off.  At Point Hope, severe blizzard conditions were observed. There was a peak wind gust of 68 kt (78 mph) at the Point Hope AWOS before power was lost to the AWOS. It was estimated that the wind gusted as high as 85 mph in the village during the height of the storm during the morning and early afternoon hours on the 9th. Five power poles were knocked down in the storm EVENT NARRATIVE: 
## 902297                           EPISODE NARRATIVE: An intense upper level low developed on the 28th at the base of a highly amplified upper trough across the Great Lakes and Mississippi Valley.  The upper low closed off over the mid South and tracked northeast across the Tennessee Valley during the morning of the 29th.   A warm conveyor belt of heavy rainfall developed in advance of the low which dumped from around 2 to over 5 inches of rain across the eastern two thirds of north Alabama and middle Tennessee.  The highest rain amounts were recorded in Jackson and DeKalb Counties with 3 to 5 inches.  The rain fell over 24 to 36 hour period, with rainfall remaining light to moderate during most its duration.  The rainfall resulted in minor river flooding along the Little River, Big Wills Creek and Paint Rock.   A landslide occurred on Highway 35 just north of Section in Jackson County.  A driver was trapped in his vehicle, but was rescued unharmed.  Trees, boulders and debris blocked 100 to 250 yards of Highway 35.\n\nThe rain mixed with and changed to snow across north Alabama during the afternoon and  evening hours of the 28th, and lasted into the 29th.  The heaviest bursts of snow occurred in northwest Alabama during the afternoon and evening hours, and in north central and northeast Alabama during the overnight and morning hours.  Since ground temperatures were in the 50s, and air temperatures in valley areas only dropped into the mid 30s, most of the snowfall melted on impact with mostly trace amounts reported in valley locations.  However, above 1500 foot elevation, snow accumulations of 1 to 2 inches were reported.  The heaviest amount was 2.3 inches on Monte Sano Mountain, about 5 miles northeast of Huntsville.EVENT NARRATIVE: Snowfall accumulations of up to 2.3 inches were reported on the higher elevations of eastern Madison County.  A snow accumulation of 1.5 inches was reported 2.7 miles south of Gurley, while 2.3 inches was reported 3 miles east of Huntsville atop Monte Sano Mountain.
##        REFNUM
## 902292 902292
## 902293 902293
## 902294 902294
## 902295 902295
## 902296 902296
## 902297 902297
```

Begin and end dates were reformatted to date format

```r
library(lubridate)
storm$BGN_DATE <- mdy_hms(storm$BGN_DATE)
storm$END_DATE <- mdy_hms(storm$END_DATE)
```

Save as an R dataset for future use (faster than rereading csv file)

```r
saveRDS(storm, "storm.rds")
```

Alternatively, if the data has already been saved to an R dataset,
read the RDS file:
`storm <- readRDS("storm.rds")`

I created a subset of the data containing only the columns needed for tabulating the results.

```r
library(dplyr)
pa2 <-
        select(
                storm, EVTYPE, BGN_DATE, END_DATE, FATALITIES, INJURIES, 
                PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP
        )
```

Per https://www.ncdc.noaa.gov/stormevents/details.jsp: "From 1996 to present, 48 event types are recorded as defined in NWS Directive 10-1605." This implies that we don't have to go back any further than 1996 (because 1996 was the first year that all events were tracked). So, we filter out rows from before 1996.

```r
pa2 <- filter(pa2, year(BGN_DATE) >= 1996)
```

Summarize evtype by year; see that the number of distinct types is near the expected number of 48 starting in 2003.

```r
yr <- group_by(pa2, year(BGN_DATE))
summarize(yr, n_distinct(EVTYPE))
```

```
## Source: local data frame [16 x 2]
## 
##    year(BGN_DATE) n_distinct(EVTYPE)
##             (dbl)              (int)
## 1            1996                228
## 2            1997                170
## 3            1998                126
## 4            1999                121
## 5            2000                112
## 6            2001                122
## 7            2002                 99
## 8            2003                 51
## 9            2004                 38
## 10           2005                 46
## 11           2006                 50
## 12           2007                 46
## 13           2008                 46
## 14           2009                 46
## 15           2010                 46
## 16           2011                 46
```

Therefore, I filter out rows from before 2003; later years seem to be the most reliable.

```r
recent <- filter(pa2, year(BGN_DATE) >= 2003)
dim(recent)
```

```
## [1] 417437      9
```

### Harm to population health

Now we try to answer the question, "Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?"  
Keep only events with casualties (defined as fatalities or injuries)

```r
evCas <- filter(recent, FATALITIES > 0 | INJURIES > 0) 
# now we have 6371 events...
dim(evCas)
```

```
## [1] 6371    9
```

```r
# ... and 46 unique event types
unique(evCas$EVTYPE)
```

```
##  [1] EXTREME COLD             TORNADO                 
##  [3] FLASH FLOOD              RIP CURRENT             
##  [5] TSTM WIND                LIGHTNING               
##  [7] AVALANCHE                HIGH WIND               
##  [9] DUST STORM               HAIL                    
## [11] WILD/FOREST FIRE         RIP CURRENTS            
## [13] EXCESSIVE HEAT           WILDFIRE                
## [15] DENSE FOG                URBAN/SML STREAM FLD    
## [17] HEAVY RAIN               EXTREME COLD/WIND CHILL 
## [19] LANDSLIDE                BLIZZARD                
## [21] STRONG WIND              HEAVY SURF/HIGH SURF    
## [23] FLOOD                    HEAVY SNOW              
## [25] ICE STORM                WINTER STORM            
## [27] WINTER WEATHER/MIX       DUST DEVIL              
## [29] TROPICAL STORM           EXTREME WINDCHILL       
## [31] HURRICANE/TYPHOON        STORM SURGE             
## [33] MARINE TSTM WIND         COASTAL FLOOD           
## [35] WINTER WEATHER           THUNDERSTORM WIND       
## [37] HEAT                     HIGH SURF               
## [39] DROUGHT                  COLD/WIND CHILL         
## [41] MARINE THUNDERSTORM WIND MARINE STRONG WIND      
## [43] STORM SURGE/TIDE         HURRICANE               
## [45] MARINE HIGH WIND         TSUNAMI                 
## 985 Levels:    HIGH SURF ADVISORY  COASTAL FLOOD ... WND
```

Calculate number of casualties for each event, and summarize by event type

```r
evCas <- mutate(evCas, casualties = FATALITIES + INJURIES)

evByCas <- evCas %>%
        group_by(EVTYPE) %>%
        summarize(totalCas = sum(casualties)) %>%
        arrange(desc(totalCas))
evByCas
```

```
## Source: local data frame [46 x 2]
## 
##               EVTYPE totalCas
##               (fctr)    (dbl)
## 1            TORNADO    13677
## 2     EXCESSIVE HEAT     2943
## 3          LIGHTNING     2313
## 4  THUNDERSTORM WIND     1530
## 5               HEAT     1451
## 6  HURRICANE/TYPHOON     1022
## 7           WILDFIRE      986
## 8        FLASH FLOOD      953
## 9          TSTM WIND      945
## 10       RIP CURRENT      545
## ..               ...      ...
```

The number of casualties for hurricanes seems low, let's check further. Consider any EVTYPE containing "HURRICANE".

```r
evByCas[grep("HURRICANE", evByCas$EVTYPE),]
```

```
## Source: local data frame [2 x 2]
## 
##              EVTYPE totalCas
##              (fctr)    (dbl)
## 1 HURRICANE/TYPHOON     1022
## 2         HURRICANE       15
```

That can't be right, we know Hurricane Katrina (2005) alone had at least 1200 deaths (See http://fivethirtyeight.com/features/we-still-dont-know-how-many-people-died-because-of-katrina/.) 

Going back to the orignal *storm* dataset, we find 15 hurricane events between 2005-08-15 (Katrina landfall was 2005-08-29, see previous link) and the end of 2005.

```r
recentHurr <- storm[grep("HURRICANE", storm$EVTYPE),]
Hurr2005 <- filter(recentHurr, BGN_DATE >= "2005-08-15" & BGN_DATE <= "2005-12-31")
Hurr2005 <- Hurr2005[grep("Katrina", Hurr2005$REMARKS), ]
select(Hurr2005, FATALITIES, INJURIES)
```

```
##    FATALITIES INJURIES
## 1           0        0
## 4           6        0
## 5           0        0
## 6           0        0
## 11          0        0
## 12          0        0
## 13          0        0
## 18          0        0
## 19          0        0
## 20          0        0
## 21         15      104
## 22          0        0
## 23          0        0
## 28          3        3
```

We discover that the remarks for 14 events reference Katrina. It looks like each zone has entered its own event.  

Unfortunately, these events only add up to a total of 24 fataliies and 107 injuries. We know this is not accurate. A future analysis might look into other data sources and/or the remarks in this dataset for additonal information. The results I present should be viewed with that in mind.

### Economic consequences
