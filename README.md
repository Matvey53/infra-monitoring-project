# Infrastructure Monitoring Project

Учебный DevOps-проект для проверки доступности HTTP API, анализа логов и запуска сервисов в Docker.

**Технологии:** Bash, Docker Compose, Nginx, GitHub Actions, SSH/SCP.

## Запуск проекта

Клонировать репозиторий:

```bash
git clone <URL_РЕПОЗИТОРИЯ>
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

## SSH и SCP

**SSH** — защищённое подключение к удалённому серверу. **SCP** — передача файлов через SSH.

Создание SSH-ключа:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/infra_monitoring
```

Копирование публичного ключа на сервер:

```bash
ssh-copy-id -i ~/.ssh/infra_monitoring.pub user@SERVER_IP
```

Подключение к серверу:

```bash
ssh -i ~/.ssh/infra_monitoring user@SERVER_IP
```

Создание архива проекта:

```bash
tar --exclude=.git --exclude='*.log' -czf project.tar.gz .
```

Передача архива через SCP:

```bash
scp -i ~/.ssh/infra_monitoring project.tar.gz user@SERVER_IP:/tmp/
```

Развёртывание на сервере:

```bash
ssh -i ~/.ssh/infra_monitoring user@SERVER_IP
mkdir -p ~/infra-monitoring-project
tar -xzf /tmp/project.tar.gz -C ~/infra-monitoring-project
cd ~/infra-monitoring-project
docker compose up -d
```

`SERVER_IP` и `user` заменяются адресом сервера и именем пользователя. На сервере должны быть установлены Docker и Docker Compose. Приватный SSH-ключ нельзя публиковать.

## CI/CD

GitHub Actions автоматически проверяет Bash-скрипты при создании Pull Request в `main`.# infra-monitoring-project
