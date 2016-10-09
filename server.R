
# Function creates a tooltip based on the variable input into the parameters
createTooltip <- function(dataset, variables, type = "edge") {
  
  if (type == "edge") {
    paste0("<b>", dataset$from, " — ", dataset$to, "</b><br/>", 
           "<b>", variables, ":</b> ", dataset[[variables]])
  } else {
    paste0("<b> Node ", dataset$user.id, "</b><br/>", 
           "<b>", variables[1], ":</b> ", dataset[[variables[1]]], "<br/>",
           "<b>", variables[2], ":</b> ", dataset[[variables[2]]])
  }
}

# Given a discrete variable, returns a vector of colors to be fed into visUpdateNodes
getColor <- function(dataset, variable) {
  if (variable == 'none') {
    return (rep("yellow", 84))
  }
  
  # pal <- brewer.pal(length(unique(dataset[[variable]])), "Set1")
  pal <- c("blue", "yellow", "grey", "red", "green", "purple", "orange", "#f781bf", "brown")
  names(pal) <- unique(dataset[[variable]])
  pal[dataset[[variable]]]
}

# Given a numeric variable, rescales it to be fed into visUpdateNodes
getSize <- function(dataset, variable) {
  if (variable == 'none') {
    return (rep(20, 84))
  }
  rescale(dataset[[variable]], to = c(5, 50))
}


# Updates nodes based on the selected color and size variables
updateNodes <- function(input, networkProxy, dataset) {
  networkProxy %>% 
    visUpdateNodes(data.frame(id = 1:nrow(dataset), 
                              color = list(background = getColor(dataset, input$node_color),
                                           outline = rep("black", 84)),
                              size = getSize(dataset, input$node_size),
                              title = createTooltip(dataset, 
                                                    c(input$node_color, input$node_size), "node")))
}

# Updates edges based on the selected variable.
updateEdges <- function(networkProxy, variable) {
  
  if (variable == "none") {
    networkProxy %>% 
      visRemoveEdges(id = 1:7056) 
    return()
    }
  
  # Removes edges with no data -- greatly saves computational time
  reduced_edgelist <- edgelist[edgelist[[variable]] > 0, ]
  
  if(variable == 'proximity') {
    reduced_edgelist <- edgelist[edgelist$proximity > 1200,] # Deletes edges with less than 1200 count -- again, helping with lag
    # Redraws edges with proximity in width and length
    networkProxy %>% 
      visRemoveEdges(id = 1:7056) %>% 
      visUpdateEdges(data.frame(from = reduced_edgelist$from, to = reduced_edgelist$to, 
                                length = rescale(reduced_edgelist$proximity, to = c(1, 10)),
                                width = rescale(log(reduced_edgelist$proximity), to = c(1, 10)),
                                id = 1:nrow(reduced_edgelist), 
                                title = createTooltip(reduced_edgelist, "proximity", "edge")))
  } else {
    # Redraws edges with thickness based on variable
    networkProxy %>% 
      visRemoveEdges(id = 1:7056) %>% 
      visUpdateEdges(data.frame(from = reduced_edgelist$from, to = reduced_edgelist$to, 
                                width = rescale(log(reduced_edgelist[[variable]]), to = c(1, 10)),
                                id = 1:nrow(reduced_edgelist), 
                                title = createTooltip(reduced_edgelist, variable, "edge")))
  }
}



shinyServer(function(input, output) {
  
  
  # Displays the name of the selected month above the slider
  # output$month_name <- renderText({
  #   months_translate <- c("September 2008", "October 2008", "November 2008", 
  #                         "December 2008", "January 2009", "February 2009", 
  #                         "March 2009", "April 2009", "May 2009", "June 2009")
  #   months_translate[input$month]
  # })
  # 
  
  # Render initial network
  output$network <- renderVisNetwork({
    visNetwork(nodes = data.frame(id = 1:84, color = list(background = rep("yellow", 84),
                                                          border = rep("black", 84),
                                                          highlight = rep("gold", 84)))
               ) %>%
      # visLegend() %>% 
      visOptions(manipulation = TRUE) %>%
      visPhysics(solver = 'repulsion')
  })
  
  # Creates a proxy from the initial network. 
  networkProxy <- visNetworkProxy("network")
  
  # Checks whether inputs have been changed, and updates nodes if they have been.
  observeEvent({input$node_color; input$node_size}, {
    updateNodes(input, networkProxy, nodes)
  })
  
  # Checks whether edgeset option has been changed, and updates edges if it has been.
  observeEvent(input$edge_set, {
    updateEdges(networkProxy, input$edge_set)
    
  })
  
})
