# DECISION.md

This file explains the core design choices for the Nginx Blue/Green implementation.

## 1. Templating: `envsubst` + Entrypoint Script

* **Problem:** The Nginx config needed to be dynamic based on the `ACTIVE_POOL` environment variable to determine which upstream server was `primary` and which one was `backup`.
* **Solution:** I used the standard `nginx` Docker image's entrypoint system.
    1.  A custom script `20-template.sh` is mounted into `/docker-entrypoint.d/`.
    2.  This script runs *before* Nginx starts.
    3.  It contains simple `if/else` logic to `export` two new variables, `BLUE_ROLE` and `GREEN_ROLE`, setting one to `backup` and the other to `""` based on `ACTIVE_POOL`.
    4.  It then uses `envsubst` to substitute these variables (and `$APP_PORT`) into the `nginx.conf.template` and write the final `default.conf`.
* **Why:** This approach is simple, doesn't require installing extra tools (like `sed` or `awk`), and keeps the logic clean. It directly supports the manual `ACTIVE_POOL` toggle requirement. Reloading the config is as simple as re-running `docker compose up -d nginx`, which re-triggers the entrypoint.

## 2. Failover: `proxy_next_upstream` vs. `max_fails`

The task required two types of failover:

1.  **In-Flight Retry:** "If Blue fails... Nginx retries to Green within the *same client request*."
2.  **Automatic Failover:** "On Blue's failure: Nginx automatically switches to Green."

These are handled by two different directives:

* **`proxy_next_upstream`**: This directive handles **Requirement 1**. It tells Nginx: "If *this specific request* fails with `error`, `timeout`, or `http_5xx`, *do not* send the error to the client. Instead, try the next server in the `upstream` block." This is what provides the zero-downtime experience for the user *during* the initial failure.
* **`max_fails` / `fail_timeout`**: This directive on the `server` line handles **Requirement 2**. It tells Nginx: "If a server fails `max_fails` times within `fail_timeout` seconds, mark it as 'down' and *do not send any new traffic* to it for the `fail_timeout` duration." This ensures that after the initial failure is detected, all subsequent traffic goes *directly* to the healthy Green instance without even attempting Blue.
