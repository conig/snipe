write_main_contents <- function(new_dir) {
  main_contents <- glue::glue(
    'library(targets)
library(future)
library(tarchetypes)
library(future.callr)
plan(callr, workers = snipe::n_workers())

tar_option_set(packages = c("data.table", "future.apply"))

scripts <- list.files("R",
            full.names = TRUE,
            pattern = ".r$",
            ignore.case = TRUE,
            recursive = TRUE)

for(s in scripts) source(s)

list(
tar_target(data_path, "data/{basename(path)}", format = "file"),
tar_target(clean_data, clean_data.fn(data_path))
)
'
  )

# Write main
write(main_contents
      , paste0(new_dir, "/_targets.R"))

}


