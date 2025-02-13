#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(googlesheets4)
library(ggplot2)
gs4_deauth()


library(shiny)

ui <- fluidPage(
   
   titlePanel("Hand washing card randomization results"),
   
   sidebarLayout(
      sidebarPanel(
        checkboxInput(inputId='show_p', 
                      label='Show proportion of simulations with at least 7 
                      sick children in treatment group', 
                      value=FALSE), 
        checkboxInput(inputId='theory',
                      label='Show expected counts',
                      value=FALSE)
      ),
      
      mainPanel(
         plotOutput("distPlot")
      )
   )
)


server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    
    sheet_dat = read_sheet("https://docs.google.com/spreadsheets/d/10_wPfCJYvY8htw2T-vsU4HID8WPhH3OsnoPPEGHpk-E/edit?resourcekey=&gid=1608423419#gid=1608423419")
    
    sick_tr = sheet_dat$`How many kids in the treatment group got sick?`
    sick_contr = sheet_dat$`How many kids in the control group got sick?`
    
    sheet_dat$prop_diff = (sick_tr / 10) - (sick_contr / 10)
    
    fig = ggplot(data=sheet_dat, aes(x=prop_diff)) + 
      geom_histogram(breaks=seq(-1.05, 1.05, 0.1), 
                     color='blue', fill='lightblue') + 
      xlab('Difference: proportions sick in treatment vs. control') + 
      scale_x_continuous(breaks=seq(-1, 1, 0.1), limits=c(-1.05, 1.05)) + 
      ylab('Number of randomizations') + 
      theme_minimal()

    if(input$show_p){
      
      n_below = sum(sheet_dat$prop_diff <= -0.25)
      n_tot = nrow(sheet_dat)
      p_below = round(n_below/n_tot, 3)
      p_lab = paste('Difference at least -0.30:\n', n_below, '/', n_tot, '=', p_below)
      
      ypos = max(table(sheet_dat$prop_diff))
      
      fig = fig + 
        geom_label(label=p_lab, x=1, y=ypos, vjust='inward', hjust='inward', 
                   size=5)
      
    }
    
    if(input$theory){
      
      count_sick = 1:10
      p_count_sick = dhyper(x=count_sick, m=11, n=9, k=10) * nrow(sheet_dat)
      p_diff = (count_sick / 10) - ((11 - count_sick) / 10)
      true_dist = data.frame(p_diff, p_count_sick)
      
      fig = fig + 
        geom_spoke(data=true_dist, aes(x=p_diff-0.04, y=p_count_sick), 
                   angle=0, color='red', size=2, radius=0.1)
      
    }
    
    fig

  })
}

# Run the application 
shinyApp(ui = ui, server = server)

