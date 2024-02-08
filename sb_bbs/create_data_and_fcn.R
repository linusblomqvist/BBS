library(tidyverse)
library(lubridate)
library(gridExtra)
library(janitor)
library(RColorBrewer)
library(DT)
library(magrittr)
library(shinythemes)
library(scales)

# Read in data
bbs_df <- read_csv("BBS_data_Jan_2024.csv")
aba_list <- read_csv("aba_checklist.csv")

bbs_df <- janitor::clean_names(bbs_df)

bbs_df <- bbs_df %>%
  select(record_number, common_name, locality, observation_date, breeding_evidence, 
         observation_details, nest_structure_or_substrate)

# Standardize date format
bbs_df$observation_date <- dmy(bbs_df$observation_date)

bbs_df <- bbs_df %>%
  filter(!(is.na(observation_date)))

bbs_df <- bbs_df %>%
  mutate(observation_date = case_when(record_number == 11965 ~ ymd("2011-04-07"),
                                      record_number == 11963 ~ ymd("2011-04-21"),
                                      record_number == 11964 ~ ymd("2011-04-21"),
                                      record_number == 11966 ~ ymd("2011-05-01"),
                                      record_number == 11967 ~ ymd("2011-05-01"),
                                      record_number == 11962 ~ ymd("2014-04-19"),
                                      record_number == 9535 ~ ymd("2019-02-21"),
                                      record_number == 11961 ~ ymd("2022-04-15"),
                                      record_number == 11948 ~ ymd("2022-08-14"),
                                      record_number == 11949 ~ ymd("2022-08-14"),
                                      record_number == 11940 ~ ymd("2022-08-15"),
                                      record_number == 11941 ~ ymd("2022-08-15"),
                                      record_number == 11942 ~ ymd("2022-08-15"),
                                      record_number == 11943 ~ ymd("2022-08-15"),
                                      record_number == 11944 ~ ymd("2022-08-18"),
                                      record_number == 11950 ~ ymd("2022-08-18"),
                                      record_number == 11951 ~ ymd("2022-08-19"),
                                      record_number == 11952 ~ ymd("2022-09-02"),
                                      record_number == 11953 ~ ymd("2022-09-03"),
                                      .default = observation_date))

# Make a new variables for week, month, day
bbs_df$week <- week(bbs_df$observation_date)
bbs_df$month <- month(bbs_df$observation_date)
bbs_df$day <- day(bbs_df$observation_date)

# Get unique types of breeding evidence
breeding_evidence_all <- unique(bbs_df$breeding_evidence)

breeding_evidence_selected <- c("Fledgling out of Nest--Brancher",
                       "Nestling in Nest",
                       "Egg in Nest",
                       "Fledgling under Parental Care",
                       "Fledgling Under Parental Care",
                       "Nest Building",
                       "Family Group in Close Association",
                       "Feeding Fledgling",
                       "Delivering Food to Nest or Cavity",
                       "Carrying Nesting Material",
                       "Carrying Food",
                       "Fledgling Begging",
                       "Fledgling with Presumed Parent",
                       "Juvenile Independent",
                       "Copulation",
                       "Carrying Fecal Sac")

bbs_df <- bbs_df %>%
  filter(breeding_evidence %in% breeding_evidence_selected)

bbs_df <- bbs_df %>%
  mutate(breeding_evidence_type = case_when(
    breeding_evidence %in% c("Carrying Nesting Material", "Nest Building") ~ "Nest construction",
    breeding_evidence %in% c("Copulation", "Egg in Nest") ~ "Copulation and eggs in nest",
    breeding_evidence %in% c("Carrying Food", "Delivering Food to Nest or Cavity", "Nestling in Nest",
                             "Carrying Fecal Sac", "Fledgling out of Nest--Brancher") ~ "Nestling and brancher",
    breeding_evidence %in% c("Family Group in Close Association", "Feeding Fledgling",
                             "Fledgling Begging", "Fledgling under Parental Care", "Fledgling Under Parental Care",
                             "Fledgling with Presumed Parent") ~ "Fledglings and families",
    breeding_evidence == "Juvenile Independent" ~ "Juvenile Independent"
  ))

bbs_df <- bbs_df %>%
  mutate(breeding_evidence_type = factor(breeding_evidence_type, levels = c("Nest construction",
                                                                            "Copulation and eggs in nest",
                                                                            "Nestling and brancher",
                                                                            "Fledglings and families",
                                                                            "Juvenile Independent")))

# https://stackoverflow.com/questions/6919025/how-to-assign-colors-to-categorical-variables-in-ggplot2-that-have-stable-mappin

# Week and month key
week_key <- data.frame(floor_day = seq(as.Date("2021-1-1"), as.Date("2021-12-31"),
                                       by = "weeks"), week = 1:53)
month_key <- data.frame(floor_day = seq(as.Date("2021-1-1"), as.Date("2021-12-31"),
                                        by = "months"), month = 1:12)

# Floor day is just a date in 2021 that corresponds to a given week (1-53)
# or month (1-12). This is so that the x axis retains a date format

# Taxonomic order
aba_list <- aba_list %>%
  select(species) %>%
  rename(common_name = species) %>%
  mutate(common_name = case_when(
    common_name == "Pacific-slope Flycatcher" ~ "Western Flycatcher",
    .default = common_name
  )) %>%
  filter(common_name != "Cordilleran Flycatcher")

bbs_df <- left_join(aba_list, bbs_df, by = "common_name") %>%
  filter(!is.na(record_number)) %>%
  select(-record_number)

# Clean up empty spaces in nest_structure
bbs_df <- bbs_df %>%
  mutate(nest_structure_or_substrate = case_when(
    str_detect(nest_structure_or_substrate, regex("^\\s*?$")) == TRUE ~ NA,
    .default = nest_structure_or_substrate
  ))

# Check common nest structures
obs_by_nest_structure <- bbs_df %>%
  filter(!is.na(nest_structure_or_substrate)) %>%
  group_by(nest_structure_or_substrate) %>%
  summarize(n = n()) %>%
  arrange(desc(n))

# oak, sycamore, eucalyptus, pine, willow, palm, cypress, cottonwood, fig, 

tree_search_fcn <- function(tree) {
  bbs_df %>%
    filter(str_detect(bbs_df$nest_structure_or_substrate, regex(tree, ignore_case = T)) == TRUE) %$%
    unique(nest_structure_or_substrate)
}

oak <- tree_search_fcn("oak")
sycamore <- tree_search_fcn("sycamore")
eucalyptus <- tree_search_fcn("eucalyptus")
pine <- tree_search_fcn("pine")
willow <- tree_search_fcn("willow")
palm <- tree_search_fcn("palm")
cypress <- tree_search_fcn("cypress")
cottonwood <- tree_search_fcn("cottonwood")
fig <- tree_search_fcn("fig")

# Create tree type
bbs_df <- bbs_df %>%
  mutate(tree_type = case_when(
    nest_structure_or_substrate %in% oak ~ "Oak",
    nest_structure_or_substrate %in% sycamore ~ "Sycamore",
    nest_structure_or_substrate %in% eucalyptus ~ "Eucalyptus",
    nest_structure_or_substrate %in% pine ~ "Pine",
    nest_structure_or_substrate %in% willow ~ "Willow",
    nest_structure_or_substrate %in% palm ~ "Palm",
    nest_structure_or_substrate %in% cypress ~ "Cypress",
    nest_structure_or_substrate %in% cottonwood ~ "Cottonwood",
    nest_structure_or_substrate %in% fig ~ "Fig"
  ))

# Nest structure
tree_by_week <- bbs_df %>%
  filter(!is.na(tree_type)) %>%
  group_by(week, tree_type) %>%
  summarize(n = n())

tree_by_week_plot <- function(select_tree) {
  
  n_obs <- filter(tree_by_week, tree_type == select_tree) %>%
    ungroup() %>%
    summarize(sum(n))
  
  left_join(week_key, tree_by_week %>%
              filter(tree_type == select_tree), by = "week") %>%
    mutate(n = case_when(is.na(n) ~ 0, .default = n)) %>%
    ggplot(aes(x = floor_day, y = n)) +
      geom_line() +
    labs(title = select_tree,
         x = "Date",
         y = "Observations per week",
         caption = str_c("n = ", n_obs, sep = "")) +
    theme_light() +
    standard_theme +
    scale_x_date(date_labels = "%b", 
                 date_breaks = "1 month", 
                 limits = as_date(c("2021-01-01", "2021-12-31")),
                 minor_breaks = "1 week") +
    scale_y_continuous(breaks = pretty_breaks())
}

# Day of year
bbs_df <- bbs_df %>%
  mutate(day_of_year = yday(observation_date))

# Theme template
standard_theme <- theme(panel.grid.major.x = element_blank(),
                        panel.grid.minor.x = element_blank(),
                        text = element_text(size = 15),
                        plot.title = element_text(hjust = 0.5),
                        plot.subtitle = element_text(hjust = 0.5))

# Color scheme
my_colors <- brewer.pal(5, "Set3")
names(my_colors) <- levels(bbs_df$breeding_evidence_type)
col_scale <- scale_colour_manual(name = "breeding_evidence_type", values = my_colors)

# Single species
single_species_plot_function <- function(select_species, time_aggr) {
  
  n_obs <- nrow(filter(bbs_df, common_name == select_species))
  
  if (time_aggr == "month") {
    time_key <- month_key
  } else if (time_aggr == "week") {
    time_key <- week_key
  }
  
  bbs_df %>% # start with full dataset
    filter(common_name == select_species) %>% # only include select species
    #filter(Breeding.Evidence %in% select_breeding_evidence) %>% # only certain kinds of evidence
    group_by(!!as.name(time_aggr), breeding_evidence_type) %>% # summarize over weeks or months
    tally() %>% # count the number of observations
    left_join(time_key, by = time_aggr) %>% # merge a date onto the week/month number
    ggplot(aes(x = floor_day, y = n, fill = breeding_evidence_type)) +
    geom_bar(position = "stack", stat = "identity") +
    labs(title = select_species,
         x = "Date",
         y = str_c("Observations per ", time_aggr),
         caption = str_c("n = ", n_obs, sep = "")) +
    theme_light() +
    standard_theme +
    theme(legend.position = "bottom",
          legend.title=element_blank()) +
    scale_x_date(date_labels = "%b", 
                 date_breaks = "1 month", 
                 limits = as_date(c("2021-01-01", "2021-12-31")),
                 minor_breaks = "1 week") +
    guides(fill = guide_legend(nrow = 5, byrow = TRUE)) +
    scale_fill_discrete(drop = FALSE,
                        limits = levels(bbs_df$breeding_evidence_type))
}

# single_species_plot_function("California Towhee", "week")

# save(bbs_df, month_key, month_key_Dec, standard_theme, week_key, week_key_Dec,
#      breeding_evidence, single_species_plot_function, file = "sb_bbs/objects.Rdata")
