import std/[os, osproc, asyncdispatch]
import brute

let domain = paramStr(1)
let wordlist = paramStr(2)

echo "[i] Checking with crt.sh.." 

let pyCmd = "python3 find.py " & domain
discard execCmd(pyCmd)

echo "[i] Starting DNS Enumeration.."
waitFor(ProcessList(wordlist, domain))
