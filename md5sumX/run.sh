#!/bin/bash

tl=/home/xinguo/.mysettings/md5sumX
tdir=/home/xinguo/temp/test
[ $# -ge 1 ] && tdir=$(realpath "$1")
if [ ! -d "$tdir" ]; then
	echo "invalid directory to run"
	exit
fi

sizetoskip=0
[ $# -ge 2 ] && sizetoskip=$2
echo mini size to skip huge file is $sizetoskip

#"$tl/mdsfile.sh" -d "$tdir" -a del
#"$tl/mdsfile.sh" -d "$tdir" -a delold
"$tl/mkmd5deep.sh" "$tdir" no "$sizetoskip"
#"$tl/mdsfile.sh" -d "$tdir" -a list
"$tl/mdsfile.sh" -d "$tdir" -a merge
#"$tl/mdsfile.sh" -d "$tdir" -a listmerge
"$tl/finddup.sh" "$tdir"
echo "."

