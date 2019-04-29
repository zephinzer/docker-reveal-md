FROM node:10.15.3-alpine AS base
RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add --no-cache make
RUN npm install --global npx
WORKDIR /app
COPY ./package.json /app/package.json
RUN npm install
ENTRYPOINT [ "make" ]

FROM base AS development
RUN apk add --no-cache git python g++
WORKDIR /reveal
RUN git clone https://github.com/hakimel/reveal.js.git .
RUN npm install
WORKDIR /app
COPY ./Makefile /app/Makefile
ENTRYPOINT [ "make" ]

FROM base AS production
WORKDIR /app
COPY ./Makefile /app/Makefile
ENTRYPOINT [ "make", "start" ]