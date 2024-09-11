FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

WORKDIR /opt/app-root/src
RUN mkdir -m ug+rwx backend
RUN mkdir -m ug+rwx frontend

WORKDIR /opt/app-root/src/backend
RUN mkdir -m ug+rwx client
COPY backend/* ./

WORKDIR /opt/app-root/src/frontend
COPY frontend/package* ./
RUN npm ci --omit-dev --ignore-scripts
COPY frontend/ ./
RUN npm run build
RUN mv dist /opt/app-root/src/backend/client/

WORKDIR /opt/app-root/src/backend

EXPOSE 5001

CMD ["go", "run", "main.go"]
