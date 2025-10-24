FROM rocker/verse:latest

USER root

# Installs cluster package into R
RUN R -e "install.packages('cluster')"
RUN R -e "install.packages('plotly')"
