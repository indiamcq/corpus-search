#!/bin/zsh
# version 2

corpus="$1"
searchwords="$2"
type="phrase"
safestring=${searchwords// /}

if [[ $# -lt 2 ]] then
 ls source/*.xml
 exit 1
fi

main() {
    reset='\033[0m'
    green='\033[32m'
    blue='\033[34m'
    red='\033[31m'

    echo -e "${green}Search corpus: ${corpus}${reset}"
    echo -e "${green}Search string: ${searchwords}${reset}"
    echo -e "${green}Search type: ${type}${reset}"

    safestring="${sstring//\?/_}"
    htmlfile="$(pwd)/output/${type}-${corpus}-${searchwords// /}.html"
    echo -e "${green}Output file: ${htmlfile}${reset}"

 
    mkdir -p output
    rm -f "$htmlfile"

    # end setup
    xsearchcorpus

}

xsearchcorpus() {
  echo -e ${blue}java -jar ../saxon/saxon-he-12.10.jar -s:source/${corpus}-corpus.xml -xsl:corpus-search.xslt -o:"${htmlfile}" target=${corpus} searchwords="${searchwords}" ${reset}
  java -jar ../saxon/saxon-he-12.10.jar -s:source/${corpus}-corpus.xml -xsl:corpus-search.xslt -o:"${htmlfile}" target=${corpus} searchwords="${searchwords}" type=${type}
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
