renv::status()
which.to.update <- renv::update()
# which.to.update <- list(1)
# names(which.to.update) <- "lubridate"

dt <- list()

# Pfade ####
dt$pfad$local <- "D:/R/r4u_library/"
dt$pfad$renv <- "renv/library/R-4.3/x86_64-w64-mingw32/"
dt$pfad$local.lib <- paste0( dt$pfad$local, dt$pfad$renv)

source( r4dt::wdfind())
dt$pfad$server <- paste0(wd$r4u)

dt$pfad$library <- "library"

library.all <- dir( paste0( dt$pfad$server, "/", dt$pfad$library ) )
library.num <- library.all[ grepl("^[0-9]+$", library.all) ]
library.20 <- library.num[ grep(20, substr(library.num, 1, 2)) ]
lib.loc <- min(library.20)

dt$pfad$server.lib <- paste0( dt$pfad$server, "/", dt$pfad$library, "/", lib.loc)

# delete updated package in library
setwd( dt$pfad$server.lib )
for(i in 1 : length( names(which.to.update) ))
  unlink( grep(names(which.to.update)[ i ], dir(), value = T)[ 1 ], recursive = T, force = T)

if( length( grep(names(which.to.update)[ i ], dir()) ) > 0)
  warning("Folder was not deleted successfully!")

# copy updated package into library
for(i in 1 : length( names(which.to.update) )){
  file.copy(from = paste0(dt$pfad$local.lib, names(which.to.update)[ i ])
            , to = paste0(dt$pfad$server.lib)
            , overwrite = T, recursive = T)
}

