# This script creates the data for Lou's HW5 assignment
set.seed(123)
generate_hypercube_clusters <- function(n, k, side_length, noise_sd = 1.0){
  cluster_df <- data.frame()
  # want df with vars n, side_length, v1, ..., vn
  # create positive basis vectors, scaled by side_length
  # 
  
  return(cluster_df)
}


# Generating data sets and concatenating them by dimension
for (i in 1:6) {
  intermediate_df <- data.frame()  # resets dataframe
  for (j in 1:10) {
    intermediate_df <- generate_hypercube_clusters(i, 100, j) |> rbind(df)
  }
  df_name_str <- paste0("df_n", i)
  assign(df_name_str, intermediate_df)  # creates new dataframe for n=i
}

# Export the data frame to CSV
folder_path <- "~/work/task1data/n6l10.csv"
