## R Markdown

#This script is aimed to get the wall posts from different VK communities

```{r }

#user_id <- as.numeric(readline(prompt = "Enter your id VK: ")) #receiving ID VKhead
user_id <- 48166591
cat("Your ID is", user_id)
#access_token <-(readline(prompt = "Enter your Access Token VK: ")) #receiving access code
access_token <- "0b603db7a39dccc59a2f774d501bb1027e1402c4b46da45d53a394a27ec0447b9c13c1cd9268c5a978f1d"
cat("Your Access Token is", access_token)
#domain <-(readline(prompt = "Enter domain: "))
owner_id <-as.numeric(-23904) #receiving domain
cat("Your owner_id is", owner_id)
#count <- as.character(readline(prompt = "Enter the count of posts per one request (sample)"))
count <- as.character(100)
counter <- as.numeric(count)
cat("count =", count)
#offset <- as.character(readline(prompt = "Enter the offset of samples "))
offset <- as.character(100)
cat("offset =", count)
#num_request <- as.numeric(readline(prompt = "Enter the number of requests "))
num_request <- as.numeric(200)
cat("num_request =", num_request)
total=counter*num_request
cat("Records = ", total)
###########################################
#receiving the data
library(RCurl)
library(jsonlite) 
i=150
off=15000
#new = new[FALSE]
new <- data.frame()

for (i in 1:num_request){
j <- as.character(off)
d <- postForm('https://api.vk.com/method/wall.get',
             user_id=print(user_id), 
             access_token=print(access_token),
             v=5.131,
             owner_id=print(owner_id),
             count=print(count),
             offset=print(off))
rd <- fromJSON(d, flatten = TRUE)
typeof(rd)
d=as.data.frame(rd, optional = TRUE) # data frame 
typeof(d)
md<-data.frame(d$response.count, d$response.items.id, d$response.items.text,
              d$response.items.comments.count,
              d$response.items.date, d$response.items.views.count,
              d$response.items.from_id, d$response.items.hash,
              d$response.items.likes.count,
              d$response.items.marked_as_ads, d$response.items.owner_id,
              d$response.items.post_source.platform,
              d$response.items.reposts.count)
new <- rbind(new,md)
off=off+100
}
dataframe <- new
head(new)
new <- apply(new,2,as.character)
write.csv2(new, "my_df.csv")
#new<-(d$response.items.text)
```
