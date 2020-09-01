#!/bin/bash
# This script use Smile Report
# https://git.smile.fr/dirtech/report

echo "Generate provision.pdf file"
rm -f ./provision.pdf
report generate ./provision/README.md ./provision.pdf
echo ""

echo "Generate deploy.pdf file"
rm -f ./deploy.pdf
report generate ./deploy/README.md ./deploy.pdf
echo ""
