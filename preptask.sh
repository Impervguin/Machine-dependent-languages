#!/bin/bash

# python3 PrepTask.py -v --add-masm -f --dir "$1" --build MAIN.EXE --config "/home/impervguin/.dosbox/dosbox-0.74-3.conf"
# python3 PrepTask.py -v --add-masm -f --dir "$1" --config "/home/impervguin/.dosbox/dosbox-0.74-3.conf"
python3 PrepTask.py -v --add-masm -f --dir "$1" --build MAIN.COM --config "/home/impervguin/.dosbox/dosbox-0.74-3.conf"
