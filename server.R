library(shiny)
library(rvest)
library(xml2)
library(jiebaR)
library(stringr)
library(wordcloud2)

server <- function(input, output) {

  data <- eventReactive(input$get,{
    
    filename <- filename();
    
    #if(!file.exists(filename)){
      
      isolate({
        withProgress({
          setProgress(message = "分析中...")
          
          writeInfo(filename)
          
        })
      })
    #}else{
      #readInfo(filename)
    #}
    
  })
  
  
  filename<- function(){
    filename <- input$pageURL
    filename <- gsub('[/]','-',filename)
    filename <- paste(filename,".csv", sep = "")
    return(filename)
  }
  
  catchInfo <- function(){
    web <- read_html(input$pageURL)
    print(web)
    position <- web %>% html_nodes(input$tags) %>% html_text()
    engine_s <- worker(stop_word="stopwords.txt") 
    seg <- segment(position,engine_s)
    f <- freq(seg)
    
  }
  
  writeInfo <- function(filename){
      if(catchInfo()){
        #print(catchInfo())
        catchData <- catchInfo()
      }else{
        return('没内容')
      }
      #catchData <- data.frame(catchData)
      file.create(filename)
      write.csv(catchData,file = filename,quote = F,row.names = F)
      print('already written!')
      return(catchData)
    }

  readInfo <- function(filename){
      Info <- read.csv(file = filename)
      #Info <- data.frame(Info)
      print(Info)
      #Info
      print('ready csv')
      return(Info)
  }
  
  output$plot <-renderWordcloud2({
    filename<-filename()
    
    if(!file.exists(filename)){
      x <- data()
    }else{
      
      x <- readInfo(filename)
    }
    
    
    
    env = parent.frame()
    x <- x[1:input$num,]
    #x <- freq(x)
    print(x)
    wordcloud2(x,size=1,minRotation = -pi/2, maxRotation = -pi/2,
               fontFamily = "微软雅黑",color = 'random-dark')
  })
}