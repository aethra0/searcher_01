#!/data/data/com.termux/files/usr/bin/bash
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/lib/core.sh"
mkdir -p "$OUT_DIR" "$CACHE_DIR"; db_init
for m in "$SCRIPT_DIR"/lib/*.sh; do source "$m"; done

run_and_report() {
  local selector="$1" target="$2"; shift 2
  local ts report status
  ts=$(date -u +%s)
  report="$OUT_DIR/${selector}_${ts}.txt"
  {
    report_header "$selector" "$target"
    "$@"
  } 2>&1 | tee "$report"
  status=${PIPESTATUS[0]}
  db_log "$selector" "$target" "$report"
  printf '\n'
  ok "Report: $report"
  pause
  return "$status"
}

menu() {
  clear_screen
  cat <<'MENU'
+----------------------------------------------+
|  probiv v2 - OSINT framework                 |
|  1) phone   6) image    b) fio               |
|  2) email   7) vk       c) telegram          |
|  3) nick    8) domain   d) auto              |
|  4) ip      9) crypto   h) history           |
|  5) exit                                     |
+----------------------------------------------+
MENU
  read -r -p "> " c
  case "$c" in
    1) read -r -p "Number: " v; run_and_report phone "$v" phone_run "$v" ;;
    2) read -r -p "Email: " v; run_and_report email "$v" email_run "$v" ;;
    3) read -r -p "Nick: " v;   run_and_report nick "$v"  nick_run  "$v" ;;
    4) read -r -p "IP: " v;    run_and_report ip "$v"    ip_run    "$v" ;;
    8) read -r -p "Domain: " v; run_and_report domain "$v" domain_run "$v" ;;
    6) read -r -p "Image: " v;  run_and_report image "$v" image_run "$v" ;;
    b) read -r -p "FIO: " f; read -r -p "City: " c; run_and_report fio "$f" fio_run "$f" "$c" ;;
    7) read -r -p "VK: " v;    run_and_report vk "$v"    vk_run    "$v" ;;
    c) read -r -p "TG: " v;    run_and_report telegram "$v" tg_run "$v" ;;
    d) read -r -p "VIN/plate: " v; run_and_report auto "$v" auto_run "$v" ;;
    9) read -r -p "Address: " v; run_and_report crypto "$v" crypto_run "$v" ;;
    h) section "History"; sqlite3 "$DB" "SELECT ts,selector,target FROM runs ORDER BY id DESC LIMIT 20;" 2>/dev/null; pause ;;
    5) exit 0 ;;
    *) warn "Wrong choice"; sleep 1 ;;
  esac
  menu
}

if [[ $# -gt 0 ]]; then
  case "$1" in
    phone) shift; run_and_report phone "${1:-}" phone_run "${1:-}" ;;
    email) shift; run_and_report email "${1:-}" email_run "${1:-}" ;;
    nick)  shift; run_and_report nick "${1:-}" nick_run "${1:-}" ;;
    ip)    shift; run_and_report ip "${1:-}" ip_run "${1:-}" ;;
    domain) shift; run_and_report domain "${1:-}" domain_run "${1:-}" ;;
    image) shift; run_and_report image "${1:-}" image_run "${1:-}" ;;
    fio)   shift; run_and_report fio "${1:-}" fio_run "${1:-}" "${2:-}" ;;
    vk)    shift; run_and_report vk "${1:-}" vk_run "${1:-}" ;;
    telegram) shift; run_and_report telegram "${1:-}" tg_run "${1:-}" ;;
    auto)  shift; run_and_report auto "${1:-}" auto_run "${1:-}" ;;
    crypto) shift; run_and_report crypto "${1:-}" crypto_run "${1:-}" ;;
    --help|-h) echo "probiv v2: phone|email|nick|ip|domain|image|fio|vk|telegram|auto|crypto";;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
  exit $?
fi

menu
