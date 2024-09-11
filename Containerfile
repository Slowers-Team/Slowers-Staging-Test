FROM registry.access.redhat.com/ubi9/go-toolset

ENV TZ="Europe/Helsinki"

WORKDIR /opt/app-root/src/backend
RUN mkdir client
RUN ls -lR ..
COPY backend/* ./
RUN ls -lR ..

WORKDIR /opt/app-root/src/frontend
COPY frontend/package* ./
RUN ls -lR ..
RUN chmod -R g+w .
RUN ls -lR ..
RUN npm ci --omit-dev --ignore-scripts
COPY frontend/* ./
RUN \
    npm run build && \
    mv dist /opt/app-root/src/backend/client/

WORKDIR /opt/app-root/src/backend

EXPOSE 5001

CMD ["go", "run", "main.go"]
