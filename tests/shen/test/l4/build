#!/bin/bash
find . -name "*.lua" | awk '{ print("luajit -b " $1 " " $1 "x") }' | sh
