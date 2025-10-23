# This script conducts kmeans clustering on the TASK 1 data
library(tidyverse)
library(cluster)

df_n2 <- read_csv("work/task1data/df_n2")
df_n3 <- read_csv("work/task1data/df_n3")
df_n4 <- read_csv("work/task1data/df_n4")
df_n5 <- read_csv("work/task1data/df_n5")
df_n6 <- read_csv("work/task1data/df_n6")

list_of_dfs <- list(df_n2, df_n3, df_n4, df_n5, df_n6)

gap_stats_df <- data.frame()  # initializes df to hold gap stats
for (i in 1:5) {
  for (j in 1:10) {
    gap_stat <- list_of_dfs[[i]] |>
      dplyr::filter(side_length == j) |> 
      select(-side_length) |>
      clusGap(FUNcluster = kmeans, K.max = 10, nstart = 20)
    optimal_k <- maxSE(f = gap_stat$Tab[, "gap"],  # stores optimal cluster cnt
                       SE.f = gap_stat$Tab[, "SE.sim"])
    gap_stats_df <- c(i+1,j,optimal_k) |> rbind(gap_stats_df)
  }
}
view(gap_stats_df)