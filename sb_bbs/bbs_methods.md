This web app was built by Linus Blomqvist (code
[here](https://github.com/linusblomqvist/BBS/tree/main/sb_bbs)) using
data from the Santa Barbara Breeding Bird Study. For more information
about this study, see [this
website](https://santabarbaraaudubon.org/santa-barbara-county-breeding-bird-study).

As of the most recent update of this web app on 2024-08-11, the database
contained a total of 12777 records with the following 37 types of
breeding behavior:

    ##  [1] "Fledgling out of Nest--Brancher"                                 
    ##  [2] "No suitable category"                                            
    ##  [3] "Nestling in Nest"                                                
    ##  [4] "Egg in Nest"                                                     
    ##  [5] "Fledgling under Parental Care"                                   
    ##  [6] "Nest Building"                                                   
    ##  [7] "Family Group in Close Association"                               
    ##  [8] "Host - Brood Parasite Interaction"                               
    ##  [9] "Feeding Fledgling"                                               
    ## [10] "Delivering Food to Nest or Cavity"                               
    ## [11] "Carrying Nesting Material"                                       
    ## [12] "Nest in Use (clarify)"                                           
    ## [13] "Carrying Food"                                                   
    ## [14] "Cavity Nester Attending Cavity"                                  
    ## [15] "Fledgling Begging"                                               
    ## [16] "Adult at Nest (clarify)"                                         
    ## [17] "Visiting Probable Nest Site"                                     
    ## [18] "Fledgling with Presumed Parent"                                  
    ## [19] "Nestling/Fledgling Dead (photo, please)"                         
    ## [20] "Copulation"                                                      
    ## [21] "Juvenile Independent"                                            
    ## [22] "Pair in suitable habitat"                                        
    ## [23] "Courtship or Display"                                            
    ## [24] "Carrying Fecal Sac"                                              
    ## [25] "Agitated Behavior (clarify)"                                     
    ## [26] "Territorial Defense"                                             
    ## [27] NA                                                                
    ## [28] "Male Singing on Territory"                                       
    ## [29] "Physiological--Brood Patch"                                      
    ## [30] "Ad. ? collected/museum specimen (distended oviduct, egg in duct)"
    ## [31] "Multiple Singing males (give number)"                            
    ## [32] "Dead (Museum) specimen"                                          
    ## [33] "Aborted nesting"                                                 
    ## [34] "Male Singing on territory"                                       
    ## [35] "Distraction Display"                                             
    ## [36] "No Suitable Category"                                            
    ## [37] " "

Some of these have been filtered out for the graphs on this web app, for
one or both of the following reasons:

-   The breeding behavior does not correspond to a particular breeding
    stage (such as “Pair in suitable habitat”), making it unsuitable for
    the study of phenology
-   The behavior is only weak evidence of breeding (for example, “Male
    Singing on Territory”)

This leaves 15 types of breeding behavior that are incorporated into the
figures for individual bird species:

    ##  [1] "Fledgling out of Nest--Brancher"   "Nestling in Nest"                 
    ##  [3] "Egg in Nest"                       "Fledgling under Parental Care"    
    ##  [5] "Nest Building"                     "Family Group in Close Association"
    ##  [7] "Feeding Fledgling"                 "Delivering Food to Nest or Cavity"
    ##  [9] "Carrying Nesting Material"         "Carrying Food"                    
    ## [11] "Fledgling Begging"                 "Fledgling with Presumed Parent"   
    ## [13] "Juvenile Independent"              "Copulation"                       
    ## [15] "Carrying Fecal Sac"

This leaves 10483 records, or 80% of the total number of records.

These 15 behaviors are further grouped into 5 categories as follows:

-   “Nest construction” = {“Carrying Nesting Material”, “Nest Building”}
-   “Copulation and eggs in nest” = {“Copulation”, “Egg in Nest”}
-   “Nestling and brancher” = {“Carrying Food”, “Delivering Food to Nest
    or Cavity”, “Nestling in Nest”, “Carrying Fecal Sac”, “Fledgling out
    of Nest–Brancher”}
-   “Fledglings and families” = {“Family Group in Close Association”,
    “Feeding Fledgling”, “Fledgling Begging”, “Fledgling under Parental
    Care”, “Fledgling with Presumed Parent”}
-   “Juvenile Independent” = {“Juvenile Independent”}

For the tree usage graph, the following behaviors were included:

    ## [1] "Adult at Nest"                     "Carrying Nesting Material"        
    ## [3] "Egg in Nest"                       "Nest in Use"                      
    ## [5] "Nest Building"                     "Nestling in Nest"                 
    ## [7] "Delivering Food to Nest or Cavity" "Cavity Nester Attending Cavity"   
    ## [9] "Fledgling out of Nest--Brancher"

These all relate to breeding behaviors taking place in different tree
types.

The database contains 397 different nest structures or substrates. Out
of these, 9 types of tree were selected, based on them occurring most
frequently in the data. Each “type” roughly corresponds to a genus. The
types are:

    ## [1] "Eucalyptus" "Oak"        "Pine"       "Sycamore"   "Willow"    
    ## [6] "Cypress"    "Fig"        "Cottonwood" "Palm"

Each of the selected tree types corresponds to several different entries
in the database. For example, “Eucalyptus” comes in the form of
“Eucalyptus tree”, “Red Gum Eucalyptus”, “Eucalyptus globulus”, and so
on. These different entries were detected using a string search, and
then merged into the genus-level type. Further refinements to this
method are coming. These 9 tree types cover 70% of all records with a
nest structure or substrate, not all of which pertain to trees.

To show the timing of records, the year is divided into 52 weeks. One
bar corresponds to one such week. It does not necessarily correspond to
week one, two, three, or four of a given month.
