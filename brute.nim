import std/[strutils, os, syncio, asyncdispatch]
import ndns

let wordlist = paramStr(1)
let domain = paramStr(2)

proc subdomainCheck(subdomain: string) {.async.} = 
  let client = initDnsClient("1.1.1.1")
  try:
    let response = await client.asyncResolveIPv4(subdomain)
    if response.len > 0:
      echo subdomain
  except:
    discard
proc processList(wlPath: string, domainName: string) {.async.} =
  try:
    var tasks: seq[Future[void]] = @[]
    for line in lines(wlPath):
      let word = line.strip()
      let subdomain = word & "." & domainName
      tasks.add(subdomainCheck(subdomain))
    await all(tasks)
      
      
  except Exception as e:
    echo "Error opening " & e.msg
waitFor(processList(wordlist, domain))
