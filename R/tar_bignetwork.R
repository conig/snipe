#' tar_bignetwork
#' 
#' Makes a bigger html widget tar_visnetwork
#' @param width string including "px"
#' @param height string including "px"
#' @export 

tar_bignetwork <- function(width = "1020px", height = "980px") {
  targets::tar_visnetwork() |>
    visNetwork::visOptions(width = width, height = height)
}