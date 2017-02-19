#!/bin/bash

actionlist="list listold del delold copy revert" 
action=list
rdir=
mdfmerge=
verbose=false

while getopts d:a:vqm opt
do
	case $opt in
		d)  rdir=$OPTARG 
			;;
		a)	action=$OPTARG 
			;;
		v)	verbose=true 
			;;
		q)	verbose=false 
			;;
		*)	echo "options: -d <dir> -a <${actionlist}> -vq"
			exit
			;;
	esac
done

if [ rdir ]; then
	rdir=$(realpath "$rdir")
else
	rdir=$(pwd)
fi
if [ ! -d "$rdir" ] || [ ! -x "$rdir" ]; then
	[ $verbose = true ] && echo "invalid dir: $rdir"
	exit
fi
# collect files for the action
#	actions include (list listold del delold copy revert) 
HDOC=
case $action in
	"list" | "copy" | "del" | "merge" ) 
		HDOC=`find "$rdir" -type f -name ".md5list"` 
		;;
	"listmerge" )
		HDOC="$rdir/.md5list.merge" 
		;;
	"listold" | "revert" | "delold" ) 
		HDOC=`find "$rdir" -type f -name ".md5list.old"` 
		;;
	*)	
		[ $verbose = true ] && echo "invalid action: $action"
		exit
	;;
esac
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
# 遍历所有 × 子目录 ×
find "$rdir" -maxdepth 1 -type d | while read fd
do
	if [ ! -x "$fd" ] || [ "$(basename "$fd")" = ".git" ]; then
		continue
	elif [ "$fd" = "$rdir" ]; then
		echo create mds in "$fd"
		sh ./mkmd5-1.sh "$fd" "$findAndUseOld"
		echo "remove exit"
		exit
	else
		sh ./mkmd5-deep.sh "$fd" "$findAndUseOld"
	fi
done

