#!/data/data/com.termux/files/usr/bin/bash
vk_run() {
  local id="${1:-}"
  [[ -n "$id" ]] || { read -r -p 'VK ID: ' id; }
  id=$(printf '%s' "$id" | sed -E 's#^https?://vk\.com/##; s#/.*##')
  section "VK: $id"
  report_header "vk" "$id"
  printf 'Profile: https://vk.com/%s\nFriends: https://vk.com/friends?section=all\nGroups: https://vk.com/groups?section=all\n' "$id"
  printf 'Archive.today: https://archive.ph/newest/https://vk.com/%s\n' "$id"
  printf 'Wayback: https://web.archive.org/web/*/vk.com/%s\n' "$id"
}
