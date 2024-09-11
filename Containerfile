FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

WORKDIR /opt/app-root/src

ARG BASE_PATH
ENV BASE_PATH=$BASE_PATH

ARG STAGING
ENV STAGING=$STAGING

ARG E2E
ENV E2E=$E2E

WORKDIR /opt/app-root/src/backend
COPY backend/* ./
RUN ls -lR .. && mkdir client

WORKDIR /opt/app-root/src/frontend
COPY frontend/package* ./
RUN npm ci --omit-dev --ignore-scripts
COPY frontend/* ./
RUN \
    npm run build && \
    mv dist /opt/app-root/src/backend/client/

WORKDIR /opt/app-root/src/backend

EXPOSE 5001

CMD ["go", "run", "main.go"]
