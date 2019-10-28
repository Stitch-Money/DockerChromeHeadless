FROM ubuntu:18.04

# Dependencies
RUN apt-get -qq update && \
    echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections && \
    apt-get -y -qq install software-properties-common &&\
    apt-add-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner" && \
    apt-add-repository ppa:malteworld/ppa && apt-get -qq update && apt-get -y -qq install \
    dumb-init \
    adobe-flashplugin \
    msttcorefonts \
    ffmpeg \
    fonts-noto-color-emoji \
    fonts-noto-cjk \
    fonts-liberation \
    fonts-thai-tlwg \
    fonts-indic \
    fontconfig \
    libappindicator3-1 \
    pdftk \
    unzip \
    locales \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    xvfb \
    curl &&\
    apt-get -y -qq install build-essential &&\
    fc-cache -f -v

ENV CONNECTION_TIMEOUT=60000
ENV CHROME_PATH=/usr/bin/google-chrome
ENV ENABLE_XVBF=true
ENV HOST=0.0.0.0
ENV IS_DOCKER=true



# Install Chrome Stable when specified
RUN cd /tmp &&\
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&\
    dpkg -i google-chrome-stable_current_amd64.deb;

RUN groupadd -r chromeuser && useradd -r -g chromeuser -G audio,video chromeuser \
    && mkdir -p /home/chromeuser/Downloads \
    && chown -R chromeuser:chromeuser /home/chromeuser

RUN apt-get -qq clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER chromeuser
WORKDIR /home/chromeuser/


ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["google-chrome", "--headless", "--disable-gpu", "--no-sandbox", "--remote-debugging-port=9222"]
