################# Variables ################
ARG ELIXIR_VERSION=1.16.2
ARG OTP_VERSION=26.2.3
ARG DEBIAN_VERSION=bullseye-20240130-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

################# BUILDER ################
FROM ${BUILDER_IMAGE} AS builder

ARG CORE_APP=logatron_core
ARG APIS_APP=apis
ARG EDGE_APP=logatron_edge

RUN apt-get update -y && \
    apt-get install -y build-essential git npm esbuild  && \
    apt-get clean && rm -f /var/lib/apt/lists/*_*


# prepare build dir
WORKDIR /build_space

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG MIX_ENV=prod
ENV MIX_ENV=prod

ENV OTPROOT=/usr/lib/erlang
ENV ERL_LIBS=/usr/lib/erlang/lib

# copy umbrella apps
COPY apps/${APIS_APP} apps/${APIS_APP}/
COPY apps/${CORE_APP} apps/${CORE_APP}/
COPY apps/${EDGE_APP} apps/${EDGE_APP}/

COPY config/config.exs config/prod.exs config/runtime.exs  config/
COPY mix.exs mix.lock ./
# install mix dependencies
RUN MIX_ENV="prod" mix do deps.get --only "prod", deps.compile
# build assets
 COPY apps/${EDGE_APP} ./apps/${EDGE_APP}

RUN MIX_ENV="prod" mix compile && \
    MIX_ENV="prod" mix release for_edge


########### RUNTIME ###############
# prepare release image
FROM ${RUNNER_IMAGE} AS for_web

ARG CORE_APP=logatron_core
ARG EDGE_APP=logatron_edge

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates  && \
    apt-get clean && rm -f /var/lib/apt/lists/*_* 

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /system

RUN chown nobody /system

COPY --from=builder --chown=nobody /build_space/_build/prod/rel/for_edge .

USER nobody

ENV HOME=/system
ENV MIX_ENV="prod"
ENV DATABASE_URL=irrelevant
ENV SECRET_KEY_BASE=irrelevant

CMD ["/system/bin/for_edge", "start"]

