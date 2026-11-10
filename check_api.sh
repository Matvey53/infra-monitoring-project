
#!/usr/bin/env bash

# Проверяем наличие аргумента
if [ "$#" -ne 1 ]; then
    echo "Использование: $0 URL"
    exit 1
fi

url="$1"

# Отправляем запрос и получаем HTTP-код
http_code=$(curl --silent --show-error \
    --location \
    --max-time 10 \
    --output /dev/null \
    --write-out "%{http_code}" \
    "$url")

curl_status=$?

# Проверяем результат запроса
if [ "$curl_status" -ne 0 ]; then
    echo "API недоступен, код ответа: ${http_code:-000}"
    exit 1
fi

if [ "$http_code" = "200" ]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: $http_code"
    exit 1
fi

