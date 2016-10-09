shinyUI(pageWithSidebar(
  headerPanel(title = "Network Visualization of Student Interactions"
  ),
  sidebarPanel(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    
    #-------- Time slider chooses data from corresponding survey --------------#
    
    # h3("Month"),
    # textOutput("month_name"),
    # radioButtons("radio", label = h3("Survey Date"), inline = TRUE,
    #              choices = list("Sep 2008" = "2008.09", 
    #                             "Oct 2008" = "2008.10",
    #                             "Nov 2008" = "2008.11",
    #                             "Dec 2008" = "2008.12",
    #                             "Jan 2009" = "2009.01",
    #                             "Feb 2009" = "2009.02",
    #                             "Mar 2009" = "2009.03",
    #                             "Apr 2009" = "2009.04",
    #                             "May 2009" = "2009.05",
    #                             "Jun 2009" = "2009.06"), selected = 1),
    
    
    #--------------- Drop-down menus for node properties. ---------------------#
    
    h3("Node Options"),
    div(class = "dropdown",
        
        # Allows you to choose the node characteristics you are interested in
        selectInput("node_color", "Color variable:",
                    choices = list("None" = "none",
                                   'Health' = c("Health of diet" = "healthy_diet",
                                               "Current smoker" = "current_smoker"
                                               ),
                                   'Politics' = c(
                                                "Interest in politics" = "interest",
                                                "Party of preference" = "preference",
                                                "Political spectrum" = "spectrum"
                                                ),
                                   'User Info' = c(
                                                "Class status" = "class_status",
                                                "Floor of residence" = "floor")),
                    selectize = FALSE),
        selectInput("node_size", "Size variable:",
                    choices = list("None" = "none",
                                   'Actvities' = c(
                                              "Number of activities" = "total.orgs"),
                                   'Health' = c(
                                              "Hours on aerobics" = "aerobic_per_week",
                                              "Hours on sports" = "sports_per_week")),
                    selectize = FALSE)
    ),
    
    #--------------- Drop-down menus for edge properties. ---------------------#
    
    h3("Edge Options"),
    div(class = "dropdown",
        selectInput("edge_set", "Edges variable:",
                    choices = list('None' = "none",
                                   'Phone use' = c("Number of calls" = "calls",
                                                   "Number of SMS" = "SMS"),
                                   'Proximity' = c("Physical proximity" = "proximity")#,
                                   #'Relationships' = c("Type of relationship" = "relationship")
                    ),
                    selectize = FALSE)
    ),
    
    # --------------------------- Author Information --------------------------#
    br(), br(),
    strong("Event:"), "Midwest Big Data Hackathon", br(),
    strong("Location:"), "University of Iowa, Iowa City, IA, USA", br(),
    strong("Authors:"), "Krit Petrachaianan and Jarren Santos", br(),
    strong("Date:"), "October 8-9, 2016", br(),
    strong("Dataset:"), "Social Evolution Dataset of MIT Human Dynamics Lab", br(),br(),
    span(class = "underline", "Sensing the 'Health State' of a Community,")," A. Madan, M. Cebrian, S. Moturu, K. Farrahi, A. Pentland, ", em("Pervasive Computing"), ", Vol. 11, No. 4, pp. 36-45 Oct 2012"
    
  ),
  
  mainPanel( 
    visNetworkOutput("network", height = 550)
  )
  
  
))
