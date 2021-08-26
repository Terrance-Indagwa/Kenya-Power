
library(shiny)



source("/home/rwills/Rproject/Project-JULY/Kenya-Power/common.R")

navbarPage("Navbar!",

           tabPanel("Plot",
                    sidebarLayout(
                        sidebarPanel(
                            selectInput("category", "category", choices=InputCategory,
                                        multiple = TRUE),
                            selectInput("station", "station", choices=NULL,
                                        multiple = TRUE)
                        ),
                        mainPanel(

                            plotlyOutput("cols")
))
),

            tabPanel("summary",
                    div(id="tbl", class="summary",
                    fluidRow("Hydroelectric",tableOutput("hydro")),
                    fluidRow("Geothermal",tableOutput("geothermal")),
                    fluidRow("Fossils",tableOutput("fossils")),
                    fluidRow("Wind",tableOutput("wind")),
                    fluidRow("Solar",tableOutput("solar"))

                    ))
           )
