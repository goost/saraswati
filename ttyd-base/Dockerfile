FROM ubuntu
# TODO (glost) Latest compose tag
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -q \
  && apt install -yy -qq apt-transport-https ca-certificates curl  gnupg-agent software-properties-common \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs)  stable" \
  && apt update -q && apt install -yy -qq docker-ce-cli \
  && curl -L --silent "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose \
  && chmod +x /usr/bin/docker-compose

RUN latest_ttyd=$(curl -L --silent "https://api.github.com/repos/tsl0922/ttyd/releases/latest" | grep -E 'browser_download_url":\s".*?ttyd_linux.x86_64' | cut -f 2,3 -d ':' | cut -f 2 -d '"') \
  && curl -Ls -o /usr/bin/ttyd $latest_ttyd \
  && chmod +x /usr/bin/ttyd

ENTRYPOINT [ "/usr/bin/ttyd", "-p", "4242" ]