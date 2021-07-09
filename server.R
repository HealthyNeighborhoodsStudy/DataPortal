function(input, output, session) {
  
  #-----------------------------------------------------------------------------------
  #About:   --------------------------------------------------------------------------
  #-----------------------------------------------------------------------------------
  
  #survey sections-------------------------------------------
  colnames(survey_sections)=c("Survey Sections","What's included?")
  output$survey_sections__table = renderDT(
    survey_sections, rownames = FALSE,options = list(pageLength = 12,dom = 't')
  )
  
  #survey stats  -------------------------------------------
  var_stats = c("agecat_3","gender","race_cat","hhrentown","yearsinneigh_cat","usborn","otherlang","incshort")
  var_l = c("Age","Gender","Race/Ethnicity","Housing Tenure","Neighborhood Tenure","US or Foreign Born","Other Language Spoken at Home","Short in Income in the Past Month")
  
  datalist=list()
  for (i in 1:length(var_stats)){
    title=data.frame("Question"=var_l[i],"Frequency"=(""),"Percentage"="")
    t= table_per(hns_survey,var_stats[i]) 
    t=t[,c(1:2,4)]
    colnames(t)=c("Question","Frequency","Percentage")
    t=filter(t,!(Question %in% c("Total","No Response")))%>% 
      arrange(-Frequency)%>%
      mutate(Frequency=as.character(Frequency))
    # %>%
    # mutate(Percentage=paste(Percentage,"%"))
    t1=rbind(title,t)
    datalist[[i]]=t1
  }
  survey_stats = bind_rows(datalist) %>%filter(Question!="No")
  
  output$survey_stats = renderDT({
    DT::datatable(survey_stats, rownames = FALSE,options = list(pageLength = 12,dom = 'tip', escape =FALSE)
    )%>%formatStyle("Percentage",
                    target = 'row',
                    backgroundColor = styleEqual("", c('#9ac2da')))
  })
  
  #-----------------------------------------------------------------------------------
  #Explore:   --------------------------------------------------------------------------
  #-----------------------------------------------------------------------------------
  
  #Step 1: filter data by section------------------------------
  section_vars <- reactive({
    filter(data_dictionary, Section_2020 == input$section)
  })
  
  #step 2: output all questions in section to dashboard---------
  observeEvent(section_vars(), {
    choices <- unique(section_vars()$Labels_2020)
    updateSelectInput(session, "question", choices = choices)
  })
  
  #Step 3.1: subset data by question---------------------------------
  
  question_var <- reactive({
    question_var <- section_vars()%>%
      filter(Labels_2020 == input$question) %>%
      select(Section_2020,Variable_2020, Labels_2020)
  })
  
  #Step 3.2: subset data by filter choice---------------------------------
  
  dat = hns_survey
  
  reactive_data= reactive({
    
    if(length(input$surveyneighborhood) != length(hns_survey$surveyneighborhood)){
      dat= dat %>% filter(surveyneighborhood %in% input$surveyneighborhood | is.null(input$surveyneighborhood) )}
    
    
    if (length(input$hnssurvey) != length(levels(hns_survey$hnssurvey))) {
      dat= dat %>% filter(hnssurvey %in% input$hnssurvey | is.null(input$hnssurvey) )
    }
    
    if (length(input$agecat_3) != length(levels(hns_survey$agecat_3))) {
      dat= dat %>% filter(agecat_3 %in% input$agecat_3 | is.null(input$agecat_3) )
    }
    
    if (length(input$race_cat) != length(levels(hns_survey$race_cat))) {
      dat= dat %>% filter(race_cat %in% input$race_cat | is.null(input$race_cat) )
    }
    
    if (length(input$gender) != length(levels(hns_survey$gender))) {
      dat= dat %>% filter(gender %in% input$gender | is.null(input$gender) )
    }
    
    if (length(input$yearsinneigh_cat) != length(levels(hns_survey$yearsinneigh_cat))) {
      dat= dat %>% filter(yearsinneigh_cat %in% input$yearsinneigh_cat | is.null(input$yearsinneigh_cat) )
    }
    
    if (length(input$otherlang) != length(levels(hns_survey$otherlang))) {
      dat= dat %>% filter(otherlang %in% input$otherlang | is.null(input$otherlang) )
    }
    
    if (length(input$usborn) != length(levels(hns_survey$usborn))) {
      dat= dat %>% filter(usborn %in% input$usborn | is.null(input$usborn) )
    }
    
    return(dat)
  })
  
  # Generate text-------------------------------------------------------------------------
  
  #question variable
  q = reactive({as.character(question_var()$Variable_2020) })
  #question label
  var_name = reactive({as.character(question_var()$Labels_2020) })
  
  #Get question description
  question_desc <- renderText({
    data_dic = data_dictionary %>%filter(Variable_2020== q())%>%
      select("Section_2020","Labels_2020","Question_2020","Var_Description_2020")%>%
      mutate(Question_2020=if_else( is.na(Question_2020) | Question_2020==""
                                    ,"This is a data point extracted from a survey question"
                                    , as.character(Question_2020))
      )
    colnames(data_dic)=c("Survey Section","Selected data point", "Survey Question","Description")
    row.names(data_dic)=NULL
    
    as.character(data_dic[,"Description"])  
  })
  
  output$question_desc_text_top <- renderText({  question_desc()  })
  
  
  #results: description-------------------------
  explore_description = reactive({
    data.frame(
      "Criteria"=c( "Survey section"
                    ,"Survey Question"
                    ,"Survey Question Description"
      )
      ,"Selected"=c(input$section
                    ,var_name()
                    ,question_desc()
      )
    )
  })
  
  #results: description-------------------------
  output$explore_description <- DT::renderDataTable({
    DT::datatable(explore_description(), rownames = FALSE,options = list(dom = 't'))%>%
      formatStyle('Criteria',  color = 'black', backgroundColor = '#eaeaea')
  })
  
  
  
  #Results: Get optional filters-----------
  
  explore_filters = reactive({
    data.frame(
      "Filter"=c(    "Survey year"
                     ,"Neighborhood"
                     ,"Age"
                     ,"Race/Ethnicity"
                     ,"Gender"
                     ,"Non-English Languages spoken at home"
                     ,"US or Foreign Born"
                     ,"Neighborhood tenure"
      )
      ,"Selected"=c( toString(input$hnssurvey)
                     ,toString(input$surveyneighborhood)
                     ,toString(input$agecat_3)
                     ,toString(input$race_cat)
                     ,toString(input$gender)
                     ,toString(input$otherlang)
                     ,toString(input$usborn)
                     ,toString(input$yearsinneigh_cat)
      )
    )
  })
  
  output$explore_filters <- DT::renderDataTable({
    DT::datatable(explore_filters(), rownames = FALSE,options = list(dom = 't'))%>%
      formatStyle('Filter',  color = 'black', backgroundColor = '#eaeaea')
  })
  
  
  
  # Generate summary stats table-----------------------------------------------------------
  
  output$data <- DT::renderDataTable({
    
    #if no filters are chosen:
    if(nrow(reactive_data())==nrow(hns_survey)){
      
      if(q() %in% numeric_vars){#if var is numeric
        table_q=table_mean(reactive_data(),q())
        var_name_table = data.frame("Variable" =var_name() )
        table_q=cbind(var_name_table,table_q)
        colnames(table_q)= c("Variable","All Surveys: Frequency","All Surveys: Mean")
      }else {#if var is not numeric
        table_q = table_per(reactive_data(),q())
        table_q=table_q[,c(1,2,4)]
        colnames(table_q)= c(var_name(),"All Surveys: Frequency","All Surveys: Percentage")
      }
      tot_table=table_q
      
    } else {# create table with columns for all surveys and columns for filtered surveys
      
      if(q() %in% numeric_vars){#if var is numeric
        
        #subset dat
        table_q = table_mean(reactive_data(),q())
        colnames(table_q)= c("Subset: Frequency","Subset: Mean")
        
        #table for all surveys
        table_all_surveys = table_mean(hns_survey,q())
        colnames(table_all_surveys)= c("All Surveys: Frequency","All Surveys: Mean")
        
        #get var name
        var_name_table = data.frame("Variable" =var_name() )
        
        #join tables
        tot_table = cbind(var_name_table,table_all_surveys, table_q)
        rownames(tot_table)=NULL
        tot_table=tot_table[,c(1,4,5,2,3)]
        
      } else { # if var is not numeric
        
        #subset dat
        table_q = table_per(reactive_data(),q())
        table_q=table_q[,c(1,2,4)]
        colnames(table_q)= c(var_name(),"Subset: Frequency","Subset: Percentage")
        
        #table for all surveys
        table_all_surveys = table_per(hns_survey,q())
        table_all_surveys=table_all_surveys[,c(1,2,4)]
        colnames(table_all_surveys)= c(var_name(),"All Surveys: Frequency","All Surveys: Percentage")
        
        #join tables
        tot_table = left_join(table_all_surveys, table_q, by = var_name())
        tot_table=tot_table[,c(1,4,5,2,3)]
        rownames(tot_table)=NULL
      }
    }
    if(nrow(reactive_data())<=5){
      #Warning Promt
      # observeEvent(nrow(data2)<=5, {
      sendSweetAlert(
        session = session,
        title = "Warning",
        text = "There are less than 5 surveys that match the subset criteria you choose. Please remove some filter criteria to view analysis results.",
        type = "error" )
      # })
      #Warning table
      tot_table=data.frame("Warning"="There are less than 5 surveys that match the subset criteria you choose. Please remove some filter criteria to view analysis results.")}
    
    if(nrow(reactive_data())!=nrow(hns_survey)&
       input$explore_table_option=="Chosen subset"
    ){
      tot_table=tot_table[,c(1:(length(tot_table)-2))]
    }
    DT::datatable(tot_table, rownames = FALSE,options = list(dom = 'tip'))%>%
      formatStyle(colnames(tot_table)[1],  color = 'black', backgroundColor = '#eaeaea')
    
  })
  
  #generate graph ----------------------------------------------------------------
  output$graph <- renderPlotly({ 
    
    if(nrow(reactive_data())==nrow(hns_survey)){
      bar_plot(reactive_data(),q(),var_name())
    }else if(nrow(reactive_data())!=nrow(hns_survey)& input$explore_table_option=="Chosen subset"){
      bar_plot(reactive_data(),q(),var_name()) } else{
        bar_plot_all(reactive_data(),q(),var_name())
      }
  })
  
  
  
  #-------------------------------------------------------------------------------------------------------------------------
  #Analyze-------------------------------------------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------------------------------------------------
  
  
  
  #Step 1: filter data by section------------------------------
  section_vars2  <- reactive({  filter(data_dictionary2, Section_2020 == input$section2)  })
  section_vars22 <- reactive({  filter(data_dictionary22, Section_2020 == input$section22)  })
  
  #step 2: output all questions in section to dashboard---------
  observeEvent(section_vars2(), {
    choices2 <- unique(section_vars2()$Labels_2020)
    updateSelectInput(session, "question2", choices = choices2)
  })
  
  observeEvent(section_vars22(), {
    choices22 <- unique(section_vars22()$Labels_2020)
    updateSelectInput(session, "question22", choices = choices22)
  })
  
  
  #Step 3.1: subset data by question---------------------------------
  
  question_var2 <- reactive({
    question_var2 <- section_vars2()%>%
      filter(Labels_2020 == input$question2) %>%
      select(Section_2020,Variable_2020, Labels_2020)
  })
  
  question_var22 <- reactive({
    question_var22 <- section_vars22()%>%
      filter(Labels_2020 == input$question22) %>%
      select(Section_2020,Variable_2020, Labels_2020)
  })
  
  #Step 3.2: subset data by filter choice---------------------------------
  
  data2 = hns_survey
  
  reactive_data2= reactive({
    
    dat_filter = function(dat,v,v2){
      d= dat %>% filter(eval(as.symbol(v)) %in% input[[v2]] | is.null(input[[v2]]))
      return(d)}
    
    # Apply filter function to choice criteria
    if (length(input$surveyneighborhood2) != length(levels(hns_survey$surveyneighborhood))) { data2 = dat_filter(data2,"surveyneighborhood","surveyneighborhood2")}
    if (length(input$agecat_32) != length(levels(hns_survey$agecat_3))) { data2 = dat_filter(data2,"agecat_3","agecat_32")}
    if (length(input$race_cat2) != length(levels(hns_survey$race_cat))) { data2 = dat_filter(data2,"race_cat","race_cat2")}
    if (length(input$gender2) != length(levels(hns_survey$gender))) { data2 = dat_filter(data2,"gender","gender2")}
    if (length(input$hnssurvey2) != length(levels(hns_survey$hnssurvey))) { data2 = dat_filter(data2,"hnssurvey","hnssurvey2")}
    if (length(input$yearsinneigh_cat2) != 5) { data2 = dat_filter(data2,"yearsinneigh_cat","yearsinneigh_cat2")}
    if ((input$usborn2) != "All") { data2 = dat_filter(data2,"usborn","usborn2")}
    if ((input$otherlang2) != "All") { data2 = dat_filter(data2,"otherlang","otherlang2")} 
    
    return(data2)
  })
  
  
  # Generate text-------------------------------------------------------------------------
  
  #question variable
  q2 = reactive({as.character(question_var2()$Variable_2020) })
  q22 = reactive({as.character(question_var22()$Variable_2020) })
  
  #question label
  var_name2 = reactive({as.character(question_var2()$Labels_2020) })
  var_name22 = reactive({as.character(question_var22()$Labels_2020) })
  
  #description top
  question_desc2 <- reactive({  data_dic = data_dictionary %>%filter(Variable_2020== q2())
  as.character(data_dic[,"Var_Description_2020"])
  })
  question_desc22 <- reactive({  data_dic = data_dictionary %>%filter(Variable_2020== q22())
  as.character(data_dic[,"Var_Description_2020"])
  })
  
  output$question_desc_text_top2 <- renderText({  question_desc2()  })
  output$question_desc_text_top22 <- renderText({  question_desc22()  })
  
  #results: description-------------------------
  analyze_description = reactive({
    x=data.frame(
      "Criteria"=c( "Survey section"
                    ,"Survey Question"
                    ,"Survey Question Description")
      ,"First"=c(input$section2
                 ,var_name2()
                 ,question_desc2())
      ,"Second"=c(input$section22
                  ,var_name22()
                  ,question_desc22())
    )
    colnames(x)=c("Criteria","Selected: First Question","Selected: Second Question")
    x
  })
  
  #results: description-------------------------
  output$analyze_description <- DT::renderDataTable({
    DT::datatable(analyze_description(), rownames = FALSE,options = list(dom = 't'))%>%
      formatStyle('Criteria',  color = 'black', backgroundColor = '#eaeaea')
  })
  
  
  #Results: Get optional filters-----------
  
  analyze_filters = reactive({
    data.frame(
      "Filter"=c(    "Survey year"
                     ,"Neighborhood"
                     ,"Age"
                     ,"Race/Ethnicity"
                     ,"Gender"
                     ,"Non-English Languages spoken at home"
                     ,"US or Foreign Born"
                     ,"Neighborhood tenure"
      )
      ,"Selected"=c( toString(input$hnssurvey2)
                     ,toString(input$surveyneighborhood2)
                     ,toString(input$agecat_32)
                     ,toString(input$race_cat2)
                     ,toString(input$gender2)
                     ,toString(input$otherlang2)
                     ,toString(input$usborn2)
                     ,toString(input$yearsinneigh_cat2)
      )
    )
  })
  
  output$analyze_filters <- DT::renderDataTable({
    DT::datatable(analyze_filters(), rownames = FALSE,options = list(dom = 't'))%>%
      formatStyle('Filter',  color = 'black', backgroundColor = '#eaeaea')
  })
  
  
  
  #Step 3: subset data by question---------------------------------
  output$data2 <- DT::renderDataTable({ 
    
    #create summary table per question-----------------------
    
    if(q2() %in% numeric_vars){#if var is numeric
      
      tot_table2=cross_table_mean(reactive_data2(),q2(),q22(),var_name2(),var_name22()) # render mean table
      
    }else {#if var is not numeric
      #----- Create frequency table  -----
      table_q2 =  as.data.frame(
        dat_subset(reactive_data2(),q2(),q22())  %>%select(q2(),q22())%>% droplevels()%>% 
          dplyr::group_by(eval(as.symbol(q22())), eval(as.symbol(q2()))) %>%
          dplyr::summarize(frequency = n(), .groups = 'drop') %>%
          `colnames<-`(c(q2(), q22(), "frequency"))%>%
          spread(q2(), frequency, fill = 0) 
      )
      
      table_q2=table_q2%>% mutate(Total = rowSums(table_q2[2:ncol(table_q2)]))%>%arrange(-Total)
      # table_q2=table_q2[,c(1,ncol(table_q2),2:(ncol(table_q2)-1))]
      colnames(table_q2)=c(paste(var_name2(),"/",var_name22())
                           ,colnames(table_q2)[2:ncol(table_q2)])
      table_n=table_q2 %>%adorn_totals()
      
      
      # ----- Create % table  -----
      table_q2_p=table_q2
      for (i in 2:ncol(table_q2)){
        table_q2_p[,i]=table_q2[,i]/sum(table_q2_p[,i])*100}
      
      table_q2_p$total_n=table_q2$Total
      
      table_p = table_q2_p%>%adorn_totals()
      for (i in 2:(ncol(table_p)-1)){table_p[,i]=paste(as.character(round(table_p[,i],0)),"%")} # round number and add % symbol
      
      names(table_p)[names(table_p) == "Total"] <- "Subset Total: Percentage"
      names(table_p)[names(table_p) == "total_n"] <- "Subset Total: Frequency"
      # 
      tot_table2=table_p # render % table 
      if(input$analyze_table_option=="Chosen subset"){
        tot_table2=tot_table2[,c(1:(length(tot_table2)-2))]
      }
    }
    
    
    
    if(nrow(reactive_data2())<=5){
      #Warning Promt
      # observeEvent(nrow(data2)<=5, {
      sendSweetAlert(
        session = session,
        title = "Warning",
        text = "There are less than 5 surveys that match the subset criteria you choose. Please remove some filter criteria to view analysis results.",
        type = "error" )
      # })
      #Warning table
      tot_table2=data.frame("Warning"="There are less than 5 surveys that match the subset criteria you choose. Please remove some filter criteria to view analysis results.")}
    
    DT::datatable(tot_table2, rownames = FALSE,options = list(dom = 'tip'))%>%
      formatStyle(colnames(tot_table2)[1],  color = 'black', backgroundColor = '#eaeaea')
  }) 
  
  
  #generate graph ----------------------------------------------------------------
  
  output$graph22 = renderPlotly({ 
    if(q2() %in% numeric_vars){
      cross_table_mean_graph(reactive_data2(),q2(),q22(),var_name2(),var_name22()) }else{}  
  })
  
  
  output$graph2 <- renderPlot({ 
    if(!(q2() %in% numeric_vars)){
      bar_plot2(reactive_data2(),q2(),q22())   }else{} 
  })
  
  
  
  #-------------------------------------------------------------------------------------------------------------------------
  #COMPARE-------------------------------------------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------------------------------------------------
  
  data3 = hns_survey
  
  #Step 1: your neighborhood
  
  compare_neigh_1 = reactive({input$compare_neigh_1})
  
  
  # Step 2 - compare to other neighborhoods
  observeEvent(compare_neigh_1(), {
    choices_neigh <- unique(
      filter(data3,surveyneighborhood!=compare_neigh_1())[,"surveyneighborhood"]  )
    updateCheckboxGroupInput(session, "compare_neigh_2", choices  = choices_neigh)
  })
  
  compare_neigh_2 = reactive({input$compare_neigh_2})
  
  
  #Step 2: filter data by section------------------------------
  section_vars3  <- reactive({  filter(data_dictionary, Section_2020 == input$section3)  })
  
  #step 4: output all questions in section to dashboard---------
  observeEvent(section_vars3(), {
    choices3 <- unique(section_vars3()$Labels_2020)
    updateSelectInput(session, "question3", choices = choices3)
  })
  
  
  #Step 4: subset data by question---------------------------------
  
  question_var3 <- reactive({
    question_var3 <- section_vars3()%>%
      filter(Labels_2020 == input$question3) %>%
      select(Section_2020,Variable_2020, Labels_2020)
  })
  
  #question variable
  q3 = reactive({as.character(question_var3()$Variable_2020) })
  
  #question label
  var_name3 = reactive({as.character(question_var3()$Labels_2020) })
  
  #Optional filters: subset data by filter choice---------------------------------
  reactive_data3= reactive({
    
    data3= data3 %>% filter(surveyneighborhood %in% c(input$compare_neigh_1,input$compare_neigh_2) )
    
    dat_filter = function(dat,v,v2){
      d= dat %>% filter(eval(as.symbol(v)) %in% input[[v2]] | is.null(input[[v2]]))
      return(d)}
    
    if (length(input$agecat_33) != length(levels(hns_survey$agecat_3))) { data3 = dat_filter(data3,"agecat_3","agecat_33")}
    if (length(input$race_cat3) != length(levels(hns_survey$race_cat))) { data3 = dat_filter(data3,"race_cat","race_cat3")}
    if (length(input$gender3) != length(levels(hns_survey$gender))) { data3 = dat_filter(data3,"gender","gender3")}
    if (length(input$hnssurvey3) != length(levels(hns_survey$hnssurvey))) { data3 = dat_filter(data3,"hnssurvey","hnssurvey3")}
    if (length(input$yearsinneigh_cat3) != 5) { data3 = dat_filter(data3,"yearsinneigh_cat","yearsinneigh_cat3")}
    if ((input$usborn3) != "All") { data3 = dat_filter(data3,"usborn","usborn3")}
    if ((input$otherlang3) != "All") { data3 = dat_filter(data3,"otherlang","otherlang3")}
    
    data3=data3%>%droplevels()
    
    return(data3)
  })
  
  
  # Generate text-------------------------------------------------------------------------
  
  #Description: question
  question3_desc <- reactive({
    
    #get variable from data dictionary
    question_var3 <- section_vars3()%>%
      filter(Labels_2020 == input$question3) %>%
      select(Section_2020,Variable_2020, Labels_2020)
    
    q3 = as.character(question_var3$Variable_2020)
    data_dic = data_dictionary %>%filter(Variable_2020== q3)%>%select("Var_Description_2020")
    
    as.character(data_dic[,"Var_Description_2020"])
  })
  
  #description: top
  output$question_desc_text_top3 <- renderText({question3_desc()})#question:description top
  
  #description: results
  description3=reactive({
    data.frame(
      "Criteria"=c("Your Neighborhood"
                   ,"Compare to these neighborhoods:"
                   ,"Survey section"
                   ,"Survey Question"
                   ,"Survey Question Description")
      ,"Selected"=c(input$compare_neigh_1
                    ,if(is.null(input$compare_neigh_2)){
                      "You haven't selected neighborhoods yet"}else{
                        paste(c(input$compare_neigh_2), collapse=', ' )
                      }
                    ,input$section3
                    ,var_name3()
                    ,question3_desc())
    )
  })
  
  #results: description
  output$description3 <- DT::renderDataTable({
    DT::datatable(description3(), rownames = FALSE,options = list(dom = 't'))%>%
      formatStyle('Criteria',  color = 'black', backgroundColor = '#eaeaea')%>%
      formatStyle('Selected',backgroundColor = styleEqual(input$compare_neigh_1, c('#d9534f')) )
  })
  
  #Results: Get optional filters-----------
  
  compare_filters = reactive({
    data.frame(
      "Filter"=c(    "Survey year"
                     # ,"Neighborhood"
                     ,"Age"
                     ,"Race/Ethnicity"
                     ,"Gender"
                     ,"Non-English Languages spoken at home"
                     ,"US or Foreign Born"
                     ,"Neighborhood tenure"
      )
      ,"Selected"=c( toString(input$hnssurvey3)
                     # ,paste(toString(input$compare_neigh_1),toString(input$compare_neigh_2))
                     ,toString(input$agecat_33)
                     ,toString(input$race_cat3)
                     ,toString(input$gender3)
                     ,toString(input$otherlang3)
                     ,toString(input$usborn3)
                     ,toString(input$yearsinneigh_cat3)
      )
    )
  })
  
  output$compare_filters <- DT::renderDataTable({
    DT::datatable(compare_filters(), rownames = FALSE,options = list(dom = 't'))%>%
      formatStyle('Filter',  color = 'black', backgroundColor = '#eaeaea')
  })
  
  
  
  # #Step 3: subset data by question---------------------------------
  output$data3 <- DT::renderDataTable({
    
    #create summary table per question-----------------------
    
    if(q3() %in% numeric_vars){#if var is numeric
      
      tot_table3=cross_table_mean(reactive_data3(),q3(),"surveyneighborhood",var_name3(),"Neighborhood") # render mean table
      
      if(nrow(reactive_data3())!=nrow(hns_survey)&
         input$compare_table_option=="Selected neighborhoods"
      ){
        tot_table3=tot_table3[,c(1:(length(tot_table3)-1))]
      } else{tot_table3=tot_table3}
      
    }else {#if var is not numeric
      #----- Create frequency table  -----
      table_q3 =  as.data.frame(
        dat_subset(reactive_data3(),q3(),"surveyneighborhood")  %>%
          dplyr::group_by(surveyneighborhood, eval(as.symbol(q3()))) %>%
          dplyr::summarize(frequency = n()) %>%
          `colnames<-`(c(q3(), "Neighborhood", "frequency"))%>%
          spread(q3(), frequency, fill = 0)
        
      )
      
      table_q3=table_q3%>% mutate(Total = rowSums(table_q3[2:ncol(table_q3)]))
      colnames(table_q3)=c(paste(var_name3(),"/ Neighborhood")
                           ,colnames(table_q3)[2:ncol(table_q3)])
      table_n=table_q3 %>%adorn_totals()
      
      
      # ----- Create % table  -----
      table_q3_p=table_q3
      for (i in 2:ncol(table_q3)){
        table_q3_p[,i]=table_q3[,i]/sum(table_q3_p[,i])*100}
      
      table_q3_p$total_n=table_q3$Total
      
      table_p = table_q3_p%>%adorn_totals()
      for (i in 2:(ncol(table_p)-1)){table_p[,i]=paste(as.character(round(table_p[,i],0)),"%")} # round number and add % symbol
      
      names(table_p)[names(table_p) == "Total"] <- "All Selected Neighborhoods: Percentage"
      names(table_p)[names(table_p) == "total_n"] <- "All Selected Neighborhoods: Frequency"
      #
      tot_table3=table_p # render % table
      
      
      if(nrow(reactive_data3())!=nrow(hns_survey)&
         input$compare_table_option=="Selected neighborhoods"
      ){
        tot_table3=tot_table3[,c(1:(length(tot_table3)-2))]
      }
      
      
    }
    
    
    
    if(nrow(reactive_data3())<=5){
      #Warning Promt
      # observeEvent(nrow(data2)<=5, {
      sendSweetAlert(
        session = session,
        title = "Warning",
        text = "There are less than 5 surveys that match the subset criteria you choose. Please remove some filter criteria to view analysis results.",
        type = "error" )
      # })
      #Warning table
      tot_table3=data.frame("Warning"="There are less than 5 surveys that match the subset criteria you choose. Please remove some filter criteria to view analysis results.")}
    
    
    
    DT::datatable(tot_table3, rownames = FALSE,options = list(dom = 'tip'))%>%
      formatStyle(colnames(tot_table3)[1],  color = 'black', backgroundColor = '#eaeaea')%>%
      formatStyle(input$compare_neigh_1,  color = 'black', backgroundColor = '#d9534f', fontWeight = 'bold') 
  })
  
  
  #generate graph ----------------------------------------------------------------
  
  output$graph33 = renderPlotly({
    if(q3() %in% numeric_vars){
      cross_table_mean_graph(reactive_data3(),q3(),"surveyneighborhood",var_name3(),"Neighborhood") }else{}
  })
  
  
  output$graph3 <- renderPlot({
    if(!(q3() %in% numeric_vars)){
      if(input$compare_graph_option=="Pie Chart"){
        pie_wrap(reactive_data3(),q3(),"surveyneighborhood",compare_neigh_1(),c(compare_neigh_2())) 
      }else{  bar_plot2(reactive_data3(),q3(),"surveyneighborhood") }   }else{}
  })
  
}