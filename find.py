import requests
import json
import sys
import time

target = sys.argv[1]
crturl = f"https://crt.sh/?q=%.{target}&output=json"

found = set()

try:
    r = requests.get(crturl)
    data = r.json()
    for item in data:
        domains = item['name_value'].split("\n")
        for domain in domains:
            clean_domain = domain.lstrip("*.")
            if "@" in clean_domain or " " in clean_domain:
                clean_domain = clean_domain.replace(" ", "@").split("@")[-1]
            if clean_domain != target and clean_domain.endswith(target):
                found.add(clean_domain)

except Exception as e:
    choice = input(f"Failed to fetch from crt.sh, retry? [Y/n]: ")
    if choice.lower() != "n" or choice.lower != "y":
        for i in range(0,4):
            print(f"Retrying.. {i}/5")
            time.sleep(2)
            continue

print("\n[CRT.SH FINDS]\n")

for subdomain in sorted(found):
    print(subdomain)
