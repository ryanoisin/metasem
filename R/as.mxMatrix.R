as.mxMatrix <- function(x, name, ...) {
  ## If it is a vector, the output is a column matrix.
  if (!is.matrix(x))
      x <- as.matrix(x)

  # suppress warnings
  ## warn <- options()$warn
  ## options(warn=-1)
  nRow <- nrow(x)
  nCol <- ncol(x)

  # check if "name" was give
  # if not, use the matrix name
  if (missing(name))
    name <- as.character(match.call())[2]

  values <- suppressWarnings(as.numeric(x))  # They are NA for characters
  free <- is.na(values)    # They are TRUE for parameters with labels
  freePara1 <- x[free]     # Extract free parameters
  # check if there are any free parameters
  if (length(freePara1)>0) {
    freePara2 <- strsplit(freePara1, "*", fixed=TRUE)
    # replace NA with starting values 0.5 before "0.5*a"
    values[free] <- sapply(freePara2, function(x){ as.numeric(x[1])})
    labels <- matrix(NA, ncol=nCol, nrow=nRow)
    labels[free] <- sapply(freePara2, function(x){ x[2]})
    
    ## Replace TRUE by FALSE in free when there are definition variables
    free[grep("data.", labels)] <- FALSE
    
    out <- mxMatrix(type = "Full", nrow=nRow, ncol=nCol, values=values, free=free,
                    name=name, labels=labels, ...)
  } else {
    out <- mxMatrix(type = "Full", nrow=nRow, ncol=nCol, values=values, free=free,
                    name=name, ...)
  }

    ## Don't include dimnames if nRow==1 (most likely mean vector)
    ## Dimensions in the M matrix may create an error   
  if (nRow>1) {
      ## Add the dimnames for ease of references
      dimnames(out@values) <- dimnames(out@labels) <- dimnames(out@free) <- dimnames(x)
  }    

  ## options(warn=warn)
  out
}
