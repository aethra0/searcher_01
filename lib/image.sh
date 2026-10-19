#!/data/data/com.termux/files/usr/bin/bash
image_run() {
  local f="${1:-}"
  [[ -n "$f" ]] || { read -r -p 'Image path: ' f; }
  [[ -f "$f" ]] || { warn "File not found"; return 2; }
  section "File: $f"
  report_header "image" "$f"
  section "Size/date"; stat -c 'Size: %s bytes | Modified: %y' "$f" 2>/dev/null
  section "Hashes"; md5sum "$f" 2>/dev/null; sha1sum "$f" 2>/dev/null; sha256sum "$f" 2>/dev/null
  section "EXIF"
  if command -v exiftool >/dev/null 2>&1; then exiftool -G1 -s "$f" 2>/dev/null | grep -iE 'gps|date|make|model|software|location|city|country' | head -30; else note "exiftool not installed"; fi
  section "Reverse search"
  printf 'Yandex: https://yandex.com/images/\nGoogle: https://lens.google.com/\nTinEye: https://tineye.com/\nSunCalc: https://www.suncalc.org/\n'
}
