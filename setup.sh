#!/bin/bash

set -e

echo "Creating folder structure..."
mkdir -p backend/src/main/java/com/demo/backend/controller
mkdir -p backend/src/main/resources
mkdir -p frontend/public frontend/src
mkdir -p .github/workflows
mkdir -p .devcontainer

echo "Writing backend files..."

cat > backend/src/main/java/com/demo/backend/controller/HelloController.java << 'EOF'
package com.demo.backend.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "http://localhost:3000")
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello from Spring Boot";
    }
}
EOF

cat > backend/src/main/resources/application.properties << 'EOF'
server.port=8080
EOF

cat > backend/README.md << 'EOF'
# Backend (Spring Boot)

Run:
mvn spring-boot:run

Test:
http://localhost:8080/api/hello
EOF

cat > backend/Dockerfile << 'EOF'
FROM maven:3.8.8-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/backend-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

echo "Writing frontend files..."

cat > frontend/package.json << 'EOF'
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build"
  }
}
EOF

cat > frontend/public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>Fullstack Cloud Demo</title>
</head>
<body>
  <div id="root"></div>
</body>
</html>
EOF

cat > frontend/src/index.js << 'EOF'
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

const root = createRoot(document.getElementById('root'));
root.render(<App />);
EOF

cat > frontend/src/App.js << 'EOF'
import React, { useEffect, useState } from "react";

function App() {
  const [message, setMessage] = useState("Loading...");

  useEffect(() => {
    fetch("http://localhost:8080/api/hello")
      .then(res => res.text())
      .then(data => setMessage(data))
      .catch(() => setMessage("Backend not reachable"));
  }, []);

  return <h1>{message}</h1>;
}

export default App;
EOF

cat > frontend/README.md << 'EOF'
# Frontend (React)

Run:
npm install
npm start

Open:
http://localhost:3000
EOF

cat > frontend/Dockerfile << 'EOF'
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine
RUN npm install -g serve
WORKDIR /app
COPY --from=build /app/build ./build
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
EOF

echo "Writing GitHub Actions CI..."

cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main ]

jobs:
  backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'
      - run: mvn -f backend package

  frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      - run: |
          cd frontend
          npm install
          npm run build
EOF

echo "Writing devcontainer config..."

cat > .devcontainer/devcontainer.json << 'EOF'
{
  "name": "Fullstack Cloud Demo",
  "image": "mcr.microsoft.com/devcontainers/java:17",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "18"
    }
  },
  "forwardPorts": [8080, 3000]
}
EOF

echo "Committing to git..."

git add .
git commit -m "Complete backend, frontend, CI and devcontainer setup"
git push origin main

echo "DONE. Repo is now fully set up."







