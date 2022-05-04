# Superheroes & Villains

This project collects data using the **[Superhero API](https://www.superheroapi.com/)** to explore individual comic book character backgrounds. Data was compiled using R (httr & jsonlite packages), code for data collection process can be found [here](https://github.com/tashapiro/superhero-comics/blob/main/code/superhero-api-data-collection.R). 


## Data

Data dictionary can be found [here](https://github.com/tashapiro/superhero-comics/blob/main/data/README.md).

Information collected from **[Superhero API](https://www.superheroapi.com/)**. The dataset contains biographical information about each comic book character (e.g. name, place of birth, species), character associaitions (e.g. affiliations, relatives), as well as power stat information scaled from 0-100 (e.g. strength, durability, intelligence).

Characters are from various different comic book publishers, including but not limited to DC Comics, Marvel Comics, and Dark Horse comics  The data consists of a total of 731 different characters.

## Visualization Gallery

Visualizations created with the help of **ggplot2** and ggplot extensions, **geomtext_path** and **ggimage**. I picked select characters from popular affiliations of super heros & villains (Justice League, The Avengers, Guardians of The Galaxy), and plotted the values of their super abilities. Images for these characters were downloaded from the respective **[DC Fandom](https://dc.fandom.com/wiki/DC_Comics_Database)** and **[Marvel Fandom](https://marvel.fandom.com/wiki/Marvel_Database)** sites. 

### Justice League
![plot](./plots/justice_league.jpeg)

### The Avengers
![plot](./plots/avengers.jpeg)


### Guardians of The Galaxy
![plot](./plots/guardians.jpeg)
