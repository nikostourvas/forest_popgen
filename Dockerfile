####### Dockerfile #######
FROM hlapp/rpopgen:latest
MAINTAINER Nikolaos Tourvas <nikostourvas@gmail.com>

# Tinytex
RUN wget -qO- \
    "https://github.com/yihui/tinytex/raw/master/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
  && mv ~/.TinyTeX /opt/TinyTeX \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && tlmgr install metafont mfware inconsolata tex ae parskip listings \
  && tlmgr path add \
  && Rscript -e "source('https://install-github.me/yihui/tinytex'); tinytex::r_texmf()" \
  && chown -R root:staff /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin
  
# Install additional Latex packages
RUN tlmgr install \
  greek-fontenc \
  babel-greek \
  setspace \
  hanging
  
# Install Tahoma font
COPY tahoma.ttf /usr/share/fonts/truetype/tahoma.ttf
COPY tahomabd.ttf /usr/share/fonts/truetype/tahomabd.ttf

# Create directory for population genetics software on linux
RUN mkdir /home/rstudio/software

# Install clumpp
RUN mkdir /home/rstudio/software/clumpp \ 
  && cd /home/rstudio/software/clumpp \
  && wget https://rosenberglab.stanford.edu/software/CLUMPP_Linux64.1.1.2.tar.gz \
  && gunzip CLUMPP_Linux64.1.1.2.tar.gz; tar xvf CLUMPP_Linux64.1.1.2.tar \
  && rm -rf CLUMPP_Linux64.1.1.2.tar.gz CLUMPP_Linux64.1.1.2.tar \
  && cd CLUMPP_Linux64.1.1.2 \
  && cp CLUMPP /usr/local/bin/CLUMPP

# Install Structure
RUN mkdir /home/rstudio/software/struct-src \
  && cd /home/rstudio/software/struct-src \
  && wget https://web.stanford.edu/group/pritchardlab/structure_software/release_versions/v2.3.4/structure_kernel_source.tar.gz \
  && gunzip structure_kernel_source.tar.gz; tar xvf structure_kernel_source.tar \
  && rm -rf structure_kernel_source.tar.gz structure_kernel_source.tar\
  && cd structure_kernel_src \
  && make \
  && cp structure /usr/local/bin/structure 

# Install Migraine
RUN apt-get update -qq \
  && apt -y install libgmp3-dev 
RUN install2.r --error \
 blackbox \
 && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN mkdir /home/rstudio/software/migraine \
  && cd /home/rstudio/software/migraine \
  && wget http://kimura.univ-montp2.fr/%7Erousset/migraine05/migraine.tar.gz \
  && gunzip migraine.tar.gz; tar xvf migraine.tar \
  && rm -rf migraine.tar.gz  migraine.tar \
  && g++ -DNO_MODULES -o migraine latin.cpp -O3 
  
# Install Bayescan
RUN mkdir /home/rstudio/software/bayescan \
  && cd /home/rstudio/software/bayescan \
  && wget http://cmpg.unibe.ch/software/BayeScan/files/BayeScan2.1.zip \
  && unzip BayeScan2.1.zip \
  && rm -rf BayeScan2.1.zip \
  && cd /home/rstudio/software/bayescan/BayeScan2.1/source \
  && make
  
# Install Pophelper for Structure output
  # install linux dependencies
RUN sudo apt -y install libcairo2-dev \
  && sudo apt -y install libxt-dev
  # install R dependencies
RUN install2.r --error \
  Cairo \
  devtools \
  ggplot2 \
  gridExtra \
  gtable \
  tidyr 
  # install pophelper from github
RUN installGithub.r \
  royfrancis/pophelper \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
  
# Install dartR package
  # install linux dependencies
RUN sudo apt-get update -qq
RUN sudo apt -y install libglu1-mesa-dev
RUN sudo apt-get -y --no-install-recommends \
	install gdal-bin proj-bin libgdal-dev libproj-dev
  # Install BiocManager
RUN install2.r --error \
  BiocManager \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
  # Install R packages from Bioconductor
RUN R -e "BiocManager::install(c('SNPRelate', 'qvalue'))"
  # Install dartR
#RUN install2.r --error \
#  dartR \
#  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN installGithub.r \
  green-striped-gecko/dartR \
 && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Install R packages from CRAN
RUN apt-get update -qq \
  && apt-get -y install libudunits2-dev # needed for scatterpie
RUN install2.r --error \
  bookdown \
  citr \
  ggThemeAssist \
  remedy \
  popprxl \
  genepop \
  factoextra \
  kableExtra \
  scatterpie \
  ggmap \
  ggsn \
  diveRsity \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Install R packages from github
RUN installGithub.r \
  jgx65/hierfstat \
  fawda123/ggord \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
  
# Install radiator
RUN install2.r --error \
  pak \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

#RUN R -e "pak::pkg_install("thierrygosselin/radiator", ask = FALSE)"
RUN installGithub.r \
	thierrygosselin/radiator \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
	

# Install genepop on linux
RUN mkdir /home/rstudio/software/genepop \
  && cd /home/rstudio/software/genepop \
  && wget http://kimura.univ-montp2.fr/%7Erousset/GenepopV4.zip \
  && unzip GenepopV4.zip \
  && unzip sources.zip \ 
  && rm -rf GenepopV4.zip sources.zip \
  && g++ -o Genepop *.cpp -O3 \
  && cp Genepop /usr/local/bin/Genepop

# Install console version of Arlequin
RUN mkdir /home/rstudio/software/arlecore \
  && cd /home/rstudio/software/arlecore \
  && wget http://cmpg.unibe.ch/software/arlequin35/linux/arlecore_linux.zip\
  && unzip arlecore_linux.zip \
  && rm -rf arlecore_linux.zip	 

# Install ecodist package
RUN install2.r --error \
  ecodist \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Import Data or Create a blank Data directory
# COPY /data /home/rstudio/data
RUN mkdir /home/rstudio/data
# Make data read-only

# Import preferences for RStudio interface
COPY set_theme.sh /etc/cont-init.d/theme
