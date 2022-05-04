library(tidyverse)
library(geomtextpath)
library(ggimage)
library(showtext)
library(sysfonts)


#import fontss
font_add_google("Chivo", "Chivo")
showtext_auto()

df<-read.csv("https://raw.githubusercontent.com/tashapiro/superhero-comics/main/data/superheroes.csv")

#justice league members
jl<-c(38, 70, 98, 266, 298, 306, 315, 644, 720)
avengers<-c(106, 107, 149, 226, 313, 332, 346, 414, 659)
guardians<-c(234, 275, 303, 566, 630, 431, 487, 655, 727)

#datasets for different charactetrs
df_jl<-df%>%
  filter(id %in% jl)%>%
  select(name, full_name, intelligence, combat, strength, power, speed, durability)%>%
  pivot_longer(intelligence:durability, names_to = "ability", values_to = "stat")%>%
  mutate(name = case_when(name=="Hal Jordan" ~ "Green Lantern", name=="Flash III" ~ "Flash", TRUE ~name),
         image = paste0('character-icons/',tolower(str_replace(name, " ","_")),".png"))


df_avengers<-df%>%
  filter(id %in% avengers)%>%
  select(name, full_name, intelligence, combat, strength, power, speed, durability)%>%
  pivot_longer(intelligence:durability, names_to = "ability", values_to = "stat")%>%
  mutate(image = paste0('character-icons/',tolower(str_replace(name, " ","_")),".png"))

df_guardians<-df%>%
  filter(id %in% guardians)%>%
  select(name, full_name, intelligence, combat, strength, power, speed, durability)%>%
  pivot_longer(intelligence:durability, names_to = "ability", values_to = "stat")%>%
  mutate(name = case_when(name=="Yellowjacket II" ~ "Yellowjacket", TRUE~name),
         full_name = case_when(full_name==""~ name, TRUE ~full_name),
         image = paste0('character-icons/',tolower(str_replace_all(name, " ","_")),".png"))

#filter avengers

#palettes
pal_font<-"white"
pal_bg <-"#131314"
pal_line <-"#D0D0D0"
pal<-c("#E1341A","#FF903B","#ffe850","#27f897","#4bd8ff","#6F02CE")


#create dataframe for custom labels and line segments (for axis)
labels<-data.frame(
  y = c(25,50,75,100),
  x = rep(0.25,4),
  char = rep("Aquaman",4)
)

segments<- data.frame(
  x1=rep(0,5),
  x2=rep(5.5,5), 
  y1=c(0,25,50,75,100), 
  y2=c(0,25,50,75,100)
)

#PLOT -- GUARDIANS, easily swapped with other datasets to show avengers or justice league
ggplot(df_guardians, aes(x=ability, y=stat, fill=ability))+
  #create y axis text
  geom_textpath(inherit.aes=FALSE, mapping=aes(x=ability, label=ability, y=130), fontface="bold", upright=TRUE, text_only=TRUE, size=3, color=pal_font)+
  geom_image(mapping=aes(y=-70,x=1,image=image), size=0.225)+
  coord_curvedpolar()+
  #create linesegments to represent panel gridlines
  geom_segment(inherit.aes=FALSE, data = segments, mapping=aes(x=x1,xend=x2,y=y1,yend=y2), size=0.35, color=pal_line)+
  geom_col(show.legend = FALSE, width=.8)+
  #text for panel gridlines
  geom_textsegment(inherit.aes=FALSE, data=labels, mapping=aes(x=5.5, xend=6.5, y= y, yend=y, label=y), color = pal_line, textcolour= pal_font, linewidth=0.35, size=2.5)+
  #text for actual name below superhero name
  geom_text(inherit.aes=FALSE, mapping=aes(label=full_name, x=0, y=135), vjust=-1, color="white", size=3.5)+
  scale_fill_manual(values=pal)+
  scale_y_continuous(limits=c(-70,135))+
  facet_wrap(~toupper(name))+
  labs(title="GUARDIANS OF THE GALAXY", subtitle="Power Stats by Superhero. Abilities scaled from 0 to 100.",
       caption="Data from Superhero API | Graphic @tanya_shapiro")+
  theme_minimal()+
  theme(text=element_text(family="Chivo", color=pal_font),
        plot.background = element_rect(fill=pal_bg),
        plot.title=element_text(face="bold", hjust=0.5, size=18, margin=margin(t=5)),
        plot.subtitle=element_text(hjust=0.5, margin=margin(t=5, b=20)),
        plot.caption = element_text(margin=margin(t=15)),
        axis.title=element_blank(),
        panel.grid = element_blank(),
        plot.margin=margin(t=10,b=5,l=10,r=10),
        axis.text=element_blank(),
        axis.ticks = element_blank(),
        strip.text=element_text(face="bold", color=pal_font, size=12, vjust=-0.5))


ggsave("guardians.jpeg", height=9.5, width=7.3)
