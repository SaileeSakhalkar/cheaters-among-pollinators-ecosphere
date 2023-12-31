# Script for generating an igraph circular network ----

# Setting working directory with package 'here'
install.packages("here")
library(here)


# Loading libraries ----
rm(list = ls()) # Remove all the objects we created so far.
library(igraph)
library(dplyr)
library(RColorBrewer)
library(readxl)
library(tidyverse)

# THIEF NETWORK ----

# Reading in data ----
# Read in the node list
(node_list <-  read_excel("../input/for_igraph.xlsx", 
                         sheet = "node_list_thieves"))

# Read in the edge list
(edge_list <- read_excel("../input/for_igraph.xlsx", 
                        sheet = "edge_list_thieves"))

# Format transformation ----

# Convert to edgelist to graph
net <- graph_from_data_frame(d = edge_list, vertices = node_list, directed = T)
  
# Check class
class(net)


# Setting network parameters ----

# Set colours. Ideally would have more colours, but can fix this later.
colrs <- brewer.pal(n = 11, name = "Spectral")
colrs <- colorRampPalette(colrs)(15)
V(net)$color <- colrs[V(net)]
edge.start <- ends(net, es=E(net), names=F)[,1]
edge.col <- V(net)$color[edge.start]

# Set layout
l <- layout_in_circle(net)

# Plot ----
(thieving_network <-  plot(net, 
           edge.arrow.size = 0.2, edge.color = edge.col, 
           edge.width = (E(net)$Weight*1.5),
           vertex.frame.color = "white", vertex.size = ((V(net)$Weight)/2),
           vertex.label = V(net)$F.G., vertex.label.color = "black",
           layout = l, edge.curved = 0.2, margin = c(0)))

# ROBBER NETWORK ----

# Reading in data ----
# Read in the node list, force checking
(node_list <-  read_excel("../input/for_igraph.xlsx", 
                          sheet = "node_list_robbers"))

# Read in the edge list, force checking
(edge_list <- read_excel("../input/for_igraph.xlsx", 
                         sheet = "edge_list_robbers"))

# Format transformation ----
# Convert to graph
net <- graph_from_data_frame(d = edge_list, vertices = node_list, directed = T)

# Check class
class(net)


# Setting network parameters ----

# Set colours. Ideally would have more colours, but can fix this later.
colrs <- brewer.pal(n = 11, name = "Spectral")
colrs <- colorRampPalette(colrs)(15)
V(net)$color <- colrs[V(net)]
edge.start <- ends(net, es = E(net), names = F)[ ,1]
edge.col <- V(net)$color[edge.start]

# Set layout
l <- layout_in_circle(net)

# Plot ----
(robbing_network <- plot(net, 
          edge.arrow.size = 0.2, edge.color = edge.col, 
          edge.width = (E(net)$Weight*1.5),
          vertex.frame.color = "white", vertex.size = ((V(net)$Weight)/2),
          vertex.label = V(net)$F.G., vertex.label.color = "black",
          layout = l, edge.curved = 0.2, margin = c(0)))

# Creating heatmaps to accompany interaction networks -----

# Libraries ----
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}

# Thief heatmap ----

netx <- read_excel("../input/for_igraph.xlsx", sheet = "edge_list_thieves")

ggplot(netx, aes(x = Pollinator, y = Thief, fill = `Weight`)) +
  geom_tile() +
  geom_text(aes(label = round(`Weight`, 1)), color = "black") +
  scale_fill_gradient(low = "khaki1", high = "orange") +
  theme(axis.text.x = element_text(angle = 10, hjust = 0),
        panel.background=element_rect(fill="white", colour="black"),
        legend.position = "none") + 
  labs(title = "Plant species shared by thieves and pollinators")


# Robber heatmap ----
nety <- read_excel("../input/for_igraph.xlsx", sheet = "edge_list_robbers")


ggplot(nety, aes(x = Pollinator, y = Robber, fill = `Weight`)) +
  geom_tile() +
  geom_text(aes(label = round(`Weight`, 1)), color = "black") +
  scale_fill_gradient(low = "khaki1", high = "orange") +
  theme(axis.text.x = element_text(angle = 10, hjust = 0),
        panel.background=element_rect(fill="white", colour="black"),
        legend.position = "none") + 
  labs(title = "Plant species shared by robbers and pollinators")
