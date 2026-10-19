#!/data/data/com.termux/files/usr/bin/bash
set -u
if [[ -t 1 ]]; then
  C_RESET='\033[0m'; C_CYAN='\033[1;36m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_GREEN='\033[1;32m'
else
  C_RESET=''; C_CYAN=''; C_YELLOW=''; C_RED=''; C_GREEN=''
fi
section() { printf "\n${C_CYAN}== %s ==${C_RESET}\n" "$*"; }
note()    { printf "${C_YELLOW}[i] %s${C_RESET}\n" "$*"; }
warn()    { printf "${C_RED}[!] %s${C_RESET}\n" "$*"; }
ok()      { printf "${C_GREEN}[+] %s${C_RESET}\n" "$*"; }
pause()   { printf '\n'; read -r -p "Enter - back to menu... " _ || true; }
clear_screen() { if [[ -t 1 ]]; then printf '\033[2J\033[H'; fi; }
cache_key() { printf '%s' "$1" | md5sum | cut -d' ' -f1; }
cache_get() {
  local key file
  key=$(cache_key "$1"); file="$CACHE_DIR/$key"
  [[ -f "$file" ]] || return 1
  local age=$(( $(date +%s) - $(stat -c %Y "$file" 2>/dev/null || echo 0) ))
  (( age < CACHE_TTL )) && cat "$file" && return 0
  rm -f "$file"; return 1
}
cache_set() {
  local key file
  key=$(cache_key "$1"); file="$CACHE_DIR/$key"
  mkdir -p "$CACHE_DIR"; printf '%s' "$2" > "$file"
}
http_get() {
  local url="$1" cached body=""
  cached=$(cache_get "$url") && { printf '%s' "$cached"; return 0; }
  for ((i=0; i<=RETRIES; i++)); do
    body=$(curl -fsSL --max-time "$TIMEOUT" -A "$USER_AGENT" "$url" 2>/dev/null) && break
    sleep 1
  done
  [[ -n "$body" ]] && cache_set "$url" "$body"
  printf '%s' "$body"
}
db_init() {
  command -v sqlite3 >/dev/null 2>&1 || return 0
  sqlite3 "$DB" "CREATE TABLE IF NOT EXISTS runs (id INTEGER PRIMARY KEY AUTOINCREMENT, ts TEXT, selector TEXT, target TEXT, report TEXT);" 2>/dev/null
}
db_log() {
  command -v sqlite3 >/dev/null 2>&1 || return 0
  sqlite3 "$DB" "INSERT INTO runs (ts,selector,target,report) VALUES ('$(date -u +%FT%TZ)','$1','$2','$3');" 2>/dev/null
}
report_header() {
  printf 'probiv v2 - %s\nUTC: %s\nTarget: %s\n----------------------------------------\n' "$1" "$(date -u '+%Y-%m-%d %H:%M:%S')" "$2"
}
