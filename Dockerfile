FROM ubuntu:focal

# ports and volumes
EXPOSE 5000

ARG DEBIAN_FRONTEND=noninteractive

# environment settings
ENV HOME="/config"
ENV ASPNETCORE_ENVIRONMENT="Production"
ENV ASPNETCORE_URLS="http://*:5000"

# Base Deps
RUN \
 apt-get update && \
 apt-get install -y \
  apt-utils \
  wget \
  apt-transport-https \
  unzip \
  acl \
  ffmpeg \
  libc6-dev \
  libgdiplus \
  libssl1.0 \
  libx11-dev \
  libxtst-dev \
  xclip \
  jq \
  curl

# Dotnet 3.1
RUN \
  wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  apt-get update && \
  apt-get install -y aspnetcore-runtime-5.0

# Remotely
RUN \
  mkdir -p /var/www/remotely && \
  mkdir /config && \
  VERSION=$(curl -s https://api.github.com/repos/lucent-sea/Remotely/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
  wget -q https://github.com/lucent-sea/Remotely/releases/download/$VERSION/Remotely_Server_Linux-x64.zip && \
  unzip -o Remotely_Server_Linux-x64.zip -d /var/www/remotely && \
  rm Remotely_Server_Linux-x64.zip && \
  setfacl -R -m u:www-data:rwx /var/www/remotely && \
  chown -R www-data:www-data /var/www/remotely

COPY docker-entrypoint.sh /

WORKDIR /var/www/remotely
ENTRYPOINT ["/docker-entrypoint.sh"]
