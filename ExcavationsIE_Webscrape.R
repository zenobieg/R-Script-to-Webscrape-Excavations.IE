##Webscraping excavations.ie

library(rvest)
library(stringr) ##needed to subset string to isolate by reports

##reads in webpage

url<-"https://excavations.ie/advanced-search/page/1/?exca_a=advanced_search&y&c&a&snu&sna&st&rtc=ring-ditch&itm&smrn&eln" ##replace this url with the search results for the type of reports you are interested in collecting, note that it is useful to consider different spellings (i.e. ring ditch vs. ring-ditch)
webpage<-read_html(url)  ##loads in html of search results at excavations.ie


##extracts number of search result pages
pages<-html_node(webpage,xpath = "/html/body/div[3]/div[2]/nav[1]/div/span[1]") ##reads in path to number of search page results
pages<-html_text(pages)  ##reads in text of number of search page results
pages<-ifelse(is.na(pages), 1)  ##if search results are limited to a single page sets the number of pages to 1
pages<-sub(".*\\s", "", pages) ##removes "Page # of " from string
pages<-as.integer(pages) ##transform page number from string to integer

##Gets report links to scrape data
all_reportlinks<-character()  ##creates empty vector to store all links in

for (i in 1:pages) {
  
  t0 <- Sys.time()
 
   url2<-paste("https://excavations.ie/advanced-search/page/",i,"/?exca_a=advanced_search&y&c&a&snu&sna&st&rtc=ring-ditch&itm&smrn&eln", sep = "")
  webpage2<-read_html(url2)  ##reads in url of particular search page
  reportlinks<-html_nodes(webpage, "a")  ##gets list of attribute nodes for webpage
  reportlinks<-html_attr(reportlinks, "href")    ##pulls out attributes that are url links from webpage
  reportlinks<-str_subset(reportlinks, "report", negate = "FALSE")  ##removes links that are not reports
  all_reportlinks<-append(all_reportlinks, reportlinks)
  
  t1 <- Sys.time()
  response_delay <- as.numeric(t1-t0)
  Sys.sleep(10*response_delay) # sleep 10 times longer than response_delay
}


County<-character()
SiteName<-character()
SMR<-character()
License<-character()
Author<-character()
SiteType<-character()
ITM<-character()
LatLong<-character()
Description<-character()

for (i in 1:length(all_reportlinks)) {
  
  t0 <- Sys.time()
 
   url3<-all_reportlinks[i]
  webpage3<-read_html(url3)
  
  county<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[1]/div[2]/p[1]/span[1]")
  county<-html_text(county)
  county<-str_replace_all(county, "[\\r\\n\\t]+", "")      
  county<-sub(".*: ","",county)
  County<-append(County, county)

  sitename<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[1]/div[2]/p[1]/span[2]")
  sitename<-html_text(sitename)
  sitename<-str_replace_all(sitename, "[\\r\\n\\t]+", "")      
  sitename<-sub(".*: ","",sitename)    
  SiteName<-append(SiteName, sitename)

  smr<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[1]/div[2]/p[2]/span[1]")
  smr<-html_text(smr)
  smr<-str_replace_all(smr, "[\\r\\n\\t]+", "")      
  smr<-sub(".*: ","",smr) 
  SMR<-append(SMR,smr)

  license<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[1]/div[2]/p[2]/span[2]")
  license<-html_text(license)
  license<-str_replace_all(license, "[\\r\\n\\t]+", "")      
  license<-sub(".*: ","",license)
  License<-append(License,license)

  author<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[1]/div[2]/p[3]/span[1]")
  author<-html_text(author)
  author<-str_replace_all(author, "[\\r\\n\\t]+", "")      
  author<-sub(".*: ","",author)
  Author<-append(Author, author)

  type<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[1]/div[2]/p[4]/span[1]")
  type<-html_text(type)
  type<-str_replace_all(type, "[\\r\\n\\t]+", "")      
  type<-sub(".*: ","",type)
  SiteType<-append(SiteType, type)

  itm<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[1]/div[2]/p[5]/span[1]")
  itm<-html_text(itm)
  itm<-str_replace_all(itm, "[\\r\\n\\t]+", "")      
  itm<-sub(".*: ","",itm)
  ITM<-append(ITM,itm)

  latlong<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[1]/div[2]/p[6]/span[1]")
  latlong<-html_text(latlong)
  latlong<-str_replace_all(latlong, "[\\r\\n\\t]+", "")      
  latlong<-sub(".*: ","",latlong)
  LatLong<-append(LatLong,latlong)
  
  description<-html_node(webpage3, xpath = "/html/body/div[3]/div[1]/div[4]/div")
  description<-html_text(description)
  description<-str_replace_all(description, "[\\r\\n\\t]+", "")    
  Description<-append(Description, description)
  
  t1 <- Sys.time()
  response_delay <- as.numeric(t1-t0)
  Sys.sleep(10*response_delay) # sleep 10 times longer than response_delay
}


data<-data.frame(County, SiteName, SMR, License, Author, SiteType, ITM, LatLong, Description)

workingdirectory<-getwd() ##pulls your working directory; typing x in the R console will allow you to see what the working directory is
outputfilename<-"excavationsIE_ring-ditch.csv" ##change this to the filename that you want
outputpath<-file.path(workingdirectory,outputfilename)  ##creates the file path to the output file
write.csv(data,outputpath) 



                     