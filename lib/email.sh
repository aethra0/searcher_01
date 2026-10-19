#!/data/data/com.termux/files/usr/bin/bash
email_run() {
  local em="${1:-}" domain lower hash
  [[ -n "$em" ]] || { read -r -p 'Email: ' em; }
  [[ "$em" =~ @ ]] || { warn "Invalid email"; return 2; }
  domain="${em##*@}"; lower=$(printf '%s' "$em" | tr 'A-Z' 'a-z')
  section "Email: $em"
  report_header "email" "$em"
  section "MX"
  command -v dig >/dev/null && dig +short MX "$domain" 2>/dev/null | head -10
  section "Gravatar"
  hash=$(printf '%s' "$lower" | md5sum | cut -d' ' -f1)
  printf 'https://www.gravatar.com/avatar/%s?d=404\n' "$hash"
  if command -v holehe >/dev/null 2>&1; then section "Holehe"; holehe "$em" 2>/dev/null | grep -E '\[+\]|\[x\]' | head -60; fi
  section "Manual links"
  printf 'HIBP: https://haveibeenpwned.com/account/%s\n' "$em"
  printf 'DeHashed: https://dehashed.com/search?query=%s\n' "$em"
  printf 'IntelX: https://intelx.io/?s=%s\n' "$em"
}
