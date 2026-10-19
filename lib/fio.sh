#!/data/data/com.termux/files/usr/bin/bash
fio_run() {
  local fio="${1:-}" city="${2:-}"
  [[ -n "$fio" ]] || { read -r -p 'FIO: ' fio; }
  [[ -n "$city" ]] || { read -r -p 'City (optional): ' city; }
  section "FIO: $fio"
  [[ -n "$city" ]] && section "City: $city"
  report_header "fio" "$fio ${city:-(no city)}"
  local enc=$(python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1]))' "$fio")
  section "Open registries"
  printf 'OpenCorporates: https://opencorporates.com/companies?q=%s\n' "$enc"
  printf 'OpenSanctions: https://www.opensanctions.org/search/?q=%s\n' "$enc"
  printf 'CourtListener: https://www.courtlistener.com/?q=%s\n' "$enc"
  section "Leaks"
  printf 'DeHashed: https://dehashed.com/search?query=%s\n' "$enc"
  printf 'IntelX: https://intelx.io/?s=%s\n' "$enc"
}
