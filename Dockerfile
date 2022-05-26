FROM node:18-alpine3.14 AS dev

WORKDIR /app
COPY package*.json /app
RUN npm ci
COPY tsconfig.json /app
COPY src /app/src
RUN npm run tsc
RUN npm ci --production

FROM alpine:3.16.0 as base 
RUN apk add nodejs --no-cache
WORKDIR /app
COPY --from=build /app/node_modules .
COPY --from=build /app/dist .
CMD node ./dist/index.js

FROM base as test
RUN npm test