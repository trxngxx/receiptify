FROM node:18-alpine

COPY package*.json ./

RUN npm install

COPY . .

COPY .env.${BUILD_ENV:-dev} ./.env

EXPOSE 3000

CMD [ "npm", "start" ]