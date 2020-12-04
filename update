#!/usr/bin/env python3

import json, re, subprocess
from urllib.request import urlopen

pat = re.compile(r"(.*?)\s*:\s*(.*?)\s*/\s*(.*?)(\s*@\s*(.*))?")
lock = {}

for line in open("sources.txt").readlines():
    line = line.strip()
    if not line: continue

    m = pat.fullmatch(line)
    name = m[1]
    owner = m[2]
    repo = m[3]
    ref = m[5] or "master"

    rev = json.load(urlopen(f"https://api.github.com/repos/{owner}/{repo}/git/trees/{ref}"))["sha"]

    lock[name] = {
        "owner": owner,
        "repo": repo,
        "rev": rev,
        "sha256": subprocess.run(
            [
                "nix-prefetch-url",
                "--unpack",
                f"https://github.com/{owner}/{repo}/archive/{rev}.tar.gz",
            ],
            check = True,
            stdout = subprocess.PIPE,
            text = True,
        ).stdout.strip(),
    }

json.dump(lock, open("sources.lock.json", "w"))
