#!/bin/sh

cd "${0%/*}"

pwsh script.ps1 >> ../results/results.json

