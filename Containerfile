FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

WORKDIR /opt/app-root/src
RUN mkdir -m ug+rwx backend
RUN mkdir -m ug+rwx frontend

WORKDIR /opt/app-root/src/backend
RUN mkdir -m ug+rwx client
COPY --chmod=775 backend/* ./

WORKDIR /opt/app-root/src/frontend
COPY --chmod=775 frontend/package* ./
RUN npm ci --omit-dev --ignore-scripts
COPY --chmod=775 frontend/ ./
RUN npm run build
RUN mv dist /opt/app-root/src/backend/client/

WORKDIR /opt/app-root/src/backend

ENV GOPATH=/opt/app-root/src/backend/go

EXPOSE 5001

CMD ["go", "run", "main.go"]
