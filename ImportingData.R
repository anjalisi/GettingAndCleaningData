##GETTING THE DATA


#Before that we need to check if our directory exists or not

if(!file.exists("data"))
      dir.create("date")

#Getting data from xml
#install.packages("XML")
#library(XML)
#fileLink <- "https://www.w3schools.com/xml/simple.xml"
#doc <- xmlTreeParse(fileLink, useInternal = TRUE)
#rootNode <- xmlRoot(doc)

#READING DATA FROM JSON
install.packages("jsonlite")
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
jsonData$owner$login

#Exporting data from database to json
myjson <-toJSON(iris, pretty = TRUE)
cat(myjson)

#Converting back to JSON
iris2 <- fromJSON(myjson)
head(iris2)
#1. Go to the site: https://data.baltimorecity.gov/Transportation/Baltimore-Fixed-Speed-Cameras/dz54-2aru
#Click on export. Go to CSV, then right click and copy the link address
#Paste that address in the fileUrl variable

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

#Now, we need to download the data and save it in our working directory
download.file(fileUrl, destfile = "./data/camera.csv", method = "curl")
list.files("./data")

#To check the download date
dateDownload <- date()
dateDownload

#2. We need to read the data downloaded. To do that the most robust method is,
#read.table(). It fills data in RAM, which is not always good. And it is slow. It's important features are, file, header, sep, row.names, nrows
#But there are faster ways to read the data: read.csv() && read.csv2()

#Reading data with read.table() file
cameraData <- read.table("./data/camera.csv", sep="," , header = TRUE) #Here we have provided the separator as ","
head(cameraData)

#Reading data with read.csv() file
cameraData1 <- read.csv("./data/camera.csv", header = TRUE) #it automatically sets sep = "," & header= TRUE

#OTHER PARAMETERS ARE
##1. quote: whether there are any R related comments 
##2. na.strings: set the char that represents a missing val (usually NA)
##3. nrows: num of rows you want to read
##4. skip: num of lines to skip before starting to read.

#CREATING DATA TABLES
df= data.frame(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(df)

dt=data.table(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(dt)
##Here we can see that, the structures of both the dt and df is the same

tables()

#Subsetting rows
dt[2,]
dt[dt$y =="a"]

dt[,table(dt$y)]

install_from_swirl("Getting and Cleaning Data")

newUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(newUrl, destfile = "./data/housing.csv", method = "curl")
list.files("./data")
housingdata <- read.csv("./data/housing.csv")
# VAL attribute says how much property is worth, .N is the number of rows
# VAL == 24 means more than $1,000,000
library(data.table)
housing <- data.table::fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")

# VAL attribute says how much property is worth, .N is the number of rows
# VAL == 24 means more than $1,000,000
housing[VAL == 24, .N]


##READING DATA FROM UCSC MYSQL
##http://genome.ucsc.edu/goldenPath/help/mysql.html

install.packages("RMySQL")
ucscDb <- dbConnect(MySQL(), user="genome", host= "genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;"); dbDisconnect(ucscDb)
result

## Now we will select a database hg19, and work on its tables
hg19 <- dbConnect(MySQL(), user="genome",db="hg19", host= "genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

##Now we will list all the fields present in a particular table
dbListFields(hg19, "affyU133Plus2")

dbGetQuery(hg19, "select count(*) from affyU133Plus2")

##Reading from the table data
readAbby <- dbReadTable(hg19,"affyU133Plus2")
head(readAbby)

##Get a subset from the huge table
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)

#Storing the data from the subset
affySmall <- fetch(query, n=10); dbClearResult(query);
dim(affySmall)
dbDisconnect(hg19)


#READING DATA FROM HDF5
##We first need to install the packages https://bioconductor.org/install/
install.packages("BiocManager")
BiocManager::install(version = "3.11")
BiocManager::install("rhdf5")
library(rhdf5)
created= h5createFile("example.h5")

##Creating groups in example.h5
created= h5createGroup("example.h5","foo")
created= h5createGroup("example.h5","baa")
created= h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")

##Write data in a group
A= matrix(1:10, nr=5, nc=2)
h5write(A,"example.h5","foo/A")
B= array(seq(0.1,2.0, by = 0.1), dim = c(5,2,2)) 
attr(B,"scale") <- "liter"
h5write(B,"example.h5","foo/foobaa/B" )
h5ls("example.h5")

##Writing a dataset to the hdf5

df=data.frame(1L:5L, seq(0,1,length.out = 5), c("ab","cde","fghi","a","s"), stringsAsFactors = FALSE)
h5write(df,"example.h5","df" )
h5ls("example.h5")

##Reading the data.
readA= h5read("example.h5","foo/A")
readA

##Writing in chunks
h5write(c(12,13,14), "example.h5","foo/A",index=list(1:3,1)) #writing 12 13 14 in row 1-3 where col is 1
h5read("example.h5","foo/A")


#READING DATA FROM A URL/WEBSCRAPPING
con=url("https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

#It gives an unreadable format. So, we need to parse it to XML
library(XML)
url <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url,useInternalNodes = T)
xpathSApply(html, "//title", xmlValue)

#We can also use GET in httr package (BEST METHOD)
library(httr)
html2= GET(url)
content2= content(html2, as="text")
parsed= htmlParse(content2, asText = TRUE)
xpathSApply(parsed, "//title",xmlValue)

#Accessing webpage with password
pg1= GET("http://httpbin.org/basic-auth/user/passwd")
pg1
#We get error 401 because we do not have access. So, we need to provide an id 
#and passowrd to get the data
pg2= GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user","passwd"))
pg2
#now we get the status as 200, i.e. the page was found because access was given to us.
names(pg2)
##USING HANLDLES
#using this we can actually save the authentication to use later on
google= handle("https://www.google.com/")
pg1= GET(handle = google, path="/")
pg2= GET(handle = google, path="search")


#READING DATA FROM APIS (twitter, fb, github etc.)
library(httr)
oauth_endpoints("github")
myapp <- oauth_app("github", key = "b7e8cabd653babe9123b", secret = "6ae88e37549d3dbd09a28076a5155b4a8287bd7e")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
1
#using API
req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
output <- content(req)
datashare <- which(sapply(output, FUN=function(X) "datasharing" %in% X))
datashare
list(output[[15]]$name, output[[15]]$created_at)

install.packages("sqldf")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "acs.csv")
acs <- read.csv("acs.csv")
head(acs)
detach("package:RMySQL", unload=TRUE)
sqldf("select pwgtp1 from acs where AGEP < 50")

htmlUrl <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(htmlUrl)
close(htmlUrl)
head(htmlCode)
c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
SST <- read.fwf(fileUrl, skip=4, widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))
sum(SST[,4])


#SUMMARIZING DATA
##https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD

fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv", method = "curl")
restData <- read.csv("./data/restaurants.csv")
head(restData, n=3) #gives 3 rows from first
tail(restData, n=3) #gives 3 rows from last

###Checking the quantiles
quantile(restData$councilDistrict, na.rm = TRUE)
quantile(restData$councilDistrict, probs = c(0.5, 0.75, 0.9)) #providing our own probs

###Checking for missing values
sum(is.na(restData$councilDistrict)) #if sum>0, there is na
#checking if any val is NA
any(is.na(restData$councilDistrict))
#checking if all are NA
all(is.na(restData$councilDistrict))

all(restData$zipCode >0) #to check if all zip > 0
#It comes out to be false, so there is a negative value.

#Getting sum of rows/cols
colSums(is.na(restData))
all(is.na(restData)) #Our dataset has some missing values

#HOW TO FIND SPECIFIC VALUES/CHARACTERISTICS
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212", "21213"))

#We can even use this function to create a subset of the data
restData[restData$zipCode %in% c("21212", "21213"),] #getting all cols which satisfy this

#CROSS TABS
data("UCBAdmissions")
DF= as.data.frame(UCBAdmissions)
summary(DF)
xt <- xtabs(Freq ~ Gender+Admit, data=DF)
xt

#Flat tables
warpbreaks$replicate <- rep(1:9, len= 54)
xt= xtabs(breaks~., data= warpbreaks)
xt
ftable(xt)
object.size(xt)
print(object.size(xt), units = "MB")

#Adding columns
restData$nearme= restData$neighborhood %in% c("Roland Park", "Homeland")
restData$nearme
table(restData$nearme)

#Creating binary variables
restData$zip= ifelse(restData$zipCode <0 , TRUE, FALSE)
table(restData$zip, restData$zipCode<0)

##RESHAPING THE DATA
install.packages("reshape2")
head(mtcars)
mtcars$carname <- row.names(mtcars)
carMelt <- melt(mtcars, id=c("carname","gear","cyl"),measure.vars = c("mpg","hp"))
head(carMelt, n=3)
tail(carMelt, n=3)

#Casting the data frame
cylData <- dcast(carMelt, cyl~variable)
cylData
cylData <- dcast(carMelt, cyl~variable, mean)
cylData

#Using the Insect DataSet
head(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum) #Gives the sum of count for every spray

#We can do something similar by using split
spIns= split(InsectSprays$count, InsectSprays$spray) # we get the list of count for each spray
spIns

#Now we will calculate the sum using lapply
sprCount= lapply(spIns,sum)
sprCount
unlist(sprCount)
#We can do the same using saplly
sapply(sprCount, sum)

# We can use the plyr functions too
ddply(InsectSprays, .(spray), summarize, sum=sum(count))


##EDITING VARIABLES
rm(list = ls())
cameraData <- read.csv("./data/camera.csv", header = TRUE)
tolower(names(cameraData))
#Location.1 has a dot and capital letter, we have to remove it
splitNames= strsplit(names(cameraData),"\\.")
splitNames[[6]]

myList <- list(letters= c("A","B","C"), numbers= 1:3, matrix(1:25, ncol = 5))
myList

firstElement <- function(x){x[1]}
sapply(splitNames, firstElement)

#Searching for specific values
grep("Alameda",cameraData$intersection)

grep("Alameda",cameraData$intersection, value = TRUE)
table(grepl("Alameda",cameraData$intersection))

cameraData2 <- cameraData[!grepl("Alameda", cameraData)]

#String functions
nchar("Jeffrey Leek")
substr("Jeffrey Leek",1,7)
paste("Jeffrey","Leek")
 