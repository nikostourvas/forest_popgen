####### Dockerfile #######
FROM rocker/tidyverse:4.4.2
MAINTAINER Nikolaos Tourvas <nikostourvas@gmail.com>

# Create directory for population genetics software on linux
RUN mkdir /home/rstudio/software

# Prevent error messages from debconf about non-interactive frontend
ARG TERM=linux
ARG DEBIAN_FRONTEND=noninteractive

# Install vim
RUN apt update && apt -y install vim
	
# Servers for Migraine, Genepop and other software
# are sometimes unstable, so install first

# Install Migraine
#RUN apt-get update -qq \
#  && apt -y install libgmp3-dev libglpk-dev
#RUN install2.r --error \
# blackbox \
# && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
#RUN mkdir /home/rstudio/software/migraine \
#  && cd /home/rstudio/software/migraine \
#  && wget http://kimura.univ-montp2.fr/%7Erousset/migraine05/migraine.tar.gz \
#  && gunzip migraine.tar.gz; tar xvf migraine.tar \
#  && rm -rf migraine.tar.gz  migraine.tar \
#  && g++ -DNO_MODULES -o migraine latin.cpp -O3 
 
# Install clumpp
#RUN mkdir /home/rstudio/software/clumpp \ 
#  && cd /home/rstudio/software/clumpp \
#  && wget https://rosenberglab.stanford.edu/software/CLUMPP_Linux64.1.1.2.tar.gz \
#  && gunzip CLUMPP_Linux64.1.1.2.tar.gz; tar xvf CLUMPP_Linux64.1.1.2.tar \
#  && rm -rf CLUMPP_Linux64.1.1.2.tar.gz CLUMPP_Linux64.1.1.2.tar \
#  && cd CLUMPP_Linux64.1.1.2 \
#  && cp CLUMPP /usr/local/bin/CLUMPP

# Install clumpak
RUN mkdir /home/rstudio/software/clumpak \
        && cd /home/rstudio/software/clumpak \
	&& wget https://tau.evolseq.net/clumpak/download/CLUMPAK.zip \
        && cd /home/rstudio/software/clumpak \
        && unzip CLUMPAK.zip \
        && cd CLUMPAK \
        && unzip 26_03_2015_CLUMPAK.zip \
        && rm -rf CLUMPAK.zip 26_03_2015_CLUMPAK.zip Mac_OSX_files.zip

# Install clumpak perl dependencies via apt
RUN apt update && apt -y install libgd-graph3d-perl \
        libgd-graph-perl \
        libgd-perl \
        libarchive-zip-perl \
        libarchive-extract-perl

# Clumpak dependecies via cpanm
RUN apt -y install cpanminus
RUN cpanm Clone \
        Config::General \
        Data::PowerSet \
        Getopt::Long \
        File::Slurp \
        File::Path \
        List::MoreUtils \
        PDF::API2 \
        PDF::Table \
        File::Basename \
        List::Permutor \
        GD::Graph::lines \
        GD::Graph::Data \
        Getopt::Std \
        List::Util \
        File::Slurp \
        Scalar::Util \
        Statistics::Distributions \
        Archive::Extract \
	Archive::Zip \
        Array::Utils

# Copy .pm files to /usr/share/perl/5.38
RUN cd /home/rstudio/software/clumpak/CLUMPAK/26_03_2015_CLUMPAK/CLUMPAK \
        && chmod +x *pm \
        && cp *.pm /usr/share/perl/5.38
# fix permissions for executables & add to path
RUN cd /home/rstudio/software/clumpak/CLUMPAK/26_03_2015_CLUMPAK/CLUMPAK/CLUMPP \
        && chmod +x CLUMPP \
        && cd /home/rstudio/software/clumpak/CLUMPAK/26_03_2015_CLUMPAK/CLUMPAK/mcl/bin \
        && chmod +x * \
        && cd /home/rstudio/software/clumpak/CLUMPAK/26_03_2015_CLUMPAK/CLUMPAK/distruct \
        && chmod +x distruct1.1
ENV PATH="$PATH:/home/rstudio/software/clumpak/CLUMPAK/26_03_2015_CLUMPAK/CLUMPAK/CLUMPP"
ENV PATH="$PATH:/home/rstudio/software/clumpak/CLUMPAK/26_03_2015_CLUMPAK/CLUMPAK/mcl/bin"
ENV PATH="$PATH:/home/rstudio/software/clumpak/CLUMPAK/26_03_2015_CLUMPAK/CLUMPAK/distruct"

# Install Structure
#RUN mkdir /home/rstudio/software/struct-src \
  #&& cd /home/rstudio/software/struct-src \
  #&& wget https://web.stanford.edu/group/pritchardlab/structure_software/release_versions/v2.3.4/structure_kernel_source.tar.gz \
  #&& gunzip structure_kernel_source.tar.gz; tar xvf structure_kernel_source.tar \
  #&& rm -rf structure_kernel_source.tar.gz structure_kernel_source.tar\
  #&& cd structure_kernel_src \
  #&& make \
  #&& cp structure /usr/local/bin/structure 
RUN mkdir /home/rstudio/software/structure \
  && cd /home/rstudio/software/structure \ 
  && wget https://web.stanford.edu/group/pritchardlab/structure_software/release_versions/v2.3.4/release/structure_linux_console.tar.gz \
  && tar xzfv structure_linux_console.tar.gz \
  && rm -rf structure_linux_console.tar.gz
ENV PATH="$PATH:/home/rstudio/software/structure/console"

# Install Bayescan
RUN mkdir /home/rstudio/software/bayescan \
  && cd /home/rstudio/software/bayescan \
  && wget http://cmpg.unibe.ch/software/BayeScan/files/BayeScan2.1.zip \
  && unzip BayeScan2.1.zip \
  && rm -rf BayeScan2.1.zip \
  && cp /home/rstudio/software/bayescan/BayeScan2.1/binaries/BayeScan2.1_linux64bits /usr/local/bin/bayescan
  #&& cd /home/rstudio/software/bayescan/BayeScan2.1/source \
  #&& make

# Install genepop on linux
#RUN mkdir /home/rstudio/software/genepop \
#  && cd /home/rstudio/software/genepop \
#  && wget http://kimura.univ-montp2.fr/%7Erousset/GenepopV4.zip \
#  && unzip GenepopV4.zip \
#  && unzip sources.zip \ 
#  && rm -rf GenepopV4.zip sources.zip \
#  && g++ -o Genepop *.cpp -O3 \
#  && cp Genepop /usr/local/bin/Genepop

# Install console version of Arlequin
RUN mkdir /home/rstudio/software/arlecore \
  && cd /home/rstudio/software/arlecore \
  && wget http://cmpg.unibe.ch/software/arlequin35/linux/arlecore_linux.zip\
  && unzip arlecore_linux.zip \
  && rm -rf arlecore_linux.zip \ 
  && chmod +x arlecore_linux/arlecore3522_64bit
ENV PATH="$PATH:/home/rstudio/software/arlecore/arlecore_linux"

# Install newhybrids without gui
#RUN cd /home/rstudio/software/ \
  #&& git clone https://github.com/eriqande/newhybrids.git \
  #&& cd newhybrids \
  #&& git submodule init \
  #&& git submodule update \
  #&& ./Compile-with-no-gui-Linux.sh

# Install pipx & structure_threader
RUN apt update && apt -y install pipx \
&& pipx ensurepath \
&& pipx install structure_threader

# Install TreeMix
RUN apt update && apt -y install libboost-all-dev libgsl0-dev
RUN cd /home/rstudio/software/ \
  && git clone https://bitbucket.org/nygcresearch/treemix.git \
  && cd treemix \
  && ./configure \
  && make \
  && make install

# The following section is copied from hlapp/rpopgen Dockerfile
# It is copied instead of using it as a base for this image because it is not 
# updated regularly

#------------------------------------------------------------------------------
## Some of the R packages depend on libraries not already installed in the
## base image, so they need to be installed here for the R package
## installations to succeed.
RUN apt update \
    && apt install -y \
    libgsl0-dev \
    libmagick++-dev \
    libudunits2-dev \
    gdal-bin \
    libgdal-dev

## The nloptr package is needed by lme4, and it itself needs to download the
## NLopt code from http://ab-initio.mit.edu/wiki/index.php/NLopt, which is
## unstable. Hence we put this upfront, so that we fail fast on this step,
## which makes it easier to redo.
RUN install2.r --error \
    nloptr \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Bioconductor dependencies of packages we install from CRAN (specifically pegas)
RUN install2.r --error BiocManager \
&& Rscript -e 'requireNamespace("BiocManager"); BiocManager::install();' \
&& Rscript -e 'requireNamespace("BiocManager");	BiocManager::install(c("Biostrings", "qvalue"));' \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN R -e "BiocManager::install(c('Biostrings', 'qvalue'))"

## Install population genetics packages from CRAN
RUN rm -rf /tmp/*.rds \
&&  install2.r --error \
    #apex \
    ape \
    adegenet \
    #adespatial \
    pegas \
    phangorn \
    phylobase \
    coalescentMCMC \
    mmod \
    poppr \
    psych \
    #strataG \
    #rmetasim \
    genetics \
    hierfstat \
    lme4 \
    MuMIn \
    multcomp \
    raster \
    vegan \
    viridis \
    pcadapt \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install population genetics packages from Github
## (hierfstat included here temporarily until new release is on CRAN)
RUN installGithub.r \
    whitlock/OutFLANK \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install other useful packages from CRAN
RUN install2.r --error \
    knitcitations \
    phytools \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
#------------------------------------------------------------------------------

# Install Pophelper for Structure output
  # install linux dependencies
RUN apt -y install libcairo2-dev \
  && apt -y install libxt-dev
RUN apt install -y libfreetype6-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libnlopt-dev
  # install R dependencies
RUN install2.r --error \
  devtools \
  gridExtra \
  gtable 
  # install pophelper from github
RUN installGithub.r \
  royfrancis/pophelper \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
  
# Install dartR package
  # install linux dependencies
RUN apt-get update -qq
RUN apt -y install libglu1-mesa-dev
RUN apt-get -y --no-install-recommends \
	install gdal-bin proj-bin libgdal-dev libproj-dev

# Install SOLOMON r package
#RUN apt -y install tcl tk
#RUN install2.r --error SOLOMON

# Install R packages from Bioconductor
RUN R -e "BiocManager::install(c('SNPRelate', 'qvalue', 'ggtree'))"

# Install R packages from CRAN
RUN apt-get update -qq \
  && apt-get -y install libudunits2-dev # needed for scatterpie
RUN install2.r --error \
  bookdown \
  #citr \
  ggThemeAssist \
  remedy \
  #popprxl \
  genepop \
  factoextra \
  kableExtra \
  scatterpie \
  ggmap \
  #ggsn \
  #diveRsity \
  ecodist \
  splitstackshape \
  fsthet \
  XML \
  car \
  sjstats \
  agricolae \
  ggpubr \ 
  gridGraphics \
  officer \
  flextable \	
  PopGenReport \
  vcfR \
  #dartR \
  eulerr \
  assignPOP \
  OptM \
  gghalves \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Dependencies for strataG, PopGenUtils
RUN apt update -qq \
	&& apt -y install libglpk-dev

# Install R packages from github
RUN installGithub.r \
  jgx65/hierfstat \
  fawda123/ggord \
  thierrygosselin/radiator \
  #zkamvar/ggcompoplot \
  ericarcher/strataG \	
  bwringe/parallelnewhybrid \
  konopinski/Shannon \
  nikostourvas/PopGenUtils \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
