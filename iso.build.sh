#!/bin/bash

mkdir -p ./build/iso-tmp
mkarchiso -v -r -w ./build/iso-tmp -o ./build ./build/iso
