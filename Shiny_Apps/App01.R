setwd("...")
getwd()

library(plyr)
library(readr)
library(shiny)
library(shinydashboard)
library(DT)

#Getting the files
mydir = "files"
myfiles = list.files(path=mydir, pattern = "*.csv", full.names=TRUE)
myfiles

#Reading all the CSV files and adding to a Data Frame
dat_csv = ldply(myfiles, read_csv)
View(dat_csv)

#Creating a dataframe with the columns we need and also removing the email and only letting the user name:
#?regex used to get the str_split function
df <- data.frame(dat_csv$task,dat_csv$stage,dat_csv$has_breached,
                 str_split(dat_csv$sys_created_by, "@", n=2, simplify = TRUE), 
                 str_split(dat_csv$sys_created_on, " ", n=2, simplify = TRUE),dat_csv$percentage)

names(df)[names(df)=='X1'] <- 'Created_By'
names(df)[names(df)=='X1.1'] <- 'Created_on'
names(df)[names(df)=='dat_csv.task'] <- 'Chamado'
names(df)[names(df)=='dat_csv.stage'] <- 'Stage'
names(df)[names(df)=='dat_csv.has_breached'] <- 'Rompeu_SLA?'
names(df)[names(df)=='dat_csv.percentage'] <- 'SLA_Percentage'

df$X2 <- NULL
df$X2.1 <- NULL
View(df)

#Finding some useful information about the Data
summary(df$dat_csv.percentage)
summary(df$dat_csv.has_breached)

number <- data.frame(count(df, "Created_By"))
View(number)


#?merge
#Never do this:
   #main_df <- merge(df, df1)
   #View(main_df)


###### Building now the UI we are going to use 

ui <- dashboardPage( skin = "green",
                     dashboardHeader(title = "DashBoard Chamados"),
                     dashboardSidebar(
                       sidebarMenu(#This is the SideBar Menu
                         menuItem("Chamados", tabName = "Chamados", icon = icon("tree"))
                       )
                     ),
                     dashboardBody(
                         tabItem("df",
                                 fluidPage(
                                   h1("Chamados"),
                                   dataTableOutput("df")
                                 )
                         )    
                       )
                     )
)

server <- function(input, output){
  
  output$df <- renderDataTable(df)
  
}

shinyApp(ui, server)
