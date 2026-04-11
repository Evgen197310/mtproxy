# MTProxy

Telegram MTProto proxy на базе [mtprotoproxy](https://github.com/alexbers/mtprotoproxy) (Python, v1.1.2).

## Конфигурация

Файл конфига: `/opt/mtproxy/mtprotoproxy/config.py`

| Параметр | Значение |
|----------|----------|
| **Порт** | `48780` |
| **Режим** | TLS (маскировка под `www.cloudflare.com`) |
| **Секрет** | `48859e33e9df9e165242218e26a778c7` |

## Ссылка для подключения

```
tg://proxy?server=79.133.179.234&port=48780&secret=ee48859e33e9df9e165242218e26a778c77777772e636c6f7564666c6172652e636f6d
```

В TLS-режиме секрет формируется как: `ee` + secret + hex(TLS_DOMAIN).

## Управление

```bash
# Статус
systemctl status MTProxy

# Перезапуск
systemctl restart MTProxy

# Логи
journalctl -u MTProxy -f
```

Systemd unit: `/etc/systemd/system/MTProxy.service`

## Структура файлов

```
/opt/mtproxy/
├── mtprotoproxy/
│   ├── mtprotoproxy.py      # основной скрипт
│   ├── config.py            # конфигурация (порт, секрет, режим)
│   └── pyaes/               # встроенная AES-библиотека
├── update_config.sh          # обновление конфигов + рестарт сервиса
├── proxy-secret              # секрет для связи с серверами Telegram (C-версия)
└── proxy-multi.conf          # конфигурация серверов Telegram (C-версия)
```

## Обновление конфигурации Telegram-серверов

```bash
/opt/mtproxy/update_config.sh
```

Скрипт скачивает `proxy-secret` и `proxy-multi.conf` и перезапускает сервис.

> **Примечание:** Python-версия mtprotoproxy не использует эти файлы напрямую — она получает конфигурацию серверов автоматически. Рестарт сервиса тем не менее полезен для обновления соединений.

## Регистрация прокси

Зарегистрировать прокси и получить tag для рекламы можно через [@MTProxybot](https://t.me/MTProxybot).
