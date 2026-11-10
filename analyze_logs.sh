
#!/usr/bin/env bash

set -euo pipefail

log_file="access.log"

# Генерация тестового access.log
: > "$log_file"

for i in $(seq 1 360); do
    case $((i % 6)) in
        0)
            ip="192.168.1.10"
            method="GET"
            path="/api/users"
            status=200
            ;;
        1)
            ip="192.168.1.10"
            method="POST"
            path="/api/login"
            status=401
            ;;
        2)
            ip="10.0.0.5"
            method="GET"
            path="/api/products"
            status=200
            ;;
        3)
            ip="10.0.0.5"
            method="GET"
            path="/api/missing"
            status=404
            ;;
        4)
            ip="172.16.0.8"
            method="POST"
            path="/api/orders"
            status=500
            ;;
        5)
            ip="192.168.1.20"
            method="GET"
            path="/api/health"
            status=200
            ;;
    esac

    printf '%s - - [15/Aug/2026:10:15:%02d] "%s %s HTTP/1.1" %s\n' \
        "$ip" "$((i % 60))" "$method" "$path" "$status" \
        >> "$log_file"
done

echo "=== Анализ access.log ==="

# Общее количество запросов
total=$(wc -l < "$log_file" | tr -d ' ')
echo "Общее количество запросов: $total"

# Топ-3 IP-адресов
echo
echo "Топ-3 IP-адреса по количеству запросов:"

grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3} ' "$log_file" |
    awk '{print $1}' |
    sort |
    uniq -c |
    sort -rn |
    head -n 3

# Количество ошибок 4xx и 5xx
echo
awk '
    $NF ~ /^4[0-9][0-9]$/ { errors_4xx++ }
    $NF ~ /^5[0-9][0-9]$/ { errors_5xx++ }
    END {
        printf "Количество запросов с кодами 4xx: %d\n", errors_4xx
        printf "Количество запросов с кодами 5xx: %d\n", errors_5xx
    }
' "$log_file"

