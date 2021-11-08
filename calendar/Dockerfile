FROM node:latest

RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/calendar

WORKDIR /usr/src/app/calendar

COPY ./calendar/. /usr/src/app/calendar


RUN mkdir -p /usr/src/app/common-dto

WORKDIR /usr/src/app/common-dto

COPY common-dto/. /usr/src/app/common-dto/.

RUN npm install 
RUN npm install -g @nestjs/cli
RUN npm run build

WORKDIR /usr/src/app/calendar

RUN npm install --save --legacy-peer-deps
COPY ./calendar/. /usr/src/app/calendar

ENV NODE_ENV=development

CMD ["npm","run","start"]
