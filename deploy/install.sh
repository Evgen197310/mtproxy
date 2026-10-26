#!/bin/bash
# Раскладка systemd-юнитов и drop-in'ов mtproxy в /etc/systemd/system (хост bots).
# Репозиторий — источник правды; в /etc лежат побайтные копии.
#
# Берёт ТОЛЬКО deploy/*.service, *.timer и <юнит>.service.d/*.conf (раскладка drop-in'ов
# зеркалит /etc/systemd/system). Каталоги cron.d/ и nginx/ этим скриптом НЕ ставятся.
#
# Идемпотентно: файл ставится, только если отличается (cmp); daemon-reload — только
# если что-то поставлено. Сервисы НЕ включаются и НЕ перезапускаются: правка юнита
# вступает в силу при следующем рестарте, рестарт — отдельное решение.
#
#   install.sh          — поставить расхождения
#   install.sh --check  — только показать расхождения (код 1, если они есть)
#   SYSTEMD_DIR=/tmp/x install.sh — разложить в другой каталог (стенд; без daemon-reload)
set -euo pipefail
shopt -s nullglob
src=$(cd "$(dirname "$0")" && pwd)
dst_root=${SYSTEMD_DIR:-/etc/systemd/system}
check=0
[ "${1:-}" = --check ] && check=1
changed=0
n=0
for f in "$src"/*.service "$src"/*.timer "$src"/*.service.d/*.conf; do
    rel=${f#"$src"/}
    dst=$dst_root/$rel
    n=$((n + 1))
    cmp -s "$f" "$dst" && continue
    changed=1
    if [ $check = 1 ]; then
        echo "расходится: $dst"
    else
        install -D -m 644 "$f" "$dst"
        echo "обновлён $dst"
    fi
done
if [ $check = 1 ]; then
    echo "mtproxy: проверено файлов $n, расхождений: $([ $changed = 1 ] && echo есть || echo нет)"
    exit $changed
fi
if [ $changed = 1 ] && [ "$dst_root" = /etc/systemd/system ]; then
    systemctl daemon-reload
    echo "daemon-reload выполнен; сервисы не перезапускались"
fi
echo "mtproxy: проверено файлов $n, $([ $changed = 1 ] && echo 'изменения поставлены' || echo 'всё совпадает, ничего не менялось')"
