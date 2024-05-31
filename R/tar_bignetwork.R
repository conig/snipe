#' tar_bignetwork
#' 
#' Makes a bigger html widget tar_visnetwork
#' @param width string including "px"
#' @param height string including "px"
#' @param ... additional arguments to targets::tar_visnetwork
#' @export 

tar_bignetwork <- function(width = "1000px", height = "950px", ...) {
  targets::tar_visnetwork(...) |>
    visNetwork::visOptions(width = width, height = height)
}