test_that("tar_fuzzy_make runs tar_make on matched targets", {
  manifest <- data.frame(
    name = c("data_raw", "data_clean", "model"),
    stringsAsFactors = FALSE
  )
  called <- new.env(parent = emptyenv())

  local_mocked_bindings(
    tar_manifest = function(...) manifest,
    tar_make = function(names, ...) {
      called$names <- names
      called$dots <- list(...)
      invisible(NULL)
    },
    .package = "targets"
  )

  expect_message(
    result <- tar_fuzzy_make("DATA", ignore_case = TRUE),
    "running action 'make' on 2 target"
  )

  expect_identical(called$names, c("data_raw", "data_clean"))
  expect_identical(result, c("data_raw", "data_clean"))
})

test_that("tar_fuzzy_invalidate includes downstream targets", {
  manifest <- data.frame(
    name = c("raw_data", "clean_data", "model", "report"),
    stringsAsFactors = FALSE
  )
  network <- list(
    edges = data.frame(
      from = c("raw_data", "clean_data", "model"),
      to = c("clean_data", "model", "report"),
      stringsAsFactors = FALSE
    )
  )
  called <- new.env(parent = emptyenv())

  local_mocked_bindings(
    tar_manifest = function(...) manifest,
    tar_network = function(...) network,
    tar_invalidate = function(names, ...) {
      called$names <- names
      invisible(NULL)
    },
    .package = "targets"
  )

  expect_message(
    result <- tar_fuzzy_invalidate("clean_data", regex = FALSE, downstream = TRUE),
    "running action 'invalidate' on 3 target"
  )

  expect_identical(result, c("clean_data", "model", "report"))
  expect_identical(called$names, c("clean_data", "model", "report"))
})

test_that("tar_fuzzy_make dry run reports matches without running action", {
  manifest <- data.frame(
    name = c("dataset_alpha", "dataset_beta"),
    stringsAsFactors = FALSE
  )

  local_mocked_bindings(
    tar_manifest = function(...) manifest,
    tar_make = function(...) {
      stop("tar_make should not be called during a dry run")
    },
    .package = "targets"
  )

  expect_message(
    result <- tar_fuzzy_make("dataset", dry_run = TRUE),
    "dry run for action 'make'"
  )

  expect_identical(result, c("dataset_alpha", "dataset_beta"))
})

test_that("tar_fuzzy_make handles no matches", {
  manifest <- data.frame(
    name = c("alpha", "beta"),
    stringsAsFactors = FALSE
  )

  local_mocked_bindings(
    tar_manifest = function(...) manifest,
    tar_make = function(...) {
      stop("tar_make should not be called when there are no matches")
    },
    .package = "targets"
  )

  expect_message(
    result <- tar_fuzzy_make("gamma"),
    "no targets matched 'gamma'"
  )

  expect_identical(result, character())
})
