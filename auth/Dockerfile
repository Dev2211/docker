FROM node:latest

RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/auth

WORKDIR /usr/src/app/auth

COPY ./auth/. /usr/src/app/auth


RUN mkdir -p /usr/src/app/common-dto

WORKDIR /usr/src/app/common-dto

COPY common-dto/. /usr/src/app/common-dto/.

RUN npm install 
RUN npm install -g @nestjs/cli
RUN npm run build

WORKDIR /usr/src/app/auth

RUN npm install --save --legacy-peer-deps
COPY ./auth/. /usr/src/app/auth

ENV NODE_ENV=development

CMD ["npm","run","start"]
