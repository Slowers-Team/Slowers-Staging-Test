FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

ENV GOPATH=/opt/app-root/src/backend/go

WORKDIR /opt/app-root/src
RUN mkdir -m 775 .cache
COPY --chmod=775 . .

WORKDIR /opt/app-root/src/frontend
RUN \
    npm ci --omit-dev --ignore-scripts && \
    npm run build && \
    mkdir -m 775 /opt/app-root/src/backend/client && \
    mv dist /opt/app-root/src/backend/client/

WORKDIR /opt/app-root/src/backend
RUN echo MONGODB_URI=mongodb://root:root@slowers-mongodb > .env

EXPOSE 5001

CMD ["go", "run", "main.go"]
