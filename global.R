require(shiny)
require(visNetwork)
require(readr)
require(scales)
require(RColorBrewer)
require(magrittr)

# Reads in student data. This will form the nodes of the graph.
#
# Fields: 
#   user_id
#   month
#   (Activities):
#       org_involvement
#   (Health):
#       weight
#       healthy_diet
#       current_smoking
#       aerobic_per_week
#       sports_per_week
#   (Politics):
#       interested_in_politics
#       preferred_party
#       liberal_or_conservative
#   (Subjects):
#       year_school
#       floor

# dataset_dictionary <- list("total.orgs" = "activities.counts",
#                            "healthy_diet" = "health",
#                            "current_smoker" = "health", 
#                            "aerobic_per_week" = "health",
#                            "sports_per_week" = "health",
#                            "interest" = "politics",
#                            "preference" = "politics",
#                            "spectrum" = "politics",
#                            "year_school" = "subjects",
#                            "floor" = "subjects")

if(!exists("nodes")) {
  nodes <- read_csv("nodelist.csv")
  nodes$current_smoker %<>% as.character()
}

# Reads in the edgelist of the network. This dataset will be composed of all the
# possible combinations of two nodes (excluding self edges), totalling 83*83=6889 rows.
#   
#   Fields:
#     user.id
#     user.B.id
#     calls
#     proximity
#     SMS
if(!exists("edgelist")){
  edgelist <- read_csv("edgelist.csv")
  names(edgelist)[1:2] <- c("from", "to")
}