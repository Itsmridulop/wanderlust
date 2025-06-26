# 🚀 Full Stack Docker Setup: Redis + MongoDB + Backend + Frontend

---

This guide walks you through running a full stack application using **Docker containers**, with the following services:


All containers need to be on the same network to talk to each other.

## 🔗 Step 1: Install Docker


```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
```

## 🔗 Step 2: Check Docker is Successfully Installed


```bash
docker --version
```

## 🔗 Step 2: Create Docker Network


```bash
docker network create <NETWORK_NAME>
```

## 🔗 Step 3: Run Redis Container

```bash
docker run -d --name <REDIS_CONTAINER_NAME> --network <NETWORK_NAME>  -p 6379:6379 redis:7.0.5-alpine
```
## 🔗 Step 4: Run MongoDB Container

```bash
docker run -d --name <MONGO_CONTAINER_NAME> --network <NETWORK_NAME>  -p 27017:27017 mongo:latest
```

## 🔗 Step 5: Build and Run Backend

```bash
docker build -t <BACKEND_IMAGE_NAME>:<TAG> .
```

```bash
docker run -d --name <BACKEND_CONTAINER_NAME> --network <NETWORK_NAME> -p 8080:8080 --env-file {BACKEND_ENV_FILE_PATH} -e MONGODB_URI=mongodb://<MONGO_CONTAINER_NAME>:27017/<DATABASE_NAME> -e REDIS_URL=redis://<REDIS_CONTAINER_NAME>:6379 <BACKEND_IMAGE_NAME>:<TAG>
```

## 🔗 Step 6: Build and Run Frontend

```bash
docker build -t <FRONTEND_IMAGE_NAME>:<TAG> .
```

```bash
docker run -d --name <FRONTEND_CONTAINER_NAME> --network <NETWORK_NAME> -p 5173:5173 --env-file {FRONTEND_ENV_FILE_PATH} -e VITE_API_PATH=http://localhost:8080 <FRONTEND_IMAGE_NAME>:<TAG>
```

---

This guide walks you through running a full stack application using **Docker compose**, with the following services:

## 🔗 Step 1: Install Docker Compose

```bash
sudo apt install docker-compose-plugin -y
```

## 🔗 Step 2: Check Docker Compose is Success

```bash
docker compose version
```

## 🔗 Step 3: Run the Application

```bash
docker-compose up -d
```

---

This guide walks you through running a full stack application using **Kubernetes**, with the following services:

## 🔗 Step 1: Install Kubernetes

```text
Run install.sh If kubernetes is not installed
```

## 🔗 Step 2: Create Cluster

```bash
kind create cluster --name <CLUSTER_NAME> --config <CONFIG_FILE_PATH>
```

## 🔗 Step 3: Create namespace

```bash
kubectl apply -f kubernetes/namespace.yml
```

## 🔗 Step 4: Create configMap

```bash
kubectl apply -f kubernetes/configMap.yml
```

## 🔗 Step 5: Create secret

```bash
kubectl apply -f kubernetes/secret.yml
```
## 🔗 Step 6: Create PersistentVolume

```bash
kubectl apply -f kubernetes/mongo-pv.yml
```

## 🔗 Step 7: Create PersistentVolumeClaim

```bash
kubectl apply -f kubernetes/mongo-pvc.yml
```

## 🔗 Step 8: Create Mongo Service

```bash
kubectl apply -f kubernetes/mongo.yml
```

## 🔗 Step 9: Create Redis Service

```bash
kubectl apply -f kubernetes/redis.yml
```

## 🔗 Step 10: Create Backend Service

```bash
kubectl apply -f kubernetes/backend.yml
```

## 🔗 Step 11: Create Frontend Service

```bash
kubectl apply -f kubernetes/frontend.yml
```
