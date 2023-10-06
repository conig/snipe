#' n_workers
#'
#' Automatically select number of workers
#' @param x numeric. How many workers to reserve for other operations
#' @export

n_workers <- function(x = 10) {
  max(c(length(future::availableWorkers()) - x, 1))
}
