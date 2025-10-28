# DevOps Stage 2: Nginx Blue/Green Failover

This project demonstrates an automatic and manual Blue/Green deployment strategy using Nginx and Docker Compose.

## Setup

1.  **Environment:** Copy the example `.env` file.
    ```sh
    cp .env.example .env
    ```
2.  **Permissions:** Make the Nginx entrypoint script executable.
    ```sh
    chmod +x nginx-entrypoint.sh
    ```
3.  **Customize (Optional):** Edit the `.env` file to change the `ACTIVE_POOL` (to `blue` or `green`) or update release IDs.

## :rocket: How to Run

1.  **Start Services:**
    ```sh
    docker compose up -d
    ```
2.  **Check Logs (Optional):**
    ```sh
    docker compose logs -f nginx
    ```
    You should see `NGINX: Active pool is BLUE. Green is backup.` (or vice-versa).

## :white_tick: How to Test

### 1. Baseline (Blue Active)

Check that traffic is hitting the `blue` pool.

```sh
# Run this several times
curl -i http://localhost:8080/version
```
**Expected Output:**
```
HTTP/1.1 200 OK
...
X-App-Pool: blue
X-Release-Id: blue-v1.0.1
...
```

### 2. Induce Downtime on Blue

Trigger the `/chaos` endpoint on `blue`'s **direct port** (8081).

```sh
# Tell blue to start sending 500 errors
curl -X POST http://localhost:8081/chaos/start?mode=error
```

### 3. Verify Automatic Failover (Zero Downtime)

Immediately request the *main Nginx port* (8080). Nginx should retry the failed request on `green` so you still get a `200 OK`.

```sh
# Run this immediately after the chaos command
curl -i http://localhost:8080/version
```
**Expected Output:**
You should get a `200 OK` and the headers should now show `green`.
```
HTTP/1.1 200 OK
...
X-App-Pool: green
X-Release-Id: green-v1.0.1
...
```
Subsequent requests will also go to `green` (because `blue` is marked `down` by `max_fails`).

### 4. Stop Chaos

```sh
curl -X POST http://localhost:8081/chaos/stop
```
After 10 seconds (`fail_timeout`), Nginx will probe `blue` again, find it's healthy, and automatically switch traffic back.

### 5. Test Manual Switch (Toggle)

1.  Stop the chaos: `curl -X POST http://localhost:8081/chaos/stop`
2.  Edit your `.env` file and set `ACTIVE_POOL=green`.
3.  Re-template and reload Nginx:
    ```sh
    # This rebuilds just the nginx container, running the entrypoint again
    docker compose up -d --no-deps nginx
    ```
4.  Check traffic:
    ```sh
    curl -i http://localhost:8080/version
    ```
    **Expected Output:** Traffic should now be *primarily* served by `green`.
