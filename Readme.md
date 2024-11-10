# SkillForge WebApp

## Run application

To start the **SkillForge** webapplication using Docker Compose, run the following command in the terminal with Docker installed on the system:

```bash
docker-compose up --build
```

## Database

You can access the **phpMyAdmin** Portal [`127.0.0.1:8080/`](http://127.0.0.1:8080/) in your browser.
The tables are created automatically using the defined database scheme.

## Backend REST-API

The backend service provided by Flask is available at [`127.0.0.1:5000/`](http://127.0.0.1:5000/)
