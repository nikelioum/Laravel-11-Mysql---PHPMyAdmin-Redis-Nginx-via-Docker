# 🚀 Laravel 11 + MySQL + Redis + RabbitMQ + phpMyAdmin + Prometheus + Grafana (via Docker)

A **modern, production-grade Laravel 11 stack** running fully in Docker — with metrics, queueing, caching, and developer tools included.

---

## 🧩 Features

| Component | Description | URL / Port | Credentials |
|------------|-------------|-------------|--------------|
| **Laravel App** | PHP 8.3 + Composer + Node + Vite | [http://localhost:8000](http://localhost:8000) | — |
| **MySQL** | Database | `localhost:3306` | `user: laravel`, `pass: root` |
| **phpMyAdmin** | Database web UI | [http://localhost:8080](http://localhost:8080) | Login: `laravel` / `root` |
| **Redis** | Cache & session driver | `localhost:6379` | — |
| **RabbitMQ** | Queue system | [http://localhost:15672](http://localhost:15672) | `user: laravel`, `pass: secret` |
| **Queue Worker** | Auto runs `php artisan queue:work` | — | — |
| **Prometheus** | Metrics collection | [http://localhost:9090](http://localhost:9090) | — |
| **Grafana** | Dashboards & analytics | [http://localhost:3000](http://localhost:3000) | `admin` / `admin` |
| **cAdvisor** | Container metrics exporter | [http://localhost:8081](http://localhost:8081) | — |
| **Node Exporter** | Host system metrics | [http://localhost:9100/metrics](http://localhost:9100/metrics) | — |

---

## 🧰 Requirements

- Docker Engine ≥ 24.x  
- Docker Compose plugin  
- Git

---

## ⚙️ Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/nikelioum/Laravel-11-Mysql---PHPMyAdmin-Redis-Nginx-via-Docker.git
   cd Laravel-11-Mysql---PHPMyAdmin-Redis-Nginx-via-Docker

## START ALL SERVICES
    ```bash 
    docker compose up -d --build


