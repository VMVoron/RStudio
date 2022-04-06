#This script is aimed to count the numbers of deactivated followers for user's profile and for users' friends profile#
user_id <- as.numeric(readline(prompt = "Enter your id VK: ")) #receiving ID VK
cat("Your ID is", user_id)
access_token <-(readline(prompt = "Enter your Access Token VK: ")) #receiving access code
cat("Your Access Token is", access_token)
library(RCurl)
y = postForm('https://api.vk.com/method/users.getFollowers',
             user_id=print(user_id), access_token=print(access_token),
             v=5.74,
             extended="1",
             count="1000",
             fields="sex,city" ) #sendind a form, getting an answer, the limit of followers equals 1000
library(jsonlite) 
rd <- fromJSON(y, flatten = TRUE)
typeof(rd)
d=as.data.frame(rd, optional = TRUE) # data frame of followers
all<-d[1,1]
deact<- data.frame(table(d$response.items.deactivated)) # banned and deleted followers
numdeact=as.numeric(deact[1,2]+deact[2,2]) # returnes a sum of deactivated followers
percent_fol=as.numeric(numdeact/all*100) # returnes percentage of deactivated followers 
percent_fol
print(deact)
cat("Total amount of followers ", all) 
cat("Number of deactivated followers ", numdeact)
cat("The percent of deactivated followers is", percent_fol)
# receiving friends' IDs if they're online                      
library(RCurl)
y = postForm('https://api.vk.com/method/friends.getOnline',
user_id=print(user_id),
access_token=print(access_token), 
v=5.124,
order="count" 
) # order by ID
print(y) 
library(jsonlite)
rd <- fromJSON(y, flatten = TRUE)
typeof(rd)
df=as.data.frame(rd, optional = TRUE)
print(df) # returns an ID list of friends who online at the moment 
tempid <-0 # creating a variable for ID 
for (k in 1:nrow(df))  { # starting a cycle for counting friends' followers
tempid <- df[k,1]
y = postForm('https://api.vk.com/method/users.getFollowers',
user_id=print(tempid), access_token=print(access_token),
v=5.74,
extended="1",
count="1000",
fields="sex,city" ) # asked for sex and city just in case, unnecessary field 
library(jsonlite)
rd <- fromJSON(y, flatten = TRUE)
typeof(rd)
d=as.data.frame(rd, optional = TRUE)
all<-d[1,1]
deact<- data.frame(table(d$response.items.deactivated))
numdeact=as.numeric(deact[1,2]+deact[2,2])
percent_fol=as.numeric(numdeact/all*100)
percent_fol
print(deact)
cat(" Friend ", tempid)
cat(" Total amount of followers ", all )
cat(" Number of deactivated followers ", numdeact )
cat(" The percent of deactivated followers is", percent_fol )
}


