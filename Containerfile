FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

RUN mkdir -m 775 /src

WORKDIR /src
COPY --chmod=775 . .

WORKDIR /src/frontend
RUN \
    npm ci --omit-dev --ignore-scripts && \
    npm run build && \
    mkdir -m 775 /src/backend/client && \
    mv dist /src/backend/client/

WORKDIR /src/backend

EXPOSE 5001

CMD ["go", "run", "main.go"]
