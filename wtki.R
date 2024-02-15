# White-tailed Kite

setwd("/Users/linusblomqvist/Library/CloudStorage/Dropbox/Birding/BBS/sb_bbs")
source("create_data_and_fcn.R")

setwd("~/Library/CloudStorage/Dropbox/Birding/BBS")
wtki_coverage <- read_csv("wtki_coverage.csv")

bbs_df %>%
  filter(common_name == "White-tailed Kite") %>%
  group_by(year(observation_date)) %>%
  tally() %>%
  rename(year = `year(observation_date)`) %>%
  ggplot(aes(x = year, y = n)) +
  geom_bar(stat = "identity") +
  labs(title = "White-tailed Kite breeding records") +
  theme(plot.title = element_text(hjust = 0.5))

wtki_coverage <- wtki_coverage %>%
  slice(1:25) %>% 
  select(1:36) %>%
  rename(site = `Nesting Open Spaces`) %>%
  type_convert() %>%
  pivot_longer(!site, names_to = "year", values_to = "code") %>%
  mutate(year = as.numeric(year))

years_df <- data.frame(year = 1990:2021)

wtki_by_year <- left_join(years_df, wtki_coverage, by = "year")

wtki_by_year <- wtki_by_year %>%
  mutate(breeding = case_when(
    code == 1 ~ TRUE,
    .default = FALSE
  ),
  surveyed = case_when(
    code %in% 1:5 ~ TRUE,
    .default = FALSE
  ))

wtki_by_year_count <- wtki_by_year %>%
  group_by(year) %>%
  summarize(breeding_records = sum(breeding),
            surveyed_nests = sum(surveyed)) %>%
  mutate(pct_breeding = breeding_records / surveyed_nests) %>%
  mutate(pct_breeding = case_when(
    is.nan(pct_breeding) ~ 0,
    .default = pct_breeding
  ))

wtki_by_year_count %>%
  ggplot(aes(x = year, y = pct_breeding)) +
  geom_bar(stat = "identity") +
  labs(title = "WTKI % surveyed nests with breeding")

