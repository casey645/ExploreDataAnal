## File Name: Plot4.R
#Created by: Casey Watkins
#Purpose of this file is to accomplish the following:
#
# 1. download data from UCI Machine Learning Repository
# 2. read the data into R
# 3. inspect and recode the data
# 4. plot the data

## 1. download the data, unzip, delete zip file
file.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
file.dest <- 'power.consumption.zip'
download.file( file.url, file.dest )
source.file <- unzip( file.dest, list = TRUE )$Name
unzip( file.dest )
file.remove( file.dest )
rm(file.url)
rm(file.dest)


## 2. read the data into R, save, and remove source file
Power.Consumption <- read.table( source.file, header = TRUE, sep = ';', na.strings = '?' )
save( Power.Consumption, file = 'Power.Consumption.RData' )
file.remove( source.file )
rm(source.file)


## 3. rename variables, recode some the data, subset for relevant dates
new.names <- gsub( '_', '.', names(Power.Consumption)  )
new.names <- tolower( new.names )
names( Power.Consumption ) <- new.names
rm(new.names)

## recode dates and times
Power.Consumption$date <- as.Date (Power.Consumption$date, '%d/%m/%Y' )
Power.Consumption <- subset( Power.Consumption, date == '2007-02-01' | date == '2007-02-02' ) 
Power.Consumption$date.time <- strptime( 
        paste(
                Power.Consumption$date,
                Power.Consumption$time
        ),
        format="%Y-%m-%d %H:%M:%S"
)

## Resave 
save( Power.Consumption, file = 'Power.Consumption.RData' )


## 4. plot the data
attach(Power.Consumption)
png( 'plot4.png' )
par(mfrow=c(2,2))
plot(date.time,
     global.active.power,
     type='l',
     xlab = '',
     ylab = 'Global Active Power (kilowatts)'
)
plot(date.time,
     voltage,
     type = 'l',
)
plot(date.time,
     sub.metering.1,
     type = 'l',
     xlab = '',
     ylab = 'Energy sub metering'
)
lines(date.time,
      sub.metering.2,
      type = 'l',
      col = 'red'
)
lines(date.time,
      sub.metering.3,
      type = 'l',
      col = 'blue'
)
legend('topright',
       lty = c(1, 1, 1),
       col = c('black', 'blue', 'red'),
       legend = c('Metering 1', 'Metering 2', 'Metering 3')
)
plot(date.time,
     global.reactive.power,
     type = 'l'
)
dev.off()
detach(Power.Consumption)