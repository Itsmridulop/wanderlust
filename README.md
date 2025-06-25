# 🚀 Full Stack Docker Setup: Redis + MongoDB + Backend + Frontend

This guide walks you through running a full stack application using **Docker containers**, with the following services:

- 🛠️ Backend (Node.js/Express)
- 🧠 MongoDB (Database)
- ⚡ Redis (Cache)
- 🌐 Frontend (Vite or any modern frontend)

All containers communicate over a shared custom Docker network — no Docker Compose is used.

---

## 🧱 Prerequisites

Make sure Docker is installed and running on your machine.

---
All containers need to be on the same network to talk to each other.

## 🔗 Step 1: Create Docker Network


```bash
docker network create <NETWORK_NAME>
```

## 🔗 Step 2: Run Redis Container

```bash
docker run -d --name <REDIS_CONTAINER_NAME> --network <NETWORK_NAME>  -p 6379:6379 redis:7.0.5-alpine
```
## 🔗 Step 3: Run MongoDB Container

```bash
docker run -d --name <MONGO_CONTAINER_NAME> --network <NETWORK_NAME>  -p 27017:27017 mongo:latest
```

## 🔗 Step 4: Build and Run Backend

```bash
docker build -t <BACKEND_IMAGE_NAME>:<TAG> .
```

```bash
docker run -d --name <BACKEND_CONTAINER_NAME> --network <NETWORK_NAME> -p 8080:8080 -e MONGODB_URI=mongodb://<MONGO_CONTAINER_NAME>:27017/<DATABASE_NAME> --env-file {BACKEND_ENV_FILE_PATH} -e REDIS_URL=redis://<REDIS_CONTAINER_NAME>:6379 <BACKEND_IMAGE_NAME>:<TAG>
```

## 🔗 Step 4: Build and Run Frontend

```bash
docker build -t <FRONTEND_IMAGE_NAME>:<TAG> .
```

```bash
docker run -d --name <FRONTEND_CONTAINER_NAME> --network <NETWORK_NAME> -p 5173:5173 --env-file {FRONTEND_ENV_FILE_PATH} -e VITE_API_PATH=http://localhost:8080 <FRONTEND_IMAGE_NAME>:<TAG>
```
