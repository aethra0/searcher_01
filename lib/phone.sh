#!/data/data/com.termux/files/usr/bin/bash
urlencode() { python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$1" 2>/dev/null || printf '%s' "$1"; }
phone_run() {
  local raw="${1:-}" digits
  [[ -n "$raw" ]] || { read -r -p 'Number: ' raw; }
  digits=$(printf '%s' "$raw" | tr -cd '0-9')
  if (( ${#digits} < 7 || ${#digits} > 15 )); then warn "Need 7-15 digits"; return 2; fi
  section "Phone: +$digits"
  report_header "phone" "+$digits"
  if command -v python3 >/dev/null && python3 -c 'import phonenumbers' 2>/dev/null; then
    section "Number info"
    python3 - "$raw" <<'PY'
import sys, phonenumbers
try:
    n = phonenumbers.parse(sys.argv[1], None)
    print("E.164:", phonenumbers.format_number(n, phonenumbers.PhoneNumberFormat.E164))
    print("Valid:", "yes" if phonenumbers.is_valid_number(n) else "no")
    print("Region:", phonenumbers.region_code_for_number(n) or "?")
    from phonenumbers import carrier, geocoder, timezone
    print("Carrier:", carrier.name_for_number(n, "ru") or "?")
    print("Geo:", geocoder.description_for_number(n, "ru") or "?")
    print("TZ:", timezone.time_zones_for_number(n))
except Exception as e:
    print("Parse error:", e)
PY
  fi
  if command -v phoneinfoga >/dev/null 2>&1; then section "PhoneInfoga"; phoneinfoga scan -n "+$digits" 2>/dev/null | head -60; fi
  section "Manual links"
  printf 'Truecaller: https://www.truecaller.com/search?query=%s\n' "$(urlencode "+$digits")"
  printf 'GetContact: https://getcontact.com/number-lookup/ru\n'
  printf 'Telegram: tg://resolve?phone=%s\n' "$digits"
  printf 'WhatsApp: https://wa.me/%s\n' "$digits"
  printf 'VK: https://vk.com/search?c[q]=%s\n' "$(urlencode "+$digits")"
}
