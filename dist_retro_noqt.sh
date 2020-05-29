#!/bin/bash

rm *.dll
strip -s retroarch.exe
for i in $(seq 3); do for bin in $(ntldd -R *exe | grep -i mingw | cut -d">" -f2 | cut -d" " -f2); do cp -vu "$bin" . ; done; done
    
