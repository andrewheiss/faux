context("test-plot_design")

test_that("2w", {
  within <- list(time = c("day", "night"))
  between <- list()
  mu <- c(1,2)
  d <- sim_design(within, between, mu = mu, long = TRUE, plot = FALSE)
  plot_design(d)
})

test_that("2w*2b", {
  within <- list(time = c("day", "night"))
  between <- list(pet = c("dog", "cat"))
  mu <- list(
    dog = c(1,2),
    cat = c(3,4)
  )
  d <- sim_design(within, between, mu = mu, long = TRUE, plot = FALSE)
  design <- get_design_long(d)
  plot_design(design)
})

test_that("2w*2b", {
  within <- list(time = c("day", "night"))
  between <- list(pet = c("dog", "cat"))
  mu <- list(dog = 1:2, cat = 3:4)
  check_design(within, between, mu = mu)
})

test_that("2w*2w*2b", {
  within <- list(time = c("day", "night"), condition = c("A", "B"))
  between <- list(pet = c("dog", "cat"))
  mu <- list(dog = 1:4, cat = 2:5)
  check_design(within, between, mu = mu) %>%
    plot_design()
})

test_that("2w*2w*2b*2b", {
  within <- list(pet = c("ferret", "dog", "cat"), condition = c("A", "B"))
  between <- list(time = c("night", "day"), age = c("old", "young"))
  mu <- list(night_old = 1:6, 
             day_old = 2:7,
             night_young = 3:8, 
             day_young = 4:9)
  design <- check_design(within, between, mu = mu, plot = FALSE)
  plot_design(design)
})