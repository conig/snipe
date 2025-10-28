#' n_workers
#'
#' Automatically select number of workers to use in parallel operations
#' @param reserve_n numeric. How many workers to reserve for other operations. If NULL, reserves a third of workers
#' @param reserve_p numeric. Proportion of workers to reserve for other operations. Used when reserve_n is NULL
#' @param ncpus numeric. Number of workers to use, can be set in .Renviron using snipe_ncpus
#' @param max_workers numeric. Maximum number of workers to return
#' @export

n_workers <- function(
  reserve_n = NULL,
  reserve_p = 0.6,
  max_workers = Inf,
  ncpus = Sys.getenv("snipe_ncpus")
) {
  if (ncpus != "") {
    return(as.numeric(ncpus))
  }
  total_cores <- parallel::detectCores()
  if (is.null(reserve_n)) {
    reserve_n <- ceiling(total_cores * reserve_p)
  }
  n_cores <- parallel::detectCores() - reserve_n
  n_cores <- min(n_cores, max_workers)
  n_cores <- max(n_cores, 1)
  n_cores
}

#' source_R
#'
#' Return list of R scripts
#' @param dir dir to search in. Defaults to working directory.
#' @param recursive. bool. passed to list.files
#' @export

source_R <- function(dir = getwd(), recursive = TRUE) {
  list.files(
    dir,
    full.names = TRUE,
    pattern = ".r$",
    ignore.case = TRUE,
    recursive = recursive
  )
}
