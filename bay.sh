#!/bin/bash
cleanup() {
  [ -f "${req}" ] && rm "${req}"
}
trap cleanup EXIT

SCRIPT_NAME=$(basename $0)

top_keys() {
cat << EOF
all     Total Top100
recent  Recent Torrents

100     Audio
  101     Music
  102     Audio books
  103     Sound clips
  104     FLAC
  199     Other

200     Video
  201     Movies
  202     Movies DVDR
  203     Music videos
  204     Movie clips
  205     TV shows
  206     Handheld
  207     HD - Movies
  208     HD - TV shows
  209     3D
  299     Other

300     Applications
  301     Windows
  302     Mac
  303     UNIX
  304     Handheld
  305     IOS (iPad/iPhone)
  306     Android
  399     Other OS

400     Games
  401     PC
  402     Mac
  403     PSx
  404     XBOX360
  405     Wii
  406     Handheld
  407     IOS (iPad/iPhone)
  408     Android
  499     Other

500     Porn
  501     Movies
  502     Movies DVDR
  503     Pictures
  504     Games
  505     HD - Movies
  506     Movie clips
  599     Other

600     Other
  601     E-books
  602     Comics
  603     Pictures
  604     Covers
  605     Physibles
  699     Other
EOF
exit 0
}

help() { 
cat << EOF
usage: $SCRIPT_NAME [-t|-m|-c|-l|-h] [TERM]...
Query apibay for magnet links
Example: $SCRIPT_NAME ISO Debian 9

Options:
  -t,--tv
        print top 100 tv shows
  -m,--movie
        print top 100 movies
  -c,--custom
        Display custom top 100 catagory
  -l,--list
        List top 100 keys, for use with -c
  -h,--help
        print this message
EOF
exit 1
}

[ "$#" -eq 0 ] && help

PRECOMPILED_URL=https://apibay.org/precompiled/data_top100_#.json
JSON_NUMBER=
POSITIONAL=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -t|--tv)
      JSON_NUMBER=205
      shift
      ;;
    -m|--movie)
      JSON_NUMBER=201
      shift
      ;;
    -c|--custom)
      JSON_NUMBER=$2
      shift 2
      ;;
    -l|--list)
      top_keys
      shift
      ;;
    -h|--help)
      help
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done
set -- "${POSITIONAL[@]}"

url=
if [ -z "${JSON_NUMBER}" ]; then
  terms=${@}
  url="https://apibay.org/q.php?q=${terms// /%20}"
else
  [ "$#" -gt 0 ] && help
  url="${PRECOMPILED_URL//#/${JSON_NUMBER}}"
fi

req=$(mktemp)
status=$(curl --connect-timeout 3 -sX GET -w "%{http_code}" -o "${req}" "${url}")
[ "${status}" -ne 200 ] && echo "Error: ${status}" && exit 1

jq -r 'reverse | .[] | "\(.name)\n\tseeders: \(.seeders)\n\tsize: \(.size | tonumber /1024/1024 | floor) MB\n\tlink: magnet:?xt=urn:btih:\(.info_hash)"' <"${req}"



