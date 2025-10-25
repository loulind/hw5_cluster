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
  D <- diag(rowSums(A))  # diag mtx with entries = number edges connected to a vertex
  D_inv_sqrt <- diag(1 / sqrt(degrees))  # inverse of sqrt of matrix
  L <- D - A  # unnormalized Laplacian
  L_sym <- D_inv_sqrt %*% L %*% D_inv_sqrt  # normalized
  
  # 3. Eigen-decomp
  eig <- eigen(L_sym, symmetric = TRUE)
  idx <- order(eig$values)  # order by decreasing eigenvalue
  eig_vecs <- eig$vectors[, idx[1:k]]  # gives eigvecs corresp to k smallest eigvals
  
  # 4. Cluster Eigenvecs
  km <- kmeans(eig_vecs, centers = k, nstart = 10)  # final cluster assignment
}

# Finding number of clusters with clusGap
gap_stats_df <- data.frame()  # initializes df to hold gap stats
for (df_i in list_of_sphere_dfs) {
    gap_stat <- df_i |>
      select(-shell) |>
      as.matrix() |>
      clusGap(FUNcluster = spectral, K.max = 10, nstart = 20)
    optimal_k <- maxSE(f = gap_stat$Tab[, "gap"],  # stores optimal cluster cnt
                       SE.f = gap_stat$Tab[, "SE.sim"])
    gap_stats_df <- c(i+1,j,optimal_k) |> rbind(gap_stats_df)
}
colnames(gap_stats_df) <- c("max_radius", "opt_clstr")

# Visualize predicted clusters as a function of max_radius