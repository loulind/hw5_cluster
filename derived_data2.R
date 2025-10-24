# This script creates the data for TASK 2: Spectral Clustering
library(tidyverse)
library(plotly)

generate_shell_clusters <- function(n_shells, k_per_shell, 
                                    max_radius, noise_sd = 0.1) {
  df_spherical <- data.frame()
  for (i in 1:n_shells) {
    for (j in 1:k_per_shell) { # df of random values for (rho,theta,phi)
      obs <- c((n_shells + 1 - i),  # shell number
               (max_radius / i) + rnorm(1, mean=0, sd=noise_sd), # rand radius
               2*pi*runif(1),  # random theta
               pi*runif(1) # random phi
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
  colors = c("red", "green", "blue", "purple"),
  type = "scatter3d",
  mode = "markers",
  marker = list(size = 2, opacity = 0.8)
)

# Output data
for (i in seq_along(list_of_sphere_dfs)){
  full_path <- paste0("~/work/task2data/", 
                     names(list_of_sphere_dfs)[i], 
                     ".csv")
  write.csv(list_of_sphere_dfs[[i]], file = full_path, row.names = F)
}
