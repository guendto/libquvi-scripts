#!/bin/sh
# stamp.sh for libquvi-scripts
#  - stamps the lua scripts to match the version

stamp_scripts()
{
  [ -z $1 ] && (echo "error: define path to top source dir" ; exit 1)
  [ -z $2 ] && (echo "error: define path to top dist dir" ; exit 1)
  if [ -x "$2/gen-ver.sh" ]; then
    VN=`$2/gen-ver.sh $1`
    find "$2/share/" -name '*.lua' \
      -exec sed -i "s/^\(-- libquvi-scripts\).*/\1 $VN/" {} \;
  fi
  exit 0
}

help()
{
  echo "Usage: $0 [-h] [top_srcdir]
-h  Show this help and exit"
  exit 0
}

while [ $# -gt 0 ]
do
  case "$1" in
    -h) help;;
    *) break;;
  esac
  shift
done

echo "Find and stamp lua scripts..."
stamp_scripts $1 $2
