# This script creates the data for TASK 1: K-Means Clustering
library(tidyverse)

# Function that generates noisy positive corners of n-dimensional cube
generate_hypercube_clusters <- function(n, side_length, k, noise_sd = 1.0){
  scaled_basis_vecs <- side_length*diag(n)
  noisy_matrix <- rnorm(n*n, mean=0, sd=1) |> matrix(nrow=n, ncol=n)
  scaled_noisy_matrix <- scaled_basis_vecs + noisy_matrix
  cluster_matrix <- cbind(scaled_noisy_matrix, rep(side_length, n))
  cluster_df <- as.data.frame(cluster_matrix) |> rename(side_length = last_col())
  return(cluster_df)
}

# Generating data sets and concatenating them by dimension
for (i in 2:6) {
  intmd_df <- data.frame()  # resets intermediate df
  for (j in 1:10) {  # iterates through all side lengths
    for (k in 1:100) {  # 100 repetitions
      intmd_df <- generate_hypercube_clusters(i, j, k) |> rbind(intmd_df)
    }
  }
  df_name_str <- paste0("df_n", i)
  assign(df_name_str, intmd_df)  # creates new dataframe for each dimension
}

# Export the data frame to CSV
write.csv(df_n2, "~/work/task1data/df_n2", row.names = FALSE)
write.csv(df_n3, "~/work/task1data/df_n3", row.names = FALSE)
write.csv(df_n4, "~/work/task1data/df_n4", row.names = FALSE)
write.csv(df_n5, "~/work/task1data/df_n5", row.names = FALSE)
write.csv(df_n6, "~/work/task1data/df_n6", row.names = FALSE)