#' n_workers
#'
#' Automatically select number of workers
#' @param ncpus numeric. Number of workers to use, can be set in .Renviron using snipe_ncpus
#' @param x numeric. How many workers to reserve for other operations. Used when ncpus not given
#' @export

n_workers <- function(ncpus = Sys.getenv("snipe_ncpus"), x = 10) {
  if(ncpus != "") return(ncpus)
  max(c(length(future::availableWorkers()) - x, 1))
}
