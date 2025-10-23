# This script conducts kmeans clustering on the TASK 1 data
library(tidyverse)
library(cluster)

df_n2 <- read_csv("work/task1data/df_n2")
df_n3 <- read_csv("work/task1data/df_n3")
df_n4 <- read_csv("work/task1data/df_n4")
df_n5 <- read_csv("work/task1data/df_n5")
df_n6 <- read_csv("work/task1data/df_n6")

list_of_dfs <- list(df_n2, df_n3, df_n4, df_n5, df_n6)
list_of_dfs[1]

gap_stats_df <- data.frame()  # initializes df to hold gap stats
for (i in 1:5) {
  for (j in 10:1) {
    gap_stat <- list_of_dfs[[i]] |>
      dplyr::filter(side_length == j) |> 
      select(-side_length) |>
      clusGap(FUNcluster = kmeans, K.max = 10, nstart = 20)
    gap_stats_df <- gap_stat$[] |> rbind(gap_stats_df)
    
  }
}
view(gap_stats_df)

gap_stat <- list_of_dfs[[5]] |>
  dplyr::filter(side_length == 10) |> 
  select(-side_length) |>
  clusGap(FUNcluster = kmeans, K.max = 10, nstart = 20)
print(gap_stat)
gap_stat
view(gap_stat)