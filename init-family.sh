#!/usr/bin/env bash


# no database found - we need the setup
if [ $(ls ${GENEWEBDB}/${FAMILY}.gwb 2>/dev/null|wc -l) -eq 0 ]; then
    /home/GW/gw/gwc -o ${GENEWEBDB}/${FAMILY}.gwb
fi
