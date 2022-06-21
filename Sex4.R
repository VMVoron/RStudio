library(RCurl)
library(jsonlite)
library(dplyr)
access_token <-  "9c45bd8199e34b3971d8f3bc1a86e5cbc515f8d876f44123ec4acb92d8bf03d3b669a093e188650368456"
id_1 = 440943
id_2 = 2050007
# first 
d1 = postForm('https://api.vk.com/method/friends.get',
              user_id= id_1,
              fields = "sex",
              v=5.81,
              access_token = access_token
)
rd1 <- fromJSON(d1, flatten = TRUE)
md1<-data.frame(rd1[["response"]][["items"]][["id"]], rd1[["response"]][["items"]][["sex"]])
colnames(md1)[1] <- "id"
colnames(md1)[2] <- "sex"
# second
d2 = postForm('https://api.vk.com/method/friends.get',
              user_id= id_2,
              fields = "sex",
              v=5.131,
              access_token = access_token
)
rd2 <- fromJSON(d2, flatten = TRUE)
md2<-data.frame(rd2[["response"]][["items"]][["id"]], rd2[["response"]][["items"]][["sex"]])
colnames(md2)[1] <- "id"
colnames(md2)[2] <- "sex"
rm(d1, d2)
tempid <-0 # creating a variable for ID 
# друзья друзей первого
md_11 <- data.frame()
for (k in 1:nrow(md1))  { # starting a cycle 
  print(tempid)
  tempid <- md1[k,1]
  PF1 = postForm('https://api.vk.com/method/friends.get',
               user_id=tempid, access_token=access_token,
               v=5.131,
               extended="1",
               fields="sex" ) # field 
  rd_11 <- fromJSON(PF1, flatten = TRUE)
  typeof(rd_11)
  md_keep<-data.frame(rd_11[["response"]][["items"]][["id"]], rd_11[["response"]][["items"]][["sex"]])
  md_11 <- rbind(md_11,md_keep)
  Sys.sleep(0.33)
}
md_11 <- distinct(md_11)
colnames(md_11)[1] <- "id"
colnames(md_11)[2] <- "sex"
rm(md_keep, k, PF1)
# друзья друзей второго 
md_22 <- data.frame()
for (k in 1:nrow(md2))  { # starting a cycle 
  print(tempid)
  tempid <- md2[k,1]
  PF2 = postForm('https://api.vk.com/method/friends.get',
                 user_id=tempid, access_token=access_token,
                 v=5.131,
                 extended="1",
                 fields="sex" ) # asked for sex 
  rd_22 <- fromJSON(PF2, flatten = TRUE)
  typeof(rd_22)
  md_keep<-data.frame(rd_22[["response"]][["items"]][["id"]], rd_22[["response"]][["items"]][["sex"]])
  md_22 <- rbind(md_22,md_keep)
  Sys.sleep(0.33)
}
md_22 <- distinct(md_22)
colnames(md_22)[1] <- "id"
colnames(md_22)[2] <- "sex"
rm(md_keep, k, PF2, tempid)
### статистика для друзей
stat1 <- md1 %>% count(md1$sex, sort = TRUE)
colnames(stat1)[1] <- "sex"
stat1 # 1 - male, 2 female
stat2 <- md2 %>% count(md2$sex, sort = TRUE)
colnames(stat2)[1] <- "sex"
stat2 
### статистика для друзей друзей

stat_11 <- md_11 %>% count(md_11$sex, sort = TRUE)
colnames(stat_11)[1] <- "sex"
stat_11 

stat_22 <- md_22 %>% count(md_22$sex, sort = TRUE)
colnames(stat_22)[1] <- "sex"
stat_22
