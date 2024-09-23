FROM node:18

WORKDIR /app
COPY . .
RUN npm clean-install && npm run build

EXPOSE 8081

CMD npx http-server dist --port 8081 --proxy $BACKEND_URL?
