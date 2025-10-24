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
gap_stats_df <- rename(gap_stats_df, n=X1L, side_length=X10L, opt_clstr=X2L)

# Visualizing clusters
pred_clstr_cnts <- ggplot(gap_stats_df, 
                          aes(x = side_length, 
                              y = opt_clstr, 
                              color = as.factor(n))) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  geom_hline(aes(yintercept = n), linetype = "dashed", color = "black") +
  scale_x_reverse(breaks = unique(gap_stats_df$side_length)) +  
  scale_y_continuous(breaks = seq(0, max(gap_stats_df$n), 1)) +
  labs(
    title = "Estimated Clusters vs. Side Length",
    x = "Side Length",
    y = "Estimated Number of Clusters",
    color = "Dimension (n)"
  ) +
  theme_minimal(base_size = 14)

ggsave(filename = "~/work/task1figures/pred_clstr_cnts.png", 
       plot = pred_clstr_cnts, 
       width = 6, 
       height = 4, 
       units = "in")