## File Name: Plot1.R
#Created by: Casey Watkins
#Purpose of this file is to accomplish the following:
# 1. download data from UCI Machine Learning Repository
# 2. read the data into R
# 3. inspect and recode the data
# 4. plot the data


# 1. download the data, unzip, delete zip file
file.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
file.dest <- 'power.consumption.zip'
download.file( file.url, file.dest )
source.file <- unzip( file.dest, list = TRUE )$Name
unzip( file.dest )
file.remove( file.dest )
rm(file.url)
rm(file.dest)


# 2. read the data into R, save, and remove source file
Power.Consumption <- read.table( source.file, header = TRUE, sep = ';', na.strings = '?' )
save( Power.Consumption, file = 'Power.Consumption.RData' )
file.remove( source.file )
rm(source.file)


# 3. rename variables, recode some the data, subset for relevant dates
new.names <- gsub( '_', '.', names(Power.Consumption)  )
new.names <- tolower( new.names )
names( Power.Consumption ) <- new.names
rm(new.names)

# recode dates and times
Power.Consumption$date <- as.Date (Power.Consumption$date, '%d/%m/%Y' )
Power.Consumption <- subset( Power.Consumption, date == '2007-02-01' | date == '2007-02-02' ) 
Power.Consumption$date.time <- strptime( 
        paste(
                Power.Consumption$date,
                Power.Consumption$time
        ),
        format="%Y-%m-%d %H:%M:%S"
)

# save again
save( Power.Consumption, file = 'Power.Consumption.RData' )


# 4. plot the data
png( 'plot1.png' )
hist( Power.Consumption$global.active.power,
      col = 'red',
      main = 'Global Active Power',
      xlab = 'Global Active Power (kilowatts)'
)
dev.off()