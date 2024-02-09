#' @importFrom gdxrrw igdx
#' @importFrom withr with_output_sink
.onLoad <- function(libname, pkgname) {
  tmp <- NULL
  with_output_sink(new = textConnection("tmp", "w", local = TRUE),
                   code = {
                     path <- strsplit(Sys.getenv("PATH"), .Platform$path.sep,
                                      fixed = TRUE)[[1]]
                     path <- grep("gams", path, ignore.case = TRUE,
                                  value = TRUE)
                     # disregard variables on the Windows path
                     path <- grep("%", path, value = TRUE, fixed = TRUE,
                                  invert = TRUE)
                     # # append GAMSROOT (or empty if that does not exist) to make
                     # # sure igdx is called at least once
                     # path <- c(path, Sys.getenv("GAMSROOT"))

                     ok <- FALSE
                     for (p in path) {
                       if (isTRUE(ok <- as.logical(igdx(p)))) {
                         break
                       }
                     }
                   }, append = TRUE)

  if (!ok) {
    # truncate igdx output to 132 characters per line
    tmp <- paste0(strtrim(tmp, 129), c("", "...")[(nchar(tmp) > 132) + 1])
    packageStartupMessage(paste(tmp, collapse = "\n"))
  }
}
