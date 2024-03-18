#' n_workers
#'
#' Automatically select number of workers
#' @param ncpus numeric. Number of workers to use, can be set in .Renviron using snipe_ncpus
#' @param x numeric. How many workers to reserve for other operations. Used when ncpus not given
#' @export

n_workers <- function(ncpus = Sys.getenv("snipe_ncpus"), x = 10) {
  if(ncpus != "") return(as.numeric(ncpus))
  max(c(length(future::availableWorkers()) - x, 1))
}

#' get_R_scripts
#'
#' Return list of R scripts
#' @param dir dir to search in. Defaults to working directory.
#' @param recursive. bool. passed to list.files
#' @export

get_R_scripts <- function(dir = getwd(), recursive = TRUE){
  list.files(dir,
             full.names = TRUE,
             pattern = ".r$",
             ignore.case = TRUE,
             recursive = recursive)
}
