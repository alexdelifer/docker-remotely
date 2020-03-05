FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

# environment settings
ENV HOME="/config"

RUN \
 apt-get update && \
 #add-apt-repository universe && \
 apt-get install -y \
  apt-utils \
  wget \
  apt-transport-https \
  unzip \
  acl \
  ffmpeg \
  libc6-dev \
  libgdiplus \
  libicu60 \
  libssl1.0 && \
  #aspnetcore-runtime-2.2 && \
 mkdir -p /var/www/remotely && \
 wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && \
 dpkg -i packages-microsoft-prod.deb && \
 apt-get update && \
 apt-get install -y aspnetcore-runtime-2.2=2.2.0-1 && \
 wget -q https://github.com/Jay-Rad/Remotely/releases/download/v2020.02.14/Remotely_Server_Linux-x64.zip && \
 unzip -o Remotely_Server_Linux-x64.zip -d /var/www/remotely && \
 rm Remotely_Server_Linux-x64.zip && \
 setfacl -R -m u:www-data:rwx /var/www/remotely && \
 chown -R www-data:www-data /var/www/remotely


# add local files
#COPY /root /

# ports and volumes
EXPOSE 5000

WORKDIR /var/www/remotely
CMD ["/usr/bin/dotnet", "Remotely_Server.dll"]
