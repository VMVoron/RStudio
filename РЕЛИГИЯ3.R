# parsing data
library(RCurl)
library(jsonlite)
access_token <- "0b603db7a39dccc59a2f774d501bb1027e1402c4b46da45d53a394a27ec0447b9c13c1cd9268c5a978f1d"
sample_size <-as.numeric(1000000) ## Sample ::: 1000 (integer division by 1000 is needed)
id = sample(1:2147483647, sample_size) # 2147483647 is the maximum number of VK ID
num = sample_size/1000 # 1000 per request is the maximum for this method
idx <-  split(id, ceiling(seq_along(id)/1000)) # split into equal pieces, pieces = number of requests to server
library(tidyverse)
library(stringi)
library(tidyr)
rel <- data.frame() # creating empty dataframes
cop <- data.frame()

if (num == 1) { #first condition if sample equals 1000
  ids = paste(idx, collapse = ", ") # paste as a string, comma as a separator (comma is needed in this method)
  PF = postForm('https://api.vk.com/method/users.get',
                user_ids = ids,
                access_token = print(access_token),
                v=5.131, # âåðñèÿ àïè
                fields = "personal") 
  head(PF)
  response_list <- fromJSON(PF, flatten = FALSE)
  for (i in 1:998) {
    print(i)
    print(response_list[["response"]][["personal"]][[i]][["religion"]]) #adressing to religion
    if (is.character((response_list[["response"]][["personal"]][[i]][["religion"]])) == TRUE)
    {cop=as.list.data.frame(response_list[["response"]][["personal"]][[i]][["religion"]])
    rel <- rbind(rel,cop)} # binding dataframes, cop keeps temporary, rel saves all
  }
}
if (num > 1) { # second condition if sample is more than 1000
  for (k in 1:num) {
    ids = paste(idx[k], collapse = ", ")
    ids <- str_replace_all(ids, c("[c]" = "", "[(]" = "", "[)]" = "")) # removing extra symbols
    PF = postForm('https://api.vk.com/method/users.get',
                  user_ids = ids,
                  access_token = print(access_token),
                  v=5.131, # âåðñèÿ àïè
                  fields = "personal")
    response_list <- fromJSON(PF, flatten = FALSE)
    for (i in 1:998) { # if 999 or 1000 - returns an error (overrun)
      print(i) # just for fun
      print(response_list[["response"]][["personal"]][[i]][["religion"]]) 
      if (is.character((response_list[["response"]][["personal"]][[i]][["religion"]])) == TRUE) #adressing to religion
      {cop=as.list.data.frame(response_list[["response"]][["personal"]][[i]][["religion"]])
        rel <- rbind(rel,cop)} # binding dataframes, cop keeps temporary, rel saves all
    }
  Sys.sleep(0.33)} # system sleep in order not to be banned
}
rm(k, i, id, cop, idx) # cleansing memory
gc() #garbage collector
###
colnames(rel)[1] <- "Религия"
rel %>% group_by(Религия) # have a look into to cleanse words
rel$Религия[grepl("Православ'я", rel$Религия)] <- "Православие"
rel$Религия[grepl("атеист", rel$Религия)] <- "Атеизм"
rel$Религия[grepl("Атеист", rel$Религия)] <- "Атеизм"
rel$Религия[grepl("Христианка", rel$Религия)] <- "Христианство"
rel$Религия[grepl("Христианин", rel$Религия)] <- "Христианство"
rel$Религия[grepl("христианство", rel$Религия)] <- "Христианство"
statistics <- rel %>% count(rel[,1], sort = TRUE) # sorting by number
colnames(statistics)[1] <- "Религия" # renaming col names for better look
colnames(statistics)[2] <- "Количество наблюдений"
groups <- head(statistics %>% group_by(Религия), 10) # top-10 religions are given
groups
save(df, groups, rel, response_list, statistics, file = "data_religion.Rdata") # saving RDA 

