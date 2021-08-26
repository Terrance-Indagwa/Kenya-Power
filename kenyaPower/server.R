#


shinyServer(function(input, output, session){


    category <- reactive({
        req(input$category)

        general %>%
            filter(category == input$category)
    })#filter by category





    station <- reactive({

        req(input$station)
        filter(category(), station==input$station)
    })
    content <- reactive({
        as.character(paste(sep="<br/>",
                           "Station:", station()$station),
                     "Capacity: ", station()$`capacity (mw)`,
                     "Category:", station()$category
                     )
    })# station reactive

        observeEvent(category(), {
            updateSelectInput(session, "station", choices = unique(category()$station))
        })#station:depends on the category


    output$cols <- renderPlotly({

            col <- ggplot(category(),aes(x=station, y=`capacity (mw)`))+
            geom_col(aes(fill=station,text=station))+
            labs(
                title = "Estimated power capacity in each station"
            )+
            theme_classic(base_family = "Times New Roman")+
            theme(legend.position = "none",
                  axis.text.x = element_text(angle =60))

        ggplotly(col, tooltip = c("y", "text"))

    })# a plot of the station power capacity


    output$time <- renderValueBox({Sys.time()})

    output$fossils <- renderTable({
        fossils <- fossils %>%
            summarise(
                `Heavy fuel`=sum(`capacity (mw)`[type=="Heavy fuel oil"] ),
                Biogas=sum(`capacity (mw)`[type=="Biogas"]),
                `Coal(in development)`=sum(`capacity (mw)`[type=="Coal"]),
                `Natural gas(cancelled)`=sum(`capacity (mw)`[type=="Liquefied natural gas"])
            )
        fossils
    })

    output$geothermal <- renderTable({
        geo <- geothermal %>%
            summarise(
                operating=sum(`capacity (mw)`[notes=="Operational"]),
                planned=sum(`capacity (mw)`[notes=="Planned"]),
                `In development`=sum(`capacity (mw)`[notes=="In development"])
            )
        geo
    })

    output$hydro <- renderTable({
        hydro <- hydroelectric %>%
            summarise(
                Reservoir=sum(`capacity (mw)`[type=="Reservoir"]),
                `Run of a river`=sum(`capacity (mw)`[type=="Run of river"])
            )
        hydro
    })


    output$wind <- renderTable({
        wind <-wind %>%
            summarise(
                operating=sum(`capacity (mw)`[notes=="Operational"]),
                planned=sum(`capacity (mw)`[notes=="Planned"])
            )
        wind
    })

    output$solar <- renderTable({
        solar %>%
        summarise(operating=sum(`capacity (mw)`))
    })




















































})
