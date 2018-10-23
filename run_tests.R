library(testthat)
library(shinytest)

test_that("Application works", {
  # Use compareImages=FALSE, interactive=FALSE
  expect_pass(testApp(".", compareImages = FALSE, interactive = FALSE))
})
