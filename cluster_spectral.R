# This script conducts spectral clustering on the TASK 2 data
library(tidyverse)
library(cluster)

# Import Data
list_of_sphere_dfs <- list()
for (i in 0:10){
  full_path <- paste0("~/work/task2data/df_maxradius", i, ".csv")
  list_of_sphere_dfs[[i+1]] <- read_csv(full_path)
  names(list_of_sphere_dfs)[i+1] <- paste0("df_maxradius", i)
}

# Transformation wrapper function
spectral <- function(x, k, d_threshold = 1.0) {
  # 1. Adjacency matrix
  n <- nrow(x)
  A <- matrix(0, n, n)  # nxn zero matrix
  D <- as.matrix(dist(x))  # computing pairwise euclidean distances
  A[D < d_threshold] <- 1  # Aij=1 if dist(i,j) is less than the threshold
  
  # 2. Computing graph Laplacian
  degrees <- rowSums(A) # number edges connected to a vertex
  D <- diag(degrees)  # degree matrix
  D_inv_sqrt <- diag(1 / sqrt(degrees))  # inverse of sqrt of matrix
  L <- D - A  # unnormalized Laplacian
  L_sym <- D_inv_sqrt %*% L %*% D_inv_sqrt  # normalized
  
  # 3. Eigen-decomp
  eig <- eigen(L_sym, symmetric = TRUE)
  idx <- order(eig$values)  # order by decreasing eigenvalue
  eig_vecs <- eig$vectors[, idx[1:k]]  # gives eigvecs corresp to k smallest eigvals
  
  # 4. Cluster Eigenvecs
  km <- kmeans(eig_vecs, centers = k, nstart = 10)  # final cluster assignment
  
  return(list(cluster = km$cluster))  # outputing in a form that clusGap wants
}

# Finding number of clusters with clusGap
gap_stats_df <- data.frame()  # initializes df to hold gap stats
for (i in seq_along(list_of_sphere_dfs)) {
    gap_stat <- list_of_sphere_dfs[[i]] |>
      select(-shell) |>
      as.matrix() |>
      clusGap(FUNcluster = function(x, k) spectral(x, k, d_threshold = 1), 
              K.max = 10,
              B = 50)  # B=3 TOOK AN HOUR TO COMPUTE
    optimal_k <- maxSE(f = gap_stat$Tab[, "gap"],  # stores optimal cluster cnt
                       SE.f = gap_stat$Tab[, "SE.sim"])
    gap_stats_df <- c(i-1,optimal_k) |> rbind(gap_stats_df)
}
colnames(gap_stats_df) <- c("max_radius", "opt_clstr")

# ...........TEST...............
list_of_sphere_dfs[[5]] |>
  select(-shell) |>
  as.matrix() |>
  clusGap(FUNcluster = function(x, k) spectral(x, k, d_threshold = 1), 
          K.max = 10,
          B = 50)  # B=3 TOOK AN HOUR TO COMPUTE
# ...........TEST...............

# Visualize predicted clusters as a function of max_radius
ggplot(gap_stats_df, aes(x = max_radius, y = opt_clstr)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_hline(yintercept = 4, linetype = "dashed", color = "red", linewidth = 1) +
  scale_x_continuous(
    breaks = seq(10, 0, by = -1),
    limits = c(10, 0)
  ) +
  scale_y_continuous(
    breaks = seq(0, max(gap_stats_df$opt_clstr, na.rm = TRUE) + 1, by = 1),
    limits = c(1,6)
  ) +
  labs(
    title = "Spectral Clustering Performance on Concentric Shells",
    subtitle = "Predicted number of clusters vs. maximum shell radius",
    x = "Maximum Radius",
    y = "Predicted Number of Clusters"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.minor.y = element_blank()  # removes minor y grid lines
  )