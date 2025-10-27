# This script conducts spectral clustering on the TASK 2 data
# Note: I had to separate the Laplacian step from kmeans bc it took too long
library(tidyverse)
library(cluster)

# Import Data
list_of_sphere_dfs <- list()
for (i in 0:10){
  full_path <- paste0("~/work/task2data/df_maxradius", i, ".csv")
  list_of_sphere_dfs[[i+1]] <- read_csv(full_path)
  names(list_of_sphere_dfs)[i+1] <- paste0("df_maxradius", i)
}

# Transforming data first because laplacian step takes wayyyy too long
graph_laplacian <- function(x, d_threshold = 1.0) {
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
  idx <- order(eig$values)
  eig_vecs <- eig$vectors[, idx]
  return(eig_vecs)
}

transformed_dfs <- list()
for (i in seq_along(list_of_sphere_dfs)) {
  eig_vecs <- list_of_sphere_dfs[[i]] |>
    select(-shell) |>
    as.matrix() |>
    graph_laplacian()
  transformed_dfs[[i]] <- eig_vecs[, 1:10]  # keep only first 10 eigenvectors
}

# Rest of the spectral clustering fn to feed into clusGap
spectral <- function(x, k) {
  eig_vecs <- x[, 1:k]  # take first k smallest eigenvectors
  km <- kmeans(eig_vecs, centers = k, nstart = 20)
  return(list(cluster = km$cluster))
}

# Finding number of clusters with clusGap
gap_stats_df <- data.frame()

for (i in seq_along(transformed_dfs)) {
  gap_stat <- clusGap(
    transformed_dfs[[i]],
    FUNcluster = function(x, k) spectral(x, k),
    K.max = 4,
    B = 50
  )
  
  optimal_k <- maxSE(f = gap_stat$Tab[, "gap"], SE.f = gap_stat$Tab[, "SE.sim"])
  
  gap_stats_df <- rbind(gap_stats_df, data.frame(max_radius = i - 1, 
                                                 opt_clstr = optimal_k)
  )
}

# Visualize predicted clusters as a function of max_radius
