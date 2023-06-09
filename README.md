# R-Script-to-Webscrape-Excavations.IE

I created this script in 2020 to specifically scrape all the results for a search conducted on excavations.ie and pull all the report information from the search into a csv file.  The example provided pulls all the results for a search of the term ring-ditch (line 8) and saves them in a csv file called "excavationsIE_ring-ditch.csv".  

To use this code for your own search results you will need to replace the code between the quotation marks in line 8 with the url to the first page of search results for whatever search you have conducted on excavations.ie.  You may also want to change the outputfilename in line 118.  Again edit the code between the quotation marks with the file name of your choice but make sure that .csv is included as the end of the file name. If you are familiar with R you will want to set your working directory prior to running the code.  If you are new to R, a working directory is where all the files generated during your R session will be saved.  You can set this yourself, but if you are unsure how, this code will automatically place the output in the working directory R assigns when opened.  You can check the working directory your csv file was saved to after running the script by typing workingdirectory in the R console and hitting enter.

Note: I have added code to create a delay buffer between each pull from the excavations.ie website so that it is not overwhelmed with requests.  That means that if you have multiple pages of search results the script may take longer but it will eventually create the output you want.  

