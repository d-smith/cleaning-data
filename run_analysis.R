## CheckDataFiles does a quick sanity check on the assumptions made by
## the program about the location of the data files relative to the script
## location.
CheckDatafiles <- function() {
  if(!file.exists("UCI HAR Dataset")) {
    stop("UCI HAR Hataset directory not found")
  }
  if(!file.exists("UCI\ HAR\ Dataset/test")) {
    stop("test subdirectory not found")
  }
  if(!file.exists("UCI\ HAR\ Dataset/trainw")) {
    stop("train subdirectory not found")
  }
}