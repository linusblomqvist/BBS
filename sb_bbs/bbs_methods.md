This web app was built by Linus Blomqvist (code
[here](https://github.com/linusblomqvist/BBS/tree/main/sb_bbs)) using
data from the Santa Barbara Breeding Bird Study. For more information
about this study, see [this
website](https://santabarbaraaudubon.org/santa-barbara-county-breeding-bird-study).

As of the most recent update of this web app on 2025-07-07, the database
contained a total of 13426 records with the following 34 types of
breeding behavior:

    ##  [1] "Aborted nesting"                                                 
    ##  [2] "Ad. ? collected/museum specimen (distended oviduct, egg in duct)"
    ##  [3] "Adult at Nest (clarify)"                                         
    ##  [4] "Agitated Behavior (clarify)"                                     
    ##  [5] "Building Nest"                                                   
    ##  [6] "Carrying Fecal Sac"                                              
    ##  [7] "Carrying Food"                                                   
    ##  [8] "Carrying Nesting Material"                                       
    ##  [9] "Cavity Nester Attending Cavity"                                  
    ## [10] "Copulation"                                                      
    ## [11] "Courtship or Display"                                            
    ## [12] "Dead (Museum) specimen"                                          
    ## [13] "Delivering Food to Nest or Cavity"                               
    ## [14] "Distraction Display"                                             
    ## [15] "Egg in Nest"                                                     
    ## [16] "Family Group in Close Association"                               
    ## [17] "Feeding Fledgling"                                               
    ## [18] "Fledgling Begging"                                               
    ## [19] "Fledgling out of Nest--Brancher"                                 
    ## [20] "Fledgling under Parental Care"                                   
    ## [21] "Fledgling with Presumed Parent"                                  
    ## [22] "Host - Brood Parasite Interaction"                               
    ## [23] "Juvenile Independent"                                            
    ## [24] "Male Singing on Territory"                                       
    ## [25] "Multiple Singing males (give number)"                            
    ## [26] "Nest Building"                                                   
    ## [27] "Nest in Use (clarify)"                                           
    ## [28] "Nestling in Nest"                                                
    ## [29] "Nestling/Fledgling Dead (photo, please)"                         
    ## [30] "No suitable category"                                            
    ## [31] "Pair in suitable habitat"                                        
    ## [32] "Physiological--Brood Patch"                                      
    ## [33] "Territorial Defense"                                             
    ## [34] "Visiting Probable Nest Site"

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

This leaves 10989 records, or 80% of the total number of records.

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

The database contains 419 different nest structures or substrates. Out
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
