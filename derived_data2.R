# This script creates the data for TASK 2: Spectral Clustering
library(tidyverse)
library(plotly)

generate_shell_clusters <- function(n_shells, k_per_shell, 
                                    max_radius, noise_sd = 0.1) {
  df_spherical <- data.frame()
  for (i in 1:n_shells) {
    k <- k_per_shell*(i^2) # increases number of points per shell
    for (j in 1:k)  { # df of random values in spherical coordinates
      obs <- c(i,  # shell number
               (i*(max_radius/n_shells) + rnorm(1, sd=noise_sd)), # fuzzy radii
               2*pi*runif(1),  # uniformly distributed theta
               pi*runif(1) # uniformly distributed phi
               )
      df_spherical <- rbind(df_spherical, obs) # Each row is a vector
    }
  }
  colnames(df_spherical) <- c("shell", "rho", "theta", "phi")
  df_cartesian <- within(df_spherical, {  # adds cartesian coordinates to vecs
    z <- (rho * cos(theta))
    y <- (rho * sin(theta) * sin(phi))
    x <- (rho * sin(theta) * cos(phi))

  }) |> dplyr::select(-rho, -theta, -phi)
  return(df_cartesian)
}

# Implement data generation function
list_of_sphere_dfs <- list()
for (i in 10:0) {
  list_of_sphere_dfs[[i+1]] <- generate_shell_clusters(4,100,i)
  names(list_of_sphere_dfs)[i+1] <- paste0("df_maxradius", i)
}

# Interactive 3-D Scatter plot with plotly to confirm structure
scatter_3d <- plot_ly(
  data = list_of_sphere_dfs[[11]],
  x = ~x,
  y = ~y,
  z = ~z,
  color = ~factor(shell),
  colors = c("#D81B60", "#1E88E5", "#FFC107", "#004D40"), # colorblind-friendly palette
  type = "scatter3d",
  mode = "markers",
  marker = list(size = 1, opacity = 0.8)
)
scatter_3d

# Export Data
for (i in seq_along(list_of_sphere_dfs)){
  full_path <- paste0("~/work/task2data/", 
                     names(list_of_sphere_dfs)[i], 
                     ".csv")
  write.csv(list_of_sphere_dfs[[i]], file = full_path, row.names = F)
}
