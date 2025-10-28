tar_fuzzy <- function(
  string,
  action,
  action_label = NULL,
  regex = TRUE,
  ignore_case = FALSE,
  downstream = FALSE,
  dry_run = FALSE,
  ...
) {
  stopifnot(is.character(string), length(string) == 1L)
  stopifnot(is.function(action))

  if (is.null(action_label)) {
    action_label <- paste(deparse(substitute(action)), collapse = " ")
    action_label <- sub(".*::", "", action_label, perl = TRUE)
  }

  mf <- targets::tar_manifest()
  all_names <- mf$name

  sel <- if (isTRUE(regex)) {
    grepl(string, all_names, ignore.case = ignore_case, perl = TRUE)
  } else {
    grepl(string, all_names, ignore.case = ignore_case, fixed = TRUE)
  }

  matched <- unique(all_names[sel])

  if (length(matched) == 0L) {
    message(
      "tar_fuzzy(): no targets matched '",
      string,
      "' for action '",
      action_label,
      "'."
    )
    return(invisible(character()))
  }

  if (isTRUE(downstream)) {
    net <- targets::tar_network(targets_only = TRUE, quiet = TRUE)
    edges <- net$edges[c("from", "to")]

    closure <- function(seeds, edges) {
      out <- unique(seeds)
      repeat {
        new <- unique(edges$to[edges$from %in% out])
        new <- setdiff(new, out)
        if (length(new) == 0L) {
          break
        }
        out <- c(out, new)
      }
      unique(out)
    }

    matched <- closure(matched, edges)
  }

  if (dry_run) {
    message(
      "tar_fuzzy(): dry run for action '",
      action_label,
      "'. Matched targets (",
      length(matched),
      "):\n",
      paste(matched, collapse = ", ")
    )
    return(invisible(matched))
  }

  message(
    "tar_fuzzy(): running action '",
    action_label,
    "' on ",
    length(matched),
    " target(s)."
  )
  dots <- list(...)
  do.call(action, c(list(names = matched), dots))
  invisible(matched)
}

#' Run targets actions on fuzzy-matched names
#'
#' `tar_fuzzy_make()` builds fuzzy-matched targets, while
#' `tar_fuzzy_invalidate()` invalidates the matching set. Both helpers can
#' optionally include downstream dependents and support dry runs.
#'
#' @param string        A single string used to match target names.
#' @param regex         Treat `string` as a regular expression? (default TRUE)
#' @param ignore_case   Case-insensitive match? (default FALSE)
#' @param downstream    Also include *downstream* targets that depend on matches?
#'                      Note: `targets` automatically includes required upstream dependencies.
#' @param dry_run       If TRUE, show and return the matched target names without running the action.
#' @param ...           Passed through to the underlying `targets` function.
#'
#' @return              Invisibly returns the character vector of matched target names.
#' @export
tar_fuzzy_make <- function(
  string,
  regex = TRUE,
  ignore_case = FALSE,
  downstream = FALSE,
  dry_run = FALSE,
  ...
) {
  tar_fuzzy(
    string = string,
    action = targets::tar_make,
    action_label = "make",
    regex = regex,
    ignore_case = ignore_case,
    downstream = downstream,
    dry_run = dry_run,
    ...
  )
}

#' @rdname tar_fuzzy_make
#' @export
tar_fuzzy_invalidate <- function(
  string,
  regex = TRUE,
  ignore_case = FALSE,
  downstream = FALSE,
  dry_run = FALSE,
  ...
) {
  tar_fuzzy(
    string = string,
    action = targets::tar_invalidate,
    action_label = "invalidate",
    regex = regex,
    ignore_case = ignore_case,
    downstream = downstream,
    dry_run = dry_run,
    ...
  )
}
