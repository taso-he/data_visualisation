# Data visualisation example code ----------------------------------------------

# Written by Luke Arundel, November 2023
# Updated by Mikayla Boginsky, November 2025

# Example code that can be used to create engaging charts in R
# Theme can be adjusted according to individual brand guidelines
# Data used here from TASO's report 'Approaches to addressing the ethnicity degree award gap' 

# Necessary files to run the code ---------------------------------------------

# example_data_vis.csv
# logo_transp.png
# Fonts need to be loaded in

# Loading libraries and data ---------------------------------------------------

# Load libraries (install if needed)

library(tidyverse) 
library(extrafont) # for loading fonts
library(ggtext) # for formatting chart text

# Load data 

df <- read.csv("example_data_vis.csv")

# Loading in fonts 

# There are multiple ways to load your own fonts into R 
# This method loads in the Windows fonts 

# font_import() # Uncomment if not run before
# Importing fonts takes a few minutes, but only needs to be run once
loadfonts(device = "win") # May need to be changed on Apple devices
fonts() #Check that fonts are loaded on your device. For TASO, the 
#required fonts are Neuton for titles and Barlow for all other text. 

# Loading in a logo / images 

png <- magick::image_read("logo_transp.png")
logo <- grid::rasterGrob(png, interpolate = TRUE)

# Creating a horizontal bar chart ----------------------------------------------

example_chart <- ggplot(df, aes(x = count, y = factor(category, levels = c("No", 
                                                                           "Yes - inadequately specified", 
                                                                           "Yes - explores the general approach", 
                                                                           "Yes - adequately specified (institutional level)", 
                                                                           "Yes - adequately specified (intervention level)")))) +
  # ^ sorting the bars in the chart in desired order
  geom_bar(stat = "identity", fill = "#3b66bc") + # Bar chart coloured blue
  theme_minimal() + # Setting the theme elements as minimal, adding elements we want back in 
  # Title, subtitle, axis titles and caption 
  labs(
    title = "Over 40 providers did not include a Theory of Change (ToC) in their Access and\nParticipation Plan (APP)",
    subtitle = "Figure 3: The number of Higher Education Providers (HEPs) who included a ToC in their APP",
    caption = "Source: TASO (2023), Approaches to addressing the ethnicity degree awarding gap",
    x = NULL, # Not showing X or Y axis title for this example chart
    y = NULL 
  ) +
  # Theme elements
  theme(
    theme(
      # Set the default text style for the plot
      text = element_text(family = "Barlow", size = 12),
      
      # Set the title, subtitle, and caption position and style
      plot.title.position = "plot",  # Align title with the whole plot, not just panel
      plot.title = element_text(family = "Neuton", size = 16), #Different title font 
      plot.subtitle = element_text(size = 12),
      plot.caption.position = "plot",
      plot.caption = element_text(hjust = 0, size = 9, face = "italic"),
      
      # Background color of the entire plot
      plot.background = element_rect(fill = "#EDEBE3", color = NA),
      
      # Plot margins (top, right, bottom, left)
      plot.margin = margin(0.25, 0.25, 0.4, 0.25, "in"), # Leave extra room at bottom for logo
      
      # Panel border and grid lines
      panel.border = ggplot2::element_blank(),
      panel.grid.major = element_line(colour = "#CECABC", linewidth = 0.3), 
      panel.grid.minor = element_blank(),
      
      # Background color of the plotting panel
      panel.background = ggplot2::element_rect(fill = "#edebe3", color = NA), 
      
      # Axis text and title styling
      axis.text = element_text(size = 10),
      axis.title = element_text(size = 9, face = "italic"),
      
      # Axis lines and ticks
      axis.line.y = element_blank(),  # Remove Y-axis line
      axis.line = element_line(colour = "#485866", linewidth = 0.5), # Default axis line style
      axis.text.x = element_text(margin = margin(t = 7, unit = "pt")), # Add space above X-axis labels
      axis.ticks.length = unit(0.3, "cm"), # Increase tick length
      axis.ticks.x = element_line(colour = "#485866", linewidth = 0.5), # Style X-axis ticks
      
      # Remove legend
      legend.position = "none"
    )
    
  )+ 
  coord_cartesian(clip = "off") + # Helpful for positioning things outside of the plot
  annotation_custom(logo, ymin = -6.8, xmin = 32, xmax = 42) 
  # Adding logo with annotation_custom can be fiddly. You may need to play around
  # with x and y min/max to size and place your image as you want

# Saving the chart 

# Saving here as a png, with a specified width and height
ggsave("example_chart.png", example_chart, width = 180, height = 120, units = "mm")

# Adding extra touches - highlighting datapoint of interest --------------------

extra_chart <- ggplot(df, aes(x = count, y = factor(category, levels = c("No", 
                                                                     "Yes - inadequately specified", 
                                                                     "Yes - explores the general approach", 
                                                                     "Yes - adequately specified (institutional level)", 
                                                                     "Yes - adequately specified (intervention level)")))) +
  geom_bar(stat = "identity", fill = "#EDEBE3") + # Adding bars of same colour as background underneath so alpha can be used for colouring
  geom_bar(stat = "identity", fill = "#3b66bc", alpha = 0.4) + # Making the bars a paler blue to help highlight point of interest later on
  theme_minimal() + 
  # Title, subtitle, axis titles and caption 
  labs(
    title = 'Over 40 providers <span style="color:#3b66bc;">did not include a Theory of Change (ToC)</span> in their Access and<br> Participation Plan (APP)',
    # By using ggtext::element_markdown, we can use markdown stylings to colour specific words in the chart to highlight a point
    subtitle = "Figure 3: The number of Higher Education Providers (HEPs) who included a ToC in their APP",
    caption = "Source: TASO (2023), Approaches to addressing the ethnicity degree awarding gap",
    x = NULL, 
    y = NULL 
  ) +
  # Theme elements
  theme(
    text = element_text(family = "Barlow", size = 12),
    plot.title.position = "plot",
    plot.title = ggtext::element_markdown(family = "Neuton", size = 16), 
    # ^ Using ggtext::element_markdown so we can use markdown stylings to colour specific words
    plot.subtitle = element_text(size = 12),
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0, size = 9, face = "italic"),
    plot.background = element_rect(fill = "#EDEBE3", color = NA),
    plot.margin = margin(0.25, 0.25, 0.4, 0.25, "in"), #adjust bottom margin to leave room for logo
    panel.border = ggplot2::element_blank(),
    panel.grid.major = element_line(colour = "#CECABC", linewidth = 0.3), 
    panel.grid.minor = element_blank(),
    panel.background = ggplot2::element_rect(fill = "#edebe3", color = NA), 
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 9, face = "italic"),
    axis.line.y = element_blank(),
    axis.line = element_line(colour = "#485866", linewidth = 0.5),
    axis.text.x = element_text(margin = margin(t = 7, unit = "pt")), 
    axis.ticks.length = unit(0.3, "cm"), # Increase the length of ticks
    axis.ticks.x = element_line(colour = "#485866", linewidth = 0.5), 
    legend.position = "none"
  ) + 
  coord_cartesian(clip = "off") + 
  annotation_custom(logo, ymin = -6.8, xmin = 32, xmax = 42) 

# Highlighting "No" 
extra_chart <- extra_chart + 
  geom_bar(data = subset(df, category == "No"), fill = "#3b66bc", stat = "identity", show.legend = FALSE) +
  # Highlighting "No" by colouring it solid blue
  geom_text(aes(label = count, colour = category), vjust = 0.5, hjust = 1.5, size = 4, family = "Barlow", fontface = "bold", 
            data = subset(df, category == "No"), color = "white") +
  # Adding data labels on the bars 
  geom_text(aes(label = count, colour = category), vjust = 0.5, hjust = 1.5, size = 4,family = "Barlow", 
            data = subset(df, category != "No"), color = "black") 

ggsave("extra_chart.png", extra_chart, width = 180, height = 120, units = "mm")
