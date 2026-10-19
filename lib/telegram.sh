#!/data/data/com.termux/files/usr/bin/bash
tg_run() {
  local nick="${1:-}"
  [[ -n "$nick" ]] || { read -r -p 'TG username: ' nick; }
  nick=$(printf '%s' "$nick" | tr -d '@')
  section "Telegram: @$nick"
  report_header "telegram" "@$nick"
  printf 'Link: https://t.me/%s\ntg://: tg://resolve?domain=%s\n' "$nick" "$nick"
  local code=$(curl -s -o /dev/null -w '%{http_code}' -L --max-time 8 -A "$USER_AGENT" "https://t.me/$nick" 2>/dev/null)
  case "$code" in 200) ok "Exists";; *) note "HTTP $code";; esac
  section "Catalogs"
  printf 'TGStat: https://tgstat.ru/search?q=%s\nTelemetr: https://telemetr.io/ru/search?q=%s\n' "$nick" "$nick"
}
