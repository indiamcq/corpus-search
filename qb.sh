#!/bin/bash
# version 2

corpus="$1"
searchword="$2"
nosp="~"
type="phrase"

main() {
    reset='\033[0m'
    green='\033[32m'
    blue='\033[34m'
    red='\033[31m'

    echo -e "${green}Search corpus: ${corpus}${reset}"
    echo -e "${green}Search string: ${searchword}${reset}"
    echo -e "${green}Search type: ${type}${reset}"

    safestring="${sstring//\?/_}"
    htmlfile="$(pwd)/output/${type}-${corpus}-${safestring}.html"

 
    mkdir -p output
    rm -f "$htmlfile"

    # end setup
    searchcorpus

    status=$?
    if [[ $status -eq 1 ]]; then
        read -p "Press Enter to continue..."
    fi

    sleep "$timeout_secs"
}

searchcorpus() {
    echo -e "${blue}xslt3-he -xsl:search-present-target-js.sef.json -s:source/all-indexes.xml -o:${htmlfile} target=\"${grp}\" searchword=\"${sstring}\"${reset}"

    xslt3-he \
        -xsl:search-present-corpus.sef.json \
        -s:source/${corpus}.xml \
        -o:"${htmlfile}" \
        type="${type}" \
        searchword="${safestring}"\
        nosp="${nosp}" 
        target="${corpus}" 
}

main