#' snipe
#'
#' Initialise targets around a data object. The original data object will be moved to inside the new targets structure.
#' @param path path to data object
#' @param dir_name name of desired top-level folder
#' @param manuscript name of the manuscript file if desired, or TRUE to include
#' @export

snipe <- function(path = getwd(), dir_name = "Analysis", manuscript = NULL) {

  # Allow manuscript to be set with TRUE
  if(!is.null(manuscript)) {
    if(methods::is(manuscript, "logical") & manuscript)
      manuscript <- "manuscript.Rmd"
  }

  ext <- tools::file_ext(path)
  if (ext == "") {
    enclosing_folder <- path
    no_data <- TRUE
  } else{
    enclosing_folder <- dirname(path)
    no_data <- FALSE
  }

  new_dir <- paste0(enclosing_folder, "/", dir_name)

  if (dir.exists(new_dir))
    stop("Dir ", dir_name, " already exists, choose a different name")

  dir.create(new_dir)

  dir.create(paste0(new_dir, "/R"))
  dir.create(paste0(new_dir, "/data"))

  rstudioapi::initializeProject(new_dir)

  if(!no_data){
    new_data_path <- glue::glue("{new_dir}/data/{basename(path)}")
    copy_succeed <- file.copy(path, to = new_data_path)
    if (!copy_succeed)
      stop("Problem moving file, stopping")
  }

  if (file.exists(paste0(new_dir, "/_targets.R")))
    stop("HAULT! _targets.R already exists.")

  write_main_contents(new_dir, path)

# data_clean_contents

fn_lookup <- data.frame(row.names = c("xlsx", "csv", "sav", "rds", "dta", "sas", "stata", "xpt", "json"),
                        fn = c("readxl::read_excel", "data.table::fread", "haven::read_sav",
                               "readRDS", "haven::read_dta", "haven::read_sas", "haven::read_stata",
                               "haven::read_xpt", "jsonlite::read_json"))

read_fn <- fn_lookup[tolower(ext),"fn"]

if(!is.na(read_fn)){

  data_content <- glue::glue(
    '
#\' clean_data.fn
#\'
#\' Clean data for analysis

clean_data.fn <- function(data_path){

dat <- [[read_fn]](data_path)
dat

}
           ', .open = "[[", .close = "]]")
  write(data_content, paste0(new_dir,"/R/clean_data.R"))

}

if(!is.null(manuscript)) {
  docs_location <- glue::glue("{new_dir}/docs")
  if (!dir.exists(docs_location))
    dir.create(docs_location)
  create_manuscript(docs_location, manuscript)
}

# Create outputs folder
output_location <- glue::glue("{new_dir}/outputs")
if (!dir.exists(output_location))
  dir.create(output_location)

if(!no_data){
  unlink(path)
}

}


