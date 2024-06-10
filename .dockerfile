FROM elixir:1.12.2 AS builder

ENV TZ=Asia/Almaty \ 
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install curl npm locales -y

ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8    
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

RUN locale


##### COPY source

# Build deps of npm for pulsar
WORKDIR /app

# Build deps of pulsar
COPY mix.exs mix.exs
COPY config/config.exs config/config.exs
COPY config/prod.exs config/prod.exs
RUN mix deps.clean --all
RUN mix deps.get
RUN mix deps.compile

# Get and install JS deps with static files
COPY assets/package.json assets/package.json
RUN npm install --prefix ./assets --no-audit --loglevel=error
COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY proto /proto

# Build blazar
COPY rel rel
COPY config/runtime.exs config/runtime.exs
COPY lib lib
RUN mix do compile, release

##########################

FROM elixir:1.12.2

ENV TZ=Asia/Almaty \ 
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install openssl ca-certificates libltdl7 libpcsclite1 telnet postgresql-client iputils-ping psutils curl lsof procps wkhtmltopdf locales -y

ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8    
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV HOME=/app
ENV MIX_ENV=prod

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/pulsar .
COPY crypto.so crypto.so
COPY proto /proto
RUN mkdir data
RUN mkdir files
RUN mkdir docs

ADD entrypoint.sh entrypoint.sh

# blazar port
EXPOSE 4000

CMD ["entrypoint.sh"]
ENTRYPOINT ["sh"]