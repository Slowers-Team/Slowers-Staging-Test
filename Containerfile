FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

WORKDIR /opt/app-root/src
RUN mkdir -m 775 app

WORKDIR /opt/app-root/src/app
COPY --chmod=775 . .

WORKDIR /opt/app-root/src/app/frontend
RUN \
    npm ci --omit-dev --ignore-scripts && \
    npm run build && \
    mkdir -m 775 /opt/app-root/src/app/backend/client && \
    mv dist /opt/app-root/src/app/backend/client/

WORKDIR /opt/app-root/src/app/backend

EXPOSE 5001

CMD ["go", "run", "main.go"]
