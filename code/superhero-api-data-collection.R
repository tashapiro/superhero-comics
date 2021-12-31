library(httr)
library(jsonlite)

#setting up the first call

#set up api and base_url

#your API token, replace string below with token
api = 'XXXXXX'

#base URL for call, we will append API and character ID after
base_url = 'https://www.superheroapi.com/api.php/'

#start with the first character ID to df
response<-GET(paste(base_url,api,"/",1, sep=""))
json = fromJSON(rawToChar(response$content))

t<-data.frame(json$connections$`group-affiliation`)

#set dataframe
df = data.frame(json$id, json$biography$`full-name`,json$name, json$powerstats,
          json$biography$alignment, json$biograph$`place-of-birth`,
          json$appearance$race, json$appearance$gender, json$appearance$`eye-color`,
          json$appearance$`hair-color`,json$appearance$height[2], json$appearance$weight[1],
          json$connections$`group-affiliation`,json$connections$`relatives`,json$work$occupation,  json$biography$publisher, 
          json$image)
#rename columns
names(df)<-c('id','full_name','name','intelligence','strength','speed','durability','power','combat',
             'alignment','place_birth','race','gender','eye_color','hair_color','height_cm','weight_lb',
             'affiliations','relatives','occupation','publisher','image_url')


#create loop, loop through remaining IDs, 2 through 731
ids <- 2:731
for (i in ids){
  url = paste(base_url,api,"/",i, sep="")
  res<-GET(url)
  json = fromJSON(rawToChar(res$content))
  data = data.frame(json$id, json$biography$`full-name`,json$name, json$powerstats,
                  json$biography$alignment, json$biograph$`place-of-birth`,
                  json$appearance$race, json$appearance$gender, json$appearance$`eye-color`,
                  json$appearance$`hair-color`,json$appearance$height[2], json$appearance$weight[1],
                  json$connections$`group-affiliation`,json$connections$`relatives`,json$work$occupation,  json$biography$publisher, 
                  json$image)
  df[nrow(df) + 1, ] <- data
}

df[df=="null"]<-NA
df$power<-as.integer(df$power)
df$intelligence<-as.integer(df$intelligence)
df$strength<-as.integer(df$strength)
df$speed<-as.integer(df$speed)
df$durability<-as.integer(df$durability)
df$combat<-as.integer(df$combat)


df2 <- df
df2[df2=="-"]<-NA


df2<-df2%>%
  mutate(
    height_cm = case_when(
      grepl("cm",height_cm)~as.numeric(gsub(" cm","",height_cm)),
      grepl("meters",height_cm)~as.numeric(gsub(" meters","",height_cm))*100
    ),
    weight_lb = as.integer(trimws(gsub(" lb","", weight_lb))),
    hair_color = str_to_title(hair_color),
    eye_color = str_to_title(eye_color)
  )%>%
  mutate(
    height_in = height_cm*0.393701,
    hair_group = case_when(
      grepl("Black|Brown",hair_color)~"Dark",
      grepl("Blond|Yellow|Gold",hair_color)~"Fair",
      grepl("Red|Auburn",hair_color)~"Red",
      grepl("Grey|Silver|White",hair_color)~"Fair",
      grepl("Green|Pink|Purple|Magenta|Blue|Indigo",hair_color)~"Alternative",
      hair_color=="No Hair"~"None"
    )
  )



write.csv(df2, "../data/superheros.csv")

