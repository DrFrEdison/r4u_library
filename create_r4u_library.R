# Renv initialisieren ####
# renv::init()
# renv::install("credentials", prompt = F)
# usethis::create_github_token()
# usethis::edit_r_environ() # GITHUB_PAT=xyz
# Sys.getenv("GITHUB_PAT")
# credentials::set_github_pat()

Sys.sleep(60*60*2)

# Notwendige Pakete installieren ####

# renv::install("DrFrEdison/r4dt", repos = "https://ftp.gwdg.de/pub/misc/cran/", prompt = F)
# renv::install("DrFrEdison/r4dtpro", repos = "https://ftp.gwdg.de/pub/misc/cran/", prompt = F)
# renv::install("DrFrEdison/dtR4write", repos = "https://ftp.gwdg.de/pub/misc/cran/", prompt = F)
# renv::install("DrFrEdison/dtR4analysis", repos = "https://ftp.gwdg.de/pub/misc/cran/", prompt = F)
# renv::install("DrFrEdison/dtR4process", repos = "https://ftp.gwdg.de/pub/misc/cran/", prompt = F)
# renv::install("DrFrEdison/dtR4spc", repos = "https://ftp.gwdg.de/pub/misc/cran/", prompt = F)
# renv::install("taskscheduleR", prompt = F)
# renv::install("mRpostman", prompt = F)
# renv::install("prospectr", prompt = F)
# renv::install("openxlsx", prompt = F)
# renv::install("lubridate", prompt = F)

# Pakete aktualisieren ####
renv::status()
credentials::set_github_pat()
renv::update()
renv::snapshot()

# Pakete zippen und in r4u kopieren ####
# Pfade ####
dt <- list()
dt$pfad$local <- "D:/R/r4u_library/"
dt$pfad$renv <- "renv/library/R-4.3/x86_64-w64-mingw32/"
dt$pfad$local.lib <- paste0( dt$pfad$local, dt$pfad$renv)

source( r4dt::wdfind())
dt$pfad$server <- paste0(wd$r4u)
dt$pfad$library <- "library"
# Pfadname nach Uhrzeit
dt$pfad$systime <- gsub(" ", "", gsub("\\-", "", gsub("\\:", "", substr(as.character(Sys.time()), 1, 19))))
dt$pfad$server.lib <- paste0( dt$pfad$server, "/", dt$pfad$library, "/temp/", dt$pfad$systime)

# Name der Zip-Datei
dt$info$lib.name <- "r4u_library"

# Zip Datei erstellen mit allen Paketen ####
setwd( dt$pfad$local.lib )
unlink( paste0( dt$info$lib.name, ".zip"))

# Create a list of all files in the working directory and subdirectories
all_files <- list.files(recursive = TRUE, full.names = TRUE)

# Create the zip file using 7z.exe
system(paste0(dt$pfad$local, "7z.exe a r4u_library.zip *"))

# Ordner auf dem Server erstellen ####
setwd(paste0( dt$pfad$server, "/", dt$pfad$library))
dir.create("temp")
dir.create(dt$pfad$server.lib)

# Zip Auf den Server kopieren ####
file.copy(from = paste0(dt$pfad$local.lib, dt$info$lib.name, ".zip")
          , to = paste0(dt$pfad$server.lib, "/", dt$info$lib.name, ".zip")
          , overwrite = T)

# Zip entpacken ####
system(paste0(dt$pfad$local, "7z.exe x "
              , paste0(dt$pfad$server.lib, "/", dt$info$lib.name, ".zip")
              , " -o"
              , dt$pfad$server.lib))

# Bibliothek verschieben ####
library(ff)
from <- paste0( dt$pfad$server, "/", dt$pfad$library, "/temp/")            #Current path of your folder
to   <- paste0( dt$pfad$server, "/", dt$pfad$library, "/")            #Path you want to move it.
path1 <- paste0(from, dt$pfad$systime)
path2 <- paste0(to, dt$pfad$systime)
file.rename(path1, path2)
# file.move(path1,path2)

# Lokale Zip löschen
unlink(paste0( dt$pfad$local.lib, "r4u_library.zip"))

# Ordner auf dem Server löschen
# setwd( paste0(dt$pfad$server, "/", dt$pfad$library))
# lapply(dir(paste0( dt$pfad$server, "/", dt$pfad$library))[ !dir(paste0( dt$pfad$server, "/", dt$pfad$library)) %in% dt$pfad$systime]
#        , function( x ) unlink( x, recursive = T, force = T))
