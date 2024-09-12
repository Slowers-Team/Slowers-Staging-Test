FROM docker.io/library/golang:1.23.0-alpine3.20 AS backend-build

WORKDIR /backend
COPY backend/ ./
RUN go build -o /start-server

FROM registry.access.redhat.com/ubi9/nodejs-18-minimal AS frontend-build

ENV NODE_ENV=production

RUN mkdir -m 775 /frontend

WORKDIR /frontend
COPY frontend/ ./
RUN npm clean-install && npm run build

FROM scratch

WORKDIR /app
COPY --from=backend-build /start-server ./
COPY --from=frontend-build /opt/app-root/src/frontend/dist client/

EXPOSE 5001

CMD ["./start-server"]
