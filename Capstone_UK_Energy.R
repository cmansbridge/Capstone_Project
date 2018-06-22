# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'
library(dplyr)
library(tidyr)
library(magrittr)
library(tibble)

#   code to remove dataframe to reload
rm("UKprice","UKmix","UKtemp", "UKenergy")

# code to load the 3 distinct datasets into dataframes
UKprice <- read.csv("~/Downloads/UK_DA_Price.csv")
UKmix <- read.csv("~/Downloads/UK_ENERGY_MIX.csv")
UKtemp <- read.csv("~/Downloads/UK_MEAN_TEMP.csv")

View(UKprice)
View(UKmix)
View(UKtemp)

#rename amount column in UKtemp to AvgTemp
names(UKtemp)[names(UKtemp) == "Amount"] <- "AvgTemp"

#add quarter column to UKPrice and update
UKprice <- mutate(UKprice,"Quarter" = "NA")

UKprice[UKprice$Month == 1,"Quarter"] <- 1
UKprice[UKprice$Month == 2,"Quarter"] <- 1
UKprice[UKprice$Month == 3,"Quarter"] <- 1
UKprice[UKprice$Month == 4,"Quarter"] <- 2
UKprice[UKprice$Month == 5,"Quarter"] <- 2
UKprice[UKprice$Month == 6,"Quarter"] <- 2
UKprice[UKprice$Month == 7,"Quarter"] <- 3
UKprice[UKprice$Month == 8,"Quarter"] <- 3
UKprice[UKprice$Month == 9,"Quarter"] <- 3
UKprice[UKprice$Month == 10,"Quarter"] <- 4
UKprice[UKprice$Month == 11,"Quarter"] <- 4
UKprice[UKprice$Month == 12,"Quarter"] <- 4

#add quarter column to UKtemp and update
UKtemp <- mutate(UKtemp,"Quarter" = 0)

UKtemp[UKtemp$Month == 1,"Quarter"] <- 1
UKtemp[UKtemp$Month == 2,"Quarter"] <- 1
UKtemp[UKtemp$Month == 3,"Quarter"] <- 1
UKtemp[UKtemp$Month == 4,"Quarter"] <- 2
UKtemp[UKtemp$Month == 5,"Quarter"] <- 2
UKtemp[UKtemp$Month == 6,"Quarter"] <- 2
UKtemp[UKtemp$Month == 7,"Quarter"] <- 3
UKtemp[UKtemp$Month == 8,"Quarter"] <- 3
UKtemp[UKtemp$Month == 9,"Quarter"] <- 3
UKtemp[UKtemp$Month == 10,"Quarter"] <- 4
UKtemp[UKtemp$Month == 11,"Quarter"] <- 4
UKtemp[UKtemp$Month == 12,"Quarter"] <- 4

#create new dataframe for final dataset
rm("UKenergy")
UKenergy <- UKtemp
View(UKenergy)

#Remove from UKenergy
UKenergy<-UKenergy[!(UKenergy$Month == "3" & UKenergy$Year==2018),]
UKenergy<-UKenergy[!(UKenergy$Month == "4" & UKenergy$Year==2018),]


#Add all fields from UKPrice and UKMix to master dataframe
UKenergy <- left_join(UKenergy, select(UKprice, Month, Year, Price))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,Coal))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,Oil))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,Gas))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,Nuclear))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,Hydro))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,Wind))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,Bio))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,PumpStorage))
UKenergy <- left_join(UKenergy, select(UKmix,Quarter,Year,Other))

#Export Master Dataframe
write.csv(UKenergy,'~/Downloads/UKenergy.csv')
