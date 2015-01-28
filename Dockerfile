FROM ubuntu:latest

# Install base packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl lib32gcc1 -y

# install steamcmd
RUN mkdir -p /opt/steamcmd &&\
    cd /opt/steamcmd &&\
    curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -vxz




# install dependancy?
RUN apt-get install libcurl4-gnutls-dev:i386 -y

# install dont starve together
RUN mkdir -p /opt/dontStarveTogether
RUN /opt/steamcmd/steamcmd.sh \
            +login anonymous \
            +force_install_dir /opt/dontStarveTogether \
            +app_update 343050  validate \
            +quit



# create a volume for modifications of files
VOLUME /opt/dontStarveTogether

# Expose ports
EXPOSE 10999 

# Define default command.
ENTRYPOINT '/opt/dontStarveTogether/bin/dontstarve_dedicated_server_nullrenderer
