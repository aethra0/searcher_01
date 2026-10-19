#!/data/data/com.termux/files/usr/bin/bash
domain_run() {
  local dom="${1:-}" cert wayback
  [[ -n "$dom" ]] || { read -r -p 'Domain: ' dom; }
  dom=$(printf '%s' "$dom" | sed -E 's#^https?://##; s#/.*##; s#\?.*##' | tr 'A-Z' 'a-z')
  section "Domain: $dom"
  report_header "domain" "$dom"
  section "DNS"
  for t in A AAAA MX NS TXT SOA; do local r=$(dig +short "$t" "$dom" 2>/dev/null); [[ -n "$r" ]] && printf "%s:\n%s\n" "$t" "$r"; done
  section "WHOIS"; command -v whois >/dev/null && whois "$dom" 2>/dev/null | grep -iE 'registrar|creation|expiry|name server|registrant|email' | head -30
  section "crt.sh"
  cert=$(http_get "https://crt.sh/?q=%25.$dom&output=json")
  [[ -n "$cert" ]] && printf '%s' "$cert" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin)
 names=sorted({n.strip().lower() for x in d for n in x.get("name_value","").splitlines() if n.strip()})
 for n in names[:80]: print(n)
 if len(names)>80: print(f"... +{len(names)-80}")
except: pass' 2>/dev/null
  section "Wayback"
  wayback=$(http_get "http://web.archive.org/cdx/search/cdx?url=$dom*&output=json&fl=timestamp,original&collapse=urlkey&limit=25")
  [[ -n "$wayback" ]] && printf '%s' "$wayback" | python3 -c 'import json,sys
try:
 d=json.load(sys.stdin)
 for r in d[1:]: print(" ".join(r))
except: pass' 2>/dev/null
  section "Links"
  printf 'Shodan: https://www.shodan.io/search?query=ssl%%3A%%22%s%%22\n' "$dom"
  printf 'urlscan: https://urlscan.io/domain/%s\n' "$dom"
}
