#!/data/data/com.termux/files/usr/bin/bash
crypto_run() {
  local addr="${1:-}"
  [[ -n "$addr" ]] || { read -r -p 'BTC/ETH address: ' addr; }
  section "Crypto: $addr"
  report_header "crypto" "$addr"
  if [[ "$addr" =~ ^(bc1|[13]) ]]; then
    section "Bitcoin"
    http_get "https://blockchain.info/rawaddr/$addr?limit=5" | python3 -c '
import json,sys
try:
 d=json.load(sys.stdin)
 print("Address:", d.get("address"))
 print("Balance (satoshi):", d.get("final_balance"))
 print("Total received:", d.get("total_received"))
 print("Txs:", d.get("n_tx"))
except: print("not found/error")' 2>/dev/null
    printf 'Blockchair: https://blockchair.com/bitcoin/address/%s\n' "$addr"
  elif [[ "$addr" =~ ^0x ]]; then
    section "Ethereum"
    printf 'Etherscan: https://etherscan.io/address/%s\n' "$addr"
  else note "Not BTC/ETH"; fi
}
