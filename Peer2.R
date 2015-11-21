# Code for Peer Assessment 2

setwd("~/R/RepResearch/RepData_PeerAssessment2")

# download data and extract
# url <-
#         "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
# download.file(url, destfile = "storm.csv.bz2")
# storm <- read.csv("storm.csv.bz2")
# 
# 
# # first look at data
# dim(storm)
# str(storm)
# head(storm)
# tail(storm)
# 
# # reformat begin and end dates
library(lubridate)
# storm$BGN_DATE <- mdy_hms(storm$BGN_DATE)
# storm$END_DATE <- mdy_hms(storm$END_DATE)

# save as an R dataset for future use (faster than rereading csv file)
# saveRDS(storm, "storm.rds")

# alternatively, if the above processing has already been done,
#  read the RDS file
storm <- readRDS("storm.rds")

# select only the columns needed for this research
library(dplyr)
pa2 <-
        select(
                storm, EVTYPE, BGN_DATE, END_DATE, FATALITIES, INJURIES, 
                PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP
        )

# Per https://www.ncdc.noaa.gov/stormevents/details.jsp: "From 1996 to present, 
# 48 event types are recorded as defined in NWS Directive 10-1605." This implies
# that we don't have to go back any further than 1996 (because 1996 was the 
# first year that all events were tracked). So, we filter out rows from before
# 1996.
pa2 <- filter(pa2, year(BGN_DATE) >= 1996)

# check dimensions
dim(pa2)

# +++++++ histogram shows distribution of events by year; peaks in 1996, 2008, 2011
# +++++++ hist(year(pa2$BGN_DATE))

# summarize evtype by year; see that the number of distinct types is near
# the expected number of 48 starting in 2003
yr <- group_by(pa2, year(BGN_DATE))
summarize(yr, n_distinct(EVTYPE))

# filter out rows from before 2003; later years seems to be the most reliable
recent <- filter(pa2, year(BGN_DATE) >= 2003)
dim(recent)

# Across the United States,
#   which types of events (as indicated in the EVTYPE variable) are most harmful 
#   with respect to population health?

# filter on those events with casualties (defined as fatalities or injuries)
evCas <- filter(recent, FATALITIES > 0 | INJURIES > 0) 
# now we have 6371 events...
dim(evCas)
# ... and 71 unique event types
unique(evCas$EVTYPE)

evCas <- mutate(evCas, casualties = FATALITIES + INJURIES)
head(evCas)

evByCas <- evCas %>%
        group_by(EVTYPE) %>%
        summarize(totalCas = sum(casualties)) %>%
        arrange(desc(totalCas))
evByCas

# The number of casualties for hurricanes seems low, let's check further. 
#  Consider any EVTYPE containing "HURRICANE".
evByCas[grep("HURRICANE", evByCas$EVTYPE),]

# That can't be right, we know Hurricane Katrina (2005) alone had at least 
# 1200 deaths 
# (http://fivethirtyeight.com/features/we-still-dont-know-how-many-people-died-because-of-katrina/)
# 
# Going back to the orignal storm dataset,
# We find 15 hurricane events between 2005-08-15 (Katrina landfall was 2005-08-29, see previous link)
#  and the end of 2005
recentHurr <- storm[grep("HURRICANE", storm$EVTYPE),]
filter(recentHurr, BGN_DATE >= "2005-08-15" & BGN_DATE <= "2005-12-31")

# We discover that the remarks for 14 events reference Katrina. 
# It looks like each zone has entered its own event.
Hurr2005 <- filter(recentHurr, BGN_DATE >= "2005-08-15" & BGN_DATE <= "2005-12-31")
Hurr2005 <- Hurr2005[grep("Katrina", Hurr2005$REMARKS), ]
select(Hurr2005, FATALITIES, INJURIES)

# Unfortunately, these events only add up to a total of 24 fataliies and
#   107 injuries. We know this is not accurate. A future analysis might look into
#   other data sources and/or the remarks in this dataset for additonal 
#   information. With that in mind, here is a plot of casualities by event type.

evByCas10 <- evByCas[1:10,]  # Plot the 10 event types with the most casualities

g1 <- ggplot(evByCas10, aes(EVTYPE, totalCas)) +
        geom_bar(stat = "identity", aes(fill = EVTYPE)) +
        coord_flip() +
        labs(x = "Event Type", y = "Total Casualities (Fatalities + Injuries)", 
             title = "Total Casualities by Event Type, 2003-2011")
g1
# We can infer that, despite the known problems with the data, 
#   tornadoes are likely the most harmful to health in terms of
#   deaths and injuries.


# Across the United States, 
#   which types of events have the greatest economic consequences?

# Going back to the recent dataset, filter out events with zero damage recorded
evProp <- filter(recent, PROPDMG > 0 | CROPDMG > 0)
head(evProp)
tail(evProp)
#  There are 56 unique event types that caused property damage
unique(evProp$EVTYPE)

# examine unique values of PROPDMGEXP and CROPDMGEXP
unique(evProp$PROPDMGEXP)
unique(evProp$CROPDMGEXP)
# We get K, M, B, presumably for thousands, millions, billions.
#  Fields also have blanks, but we see there are no rows with a value 
#  greater that zero and blanks for a type of damage (CROP or PROP).
count(evProp[evProp$PROPDMGEXP == "" & evProp$PROPDMG != 0,])
count(evProp[evProp$CROPDMGEXP == "" & evProp$CROPDMG != 0,])

calcdam <- function(dam, exp) {
        
        if (exp == "K") {
                dam * 1000
        }
        else if (exp == "M") {
                dam * 1000000
        }
        else if (exp == "B") {
                dam * 1000000000
        }
        else if (exp == "") {
                0
        }
}

for(i in 1:dim(evProp)[1])
{
        evProp$PROPDMG[i] <-
                calcdam(evProp$PROPDMG[i], evProp$PROPDMGEXP[i])
        evProp$CROPDMG[i] <-
                calcdam(evProp$CROPDMG[i], evProp$CROPDMGEXP[i])
}

evProp <- mutate(evProp, totDamage = PROPDMG + CROPDMG)

# Take a look at the damage data
arrange(evProp, desc(totDamage))[1:10,]
# First on the list is the outlier that was discussed in the discussion
#  forum (General Discussion / A Few Words Of Advice). This is a flood
#  event where the property damage was obviously miscoded with an exp of
#  "B" rather than "M". We exclude that outlier.
evProp[evProp$PROPDMG > 1e+11,]
evProp <- filter(evProp, PROPDMG < 1e+11)

# group by event type and summarize
evByProp <- evProp %>%
        group_by(EVTYPE) %>%
        summarize(totByProp = sum(totDamage)) %>%
        arrange(desc(totByProp))
evByProp

# Plot top 10 by damage
evByProp10 <- evByProp[1:10,]  # Plot the 10 event types with the most damage

g2 <- ggplot(evByProp10, aes(EVTYPE, totByProp)) +
        geom_bar(stat = "identity", aes(fill = EVTYPE)) +
        coord_flip() +
        labs(x = "Event Type", y = "Total Damage (Property + Crop)", 
             title = "Total Damage by Event Type, 2003-2011")
g2

# We can infer that, despite the known problems with the data, 
#   hurricanes are likely to have the greatest economic consequences
#   in terms of property and crop damage. 
# Storm Surge and Storm Surge/Tide are probably the same thing, but
#  even if the two types are added together they obviously are well
#  behind hurricanes.

# ---------------------------------------------------
