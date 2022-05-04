library(tidyverse)
library(geomtextpath)
library(ggimage)
library(showtext)
library(sysfonts)

font_add_google("Chivo", "Chivo")
showtext_auto()

df<-read.csv("https://raw.githubusercontent.com/tashapiro/superhero-comics/main/data/superheroes.csv")

#justice league members
jl<-c("Aquaman","Batman","Black Canary","Flash","Green Arrow","Hal Jordan",
      "Hawkgirl","Superman","Wonder Woman")

#filter to only show justice league characters
df_jl<-df%>%
  filter(name %in% jl & !full_name %in% c("Terry McGinnis","Laurel Lance"))%>%
  select(name, intelligence, combat, strength, power, speed, durability)%>%
  pivot_longer(!name, names_to = "ability", values_to = "stat")

#file path to image
df_jl$image<- paste0(tolower(str_replace(df_jl$name, " ","_")),".png")

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
  x1=rep(0.5,5),
  x2=rep(5.5,5), 
  y1=c(0,25,50,75,100), 
  y2=c(0,25,50,75,100)
)

#PLOT
ggplot(df_jl, aes(x=ability, y=stat, fill=ability))+
  #create y axis text
  geom_textpath(inherit.aes=FALSE, mapping=aes(x=ability, label=ability, y=130), fontface="bold", upright=TRUE, text_only=TRUE, size=3, color=pal_font)+
  geom_image(mapping=aes(y=-70,x=1,image=image), size=0.225)+
  coord_curvedpolar()+
  #create linesegments to represent panel gridlines
  geom_segment(inherit.aes=FALSE, data = segments, mapping=aes(x=x1,xend=x2,y=y1,yend=y2), size=0.35, color=pal_line)+
  geom_col(show.legend = FALSE, width=.8)+
  #text for panel gridlines
  geom_textsegment(inherit.aes=FALSE, data=labels, mapping=aes(x=5.5, xend=6.5, y= y, yend=y, label=y), color = pal_line, textcolour= pal_font, linewidth=0.35, size=2.5)+
  scale_fill_manual(values=pal)+
  scale_y_continuous(limits=c(-70,130))+
  facet_wrap(~toupper(name))+
  labs(title="THE JUSTICE LEAGUE", subtitle="Power Stats by Superhero. Abilities scaled from 0 to 100.",
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


ggsave("justice_league.jpeg", height=9.5, width=7.3)
