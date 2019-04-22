# syntax = docker/dockerfile:1.0-experimental

# step1 ng build stage
FROM node:lts-alpine as builder

ENV NODE_ENV=production

WORKDIR /app

COPY package*.json ./

RUN --mount=type=cache,target=/root/node_modules \
  npm install

COPY . .

RUN npm run build

# step2 production build stage
FROM nginx:stable-alpine as production-stage

EXPOSE 80

COPY --from=builder /app/dist/angular-app /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
