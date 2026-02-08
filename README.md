# forest_popgen
A docker repo of Linux & R packages for the analysis of population genetics data. Also contains RStudio server so you can use your favourite software from the familiar RStudio interface in your browser.

Available to download from [Docker hub](https://hub.docker.com/r/nikostourvas/forest_popgen).

# How to run it
1. Assuming you have docker on your system, download the latest version with:
```
docker pull nikostourvas/forest_popgen:latest
```

2. Run RStudio server:
```
docker run --name popgen --rm -dp 8787:8787 -e ROOT=TRUE -e DISABLE_AUTH=true -v "$(pwd)":/home/rstudio/working nikostourvas/forest_popgen
```

3. Open your browser (e.g. Firefox or Chrome) and navigate to the following url:
```
localhost:8787
```

You can access your files from the path:
```
/home/rstudio/working/
```

Optionally, when your are done with data analysis you can shut down the RStudio server by typing in a terminal:
```
docker stop popgen
```

# Software package list (not exhaustive)

### Genetic diversity analysis
adegenet, poppr, pegas, hierfstat, Arlequin, genepop

### Genetic differentiation - hybridisation - assignment
Structure, Structure_threader, CLUMPAK, TreeMix, OpM, assignPOP

### Signals of selection
Bayescan, OutFLANK, pcadapt, FDist (via Arlequin)

### Phylogenetics
ape, phytools, ggtree

### R packages for data cleaning, visualization, etc
tidyverse, ggplot2 helpers (ggThemeAssist, ggpubr, gghalves)

For a full software list, please have a look at the included Dockerfile.

