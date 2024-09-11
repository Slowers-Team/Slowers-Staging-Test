FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

WORKDIR /opt/app-root/src
RUN ls -lR ..
RUN mkdir -m ug+rwx backend
RUN ls -lR ..
RUN mkdir -m ug+rwx frontend
RUN ls -lR ..

WORKDIR /opt/app-root/src/backend
RUN ls -lR ..
RUN mkdir client
RUN ls -lR ..
COPY backend/* ./
RUN ls -lR ..

WORKDIR /opt/app-root/src/frontend
RUN ls -lR ..
COPY frontend/package* ./
RUN ls -lR ..
RUN npm ci --omit-dev --ignore-scripts
COPY frontend/* ./
RUN \
    npm run build && \
    mv dist /opt/app-root/src/backend/client/

WORKDIR /opt/app-root/src/backend

EXPOSE 5001

CMD ["go", "run", "main.go"]
