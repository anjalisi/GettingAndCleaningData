#PLOTTING THE DATA

##BASE PLOTS 

library(datasets)
data("cars")
with(cars, plot(speed, dist))

##LATTICE SYSTEMS

library(lattice)
state <- data.frame(state.x77, region= state.region)
xyplot(Life.Exp ~ Income | region, data= state, layout= c(4,1))

##GGPLOT2 SYSTEMS

library(ggplot2)
data(mpg)
qplot(displ, hwy, data= mpg)

hist(airquality$Ozone)
with(airquality, plot(Wind, Ozone))
title(main="Ozone and Wind Levels in NYC")

airquality <- transform(airquality, Month= factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone(ppb)")

##Boxplot with annotation
with(airquality, plot(Wind, Ozone, main="Ozone and Wind Levels in NYC"))
with(subset(airquality, Month==5), points(Wind, Ozone, col="blue"))     ###For month=5 (i.e. May), we want blue dots
with(subset(airquality, Month!=5), points(Wind, Ozone, col="yellow"))
legend("topright", pch=1, col= c("blue","yellow"), legend = c("May", "Other Months"))

with(airquality, plot(Wind, Ozone, main="Ozone and Wind Levels in NYC", pch=20))
model <- lm(Ozone ~ Wind, airquality) #Adding regression line
abline(model, lwd=2)

##Adding Multiple Base Plots
par(mfrow= c(1,3), mar= c(4,4,2,1), oma=c(0,0,2,0))
with(airquality,{
      plot(Wind, Ozone, main="Ozone and Wind Levels ")
      plot(Solar.R, Ozone, main= "Ozone and Solar Radiation")
      plot(Temp, Ozone, main= "Ozone and Temperature")
      mtext("Ozone and Weather in NYC", outer = TRUE)
})

x <- rnorm(100)
hist(x)
y <- rnorm(100)
plot(x,y,pch=4)
par(mar= c(4,4,2,2))
text(-2,-2, "Label")

z<- rpois(100,2)
par(mfrow= c(2,2))      #2 rows 2 col
plot(x,y,pch=4)
plot(x,z, pch=10)
par("mar")
par(mar= c(2,2,2,2))
plot(x,y,pch=4)
plot(x,z, pch=10)
plot(z,y,pch=4)
plot(z,x, pch=10)


#Saving plots in pdf file
pdf(file="myplot.pdf")
with(faithful, plot(eruptions, waiting))
title(main="Old fashioned Geyser Data")
dev.off()

with(faithful, plot(eruptions, waiting))
title(main="Old fashioned Geyser Data")
dev.copy(png, file="geyserplot.png")      #Plotting to a PNG file
dev.off()


# LATTICE PLOTTING SYSTEM
library(lattice)
xyplot(Ozone ~ Wind, data = airquality)

airquality <- transform(airquality, Month=factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout=c(5,1))

##Panel Lattice
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each=50)
y <- x+f -f*x+ rnorm(100,sd=0.5)
f <- factor(f, labels= c("Group 1","Group 2"))
xyplot(y ~ x | f, layout= c(2,1))

##Making a Custom Panel Lattice
xyplot(y ~ x | f, panel = function(x,y,...)
{
      panel.xyplot(x,y...)
      panel.abline(h=median(y), lty = 2)
})


#ggplot2()

str(mpg)
qplot(displ, hwy, data = mpg, col= drv) #Separating colours by drive

##Adding stats to the data
qplot(displ, hwy, data = mpg, col= drv, geom = c("point","smooth"))

##Plotting histogram using a qplot (Define only 1 var)
qplot(hwy, data = mpg, fill=drv)

##Plotting facets (are similar to the panels in lattice)