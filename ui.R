header = dashboardHeader(title = "Healthy Neighborhoods Study Data Portal",titleWidth = 500)

useSweetAlert() # call this once to use dynamic alert
#**********************************************************************************************            

sidebar =  dashboardSidebar(    
  sidebarMenu(
    # menuItem("About", tabName = "Context", icon = icon("th"),startExpanded=TRUE,
    
    menuItem('About: Essential information',tabName = 'about_study', icon = icon('exclamation-circle'))
    ,menuItem('About: Survey information',tabName = 'about_survey',icon = icon('columns'))
    # menuSubItem('l', tabName = 'l',icon = icon('line-chart')),
    ,menuItem('About: Tutorials',tabName = 'about_tutorials', icon = icon('graduation-cap'))
    ,menuItem('About: Resources',tabName = 'about_resources',icon = icon('file-download'))
    # )
    
    # ,menuItem("Dashboard", tabName = "Context", icon = icon("dashboard"),startExpanded=TRUE
    
    ,menuItem("Dashboard: Explore", tabName = "explore", icon = icon("chart-bar"))
    ,menuItem("Dashboard: Analyze", tabName = "analyze", icon = icon("cog", lib = "glyphicon"))
    ,menuItem("Dashboard: Compare", tabName = "compare", icon = icon("city"))
    # )
    
  )
  ,sidebarMenuOutput("menu")
)


#**********************************************************************************************            

body =  dashboardBody(
  
  # Custom CSS to make the title background area the same color as the rest of the header.
  tags$head(tags$style(HTML('.skin-blue .main-header .logo {
                            background-color: #3c8dbc;}
                            .skin-blue .main-header .logo:hover {
                            background-color: #3c8dbc;}')))
  #Custum CSS to change box status color
  ,tags$style(HTML("
                          .box.box-solid.box-warning>.box-header {
                            color:#fff;
                            background:#222d32
                                              }
                          
                          .box.box-solid.box-warning{
                          border-bottom-color:#222d32;
                          border-left-color:#222d32;
                          border-right-color:#222d32;
                          border-top-color:#222d32;
                          }
                          
                                                              "))
  #**********************************************************************************************   
  ,tabItems(
    
    # about the study content -------------------------------------
    tabItem(tabName = "about_study",
            h1(strong("About: The Healthy Neighborhoods Study"),style = "font-weight: 1500; color: #222d32;")
            ,a(href="http://hns.mit.edu/",
               tags$u(tags$em(strong("Go to the Healthy Neighborhood Study website"),style = "font-weight: 1500; color: #3c8dbc;"))
            )
            ,p("")
            ,p(tags$em("The Healthy Neighborhoods Study (HNS) is a community-based, Participatory Action Research Study 
                  that investigates how neighborhood change impacts resident's health in nine Massachusetts communities."))
            ,p("")
            ,p(tags$em("The healthy Neighborhods Study data portal is designed to make HNS data accessible to everyone." ))
            ,p(tags$em(tags$div(tags$ul( tags$li(
              "In the" 
              ,strong("About")
              ,"section you'll find information about our study" 
              ,", " 
              ,strong(a("survey information", href="#shiny-tab-about_survey", "data-toggle" = "tab"))
              ,", "
              ,strong(a("tutorials", href="#shiny-tab-about_tutorials", "data-toggle" = "tab"))
              ,"for how to use this dashboard, and links to downloadable" 
              ,strong(a("resources", href="#shiny-tab-about_resources", "data-toggle" = "tab"))
              ," ."
            )))))
            ,p(tags$em(tags$div(tags$ul( tags$li(
              "In the" 
              ,strong("Dashboard")
              ,"section, you'll find tools to" 
              ,strong(a("explore", href="#shiny-tab-explore", "data-toggle" = "tab"))
              ,", and "
              ,strong(a("analyze", href="#shiny-tab-analyze", "data-toggle" = "tab"))
              ,"our survey data, and "
              ,strong(a("compare", href="#shiny-tab-compare", "data-toggle" = "tab"))
              ,"datapoints between neighborhoods participating in this study."
            )))))
            
            
            ,fluidRow(
              #Our team--------------------- 
              box(
                title = strong("Essential information to read before using the dashboard:"),status = "primary",
                # , color="teal",background="teal",
                solidHeader = TRUE, width = 9,collapsible = TRUE,collapsed=FALSE
                # , height = 225
                ,h4(tags$u( strong("1. The Healthy Neighborhood Study Team"),style = "font-weight: 1500; color: #222d32;"))
                ,p("The Healthy Neighborhood Study is run by local residents, grassroots advocacy organizations, the Conservation Law Foundation, MIT Department of Urban Studies and Planning, the Massachusetts Department of Public Health, and the Metropolitan Area Planning Council. ")
                ,p("Partner community organizations: Massasoit Community College | Codman Square Neighborhood Development Corporation | Alternatives for Community and Environment | Everett Community Health Partnership/Joint Committee for Children’s Health Care in Everett | GreenRoots | Lynn United for Change | Mattapan Food and Fitness Coalition | Voices for a Healthy Southcoast/Southcoast YMCA | Greater Fall River Partners for a Healthier Community")
                
                
                ,h4(tags$u(strong("2. The Healthy Neighborhood Study Communities"),style = "font-weight: 1500; color: #222d32"))
                ,p("We focus on communities that fall within a half-mile radius of a transit station and are experiencing change due 
                   to Transit-Oriented Development (TOD). Our study includes 9 neighborhoods in the Metro-Boston area:")
                
                ,p(tags$div(tags$ul( tags$li(
                  "North of Boston: Chelsea, Everett, Lynn."
                ))))
                
                ,p(tags$div(tags$ul( tags$li(
                  "Boston: Dorchester, Mattapan, Roxbury."
                ))))
                ,p(tags$div(tags$ul( tags$li(
                  "South of Boston: Brockton, Fall River, New Bedford."
                ))))
                
                ,tags$img(src="HNSNeighborhoods.png", width=400, height=300)
                
                ,h4(tags$u(strong("3. We Believe that"),style = "font-weight: 1500; color: #222d32;"))
                ,p(tags$div(tags$ul( tags$li( "The neighborhoods we live in affect our health. To read more about our approach to"
                                              ,strong("  Neighborhood Health"),"go to our website."))))
                ,p(tags$div(tags$ul( tags$li( "The people most impacted by environmental injustices
                  are best equipped to solve, design, and advocate for solutions. To read more about our approach to "
                                              ,strong("  Participatory Action Research"),"go to our website."))))
                
                ,h4(tags$u(strong("4. How we created this survey?"),style = "font-weight: 1500; color: #222d32;"))
                ,p("The survey was developed with a team of resident researchers and is being used to
                              determine what matters most to residents when it comes to building healthy neighborhoods.")
                
                
                ,h4(tags$u(strong("5. What does the survey ask about?"),style = "font-weight: 1500; color: #222d32;"))
                ,p("The survey data documents how a neighborhood's existing residents
                      are affected by rapid development in their community.")))
            
            ,h3(strong("What can we learn from this dashboard?")  ) 
            
            ,fluidRow(column(width =3,
                             box(
                               title =a(strong("EXPLORE - One survey Question"), href="#shiny-tab-explore", "data-toggle" = "tab",style = "font-weight: 1500; color: #ffffff;")
                               , color = "light-blue",solidHeader = TRUE, background = "light-blue", width = 12
                               , height = 250
                               ,p("The Explore section allows you to review the summary of responses for one survey question.
                       This type of analysis is called univariate analysis and its purpose is to describe the data.")
                             )
            )
            # ,fluidRow(
            ,column(width =3,
                    box(
                      title =a(strong("ANALYZE - Two survey questions"), href="#shiny-tab-analyze", "data-toggle" = "tab",style = "font-weight: 1500; color: #ffffff;")
                      , color = "blue",solidHeader = TRUE, background = "blue", width = 12
                      , height = 250
                      ,p("The Analyze section allows you to review the summary of responses for two survey questions simultaneously. 
                       This type of analysis is called bi-variate analysis, and we use it to explore the relationship between two variables.")
                    )
            )
            # , fluidRow(
            ,column(width =3,
                    box(
                      title =a(strong("COMPARE - Neighborhoods"), href="#shiny-tab-compare", "data-toggle" = "tab",style = "font-weight: 1500; color: #ffffff;")
                      , color = "navy",solidHeader = TRUE, background = "navy", width =12
                      , height = 250
                      ,p("The ‘Compare’ section allows you to compare the summary of responses for one survey question between two neighborhoods. In this section we are completing two ‘univariate’ analyses; one for each neighborhood.")
                    )
            )
            )
            
            ,fluidRow(
              box(
                title = strong("What can't we learn from this dashboard?"),status = "primary",
                # , color="teal",background="teal",
                solidHeader = TRUE, width = 9,collapsible = TRUE,collapsed=FALSE
                
                ,p(tags$div(tags$ul( tags$li("We cannot use survey data to make assumptions about entire neighborhoods because the demographics of the
                                         HNS sample are very different from the demographics of the HNS neighborhoods. For example, respondents in
                                         the HNS sample mostly identified as female. However, this does not mean that most people in the
                                         HNS neighborhoods identify as female."))))
                ,p(tags$div(tags$ul( tags$li("We cannot use the raw survey data and comparison tables in the dashboard to determine whether one survey
                                         result causes another survey result. For example, while the survey data can be used to determine whether
                                         happier residents have better health outcomes, it cannot be used to conclude that happiness CAUSES better
                                         health outcomes."))))
                ,p(tags$div(tags$ul( tags$li("We cannot use the survey data to make assumptions about why responses to specific survey questions have changed over time.
                             For example in 2016, 58% of survey respondents identified as female, and in 2019, 65% of survey respondents identified as
                             female. However, because we survey different people each year, we cannot assume that this increase in percentage means that
                             there are more female identifying individuals living in the HNS neighborhoods today than there were in 2016."))))
              )
            )
            
            ,fluidRow(
              box(
                title = strong("How to use this data portal?"),status = "primary",
                # , color="teal",background="teal",
                solidHeader = TRUE, width = 9,collapsible = TRUE,collapsed=FALSE
                
                ,p(tags$div(tags$ol( 
                  
                  tags$li("Read the "
                          ,a(strong("essential information"), href="#shiny-tab-about_study", "data-toggle" = "tab")
                          ,"section to understand who we are, why we created this survey, and what we can and can't learn from interpretation of our survey data."
                  )
                  
                  ,tags$li("Go to "
                           ,a(strong("Survey Information"), href="#shiny-tab-about_survey", "data-toggle" = "tab")
                           ,"to familiarize yourself with the survey domains and the Healthy Neighborhoods Study sample."
                  )
                  
                  ,tags$li("Check out the"
                           ,a(strong("Tutorials"), href="#shiny-tab-about_tutorials", "data-toggle" = "tab")
                           ,"to get instructions for how to conduct data analysis and save your results."
                  )
                  ,tags$li("Dive deeper into neighborhood health and this study in the"
                           ,a(strong("Resources"), href="#shiny-tab-about_resources", "data-toggle" = "tab")
                           ,"section"
                  )
                  ,tags$li( a(strong("Explore"), href="#shiny-tab-explore", "data-toggle" = "tab")
                            ,"the summary of responses for one survey question."
                  )
                  ,tags$li(a(strong("Analyze"), href="#shiny-tab-analyze", "data-toggle" = "tab")
                           ,"two survey questions simultaneously."
                  )
                  ,tags$li(a(strong("Compare"), href="#shiny-tab-compare", "data-toggle" = "tab")
                           ,"respones to one survey questions between 2 neighborhoods or more."
                  ))))
                
              )
            )
    )
    
    
    # about the survey content -------------------------------------
    ,tabItem(tabName = "about_survey"
             ,h1(strong("About: Survey Information")
                 # ,style = "font-weight: 1500; color: #3c8dbc;"
             )
             
             ,h3(tags$u(strong("Survey Sections",style = "font-weight: 1500; color: #3c8dbc;")))
             ,tags$div(tags$ul( tags$li(p("The survey sections were designed to address the different domains of neighborhood health. 
                    To read more about how these domains are connected to neighborhood health, please visit our website or read:"
                                          ,a(href="https://dspace.mit.edu/bitstream/handle/1721.1/117569/1-s2.0-S1353829218300716-main.pdf?sequence=1&isAllowed=y",
                                             "Community change and resident needs: Designing a Participatory Action Research study in Metropolitan Boston.") ))))
             
             ,tags$div(tags$ul( tags$li(p("The HNS survey is divided into twelve sections: demographics, household composition, housing and neighborhood conditions,
                   financial security, social support, health, food, transportation, discrimination, life priorities, local businesses, 
                   and ownership of neighborhood change."))))
             
             ,tags$div(tags$ul( tags$li(p("For domains that have established measures, such as health and neighborhood belonging
                                             , we use standardized questions."))))
             
             ,tags$div(tags$ul( tags$li(p("For domains with no established measures, such as ownership of change and prioritization
                                             , we use novel questions developed in a participatory process."))))
             
             ,fluidRow(
               box(
                 title = "Survey Sections Description", width = 8,status="primary", color = "aqua", solidHeader = TRUE, collapsible = TRUE
                 ,DTOutput('survey_sections__table')
               ))
             
             ,h3(tags$u(strong("Our Sample",style = "font-weight: 1500; color: #3c8dbc;")))
             ,tags$div(tags$ul( tags$li("We conducted surveys within a half mile radius of transit stations in the nine participating HNS neighborhoods.")))
             ,tags$div(tags$ul( tags$li("The nine HNS neighborhoods were selected for this study because they are all experiencing rapid changes  due to
                                                   Transit-Oriented Development (TOD), on top of pre-existing community level health challenges.")))
             ,tags$div(tags$ul( tags$li( "The surveys were conducted by academic researchers and local resident researchers who were employed by nine 
                                              community-based organizations, and who gathered data from nearly 900 members of their own communities each year.")))
             
             ,tags$div(tags$ul( tags$li( "The HNS survey aims to give voice to the experiences of those often under-represented in typical surveying and 
                                              planning processes  To accomplish this, teams of resident researchers determined what they wanted in a representative 
                                              sample. Each sampling plan was based on the lived experience and expertise of the resident researchers, so that the 
                                              survey sample would represent their community's voices." )))
             ,tags$div(tags$ul( tags$li("Survey respondents mostly identified Hispanic/Latino or Black, 
                                                   over half of them were women, a third of them were older than 55, 
                                                   and most of them had children")))
             ,fluidRow(
               box(
                 title = "Survey Sample Description", width = 8,status="primary", solidHeader = TRUE, collapsible = TRUE
                 ,DTOutput('survey_stats')
               ))
    )
    #             
    # # about tutorials -------------------------------------
    ,tabItem(tabName = "about_tutorials"
             ,h1(strong("About: Tutorials")
                 # ,style = "font-weight: 1500; color: #3c8dbc;"
             )
             ,tags$em("This section provides step-by-step instructions for how to use the dashboard. If the tutorials are not loading on your webpage, please try using a different browser.")
             
             ,h3(tags$u(strong("How do I use the Explore section of the Dashboard?",style = "font-weight: 1500; color: #3c8dbc;")))
             ,tags$video(src="Explore_Tutorial_Draft.mp4", width="500px", height="350px", type="video/mp4", controls="controls")
             ,tags$div(tags$ul( tags$li("Determine which survey question responses you want to review")))
             ,tags$div(tags$ul( tags$li("Select the approprite survey section and question")))
             ,tags$div(tags$ul( tags$li("Scan the results table to see how participant's responded to your chosen survey question")))
             ,tags$div(tags$ul( tags$li("Use the graph to further your understanding of the survey resopnses")))
             
             ,h3(tags$u(strong("How do I Download, Email, and Print my Analysis?",style = "font-weight: 1500; color: #3c8dbc;")))
             ,tags$video(src="DownloadPrintEmail.mp4", width="500px", height="350px", type="video/mp4", controls="controls")
             ,tags$div(tags$ul( tags$li("Download as PDF: Select file, Export as PDF, Save PDF")))
             ,tags$div(tags$ul( tags$li("Print PDF: Select file, Print")))
             ,tags$div(tags$ul( tags$li("Email PDF: Drag the saved PDF file into your email draft.")))
    )
    
    # about resources -------------------------------------

    
  ,tabItem(tabName = "about_resources"
           ,h1(strong("About: Resources"))

           ,h3(tags$u(strong("Publications",style = "font-weight: 1500; color: #3c8dbc;")))
           
           
           ,h5(tags$u(strong("Peer Reviewed Journals",style = "font-weight: 1500; color: #222d32;")))
           
           ,p(tags$div(tags$ul(tags$li(a(href="https://doi.org/10.1080/23748834.2021.1885250"
                                         ,"2021: 'It feels like money's just flying out the window': financial security, stress and health in gentrifying neighborhoods")))))
           ,p(tags$div(tags$ul(tags$li(a(href="https://doi.org/10.1016/j.socscimed.2020.113290"
                                         ,"2020: Rising home values and Covid-19 case rates in Massachusetts")))))
           
           ,p(tags$div(tags$ul(tags$li(a(href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6388393/"
                                         ,"2019: Designing and Facilitating Collaborative Research Design and Data Analysis Workshops: Lessons Learned in the Healthy Neighborhoods Study"))))
           ,p(tags$div(tags$ul(tags$li(a(href="https://pubmed.ncbi.nlm.nih.gov/30015179/"
                                         ,"2018: Community Change and Resident Needs: Designing a Participatory Action Research Study in Metropolitan Boston")))))
           
           ,p(tags$div(tags$ul(tags$li(a(href="https://pubmed.ncbi.nlm.nih.gov/27637089/"
                                         ,"2016: Research on neighborhood effects on health in the United States: A systematic review of study characteristics")))))
              
              
              
            ,h5(tags$u(strong("Reports and Field guides",style = "font-weight: 1500; color: #222d32;")))
              
               ,p(tags$div(tags$ul(tags$li(a(href="chrome-extension://oemmndcbldboiebfnladdacbdfmadadm/https://www.clf.org/wp-content/uploads/2021/01/PAR-Field-Guide.pdf"
                                           , "2020: A Participatory Action Research Field Guide")))))
               ,p(tags$div(tags$ul(tags$li(a(href="https://www.clf.org/covid-19-and-healthy-neighborhoods-study-communities/"
                                             , "2020: COVID-19 and the Healthy Neighborhoods Study Communities")))))
               ,p(tags$div(tags$ul(tags$li(a(href="https://www.clf.org/wp-content/uploads/2019/05/HNEF-Report-FINAL-FOR-PRINT.pdf"
                                                ,"2016: Healthy Neighborhoods Research Study Indicators Report")))))
               ,p(tags$div(tags$ul(tags$li(a(href="http://www.mapc.org/wp-content/uploads/2017/11/HNEF-HIA-Report-v5_0.pdf"
                                         ,"2013: Tranist-Oriented Development and Health: A Health Impact Assessment to Inform the Healthy Neighborhoods Equity Fund")))))             
           
           
           ,h3(tags$u(strong("Downloadable Data & Resources",style = "font-weight: 1500; color: #3c8dbc;")))
              
               ,p(tags$div(tags$ul(tags$li(a(href="https://docs.google.com/spreadsheets/d/1sXBWt9716b6CF2p3KjQ2YW3xv_ki7700pj8eSOV_ZHs/edit?usp=sharing", "Data Dictionary")
                                          , " - The information manuel that defines and explains each of the variables used in the dashboard."))))
               ,p(tags$div(tags$ul(tags$li(a(href="https://drive.google.com/drive/folders/1dP60iWyb4ZRaWY--QXU4WntHaldamN6f?usp=sharing"
                                             , "Paper Surveys by Year"), " - The folder containing the every version of the Healthy Neighborhoods Study survey that was used in data collection."))))
               ,p(tags$div(tags$ul(tags$li(a(href="https://drive.google.com/file/d/1ARFTD4DrXHWBdSqJKIDFIHUx_xCZWkhk/view?usp=sharing"
                                            , "Public-use Dataset"), " - The spreadsheet containing all of the data used in the Dashboard"))))
              
            ,h3(tags$u(strong("Contact Us",style = "font-weight: 1500; color: #3c8dbc;")))
              ,tags$div(tags$ul(tags$li(tags$u("Email"), "- rgibson@clf.org")))
           ))
    
    
    #---------------------------------------------------------------------------------------------------------------------------    
    # Explore tab---------------------------------------------------------------------------------------------------------------
    #---------------------------------------------------------------------------------------------------------------------------   
    ,tabItem(tabName = "explore"
             ,h1(strong("Explore the Data"))
             # ,style = "font-weight: 1500; color: #3c8dbc;"
             ,p("This section shows the summary of response options for a specific survey section. This type of analysis is called
                univariate analysis and its purpose is to describe the data.")
             
             ,fluidRow(
               
               # tabBox( id="explore_search_tabbox",
               box(
                 title = strong("Choose Survey Question to explore"), side ="right"
                 ,width = 9
                 ,status="primary"
                 , color = "aqua"
                 , solidHeader = TRUE, collapsible = TRUE
                 
                 # ,tabPanel(id="explore_search_tabbox1","Search by question"
                 ,h4(strong("Step 1: Choose Survey section"))
                 ,p("Select the survey section you want to explore. To learn more about the topics and survey 
                   questions within each survey section, check out the"
                    ,a("'About: Survey Information'", href="#shiny-tab-about_survey", "data-toggle" = "tab")
                    ," page") 
                 , prettyRadioButtons(inputId ="section",label = p("")
                                      ,choices = unique(as.character(data_dictionary$Section_2020))
                                      # ,selected = unique(as.character(data_dictionary$Section_2020))[1]
                                      ,shape = "round",status = "danger",fill = TRUE, inline = FALSE)
                 ,h4(strong("Step 2: Choose Survey Question"))
                 ,selectInput("question", "", choices = NULL)
                 ,tags$u(strong("Chosen Question Description:",style = "font-weight: 1500; color: #3c8dbc;"))
                 ,span(textOutput("question_desc_text_top"),style = "font-weight: 1500; color: #3c8dbc;")
                 # )
                 # ,tabPanel(id="explore_search_tabbox1","Search by key word")
                 
               )
               
               ,box(
                 title = "Optional filters", width = 9, status="warning",color = "blue", solidHeader = TRUE,
                 collapsible = TRUE,collapsed=TRUE
                 ,p("This optional feature allows you to filter responses to your selected survey question by 
                   survey year, neighborhood, age, race/ethnicity, gender, non-english languages spoken at home, 
                   country of birth, and neighborhood tenure. To do this, select the desired filter category and 
                   then click the response options until only the options you want to filter by have check marks next to them. ")
                 
                 , pickerInput(inputId ="hnssurvey",label = h5(strong("Survey year:"))
                               ,choices = c(unique(as.character(hns_survey$hnssurvey)))
                               ,selected = c(unique(as.character(hns_survey$hnssurvey)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 
                 , pickerInput(inputId ="surveyneighborhood",label = h5(strong("Neighborhood:"))
                               ,choices = c(unique(as.character(hns_survey$surveyneighborhood)))
                               ,selected = c(unique(as.character(hns_survey$surveyneighborhood)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                               
                 )
                 , pickerInput(inputId ="agecat_3",label = h5(strong("Age:"))
                               ,choices = c(unique(as.character(hns_survey$agecat_3)))
                               ,selected = c(unique(as.character(hns_survey$agecat_3)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 , pickerInput(inputId ="race_cat",label = h5(strong("Race/Ethnicity:"))
                               ,choices = c(unique(as.character(hns_survey$race_cat)))
                               ,selected = c(unique(as.character(hns_survey$race_cat)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 , p("*Responses other than White, Black, and Latino/Hispanic were grouped for confidentiality reasons")
                 , pickerInput(inputId ="gender",label = h5(strong("Gender*:"))
                               ,choices = c(unique(as.character(hns_survey$gender)))
                               ,selected = c(unique(as.character(hns_survey$gender)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 , p("*Responses for transgender or neither male, female, or transgender, were grouped for confidentiality reasons")
                 
                 , pickerInput(inputId ="otherlang",label = h5(strong("Non-English Languages spoken at home:"))
                               ,choices = c(unique(as.character(hns_survey$otherlang)))
                               ,selected = c(unique(as.character(hns_survey$otherlang)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 , pickerInput(inputId ="usborn",label = h5(strong("US or Foreign Born:"))
                               ,choices = c(unique(as.character(hns_survey$usborn)))
                               ,selected = c(unique(as.character(hns_survey$usborn)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 
                 , pickerInput(inputId ="yearsinneigh_cat",label = h5(strong("Neighborhood tenure:"))
                               ,choices = c(unique(as.character(hns_survey$yearsinneigh_cat)))
                               ,selected = c(unique(as.character(hns_survey$yearsinneigh_cat)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 
               )
             )
             
             
             ,fluidRow(
               # column(width = 6,
               box(
                 title = "Results", width = 9, status="danger",color = "navy", solidHeader = TRUE
                 ,collapsible = TRUE
                 
                 ,h4(strong("Results: Description of Chosen Question"),style = "font-weight: 1500; color: #d9534f;")
                 ,p("This feature allows you to review the information you have chosen. The information provided includes 
                   your chosen survey section, your chosen survey question, and the description of your chosen question" 
                    #, and the filters you applied to your search. "
                 )
                 ,DT::dataTableOutput("explore_description")
                 ,h4(strong("Results: Selected optional filters"),style = "font-weight: 1500; color: #d9534f;")
                 ,p("The table below shows the selected optional filters. By default, all options are selected to show the maximum number of surveys. 
                   For each filter you select, we remove surveys that do not match that filter, thus reducing the total number of surveys for your analysis.")
                 ,DT::dataTableOutput("explore_filters")
                 
                 ,tags$br("")
                 ,h4(strong("Results: Summary Table"),style = "font-weight: 1500; color: #d9534f;")
                 ,p("This section provides you with information about how participants responded to your chosen survey question.
                    Specifically, you are given the number and percentage of people who selected each survey response option.")
                 ,p("The columns titled all surveys show responses to this question across all surveys.
                   The columns titled subset show responses to this question for the filtered criteria only")
                 ,p("If you selected an optional filter, you can use the buttons below. The", strong("Chosen subset") ,"
                   button allows you to see only the responses from participants within the specific subset population you chose.
                   However, if you want to see how the results from your subset population compare with the rest of the survey population
                   , you can select the", strong(" Add all surveys ") ,"button. When you select this button, a new column will emerge providing you with
                   the non-filtered results of your chosen survey question.")
                 ,radioGroupButtons(
                   inputId = "explore_table_option",
                   label = "Choose table option",
                   choices = c("Chosen subset",
                               "Add summary for all surveys"),
                   justified = FALSE,
                   checkIcon = list(
                     yes = icon("ok",
                                lib = "glyphicon"))
                 )
                 ,h4(" ")
                 ,DT::dataTableOutput("data")
                 
                 ,h3("")
                 ,h4(strong("Results: Graph"),style = "font-weight: 1500; color: #d9534f;")
                 ,p("This section provides you with a visual representation of the responses to your chosen survey question. 
                   The X axis displays the response options and the Y axis displays the percentage of respondents who selected a given answer. ")
                 ,p("If you selected an optional filter, you can use the buttons above. The “Chosen subset” button allows you to see only the responses 
                   from participants within the specific subset population you chose. However, if you want to see how the results from your subset population 
                   compare with the rest of the survey population, you can select the “Add all surveys” button. When you select this button, new bars will 
                   emerge on the bar graph providing you with the non-filtered results of your chosen survey question.")
                 
                 , plotlyOutput("graph")
               )
             )
    ),
    #-------------------------------------------------------------------------------------------------------    
    # Analyze ----------------------------------------------------------------------------------------------
    #-------------------------------------------------------------------------------------------------------    
    tabItem(tabName = "analyze"
            ,h1(strong("Analyze the Data")
                # ,style = "font-weight: 1500; color: #3c8dbc;"
            )
            ,p("The Analyze section allows you to review the summary of responses for two survey questions simultaneously.
               This type of analysis is called bi-variate analysis, and we use it to explore the relationship between two variables.")
            ,p(tags$u( "How to use this section:"))
            
            ,tags$div(tags$ul( tags$li( strong("Step 1:" ),"Identify the first survey question you want to use in your analysis by choosing a survey section")))
            ,tags$div(tags$ul( tags$li( strong("Step 2:" ),"select a survey question from the drop down menu in the same section (A)")))
            ,tags$div(tags$ul( tags$li( strong("Step 3:" ),"Identify the second survey question you want to use in your analysis by choosing a survey section")))
            ,tags$div(tags$ul( tags$li( strong("Step 4:" ),"select a survey question from the drop down menu in the same section (B)")))
            
            ,p( "To learn more about the survey sections and survey questions, please visit the"
                ,a("'About: Survey Information'", href="#shiny-tab-about_survey", "data-toggle" = "tab") ,"page.")
            ,tags$br("")
            
            ,fluidRow(
              column(width =5
                     ,box(
                       title = "A. Choose first Survey Question to analyze", width = 12,status="primary", color = "aqua", solidHeader = TRUE,
                       collapsible = TRUE
                       ,h4(strong("Step 1: Choose Survey section for the first question"))
                       , prettyRadioButtons(inputId ="section2",label = p("")
                                            ,choices = unique(as.character(data_dictionary$Section_2020))
                                            # ,selected = unique(as.character(data_dictionary$Section_2020))[1]
                                            ,shape = "round",status = "danger",fill = TRUE, inline = FALSE)
                       ,h4(strong("Step 2: Choose first Survey Question"))
                       ,selectInput("question2", "", choices = NULL)
                       ,tags$u(strong("Chosen Question Description:",style = "font-weight: 1500; color: #3c8dbc;"))
                       ,span(textOutput("question_desc_text_top2"),style = "font-weight: 1500; color: #3c8dbc;")
                       
                     )
                     
              )
              ,column(width =5
                      ,box(
                        title = "B. Choose second Survey Question to analyze", width = 12,status="primary", color = "aqua", solidHeader = TRUE,
                        collapsible = TRUE
                        ,h4(strong("Step 3: Choose Survey section for the second question"))
                        , prettyRadioButtons(inputId ="section22",label = p("")
                                             ,choices = unique(as.character(data_dictionary$Section_2020))
                                             ,selected = unique(as.character(data_dictionary$Section_2020))[2]
                                             ,shape = "round",status = "danger",fill = TRUE, inline = FALSE)
                        ,h4(strong("Step 4: Choose second Survey Question"))
                        ,selectInput("question22", "", choices = NULL)
                        ,tags$u(strong("Chosen Question Description:",style = "font-weight: 1500; color: #3c8dbc;"))
                        ,span(textOutput("question_desc_text_top22"),style = "font-weight: 1500; color: #3c8dbc;")
                      )
              )
            )
            
            ,fluidRow(
              box(
                title = "Optional filters", width = 10, status="warning",color = "blue", solidHeader = TRUE,
                collapsible = TRUE,collapsed=TRUE
                ,p("This optional feature allows you to filter responses to the survey question you selected by survey year, neighborhood, age
                   , race/ethnicity, gender, non-english languages spoken at home, country of birth, and neighborhood tenure. To do this, select 
                   the desired filter category and then click the response options until only the options you want to filter by have check marks 
                   next to them. ")
                
                , pickerInput(inputId ="hnssurvey2",label = h5(strong("Survey year:"))
                              ,choices = c(unique(as.character(hns_survey$hnssurvey)))
                              ,selected = c(unique(as.character(hns_survey$hnssurvey)))
                              ,options = list(`actions-box` = TRUE), multiple = TRUE
                )
                
                , pickerInput(inputId ="surveyneighborhood2",label = h5(strong("Neighborhood:"))
                              ,choices = c(unique(as.character(hns_survey$surveyneighborhood)))
                              ,selected = c(unique(as.character(hns_survey$surveyneighborhood)))
                              ,options = list(`actions-box` = TRUE), multiple = TRUE
                              
                )
                , pickerInput(inputId ="agecat_32",label = h5(strong("Age:"))
                              ,choices = c(unique(as.character(hns_survey$agecat_3)))
                              ,selected = c(unique(as.character(hns_survey$agecat_3)))
                              ,options = list(`actions-box` = TRUE), multiple = TRUE
                )
                , pickerInput(inputId ="race_cat2",label = h5(strong("Race/Ethnicity*:"))
                              ,choices = c(unique(as.character(hns_survey$race_cat)))
                              ,selected = c(unique(as.character(hns_survey$race_cat)))
                              ,options = list(`actions-box` = TRUE), multiple = TRUE
                )
                ,p("*Responses other than White, Black, and Latino/Hispanic were grouped for confidentiality reasons")
                
                , pickerInput(inputId ="gender2",label = h5(strong("Gender*:"))
                              ,choices = c(unique(as.character(hns_survey$gender)))
                              ,selected = c(unique(as.character(hns_survey$gender)))
                              ,options = list(`actions-box` = TRUE), multiple = TRUE
                )
                ,p("*Responses for transgender or neither male, female, or transgender, were grouped for confidentiality reasons")
                
                , pickerInput(inputId ="otherlang2",label = h5(strong("Non-English Languages spoken at home:"))
                              ,choices = c(unique(as.character(hns_survey$otherlang)))
                              ,selected = c(unique(as.character(hns_survey$otherlang)))
                              ,options = list(`actions-box` = TRUE), multiple = TRUE
                )
                , pickerInput(inputId ="usborn2",label = h5(strong("US or Foreign Born:"))
                              ,choices = c(unique(as.character(hns_survey$usborn)))
                              ,selected = c(unique(as.character(hns_survey$usborn)))
                              ,options = list(`actions-box` = TRUE), multiple = TRUE
                )
                
                , pickerInput(inputId ="yearsinneigh_cat2",label = h5(strong("Neighborhood tenure:"))
                              ,choices = c(unique(as.character(hns_survey$yearsinneigh_cat)))
                              ,selected = c(unique(as.character(hns_survey$yearsinneigh_cat)))
                              ,options = list(`actions-box` = TRUE), multiple = TRUE
                )
                
              )
              
              
              ,box(
                title = "Results", width = 10, status="danger", solidHeader = TRUE,collapsible = TRUE
                
                
                ,h4(strong("Results: Description of Chosen Questions"),style = "font-weight: 1500; color: #d9534f;")
                ,p("This feature allows you to review the survey questions and filters you have chosen for your analysis. 
                   The information provided includes your chosen survey sections, your chosen survey questions, the descriptions 
                   of each chosen question, and the filters you applied to your search.")
                ,DT::dataTableOutput("analyze_description")
                ,h4(strong("Results: Selected optional filters"),style = "font-weight: 1500; color: #d9534f;")
                ,p("The table below shows the selected optional filters. By default, all options are selected to show the maximum number of surveys. 
                   For each filter you select, we remove surveys that do not match that filter, thus reducing the total number of surveys for your analysis.")
                ,DT::dataTableOutput("analyze_filters")
                
                ,h3("")
                ,h4(strong("Results: Summary Table"),style = "font-weight: 1500; color: #d9534f;")
                ,p("This is a cross table that shows how participants responded to both chosen questions. 
                    The rows in this table correspond to the first question you chose, and the columns correspond to the 
                    second question you chose. The columns titled all surveys show the responses to the first chosen question 
                    across all surveys.
                   ")
                ,p("The", strong("Chosen subset") ,"button allows you to see responses to the first selected question, broken down by the second select question, 
                    for the specific subset population you chose. If you want to compare these results to the overal chosen subset
                   , you can select the", strong(" Add summary for subset totals ") ,"button. When you select this button, new columns will emerge providing you with
                   the count and percentage for the first question across all surveys in your selected subset (not broken down by the second question)")
                ,radioGroupButtons(
                  inputId = "analyze_table_option",
                  label = "Choose table option",
                  choices = c("Chosen subset",
                              "Add summary for subset totals"),
                  justified = FALSE,
                  checkIcon = list(
                    yes = icon("ok",
                               lib = "glyphicon"))
                )
                ,DT::dataTableOutput("data2")
                
                ,h3("")
                ,h4(strong("Results: Graph for selected filtered criteria (Categorial)"),style = "font-weight: 1500; color: #d9534f;")
                ,p(tags$em("Presented only if both chosen questions are categorial"))
                ,p("This is a graph that shows how participants responded to both chosen questions. The X-axis corresponds 
                   to the survey response options of your second chosen question. The color distinct categories within each 
                   X-axis column correspond to the survey response options of your first chosen question. The Y-axis provides 
                   the percentage of participants who selected each response option")
                , plotOutput("graph2")
                
                ,h4(strong("Results: Graph for selected filtered criteria (Continous)"),style = "font-weight: 1500; color: #d9534f;")
                ,p(tags$em("Presented only if the first chosen question is continous (like a score)"))                
                ,p("This is a graph that shows how participants responded to both chosen questions. The X-axis corresponds 
                   to the survey response options of your second chosen question.  The Y-axis provides 
                   the mean value for your first selected question")
                ,plotlyOutput("graph22")
                
              )
            )
            
    )
    
    #---------------------------------------------------------------------------------------------------------------------------    
    # Compare tab---------------------------------------------------------------------------------------------------------------
    #---------------------------------------------------------------------------------------------------------------------------   
    
    ,tabItem(tabName = "compare"
             ,h1(strong("Compare Neighborhoods")
                 # ,style = "font-weight: 1500; color: #3c8dbc;"
             )
             ,p("The ‘Compare’ section allows you to compare the summary of responses for one survey question between two neighborhoods. In this section we are completing two ‘univariate’ analyses; one for each neighborhood.")
             
             ,p(tags$u( "How to use this section:"))
             
             ,tags$div(tags$ul( tags$li( strong("Step 1:" ),"Identify the primary neighborhood you want to use for this analysis")))
             ,tags$div(tags$ul( tags$li( strong("Step 2:" ),"Identify the neighborhoods you want to compare to the primary neighborhood")))
             ,tags$div(tags$ul( tags$li( strong("Step 3:" ),"Identify the survey question you want to use in your analysis by choosing a survey section")))
             ,tags$div(tags$ul( tags$li( strong("Step 4:" ),"select a survey question from the drop down menu in the same section (B)")))
             
             ,p( "To learn more about the survey sections and survey questions, please visit the"
                 ,a("'About: Survey Information'", href="#shiny-tab-about_survey", "data-toggle" = "tab") ,"page.")
             ,tags$br("")
             
             ,fluidRow(
               column(width =5
                      ,box(
                        title = "A. Choose Neighborhoods", width = 12,status="primary", color = "aqua", solidHeader = TRUE,
                        collapsible = TRUE
                        
                        ,h4(strong("Step 1: Choose your neighborhood"))
                        , prettyRadioButtons(inputId ="compare_neigh_1",label = p("")
                                             ,choices = unique(as.character(hns_survey$surveyneighborhood))
                                             ,selected = unique(as.character(hns_survey$surveyneighborhood))[1]
                                             ,status = "danger", inline = FALSE)
                        ,h4(strong("Step 2: Choose neighborhoods to compare to your neighborhood"))
                        ,awesomeCheckboxGroup(inputId ="compare_neigh_2",label = p(""),choices = NULL,inline = FALSE, status = "danger")
                        
                        ,p(tags$em("Our study includes 9 neighborhoods in the Metro-Boston area that can be grouped by geographic location as follows:"
                                   ,style = "font-weight: 1500; color: #3c8dbc;"))
                        
                        ,p(tags$em(tags$div(tags$ul( tags$li(
                          "North Shore: Chelsea, Everett, Lynn"
                          ,style = "font-weight: 1500; color: #3c8dbc;"
                        )))))
                        
                        ,p(tags$em(tags$div(tags$ul( tags$li(
                          "Boston: Dorchester, Mattapan, Roxbury"
                          ,style = "font-weight: 1500; color: #3c8dbc;"
                        )))))
                        ,p(tags$em(tags$div(tags$ul( tags$li(
                          "South Shore: Brockton, Fall River, New Bedford"
                          ,style = "font-weight: 1500; color: #3c8dbc;"
                        )))))
                      ))
               
               ,column(width =5
                       ,box(
                         title = "B. Choose survey question", width = 12,status="primary", color = "aqua", solidHeader = TRUE,
                         collapsible = TRUE
                         ,h4(strong("Step 3: Choose Survey section"))
                         ,p("Check out the "
                            ,a("'About: Survey Information'", href="#shiny-tab-about_survey", "data-toggle" = "tab")
                            ,"page to learn about what is covered in each section") 
                         , prettyRadioButtons(inputId ="section3",label = p("")
                                              ,choices = unique(as.character(data_dictionary$Section_2020))
                                              # ,selected = unique(as.character(data_dictionary$Section_2020))[1]
                                              ,shape = "round",status = "danger",fill = TRUE, inline = FALSE)
                         ,h4(strong("Step 4: Choose Survey Question"))
                         ,selectInput("question3", "", choices = NULL)
                         ,tags$em(tags$u(strong("Chosen Question Description:",style = "font-weight: 1500; color: #3c8dbc;"))
                                  ,span(textOutput("question_desc_text_top3"),style = "font-weight: 1500; color: #3c8dbc;"))
                         
                       ) 
               )
             )
             
             ,fluidRow(
               box(
                 title = "Optional filters", width = 10, status="warning",color = "blue", solidHeader = TRUE,
                 collapsible = TRUE,collapsed=TRUE
                 ,p("This optional feature allows you to filter responses to the survey question you selected by survey year, 
                neighborhood, age, race/ethnicity, gender, non-english languages spoken at home, country of birth, and neighborhood tenure. 
                To do this, select the desired filter category and then click the response options until only the options you want to filter 
                by have check marks next to them. .")
                 
                 , pickerInput(inputId ="hnssurvey3",label = h5(strong("Survey year:"))
                               ,choices = c(unique(as.character(hns_survey$hnssurvey)))
                               ,selected = c(unique(as.character(hns_survey$hnssurvey)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 
                 , pickerInput(inputId ="agecat_33",label = h5(strong("Age:"))
                               ,choices = c(unique(as.character(hns_survey$agecat_3)))
                               ,selected = c(unique(as.character(hns_survey$agecat_3)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 , pickerInput(inputId ="race_cat3",label = h5(strong("Race/Ethnicity*:"))
                               ,choices = c(unique(as.character(hns_survey$race_cat)))
                               ,selected = c(unique(as.character(hns_survey$race_cat)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 ,p("*Responses other than White, Black, and Latino/Hispanic were grouped for confidentiality reasons")
                 
                 , pickerInput(inputId ="gender3",label = h5(strong("Gender*:"))
                               ,choices = c(unique(as.character(hns_survey$gender)))
                               ,selected = c(unique(as.character(hns_survey$gender)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 ,p("*Responses for transgender or neither male, female, or transgender, were grouped for confidentiality reasons")
                 
                 , pickerInput(inputId ="otherlang3",label = h5(strong("Non-English Languages spoken at home:"))
                               ,choices = c(unique(as.character(hns_survey$otherlang)))
                               ,selected = c(unique(as.character(hns_survey$otherlang)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 , pickerInput(inputId ="usborn3",label = h5(strong("US or Foreign Born:"))
                               ,choices = c(unique(as.character(hns_survey$usborn)))
                               ,selected = c(unique(as.character(hns_survey$usborn)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
                 
                 , pickerInput(inputId ="yearsinneigh_cat3",label = h5(strong("Neighborhood tenure:"))
                               ,choices = c(unique(as.character(hns_survey$yearsinneigh_cat)))
                               ,selected = c(unique(as.character(hns_survey$yearsinneigh_cat)))
                               ,options = list(`actions-box` = TRUE), multiple = TRUE
                 )
               )
             )
             
             ,fluidRow(
               box(
                 title = "Results", width = 10, status="danger", solidHeader = TRUE,collapsible = TRUE
                 
                 ,h4(strong("Results: Description of selected criteria"),style = "font-weight: 1500; color: #d9534f;")
                 ,p("This feature allows you to review the information you have chosen for your analysis. 
              The information provided includes your two chosen neighborhoods, your chosen survey section, 
              your chosen survey question, the descriptions of your chosen question, and the filters you applied to your search. 
              One of the neighborhood names will be highlighted in red; this will help you identify which information belongs 
              to which neighborhood in the summary table.")
                 ,DT::dataTableOutput("description3")
                 ,h4(strong("Results: Selected optional filters"),style = "font-weight: 1500; color: #d9534f;")
                 ,p("The table below shows the selected optional filters. By default, all options are selected to show the maximum number of surveys. 
              For each filter you select, we remove surveys that do not match that filter, thus reducing the total number of surveys for your analysis.")
                 ,DT::dataTableOutput("compare_filters")
                 
                 ,h3("")
                 ,h4(strong("Results: Summary Table"),style = "font-weight: 1500; color: #d9534f;")
                 ,p("This is a cross table that shows how participants from each neighborhood responded to the chosen question. 
                The rows in the table correspond to the response options of the chosen question. 
                If you have selected the table option", strong(" Selected neighborhoods ") ,"the columns in the table 
                correspond to the two neighborhoods you chose. The percentages in the table represent the 
                percentages of people within each neighborhood who selected each of the response options. 
                If you have selected the table option", strong(" Add summary for all selected neighborhoods ") ,"there will 
                be two additional columns in your table. One column is the percentage of people in ALL selected 
                neighborhoods who selected each of the response options. The second column provides the same 
                information but gives the number of people rather than the percentage of people. 
              ")
                 ,radioGroupButtons(
                   inputId = "compare_table_option",
                   label = "Choose table option",
                   choices = c("Selected neighborhoods", 
                               "Add summary for all selected neighborhoods"),
                   justified = FALSE,
                   checkIcon = list(
                     yes = icon("ok", 
                                lib = "glyphicon"))
                 )
                 ,DT::dataTableOutput("data3")
                 
                 ,h3("")
                 ,h4(strong("Results: Graphs"),style = "font-weight: 1500; color: #d9534f;")
                 ,p(tags$em("Presented only if both chosen questions are categorial"))
                 ,p("This section provides you with visual representations of your comparison analysis. 
              There are two different types of graphs you can choose from: 
              ", strong(" Pie Chart ") ,"and", strong(" Bar Chart ") ,". 
              In the pie chart, each neighborhood is given its own pie graph. The colors inside each 
              pie graph correspond with one of the response options from your chosen question. In the bar chart, 
              the neighborhoods are divided into columns on the X-axis. The colors within each bar correspond 
              with one of the response options from your chosen question.")
                 ,radioGroupButtons(
                   inputId = "compare_graph_option",
                   label = "Choose visualization",
                   choices = c("Pie Chart", 
                               "Bar Chart"),
                   justified = FALSE,
                   checkIcon = list(
                     yes = icon("ok", 
                                lib = "glyphicon"))
                 )
                 
                 ,plotOutput("graph3")
                 
                 ,h4(strong("Results: Graph for selected filtered criteria (Continous)"),style = "font-weight: 1500; color: #d9534f;")
                 ,p(tags$em("Presented only if the chosen question is continous (like a score)"))                
                 ,p("This is a graph that shows how participants responded to the chosen question. The X-axis corresponds 
              to the survey response options of your second chosen question.  The Y-axis provides 
              the mean value for your selected question")
                 ,plotlyOutput("graph33")
               )
             )
    )))
#********************************************************************************************** 

dashboardPage(header, sidebar, body)






