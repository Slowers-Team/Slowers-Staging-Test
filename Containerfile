FROM docker.io/library/golang:alpine AS backend

WORKDIR /src

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/*.go ./

RUN \
    CGO_ENABLED=0 GOOS=linux go build -o /start-server && \
    echo MONGODB_URI=mongodb://root:root@slowers-mongodb > /.env

FROM registry.access.redhat.com/ubi9/nodejs-18-minimal AS frontend

WORKDIR /opt/app-root/src
RUN mkdir -m 775 frontend

WORKDIR /opt/app-root/src/frontend
COPY --chmod=775 frontend/ ./
RUN \
    npm ci --omit-dev --ignore-scripts && \
    npm run build

FROM docker.io/library/busybox

ENV TZ="Europe/Helsinki"

WORKDIR /app
COPY --from=backend /start-server /.env /app/
COPY --from=frontend /opt/app-root/src/frontend/dist/ /app/client/dist/
RUN ls -lR
RUN echo $MONGODB_URI
RUN cat .env

EXPOSE 5001

CMD ["./start-server"]
