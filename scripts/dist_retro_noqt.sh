#!/bin/bash

pushd . &>/dev/null
cd ../retroarch_dist

rm *.dll
for i in $(seq 3); do for bin in $(ntldd -R retroarch.exe | grep -i mingw | cut -d">" -f2 | cut -d" " -f2); do cp -vu "$bin" . ; done; done

popd &>/dev/null
    
