source("app.R")

testServer(server, {
  # Simulate interaction with n_points = 500000
  session$setInputs(n_points = 500000)
  expect_equal(nrow(data()), 500000)
  output$manhattanPlot # Simulates rendering of the plot

  # Simulate interaction with n_points = 1000000
  session$setInputs(n_points = 1000000)
  expect_equal(nrow(data()), 1000000)
  output$manhattanPlot # Simulates rendering of the plot

  # Simulate interaction with n_points = 1500000
  session$setInputs(n_points = 1500000)
  expect_equal(nrow(data()), 1500000)
  output$manhattanPlot # Simulates rendering of the plot

  # Simulate interaction with n_points = 2000000
  session$setInputs(n_points = 2000000)
  expect_equal(nrow(data()), 2000000)
  output$manhattanPlot # Simulates rendering of the plot

  # Simulate interaction with n_points = 2500000
  session$setInputs(n_points = 2500000)
  expect_equal(nrow(data()), 2500000)
  output$manhattanPlot # Simulates rendering of the plot

  # Simulate interaction with n_points = 3000000
  session$setInputs(n_points = 3000000)
  expect_equal(nrow(data()), 3000000)
  output$manhattanPlot # Simulates rendering of the plot
})
