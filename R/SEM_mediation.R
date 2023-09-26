#' lavaan_mediation
#' @param latents named list, name defines latent name, vector defines contents
#' @param outcome string, outcome variable
#' @param direct string, variable that forms the direct path
#' @param mediator string, variable that forms the mediator path
#' @details https://lavaan.ugent.be/tutorial/mediation.html
#' @export
#
# latents <- list(size = c("wt", "cyl"),
#                 power = c("hp","drat"))

lavaan_mediation <- function(latents, outcome, direct, mediator){


 latent_code  <- create_latent_spec(latents)

  code <- glue::glue('

mediator_model.fn <- function(clean_data){

  model <- "

  #latents
  [[latent_code]]

  # direct_effect
  [[outcome]] ~ c*[[direct]]

  # mediator
  [[mediator]] ~ a*[[direct]]
  [[outcome]] ~ b*[[mediator]]

  # indirect effect
  ab := a * b

  # total effect
  total := c + (a*b)
  "

  require(lavaan)

  fit <- sem(model, data = clean_data)
  fit


}


', .open = "[[", .close = "]]")


if(file.exists("R/lavaan_mediation.R")){
stop("R/lavaan_mediation.R already exists")
  }

  write(code, "R/lavaan_mediation.R")

}

create_latent_spec <- function(Llist){

  sapply(seq_along(Llist), function(i) glue::glue("{names(Llist)[i]} =~ {paste(Llist[[i]], collapse = ' + ')}")) |> paste(collapse = "\n  ")

}
