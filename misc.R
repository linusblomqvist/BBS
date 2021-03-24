data %>%
  filter(Record.Number == 3934)
View(filter(data, Record.Number == 3934))

test <- data %>% # start with full dataset
  filter(Common.Name == "Red-tailed Hawk") %>% # only include select species
  filter(Breeding.Evidence %in% rtha_evidence)

# With RS
evidence_rtha <- breeding_evidence[c(16,13,10,7,9,15,1,5,18,12,3,21,17,27)]

df_species_1 <- data %>% # select data for species 1
  filter(Common.Name == "Red-tailed Hawk") %>%
  filter(Breeding.Evidence %in% evidence_rtha)

df_species_1 %>%
  filter(Month >7)
View(filter(df_species_1, Month > 7))
