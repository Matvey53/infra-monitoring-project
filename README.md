# Infrastructure Monitoring Project

Учебный DevOps-проект для проверки доступности HTTP API, анализа логов и запуска сервисов в Docker.

**Технологии:** Bash, Docker Compose, Nginx, GitHub Actions, SSH/SCP.

## Запуск проекта

Клонировать репозиторий:

```bash
git clone https://github.com/Matvey53/infra-monitoring-project.git
cd infra-monitoring-project
```

Запустить контейнеры:

```bash
docker compose up -d
docker compose ps
curl http://localhost:80
```

Ожидаемый ответ: `Monitoring Service Active`.

Проверить API и проанализировать логи:

```bash
chmod +x check_api.sh analyze_logs.sh
./check_api.sh https://httpbin.org/status/200
./analyze_logs.sh
```

Остановить контейнеры:

```bash
docker compose down
```

## Безопасная передача файлов и развёртывание проекта

Для передачи проекта на удалённый Linux-сервер используются SSH и SCP. SSH обеспечивает защищённое соединение, а SCP позволяет передавать файлы по зашифрованному каналу.

### 1. Генерация SSH-ключей

На локальном компьютере создаётся пара SSH-ключей:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/infra_monitoring
```

Приватный ключ остаётся на локальном компьютере, публичный используется для авторизации на сервере.

### 2. Копирование публичного ключа

```bash
ssh-copy-id -i ~/.ssh/infra_monitoring.pub user@SERVER_IP
```

После добавления публичного ключа можно подключаться к серверу:

```bash
ssh -i ~/.ssh/infra_monitoring user@SERVER_IP
```

### 3. Передача проекта через SCP

На локальном компьютере создаётся архив проекта:

```bash
tar --exclude=.git --exclude='*.log' \
  --exclude=project.tar.gz -czf project.tar.gz .
```

Архив передаётся на удалённый сервер:

```bash
scp -i ~/.ssh/infra_monitoring \
  project.tar.gz user@SERVER_IP:/tmp/
```

### 4. Пример развёртывания проекта

Подключение к серверу:

```bash
ssh -i ~/.ssh/infra_monitoring user@SERVER_IP
```

Распаковка проекта и запуск контейнеров:

```bash
mkdir -p ~/infra-monitoring-project
tar -xzf /tmp/project.tar.gz -C ~/infra-monitoring-project
cd ~/infra-monitoring-project

docker compose up -d
docker compose ps
curl http://localhost:80
```

При успешном запуске API возвращает:

```text
Monitoring Service Active
```

**Примечание:** `user` и `SERVER_IP` заменяются реальными данными сервера. Для запуска необходимы установленные Docker и Docker Compose. Приватный SSH-ключ не должен передаваться на сервер или публиковаться в GitHub.

## CI/CD

GitHub Actions автоматически проверяет Bash-скрипты при создании Pull Request в `main`.# infra-monitoring-project
