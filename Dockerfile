FROM debian:jessie
MAINTAINER Jose Sanchez-Garcia "josebsan96@gmail.com"

# This should solve the failed connection to socket error that occurs when running eclipse
RUN export NO_AT_BRIDGE=1

# > At the moment, setting "LANG=C" on a linux system *fundamentally breaks python 3*, and that is not okay
ENV LANG C.UTF-8
# For this project, we will be using the Eclipse Mars 2 IDE
ENV ECLIPSE_DOWNLOAD_LINK http://eclipse.mirror.rafal.ca/technology/epp/downloads/release/mars/2/eclipse-java-mars-2-linux-gtk-x86_64.tar.gz

# Link to Python 3.5 file
ENV PYTHON_DOWNLOAD_LINK https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz

# Eclipse Dev environment will be here
ENV DEFAULT_ECLIPSE_ENVIRONMENT /usr/local/

# Install any necessary packages that will be used within the programs
  RUN apt-get update && apt-get -y upgrade && \
  # apt-get install -y software-properties-common curl && \
  # install apt-utils cause it keeps giving an error message
  apt-get install -y apt-utils && \
  # install wget to retrieve source file from python website
  apt-get install -y wget && \
  # Install this to be able to load up pk-gtk-module for Eclipse
  apt-get install -y packagekit-gtk3-module && \
  # install essential packages for compiling C/C++ programs on Debian/Ubuntu linux
  apt-get install -y build-essential && \
  # install this to make sure pip3 is installed along side Python 3.5
  apt-get install -y libssl-dev && \
  # this would allow you to backspace and delete within python interactive shell (if necessary)
  apt-get install -y libreadline-dev && \
  # install curl to get packages
  apt-get install -y curl && \
  # Also, in Debian Jessie, there is no Sudoers.d file, so we will need to install Sudo itself
  apt-get install -y sudo

# Installs the latest Oracle JDK 8through the addition of repositories
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/java-8-debian.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/java-8-debian.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && \
    apt-get install -y oracle-java8-installer


# Now we need to unpackage the JDK folder and move it to another directory next to the JVM folder
RUN mkdir /usr/lib/jdk && \
    # This will unzip any jdk 8 version that we is downloaded
    tar xvf /var/cache/oracle-jdk8-installer/jdk* -C /usr/lib/jdk && \
    # Since we don't want to worrry about specific names, we change the name of the folder
    # and give it a generic name.
    mv /usr/lib/jdk/jdk* /usr/lib/jdk/OracleJDK8 && \

    #apt-get install -y oracle-java8-set-default && \
    echo "export JAVA_HOME=/usr/lib/jdk/OracleJDK8/" >> ~/.bashrc && \
    echo "export PATH=/usr/lib/jdk/OracleJDK8/bin:$PATH" >> ~/.bashrc && \
    . ~/.bashrc && \
    echo $JAVA_HOME



# Install Python 3.5 from source file
  # download python source file from website
  RUN wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz && \
  # unzipe and install the file
  tar xfz Python-3.5.2.tgz && \
  cd Python-3.5.2 && \
  ./configure && \
  make && \
  make install

# Install ANT
ENV ANT_VERSION 1.8.2
RUN cd && \
  wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
  tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
  mv apache-ant-${ANT_VERSION} /opt/ant && \
  rm apache-ant-${ANT_VERSION}-bin.tar.gz

ENV ANT_HOME /opt/ant
ENV PATH ${PATH}:/opt/ant/bin

# This will download te Eclipse IDE and unpackage it
RUN curl "$ECLIPSE_DOWNLOAD_LINK" | tar vxz -C $DEFAULT_ECLIPSE_ENVIRONMENT

COPY change_config.py /usr/local/eclipse/
RUN python3 /usr/local/eclipse/change_config.py && \
  # Add this to prevent the error 1 code from happening when starting eclipse
  echo "-Dorg.eclipse.swt.internal.gtk.cairoGraphics=false" >> /usr/local/eclipse/eclipse.ini && \
  cat /usr/local/eclipse/eclipse.ini

# Cleanse the build environment
RUN apt-get --purge autoremove -y && apt-get clean

# This will allow us to set up  a connection between the virtual environment and the host
# machine to allow us to display the eclipse GUI through the host machine
RUN chmod +x $DEFAULT_ECLIPSE_ENVIRONMENT/eclipse/eclipse && \
  mkdir -p /home/developer && \
  echo "developer:x:1000:1000:Developer,,,:home/developer:/bin/bash" >> /etc/passwd && \
  echo "developer:x:1000:" >> /etc/group && \
  echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
  chmod 0440 /etc/sudoers.d/developer && \
  chown developer:developer -R /home/developer && \
  chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo && \
  echo "export SWT_GTK3=0" >> ~/.bashrc

USER developer
ENV HOME /home/developer

WORKDIR /home/developer
CMD $DEFAULT_ECLIPSE_ENVIRONMENT/eclipse/eclipse
