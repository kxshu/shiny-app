library(shiny)
library(rvest)
library(xml2)
library(jiebaR)
library(stringr)
library(wordcloud2)

ui <- fluidPage(
  titlePanel("分析热词"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "num", 
                  label = "选择显示分词数量", 
                  value = 10, min = 1, max = 100),
      textInput(inputId = "pageURL",
                label = "输入网址",
                value = "https://www.lagou.com/jobs/3872688.html"),
      textInput(inputId = "tags",
                label = "输入节点",
                value = "dd.job_bt"),
      actionButton(inputId = "get",
                   label = "获取")
    ),
    mainPanel(
      wordcloud2Output('plot')
    )
  )
  #imageOutput('plot')
  
)
