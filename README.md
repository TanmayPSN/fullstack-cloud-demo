# Fullstack Cloud Demo

This repository contains a minimal full-stack example:

- backend (Spring Boot / Java / Maven)
- frontend (React / create-react-app)

Purpose: Demonstrate a simple REST API (Spring Boot) and a React UI that calls it.

Project structure
- backend/          -> Spring Boot application (runs on port 8080)
  - src/main/java/com/demo/backend/BackendApplication.java
  - src/main/java/com/demo/backend/controller/HelloController.java
  - src/main/resources/application.properties
  - pom.xml
  - README.md
  - Dockerfile (optional)
- frontend/         -> React app (created via create-react-app)
  - public/index.html
  - src/index.js
  - src/App.js
  - package.json
  - README.md
  - Dockerfile (optional)
- docker-compose.yml -> optional convenience for running both with Docker
- .gitignore

How to run the backend (local, no Docker)
1. Install Java 17 and Maven.
2. From the `backend/` directory:
   - Install dependencies and run: `mvn spring-boot:run`
   - Or build JAR: `mvn package` then `java -jar target/backend-0.0.1-SNAPSHOT.jar`
3. Backend will listen on http://localhost:8080

How to run the frontend (local, no Docker)
1. Install Node.js (v16+ recommended) and npm.
2. From the `frontend/` directory:
   - Install dependencies: `npm install`
   - Start dev server: `npm start`
3. Frontend will open at http://localhost:3000 and will call the backend API at http://localhost:8080/api/hello

How the API works
- GET http://localhost:8080/api/hello
  - Response body: plain text "Hello from Spring Boot"
  - The Spring Boot backend enables CORS for http://localhost:3000 so the browser app can call it.

Optional: Docker
- A Dockerfile for each service and a docker-compose.yml are included for convenience. Use:
  - `docker-compose up --build`
  - This builds and starts both backend (8080) and frontend (3000).

Notes
- Keep both backend and frontend running for the app to work.
- CORS is enabled on the backend for http://localhost:3000.