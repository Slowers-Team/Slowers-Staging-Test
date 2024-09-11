FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

WORKDIR /opt/app-root
RUN mkdir -m 775 src

WORKDIR /opt/app-root/src
COPY --chmod=775 . .

WORKDIR /opt/app-root/src/frontend
RUN \
    npm ci --omit-dev --ignore-scripts && \
    npm run build && \
    mkdir -m 775 /opt/app-root/src/backend/client && \
    mv dist /opt/app-root/src/backend/client/

WORKDIR /opt/app-root/src/backend

EXPOSE 5001

CMD ["go", "run", "main.go"]
