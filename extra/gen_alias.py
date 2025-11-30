import sys

excluded = ["date", "dir", "echo"]
manual = {
    "v": "nvim",
    "nv": "neovide"
}

for line in sys.stdin:
    command = line.strip()
    if command in excluded:
        continue
    

    file = open(f"{command}.bat", "w")
    _ = file.write("@echo off\n")
    _ = file.write(f"coreutils {command} %*")

for k, v in manual:
    file = open(f"{k}.bat", "w")
    _ = file.write("@echo off\n")
    _ = file.write(f"{v} %*")


