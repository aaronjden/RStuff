

##Trying to get temperature and humidity 


#install.packages("ncdf4")
library(ncdf4)
library(chron)
library(lattice)
library(RColorBrewer)
setwd("C:/Users/perli/Downloads")


ncname <- "air.mon.mean"  
ncfname <- paste(ncname,".nc", sep="")
dname <- "air"  # note: tmp means temperature (not temporary)

# open a netCDF file
ncin <- nc_open(ncfname)
print(ncin)

lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)

lat <- ncvar_get(ncin,"lat",verbose=F)
nlat <- dim(lat)
head(lat)

print(c(nlon,nlat))

t <- ncvar_get(ncin,"time")
t

tunits <- ncatt_get(ncin,"time","units")
nt <- dim(t)
nt

tunits

tmp_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(tmp_array)



tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth=as.integer(unlist(tdstr)[2])
tday=as.integer(unlist(tdstr)[3])
tyear=as.integer(unlist(tdstr)[1])
chron(t,origin=c(tmonth, tday, tyear))


tmp_array[tmp_array==fillvalue$value] <- NA

length(na.omit(as.vector(tmp_array[,,1])))

m <- 1
tmp_slice <- tmp_array[,,m]

image(lon,lat,tmp_slice, col=rev(brewer.pal(10,"RdBu")))

grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(tmp_slice ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))

# matrix (nlon*nlon rows by 2 cols) of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)

# vector of `tmp` values
tmp_vec <- as.vector(tmp_slice)
length(tmp_vec)

tmp_df01 <- data.frame(cbind(lonlat,tmp_vec))
names(tmp_df01) <- c("lon","lat",paste(dname,as.character(m), sep="_"))
head(na.omit(tmp_df01), 10)

csvfile <- "cru_tmp_1.csv"
write.table(na.omit(tmp_df01),csvfile, row.names=FALSE, sep=",")

tmp_vec_long <- as.vector(tmp_array)
length(tmp_vec_long)

tmp_mat <- matrix(tmp_vec_long, nrow=nlon*nlat, ncol=nt)
dim(tmp_mat)

head(na.omit(tmp_mat))


lonlat <- as.matrix(expand.grid(lon,lat))
tmp_df02 <- data.frame(cbind(lonlat,tmp_mat))
names(tmp_df02) <- c("lon","lat","tmpJan","tmpFeb","tmpMar","tmpApr","tmpMay","tmpJun",
                     "tmpJul","tmpAug","tmpSep","tmpOct","tmpNov","tmpDec")
options(width=96)
head(na.omit(tmp_df02, 20))


tmp_df02$mtwa <- apply(tmp_df02[3:14],1,max) # mtwa
tmp_df02$mtco <- apply(tmp_df02[3:14],1,min) # mtco
tmp_df02$mat <- apply(tmp_df02[3:14],1,mean) # annual (i.e. row) means
head(na.omit(tmp_df02))

csvfile <- "cru_tmp_2.csv"
write.table(na.omit(tmp_df02),csvfile, row.names=FALSE, sep=",")


tmp_df03 <- na.omit(tmp_df02)
head(tmp_df03)

ls()

outworkspace="netCDF02.RData"
save.image(file=outworkspace)





datos<-read.csv("cru_tmp_2.csv")
lon1<-datos$lon
x<-lon1-180
head(x)
head(lon1)


datos$long<-x


temperature<-write.csv(datos, "temperature123.csv")

if(((long1-long2<x) or (long1-long2 > x) )AND ((lat1-lat2 <x) or (lat1-lat2 > x))){
  #Do the code
}











