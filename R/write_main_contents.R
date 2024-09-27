write_main_contents <- function(new_dir, path) {
  main_contents <- glue::glue(
'library(targets)
library(tarchetypes)
library(crew)

tar_option_set(packages = c("data.table", "future.apply"),
    controller = crew_controller_local(workers = 6))

tar_source()

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


