#!/bin/bash

# root dir
if [ $# -ge 1 ]; then
	rdir=$(realpath "$1")
else
	rdir=$(pwd)
fi

# reuse old
findAndUseOld=${2:-no}
if [ $findAndUseOld != no ]; then
	findAndUseOld=yes
fi

excludesize=0
if [ $# -ge 3 ] ; then
	excludesize=$3
fi

# 遍历所有 × 子目录 ×
find "$rdir" -maxdepth 1 -type d | while read fd
do
	if [ ! -x "$fd" ] || [ "$(basename "$fd")" = ".git" ]; then
		continue
	elif [ "$fd" = "$rdir" ]; then
		#echo create mds in "$fd"
		sh ./mkmd5.sh "$fd" "$findAndUseOld" "$excludesize"
	else
		sh ./mkmd5deep.sh "$fd" "$findAndUseOld" "$excludesize"
	fi
done

