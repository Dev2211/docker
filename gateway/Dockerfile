FROM node:latest

RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/gateway

WORKDIR /usr/src/app/gateway

COPY ./gateway/. /usr/src/app/gateway


RUN mkdir -p /usr/src/app/common-dto

WORKDIR /usr/src/app/common-dto

COPY common-dto/. /usr/src/app/common-dto/.

RUN npm install 
RUN npm install -g @nestjs/cli
RUN npm run build

WORKDIR /usr/src/app/gateway

RUN npm install --save --legacy-peer-deps
COPY ./gateway/. /usr/src/app/gateway

RUN npm install shelljs -g
RUN npm run build

ENV NODE_ENV=development

CMD ["npm","run","start"]

