# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian
# instead of Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20240612-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.17.1-erlang-27.0-debian-bullseye-20240612-slim
#   - Ex: hexpm/elixir:1.17.2-erlang-27.0-debian-bullseye-20240701-slim
# 
# hexpm/elixir images built by https://github.com/hexpm/bob#docker-images

ARG ELIXIR_VERSION=1.17.2
ARG OTP_VERSION=27.0
ARG DEBIAN_VERSION=bullseye-20240701-slim
ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"
# import commit-info using build arg then use as default env, used in config/config.exs
ARG GIT_COMMIT_ID=""
ENV GIT_COMMIT_ID=$GIT_COMMIT_ID
ARG GIT_COMMIT_TIME=""
ENV GIT_COMMIT_TIME=$GIT_COMMIT_TIME

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config config/
RUN mix deps.compile

COPY lib lib
# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

###########################################################

FROM ${RUNNER_IMAGE} as runner

# RUN apt-get update -y && \
#   apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates \
#   && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN apt-get update -y && \
  apt-get install -y locales curl iputils-ping dnsutils\
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"
ENV PORT="4000"
EXPOSE ${PORT}

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/hello_api ./

USER nobody

# carry iex helpers to /app
COPY .iex.exs .

# If using an environment that doesn't automatically reap zombie processes, it is
# advised to add an init process such as tini via `apt-get install`
# above and adding an entrypoint. See https://github.com/krallin/tini for details
# ENTRYPOINT ["/tini", "--"]

CMD ["/app/bin/hello_api", "start"]
