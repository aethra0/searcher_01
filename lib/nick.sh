#!/data/data/com.termux/files/usr/bin/bash
nick_run() {
  local nick="${1:-}"
  [[ -n "$nick" ]] || { read -r -p 'Nick: ' nick; }
  section "Nick: $nick"
  report_header "nick" "$nick"
  section "Direct checks"
  local -a pl=('GitHub|https://github.com/' 'Telegram|https://t.me/' 'VK|https://vk.com/' 'TikTok|https://www.tiktok.com/@' 'Instagram|https://www.instagram.com/' 'X|https://x.com/' 'Reddit|https://www.reddit.com/user/' 'YouTube|https://www.youtube.com/@' 'Steam|https://steamcommunity.com/id/' 'SoundCloud|https://soundcloud.com/' 'Keybase|https://keybase.io/' 'Mastodon|https://mastodon.social/@' 'Bluesky|https://bsky.app/profile/' 'Threads|https://www.threads.net/@')
  for entry in "${pl[@]}"; do
    local name="${entry%%|*}" base="${entry#*|}" code
    code=$(curl -s -o /dev/null -w '%{http_code}' -L --max-time 6 -A "$USER_AGENT" "${base}${nick}" 2>/dev/null)
    case "$code" in
      200) printf "${C_GREEN}[+] %-12s %s${C_RESET}\n" "$name" "${base}${nick}" ;;
      404) printf "[ ] %-12s\n" "$name" ;;
      *) printf "[?] %-12s HTTP %s\n" "$name" "$code" ;;
    esac
  done
  if command -v sherlock >/dev/null 2>&1; then section "Sherlock"; sherlock "$nick" --timeout 8 --print-found 2>/dev/null | head -80; fi
  if command -v maigret >/dev/null 2>&1; then section "Maigret"; maigret "$nick" --top-sites 500 --timeout 10 2>/dev/null | grep -E '\[+\]' | head -80; fi
}
