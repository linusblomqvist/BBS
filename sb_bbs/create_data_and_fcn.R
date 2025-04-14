library(tidyverse)
library(lubridate)
library(gridExtra)
library(janitor)
library(RColorBrewer)
library(DT)
library(magrittr)
library(shinythemes)
library(scales)
library(readxl)

# setwd("/Users/linusblomqvist/Library/CloudStorage/Dropbox/Birding/BBS/sb_bbs")

# Read in data
bbs_df_raw <- read_xlsx("SB BBS 11 April 2025 13051.xlsx", sheet = 4)
aba_list_raw <- read_csv("ABA_Checklist-8.17.csv")

bbs_df <- janitor::clean_names(bbs_df_raw)

bbs_df <- bbs_df %>%
  select(record_number, common_name, locality, observation_date, breeding_evidence, 
         observation_details, nest_structure_or_substrate)

# Standardize date format
bbs_df$observation_date <- ymd(bbs_df$observation_date)

bbs_df <- bbs_df %>%
  filter(!(is.na(observation_date)))

# Make a new variables for week, month, day
bbs_df$week <- week(bbs_df$observation_date)
bbs_df$day <- day(bbs_df$observation_date)

# Get unique types of breeding evidence
breeding_evidence_all <- unique(bbs_df$breeding_evidence)

breeding_evidence_selected <- c("Fledgling out of Nest--Brancher",
                       "Nestling in Nest",
                       "Egg in Nest",
                       "Fledgling under Parental Care",
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
  mutate(breeding_evidence_type = case_when(
    breeding_evidence %in% c("Carrying Nesting Material", "Nest Building") ~ "Nest construction",
    breeding_evidence %in% c("Copulation", "Egg in Nest") ~ "Copulation and eggs in nest",
    breeding_evidence %in% c("Carrying Food", "Delivering Food to Nest or Cavity", "Nestling in Nest",
                             "Carrying Fecal Sac", "Fledgling out of Nest--Brancher") ~ "Nestling and brancher",
    breeding_evidence %in% c("Family Group in Close Association", "Feeding Fledgling",
                             "Fledgling Begging", "Fledgling under Parental Care", "Fledgling with Presumed Parent") ~ "Fledglings and families",
    breeding_evidence == "Juvenile Independent" ~ "Juvenile Independent",
    .default = NA
  ))

bbs_df <- bbs_df %>%
  mutate(breeding_evidence = case_when(
    breeding_evidence == "Adult at Nest (clarify)" ~ "Adult at Nest",
    breeding_evidence == "Nest in Use (clarify)" ~ "Nest in Use",
    .default = breeding_evidence
  ))

# Week and month key
week_key <- data.frame(floor_day = seq(as.Date("2021-1-1"), as.Date("2021-12-31"),
                                       by = "weeks"), week = 1:53)

# Floor day is just a date in 2021 that corresponds to a given week (1-53)
# or month (1-12). This is so that the x axis retains a date format

# Taxonomic order
aba_list <- aba_list_raw %>%
  set_names(c("family", "species", "french_name", "scientific_name", "letter_code", "code")) %>%
  filter(!is.na(species)) %>%
  select(species) %>%
  rename(common_name = species) %>%
  add_row(.before = 1031) %>%
  mutate(common_name = ifelse(common_name == "(Northern) House Wren", "Northern House Wren", common_name))

# Note (Northern) House Wren in ABA

aba_list$common_name[1031] <- "Belding's Savannah Sparrow"

bbs_df <- left_join(aba_list, bbs_df, by = "common_name") %>%
  filter(!is.na(record_number))

# Clean up empty spaces in nest_structure
bbs_df <- bbs_df %>%
  mutate(nest_structure_or_substrate = case_when(
    str_detect(nest_structure_or_substrate, regex("^\\s*?$")) == TRUE ~ NA,
    .default = nest_structure_or_substrate
  ))

# Check common nest structures
bbs_df %>%
  filter(!is.na(nest_structure_or_substrate)) %>%
  group_by(nest_structure_or_substrate) %>%
  summarize(n = n()) %>%
  arrange(desc(n))

tree_search_fcn <- function(tree) {
  bbs_df %>%
    filter(str_detect(bbs_df$nest_structure_or_substrate, regex(tree, ignore_case = T)) == TRUE) %$%
    unique(nest_structure_or_substrate)
}

# Create tree type
bbs_df <- bbs_df %>%
  mutate(tree_type = case_when(
    nest_structure_or_substrate %in% tree_search_fcn("oak") ~ "Oak",
    nest_structure_or_substrate %in% tree_search_fcn("sycamore") ~ "Sycamore",
    nest_structure_or_substrate %in% tree_search_fcn("eucalyptus") ~ "Eucalyptus",
    nest_structure_or_substrate %in% tree_search_fcn("pine") ~ "Pine",
    nest_structure_or_substrate %in% tree_search_fcn("willow") ~ "Willow",
    nest_structure_or_substrate %in% tree_search_fcn("palm") ~ "Palm",
    nest_structure_or_substrate %in% tree_search_fcn("cypress") ~ "Cypress",
    nest_structure_or_substrate %in% tree_search_fcn("cottonwood") ~ "Cottonwood",
    nest_structure_or_substrate %in% tree_search_fcn("fig") ~ "Fig"
  ))

breeding_evidence_trees <- c("Egg in Nest", "Adult at Nest", "Nestling in Nest", 
                             "Fledgling out of Nest--Brancher", "Nest Building", 
                             "Nest in Use", "Carrying Nesting Material", 
                             "Cavity Nester Attending Cavity", "Delivering Food to Nest or Cavity")

# Nest structure
tree_by_week <- bbs_df %>%
  filter(!is.na(tree_type)) %>%
  filter(breeding_evidence %in% breeding_evidence_trees) %>%
  mutate(breeding_evidence = factor(breeding_evidence)) %>%
  group_by(week, tree_type, breeding_evidence) %>%
  summarize(n = n())

tree_by_week_plot <- function(select_tree) {
  
  n_obs <- filter(tree_by_week, tree_type == select_tree) %>%
    ungroup() %>%
    summarize(sum(n))
  
  left_join(week_key, tree_by_week %>%
              filter(tree_type == select_tree), by = "week") %>%
    mutate(n = case_when(is.na(n) ~ 0, .default = n)) %>%
    ggplot(aes(x = floor_day, y = n, fill = breeding_evidence)) +
    geom_bar(position = "stack", stat = "identity") +
    labs(title = select_tree,
         x = "Date",
         y = "Observations per week",
         caption = str_c("n = ", n_obs, sep = "")) +
    theme_light() +
    standard_theme +
    theme(legend.position = "bottom",
          legend.title=element_blank()) +
    scale_x_date(date_labels = "%b", 
                 date_breaks = "1 month", 
                 limits = as_date(c("2021-01-01", "2021-12-31")),
                 minor_breaks = "1 week") +
    scale_y_continuous(breaks = pretty_breaks()) +
    scale_fill_discrete(drop = FALSE,
                        limits = levels(bbs_df$breeding_evidence),
                        na.translate = F) +
    guides(fill = guide_legend(nrow = 4, byrow = TRUE))
}

# Theme template
standard_theme <- theme(panel.grid.major.x = element_blank(),
                        panel.grid.minor.x = element_blank(),
                        text = element_text(size = 15),
                        plot.title = element_text(hjust = 0.5),
                        plot.subtitle = element_text(hjust = 0.5))

bbs_df <- bbs_df %>%
  filter(!is.na(breeding_evidence_type))

bbs_df <- bbs_df %>%
  mutate(breeding_evidence_type = factor(breeding_evidence_type, levels = c("Nest construction",
                                                                            "Copulation and eggs in nest",
                                                                            "Nestling and brancher",
                                                                            "Fledglings and families",
                                                                            "Juvenile Independent")))

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
    filter(!is.na(breeding_evidence_type)) %>%
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
    theme(legend.position = "right",
          legend.title=element_blank()) +
    scale_x_date(date_labels = "%b", 
                 date_breaks = "1 month", 
                 limits = as_date(c("2021-01-01", "2021-12-31")),
                 minor_breaks = "1 week") +
    guides(fill = guide_legend(nrow = 5, byrow = TRUE)) +
    scale_fill_discrete(drop = FALSE,
                        limits = levels(bbs_df$breeding_evidence_type)) +
    scale_y_continuous(breaks = pretty_breaks())
}

# single_species_plot_function("California Towhee", "week")
