use bollard::{container::ListContainersOptions, Docker};
use futures_util::{SinkExt, StreamExt};
use serde::Serialize;
use std::{fs, time::Duration};
use tokio::time::interval;
use warp::{ws::{Message, WebSocket}, Filter, Rejection, Reply};

#[derive(Serialize)]
struct ContainerStats {
    id: String,
    name: String,
    memory_usage_mb: f64,
    memory_limit_mb: f64,
    memory_percent: f64,
}

#[tokio::main]
async fn main() {
    let docker = Docker::connect_with_local_defaults().unwrap();

    // Serve the dashboard at "/"
    let dashboard_route = warp::path::end().map(|| {
        warp::reply::html(
            fs::read_to_string("/app/dashboard.html")
                .unwrap_or_else(|_| "<h1>dashboard.html missing</h1>".to_string()),
        )
    });

    // WebSocket route
    let docker_filter = warp::any().map(move || docker.clone());
    let ws_route = warp::path("ws")
        .and(warp::ws())
        .and(docker_filter)
        .map(|ws: warp::ws::Ws, docker| ws.on_upgrade(move |socket| handle_ws(socket, docker)));

    // Combine
    let routes = dashboard_route.or(ws_route);

    println!("🚀 Dashboard running at http://0.0.0.0:7071");
    println!("📡 WebSocket live at ws://0.0.0.0:7071/ws");
    warp::serve(routes).run(([0, 0, 0, 0], 7071)).await;
}

async fn handle_ws(ws: WebSocket, docker: Docker) {
    let (mut tx, mut _rx) = ws.split();
    let mut ticker = interval(Duration::from_secs(2));

    loop {
        ticker.tick().await;

        let containers = docker
            .list_containers(Some(ListContainersOptions::<String> {
                all: true,
                ..Default::default()
            }))
            .await
            .unwrap_or_default();

        let mut stats = Vec::new();

        for container in containers {
            let id = container.id.clone().unwrap_or_default();
            let name = container
                .names
                .clone()
                .unwrap_or_default()
                .get(0)
                .cloned()
                .unwrap_or_default();

            let mut stream = docker.stats(&id, None);
            if let Some(Ok(data)) = stream.next().await {
                let usage = data.memory_stats.usage.unwrap_or(0) as f64 / 1024.0 / 1024.0;
                let limit = data.memory_stats.limit.unwrap_or(1) as f64 / 1024.0 / 1024.0;
                let percent = (usage / limit) * 100.0;

                stats.push(ContainerStats {
                    id,
                    name,
                    memory_usage_mb: usage,
                    memory_limit_mb: limit,
                    memory_percent: percent,
                });
            }
        }

        let json = serde_json::to_string(&stats).unwrap_or_default();
        if tx.send(Message::text(json)).await.is_err() {
            break;
        }
    }
}
