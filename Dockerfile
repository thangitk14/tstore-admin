FROM node:22 as builder

WORKDIR /app/admin

ENV NODE_OPTIONS=--openssl-legacy-provider

COPY . .

RUN rm -rf node_modules

RUN apt-get update

RUN yarn install

RUN yarn global add gatsby-cli

RUN yarn add sharp

RUN gatsby build

FROM nginx

EXPOSE 80 

COPY --from=builder /app/admin/public /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]

## Build: 
##    docker build . -t <name>
##    docker build . -t tstore-admin
## Run: 
##    docker run --name <name container> -p <port local>:<port host>/tcp -d <name image>
##    docker run --name tstore-admin_container -p 80:7000/tcp -d tstore-admin