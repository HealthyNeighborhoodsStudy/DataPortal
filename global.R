#HNS Data Dashboard
#Author: Yael Nidam
#date: July 2020

#Load libraries --------------------------------------------------
library("tidyverse")
library("janitor")
library("ggplot2")
library("expss")
library("shiny")
library("shinydashboard")
library("shinyWidgets")
library("DT")
library("plotly")
library("Hmisc")
library("reshape2")
library("viridis")
library("gmodels")
library("unikn")
library("ggrepel")
library("ggpubr")
# Initial set up: wrap master dataset in readable .rds file -------------------------------------------------------------------------------
# load("C:/Users/Yael nidam/Dropbox (MIT)/HNS interviews-secure/HNS_Resource_Library/04.HNS_surveys_master/2.survey_cleaning_script/output/2020-08-12HNS_Surveys_Public.RData")
# hns_survey = dat_public
# saveRDS(list("all"=hns_survey), "hns_survey.Rds")

#Load data    ----------------------------------------------------
all=readRDS("hns_survey.Rds")
hns_survey=all$all

data_dictionary = read.csv("2020-08-05HNS_data_dictionary.csv") 
survey_sections = read.csv("survey_sections.csv") 
row.names(survey_sections)=NULL


#subset data    ----------------------------------------------------
hns_survey=subset(hns_survey, select = -c(datenew,surveylocat,organization,surveyformat,surveytype))
data_dictionary=filter(data_dictionary,!(Variable_2020 %in% c("ID","datenew")))
data_dictionary=filter(data_dictionary,(Variable_2020 %in% names(hns_survey)))


#itentify numeric variables --------------------------------------
numeric_vars = c("functional_SS","functional_SS_avg","relate_SS","mentalhealthscore")

data_dictionary22=filter(data_dictionary,!(Variable_2020 %in% numeric_vars))
data_dictionary2=data_dictionary

levels(hns_survey$hhrentown)=c("","Public Housing","Temporary Housing","None","Own","Rent")
hns_survey[,"hhrentown"] = factor(hns_survey[,"hhrentown"],levels = c("Own","Rent","Public Housing","Temporary Housing","None"))

#------------------------------------------------------------------------------------------------------
#functions    -----------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------

#Create a subset of the data with the variables we wish to compare
dat_subset <- function(dat,var1,var2){
  subset_dat <- with(dat, dat[
    !(eval(as.symbol(var1)) == "" | eval(as.symbol(var1)) == "NA" | is.na(eval(as.symbol(var1))))
    & !(eval(as.symbol(var2)) == "" | eval(as.symbol(var2)) == "NA" | is.na(eval(as.symbol(var2))))
    , ])
  return(subset_dat)
}

#Summerize continious variables---------------------------------------------------
table_mean =function(data,q){
  table_q = dat_subset(data,"surveyneighborhood",q) %>% select("surveyneighborhood",q)%>%
    dplyr::summarize(n = n(),mean=mean(as.integer(as.character(eval(as.symbol(q)))))) 
  colnames(table_q)= c("Frequency","Mean")
  table_q$Mean = round(table_q$Mean,2)
  return(table_q)}

cross_table_mean=function(dat,q2,q22,var_name2,var_name22){#Assuming q2 is numeric and q22 is categorial
  table_q2 =  as.data.frame(
    dat_subset(dat,q2,q22) %>% select(all_of(q2),all_of(q22))%>% droplevels()%>% 
      group_by(eval(as.symbol(q22))) %>%
      mutate(numeric_v=as.numeric(as.character(eval(as.symbol(q2))))) %>%
      dplyr::summarize(frequency=n(), Mean = mean(numeric_v, na.rm=TRUE), .groups = 'drop')%>%
      `colnames<-`(c("v1","Frequency","Mean"))%>%arrange(-Mean)
  )
  sample = data.frame(v1 = "All Surveys",Frequency= nrow(dat_subset(dat,q2,q22))
                      , Mean= mean(as.numeric(as.character(dat_subset(dat,q2,q22)[,q2]))))
  table_m = rbind(table_q2,sample)
  # %>%
  # `colnames<-`(c(var_name22,paste("Frequency",var_name2),paste("Mean",var_name2)))
  table_m[,3]=round(table_m[,3],2)
  table_m=as.data.frame(t(table_m))
  colnames(table_m)=table_m[1,]
  table_m=table_m[c(2:3),]
  table_m[,var_name22]=c(paste("Frequency",var_name2),paste("Mean",var_name2))
  table_m=table_m[,c(length(table_m),1:(length(table_m)-1))]
  return(table_m)}

#Summerize categorial variables---------------------------------------------------
table_per =function(data,q){
  s = dat_subset(data,"surveyneighborhood",q) %>% select("surveyneighborhood",q)%>%droplevels()
  table_q= as.data.frame(table(s[,q]))  %>%
    mutate(Percentage=round(Freq/sum(Freq)*100,1))%>%
    adorn_totals()
  colnames(table_q)= c(q,"Frequency","Percentage")
  table_q=table_q%>% mutate(Percentage_l=paste(as.character(round(Percentage,0)),"%"))
  return(table_q)}


# Explore: create bar plot for selected criteria---------------------------------------------------
bar_plot =function(data,q,var_name){
  table_q = table_per(data,q)
  table_q=table_q[1:(nrow(table_q)-1),]
  # table_q=table_q%>% mutate(Percentage_l=paste(as.character(round(Percentage,0)),"%"))
  rownames(table_q)=NULL
  colnames(table_q)= c("Variable","Frequency","Percentage","Percentage_l")
  
  xform <- list(categoryorder = "array",
                categoryarray = c(levels(data[,q])))
  
  g <- plot_ly(table_q, x = ~Variable, y = ~Percentage, type = 'bar',
               text = ~Percentage_l, textposition = 'auto',name = 'Chosen Subset',
               hovertemplate = paste(table_q$Percentage_l,table_q$Variable," (",table_q$Frequency,"out of",nrow(data)," people)"),
               marker = list(color = 'rgb(217,83,79)',
                             line = list(color = 'rgb(8,48,107)', width = 1.5)))%>% 
    layout(xaxis = xform)
  g <- g %>% layout(title = paste0(var_name),
                    xaxis = list(title = "")
                    , yaxis = list(title = "Percentage")
  )
  return(g)}

#Explore: bar plot for selected criteria and all surveys---------------------------------------------------
bar_plot_all =function(data,q,var_name){
  
  table_q = table_per(data,q)
  table_q=table_q[1:(nrow(table_q)-1),]
  # table_q=table_q%>% mutate(Percentage_l=paste(as.character(round(Percentage,0)),"%"))
  rownames(table_q)=NULL
  colnames(table_q)= c("Variable","Frequency","Percentage","Percentage_l")
  
  dat_all=dat_subset(hns_survey,"surveyneighborhood",q)
  table_q_all = table_per(dat_all,q)
  table_q_all=table_q_all%>% mutate(Percentage_l=paste(as.character(round(Percentage,0)),"%"))
  rownames(table_q_all)=NULL
  colnames(table_q_all)= c("Variable","All_Frequency","All_Percentage","All_Percentage_l")
  
  t=left_join(table_q,table_q_all,by="Variable")
  t=as.data.frame(t)%>% mutate(Percentage=round(Percentage,0),All_Percentage=round(All_Percentage,0))
  
  xform <- list(categoryorder = "array",
                categoryarray = c(levels(data[,q])))
  
  g <- plot_ly(t, x = ~Variable, y = ~Percentage, type = 'bar',name = 'Chosen Subset',
               text = ~Percentage_l, textposition = 'auto',
               hovertemplate = paste(t$Percentage_l,t$Variable," (",t$Frequency,"out of",nrow(data)," people)"),
               marker = list(color = 'rgb(217,83,79)',line = list(color = 'rgb(8,48,107)', width = 1.5))
  )%>% 
    layout(xaxis = xform)
  
  g <- g %>% layout(title = var_name,
                    xaxis = list(title = "")
                    , yaxis = list(title = "Percentage")  )
  
  g <- g %>% add_trace(y = ~All_Percentage, name = 'All surveys',
                       text = ~All_Percentage_l, textposition = 'auto',
                       hovertemplate = paste(t$All_Percentage_l,t$Variable ," (",t$All_Frequency,"out of",nrow(dat_all)," people)"),
                       marker = list(color = 'rgb(60,141,188)',line = list(color = 'rgb(8,48,107)', width = 1.5)))
  
  g <- g %>% layout(yaxis = list(title = 'Percentage'), barmode = 'group')
  
  return(g)}

# Stacked percent bal plot---------------------------------------------------
bar_plot2 =function(dat,q2,q22){
  data=dat_subset(dat,q2,q22)%>%droplevels()
  # dplyr::filter( !((eval(as.symbol(q2))) == "" | is.na(eval(as.symbol(q2)))))%>%
  t=table(data[,q2],data[,q22])
  m=(melt(data = t, id.vars = q2))
  m_sum=as.data.frame(colSums(t))
  m_sum=mutate(m_sum,r=row.names(m_sum))
  colnames(m_sum)=c("var2_sum","Var2")
  
  m=left_join(m,m_sum,by="Var2")
  
  m$percent=round(m$value/m$var2_sum*100,0)
  m$percent_l=paste(as.character(m$percent),"%")
  colors=usecol(pal=pal_unikn_light ,n=nrow(m))
  
  g= ggplot(m, aes(fill=Var1, y=percent, x=Var2,label = percent_l)) +
    geom_bar(position="fill", stat="identity",color='black',width=0.9) +
    scale_fill_manual(values = colors) +
    ggtitle(paste("Percentage of",label(hns_survey[,q2])," responses for each ",label(hns_survey[,q22]), "category")) +
    ylab(paste0("Percentage per column"))+
    xlab("") +
    # geom_text(size = 3, position = position_fill(vjust = 0.5)) +
    scale_y_continuous(labels = scales::percent)+
    geom_text(aes(label =percent_l),
              position = position_fill(vjust = 0.5), size = 4)+
    theme(legend.position="bottom",
          axis.text.x=element_text(size=12, angle=45),
          axis.text.y=element_text(size=12)
          ,axis.text=element_text(size=12)
    )+
    theme(legend.title = element_blank())
  return(g)}

# bar plot mean-------------------------------------

cross_table_mean_for_graph=function(dat,q2,q22,var_name2,var_name22){#Assuming q2 is numeric and q22 is categorial
  table_q2 =  as.data.frame(
    dat_subset(dat,q2,q22) %>% select(all_of(q2),all_of(q22))%>% droplevels()%>% 
      group_by(eval(as.symbol(q22))) %>%
      mutate(numeric_v=as.numeric(as.character(eval(as.symbol(q2))))) %>%
      dplyr::summarize(frequency=n(), Mean = mean(numeric_v, na.rm=TRUE), .groups = 'drop')%>%
      `colnames<-`(c("v1","Frequency","Mean"))%>%arrange(-Mean)
  )
  sample = data.frame(v1 = "All Surveys",Frequency= nrow(dat_subset(dat,q2,q22))
                      , Mean= mean(as.numeric(as.character(dat_subset(dat,q2,q22)[,q2]))))
  table_m = rbind(table_q2,sample)
  table_m[,3]=round(table_m[,3],2)
  return(table_m)}

cross_table_mean_graph=function(dat,q2,q22,var_name2,var_name22){#Assuming q2 is numeric and q22 is categorial
  t=(cross_table_mean_for_graph(dat,q2,q22,var_name2,var_name22))
  
  g <- plot_ly(t, x = ~v1, y = ~Mean, type = 'bar',
               text = ~Mean, textposition = 'auto',name = 'Chosen Subset',
               hovertemplate = paste(t$Mean," Mean ", var_name2, " in ", t$v1),
               marker = list(color = 'rgb(217,83,79)',
                             line = list(color = 'rgb(8,48,107)', width = 1.5)))
  g <- g %>% layout(title = "",
                    xaxis = list(title = "")
                    , yaxis = list(title = "")
  )
  return(g)}
# cross_table_mean_graph(hns_survey,"mentalhealthscore","gender","Mental","Gender")
# pie plot---------------------------------------------------
# pie =function(dat,q2,q22,pie_title){
#   
#   data=dat_subset(dat,q2,q22)%>%droplevels()
#   # dplyr::filter( !((eval(as.symbol(q2))) == "" | is.na(eval(as.symbol(q2)))))%>%
#   t=table(data[,q2],data[,q22])
#   m=(melt(data = t, id.vars = q2))
#   m_sum=as.data.frame(colSums(t))
#   m_sum=mutate(m_sum,r=row.names(m_sum))
#   colnames(m_sum)=c("var2_sum","Var2")
#   
#   m=left_join(m,m_sum,by="Var2")
#   
#   m$percent=round(m$value/m$var2_sum*100,1)
#   m$percent_l=paste(as.character(m$percent),"%")
#   
#   t=m%>%filter(Var2==pie_title)
#   colors=usecol(pal=pal_unikn_light ,n=nrow(t))
#   
#   fig <- plot_ly(t, labels = ~Var1, values = ~percent, type = 'pie', name = pie_title
#                  ,hovertemplate = paste(t$percent_l,t$Var1 ," (",t$value,"out of",t$var2_sum," people)")
#                  ,textposition = 'inside',
#                  textinfo = 'Var1+percent_l',
#                  insidetextfont = list(color = 'black'),
#                  hoverinfo = 'text',
#                  text = paste(t$Var1),
#                  marker = list(colors = colors,
#                                line = list(color = '#FFFFFF', width = 1))
#   )
#   fig <- fig %>% layout(title = pie_title,
#                         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
#                         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
#   return(fig)}

# pie plot---------------------------------------------------

pie_wrap=function(dat,q2,q22,pie_title,neigh){
  
  data=dat_subset(dat,q2,q22)%>%droplevels()
  # dplyr::filter( !((eval(as.symbol(q2))) == "" | is.na(eval(as.symbol(q2)))))%>%
  t=table(data[,q2],data[,q22])
  m=(reshape2::melt(data = t, id.vars = q2))
  m_sum=as.data.frame(colSums(t))
  m_sum=mutate(m_sum,r=row.names(m_sum))
  colnames(m_sum)=c("var2_sum","Var2")
  
  m=left_join(m,m_sum,by="Var2")
  
  m$percent=round(m$value/m$var2_sum*100,1)
  m$percent_l=paste(as.character(m$percent),"%")
  
  m=m%>%filter(Var2%in%c(pie_title,neigh) )
  
  colors=usecol(pal=pal_unikn_light ,n=nrow(t))
  n=length(neigh)
  
  
  g= ggplot(m, aes(x="", y=percent, fill=Var1)) +
    geom_bar(stat="identity",color='black', width=1) +
    # coord_polar("y", start=0)+
    coord_polar(theta='y')+
    # theme_void()+ # remove background, grid, numeric labels
    scale_fill_manual(values = colors)+
    labs(x = NULL, y = NULL, fill = NULL, title = "") + 
    geom_text_repel(aes(label = paste0(percent, "%"),x=1.5),
                    
                    position = position_stack(vjust = 0.5)) +
    # theme_classic() +
    theme(legend.position="bottom",
          axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          plot.title = element_text(hjust = 0.5, color = "#666666")
          ,strip.text = element_text(size = 20))+
    facet_wrap(~Var2)
  return(g)
}
#----------------------------------------------------------------------------------------------

