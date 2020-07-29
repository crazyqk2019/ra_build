#!/bin/bash

for i in $(seq 3); do for bin in $(ntldd -R $1 | grep -i mingw | cut -d">" -f2 | cut -d" " -f2); do cp -vu "$bin" ../ ; done; done