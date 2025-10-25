# 🚀 Laravel 12 + MySQL + Redis + RabbitMQ + Mailhog + phpMyAdmin + Prometheus + Grafana (via Docker)

A modern, production-grade Laravel 12 stack running fully in Docker — with metrics, queueing, caching, mail testing, and developer tools.

---

## 🧩 Features

| Component | Description | URL / Port | Credentials |
|------------|-------------|-------------|--------------|
| **Laravel App** | PHP 8.3 + Composer + Node + Vite | http://localhost:8000 | — |
| **MySQL** | Database | localhost:3306 | user: laravel / pass: root |
| **phpMyAdmin** | DB web UI | http://localhost:8080 | laravel / root |
| **Redis** | Cache / Session driver | localhost:6379 | — |
| **RabbitMQ** | Queue system | http://localhost:15672 | user: laravel / pass: secret |
| **Queue Worker** | Auto runs `php artisan queue:work` | — | — |
| **Mailhog** | Mail catcher for local email testing | http://localhost:8025 | SMTP → host: mailhog / port: 1025 |
| **Prometheus** | Metrics collection | http://localhost:9090 | — |
| **Grafana** | Dashboards & analytics | http://localhost:3000 | admin / admin |
| **cAdvisor** | Container metrics exporter | http://localhost:8081 | — |
| **Node Exporter** | Host system metrics | http://localhost:9100/metrics | — |
| **Rust Memory Monitor Service** | Memories resources for each container | Dashboard running at http://0.0.0.0:7071 | 
---

## 🧰 Requirements
- Docker Engine ≥ 24.x  
- Docker Compose plugin  
- Git

---

## ⚙️ Installation

```bash
git clone https://github.com/nikelioum/Laravel-12-Mysql---PHPMyAdmin-Redis-Nginx-via-Docker.git
cd Laravel-12-Mysql---PHPMyAdmin-Redis-Nginx-via-Docker
docker compose up -d --build
