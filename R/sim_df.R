#' Simulate an existing dataframe
#'
#' \code{sim_df} Produces a data table with the same distributions and correlations 
#' as an existing data table Only returns numeric columns and simulates all numeric 
#' variables from a continuous normal distribution (for now).
#'
#' @param data the existing tbl (must be in wide format)
#' @param n the number of samples to return per group
#' @param within a list of the within-subject columns
#' @param between a list of the between-subject columns
#' @param dv the name of the DV (value) column
#' @param id the names of the column(s) for grouping observations
#' @param empirical Should the returned data have these exact parameters? (versus be sampled from a population with these parameters)
#' @param long whether to return the data table in long format
#' @param seed a single value, interpreted as an integer, or NULL (see set.seed)
#' @param grp_by (deprecated; use between)
#' 
#' @return a tbl
#' @examples
#' iris100 <- sim_df(iris, 100)
#' iris_species <- sim_df(iris, 100, between = "Species")
#' @export

sim_df <- function (data, n = 100, within = c(), between = c(), id = "id", dv = "value",
                    empirical = FALSE, long = FALSE, seed = NULL, grp_by = NULL) {
  if (!is.null(seed)) {
    # reinstate system seed after simulation
    sysSeed <- .GlobalEnv$.Random.seed
    on.exit({
      if (!is.null(sysSeed)) {
        .GlobalEnv$.Random.seed <- sysSeed 
      } else {
        rm(".Random.seed", envir = .GlobalEnv)
      }
    })
    set.seed(seed, kind = "Mersenne-Twister", normal.kind = "Inversion")
  }
  
  # error checking
  if ( !is.numeric(n) || n %% 1 > 0 || n < 3 ) {
    stop("n must be an integer > 2")
  }
  
  if (!is.null(grp_by)) {
    warning("grp_by is deprecated, please use between")
    if (between == c()) between = grp_by # set between to grp_by if between is not set
  }
  
  if (length(within)) {
    # convert long to wide
    data <- long2wide(data = data, within = within, between = between, dv = dv, id = id)
  }
  
  grpdat <- select_num_grp(data, between)
  
  if (length(between)) {
    if (is.numeric(between)) between <- names(data)[between]
    nestcols <- setdiff(names(grpdat), between)
  } else {
    nestcols <- names(grpdat)
  }
  
  simdat <- grpdat %>%
    tidyr::nest("data" = nestcols) %>%
    dplyr::mutate("newsim" = purrr::map(data, function(data) {
      rnorm_multi(
        n = n, 
        vars = ncol(data), 
        mu = t(dplyr::summarise_all(data, mean)), 
        sd = t(dplyr::summarise_all(data, sd)), 
        r = cor(data),
        varnames = names(data),
        empirical = empirical
      )
    })) %>%
    dplyr::select(-.data$data) %>%
    tidyr::unnest(.data$newsim) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(!!id := make_id(nrow(.))) %>%
    dplyr::select(!!id, tidyselect::everything())
  
  return(simdat)
}
