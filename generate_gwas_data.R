generate_gwas_data <- function(n = 100000) {
  chromosomes <- 1:23
  max_bp <- 1e8

  data <- data.frame(
    SNP = character(n),
    CHR = integer(n),
    BP = integer(n),
    P = numeric(n),
    stringsAsFactors = FALSE
  )

  data$SNP <- paste0("rs", sample(1:100000000, n, replace = TRUE))
  data$CHR <- sample(chromosomes, n, replace = TRUE)
  data$BP <- sample(1:max_bp, n, replace = TRUE)
  data$P <- runif(n, 0, 1)

  return(data)
}
