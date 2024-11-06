To start the **MariaDB** instance and **phpMyAdmin** using Docker Compose, run the following command in the `/database` subdirectory:

```bash
docker-compose up --build
```

You can access the phpMyAdmin Portal [`127.0.0.1:8080/`](http://127.0.0.1:8080/) in your browser.

The tables are created automatically using the defined database scheme.
