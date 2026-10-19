#!/data/data/com.termux/files/usr/bin/bash
ip_run() {
  local ip="${1:-}"
  [[ -n "$ip" ]] || { read -r -p 'IP: ' ip; }
  python3 -c "import ipaddress; ipaddress.ip_address('$ip')" 2>/dev/null || { warn "Invalid IP"; return 2; }
  section "IP: $ip"
  report_header "ip" "$ip"
  section "Reverse DNS"; command -v dig >/dev/null && dig +short -x "$ip" 2>/dev/null
  section "WHOIS"; command -v whois >/dev/null && whois "$ip" 2>/dev/null | grep -iE 'netname|country|org|descr|abuse|route' | head -20
  section "ipinfo"; http_get "https://ipinfo.io/${ip}/json" | python3 -m json.tool 2>/dev/null | head -30
  section "ip-api"; http_get "http://ip-api.com/json/${ip}?fields=status,country,regionName,city,isp,org,as,reverse,proxy,hosting" | python3 -m json.tool 2>/dev/null
  section "Links"
  printf 'Shodan: https://www.shodan.io/host/%s\n' "$ip"
  printf 'Censys: https://search.censys.io/hosts/%s\n' "$ip"
  printf 'AbuseIPDB: https://www.abuseipdb.com/check/%s\n' "$ip"
}
