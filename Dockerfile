FROM mono:slim

# Update and install needed utils
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl nuget vim zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# fix for favorites.json error
RUN favorites_path="/root/My Games/Terraria" && mkdir -p "$favorites_path" && echo "{}" > "$favorites_path/favorites.json"

# Download and install Vanilla Server
ENV TERRARIA_VERSION=1432

RUN mkdir /tmp/terraria && \
    cd /tmp/terraria && \
    curl -sL https://www.terraria.org/api/download/pc-dedicated-server/terraria-server-$TERRARIA_VERSION.zip --output terraria-server.zip && \
    unzip -q terraria-server.zip && \
    mv */Linux /terraria && \
    mv */Windows/serverconfig.txt /terraria/serverconfig-default.txt && \
    rm -R /tmp/* && \
    chmod +x /terraria/TerrariaServer* && \
    if [ ! -f /terraria/TerrariaServer ]; then echo "Missing /terraria/TerrariaServer"; exit 1; fi

# Download and install tModLoader
ENV TMOD_VERSION=0.11.8.5

RUN mkdir /tmp/tmod && \
    cd /tmp/tmod &&\
    curl -sL https://github.com/tModLoader/tModLoader/releases/download/v$TMOD_VERSION/tModLoader.Linux.v$TMOD_VERSION.zip --output tmodloader.zip && \
    unzip -q tmodloader.zip && \
    rm -R ./tmodloader.zip && \
    cp -r ./* /terraria && \
    rm -Rf /tmp/* && \
    chmod u+x /terraria/tModLoaderServer* && \
    if [ ! -f /terraria/tModLoaderServer ]; then echo "Missing /terraria/tModLoaderServer"; exit 1; fi

COPY run-tmodloader.sh /terraria/run.sh

# Allow for external data
VOLUME ["/config", "/ModLoader"]

# Run the server
WORKDIR /terraria
ENTRYPOINT ["./run.sh"]