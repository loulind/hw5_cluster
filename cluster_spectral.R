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
    K.max = 10,
    B = 100
  )
  
  optimal_k <- maxSE(f = gap_stat$Tab[, "gap"], SE.f = gap_stat$Tab[, "SE.sim"])
  
  gap_stats_df <- rbind(gap_stats_df, data.frame(max_radius = i - 1, 
                                                 opt_clstr = optimal_k)
  )
}

# Visualize predicted clusters as a function of max_radius
true_clusters <- 4  # <-- set the known number of clusters here

pred_clstr_cnts2 <- ggplot(gap_stats_df, aes(x = max_radius, y = opt_clstr)) +
  geom_line(aes(color = "Estimated clusters"), linewidth = 1.1) +
  geom_point(aes(color = "Estimated clusters"), size = 3) +
  geom_hline(aes(yintercept = true_clusters, color = "True clusters"), 
             linetype = "dashed", linewidth = 1) +
  scale_color_manual(
    name = "",
    values = c("Estimated clusters" = "#0072B2", "True clusters" = "red")
  ) +
  scale_x_continuous(
    breaks = gap_stats_df$max_radius,
    minor_breaks = NULL
  ) +
  scale_y_continuous(
    breaks = 1:10,
    limits = c(1, 10),
    minor_breaks = NULL
  ) +
  labs(
    title = "Estimated # Clusters over Max Radius",
    x = "Maximum Radius",
    y = "Estimated # Clusters"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title = element_text(face = "bold"),
    legend.position = "top",
    panel.grid.minor = element_blank(),  # ensures no minor grid lines
    panel.grid.major.x = element_line(linewidth = 0.4, color = "gray80"),
    panel.grid.major.y = element_line(linewidth = 0.4, color = "gray80")
  )

ggsave(filename = "~/work/task2figures/pred_clstr_cnts2.png", 
       plot = pred_clstr_cnts2, 
       width = 6, 
       height = 4, 
       units = "in")