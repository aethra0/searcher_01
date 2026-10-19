#!/data/data/com.termux/files/usr/bin/bash
auto_run() {
  local val="${1:-}"
  [[ -n "$val" ]] || { read -r -p 'VIN or plate: ' val; }
  section "Auto: $val"
  report_header "auto" "$val"
  if [[ ${#val} -eq 17 ]]; then
    section "VIN"
    printf 'VINformer: https://vinformer.su/ru/\nAutocode: https://avtokod.mos.ru/\nNHTSA: https://vpic.nhtsa.dot.gov/decoder/Decoder/DecodeVIN/%s\n' "$val"
  else
    section "Plate"
    printf 'Autocode: https://avtokod.mos.ru/\nGIBDD: https://xn--90adear.xn--p1ai/check/auto\n'
  fi
}
