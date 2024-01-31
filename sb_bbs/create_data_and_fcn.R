library(tidyverse)
library(lubridate)
library(gridExtra)

# Read in data
bbs_df <- read.csv("BBS_data.csv")

# # Change date for erroneous Allen's Hummingbird observation
# data$Date[data$Record.Number == "1043"] <- as.Date("2006-02-10")
# 
# # Change data for Red-tailed Hawk observation
# data$Date[data$Record.Number == "2441"] <- as.Date("2009-04-07")

# Delete erroneous record for RTHA
bbs_df <- bbs_df[bbs_df$Record.Number != 7170,]

# Weird date
bbs_df <- bbs_df[bbs_df$Record.Number != 9535,]

# Standardize date format
bbs_df$Date <- dmy(bbs_df$Date)

bbs_df <- bbs_df %>%
  filter(!(is.na(Date)))

# Make a new variables for week, month, day
bbs_df$Week <- week(bbs_df$Date)
bbs_df$Month <- month(bbs_df$Date)
bbs_df$Day <- day(bbs_df$Date)

# Get unique types of breeding evidence
breeding_evidence <- unique(bbs_df$Breeding.Evidence)

# Note: Index 5 and 27 both refer to fledgling under parental care

# Week and month key
week_key <- data.frame(floor_day = seq(as.Date("2021-1-1"), as.Date("2021-12-31"),
                                       by = "weeks"), Week = 1:53)
month_key <- data.frame(floor_day = seq(as.Date("2021-1-1"), as.Date("2021-12-31"),
                                        by = "months"), Month = 1:12)

week_key_Dec <- data.frame(floor_day = seq(as.Date("2020-12-1"), as.Date("2021-11-30"),
                                           by = "weeks"), Week = c(50:53, 1:49))
month_key_Dec <- data.frame(floor_day = seq(as.Date("2020-12-1"), as.Date("2021-11-30"),
                                            by = "months"), Month = c(12,1:11))

# Floor day is just a date in 2021 that corresponds to a given week (1-53)
# or month (1-12). This is so that the x axis retains a date format

# Theme template
standard_theme <- theme(panel.grid.major.x = element_blank(),
                        panel.grid.minor.x = element_blank(),
                        text = element_text(size = 15),
                        plot.title = element_text(hjust = 0.5),
                        plot.subtitle = element_text(hjust = 0.5))

# Single species
single_species_plot_function <- function(select_species, select_breeding_evidence, time_aggr, time_key) {
  n_obs <- nrow(filter(bbs_df, Common.Name == select_species, Breeding.Evidence %in% select_breeding_evidence))
  bbs_df %>% # start with full dataset
    filter(Common.Name == select_species) %>% # only include select species
    filter(Breeding.Evidence %in% select_breeding_evidence) %>% # only certain kinds of evidence
    group_by(!!as.name(time_aggr)) %>% # summarize over weeks or months
    tally() %>% # count the number of observations
    left_join(time_key, by = time_aggr) %>% # merge a date onto the week/month number
    ggplot(aes(x = floor_day, y = n)) +
    geom_point() +
    labs(title = select_species,
         x = "Date",
         y = str_c("Observations Per ", time_aggr),
         caption = str_c("n = ", n_obs, sep = "")) +
    theme_light() +
    standard_theme +
    theme(legend.position = "none") +
    scale_x_date(date_labels = "%b", date_breaks = "1 month")
}

# save(bbs_df, month_key, month_key_Dec, standard_theme, week_key, week_key_Dec,
#      breeding_evidence, single_species_plot_function, file = "sb_bbs/objects.Rdata")
