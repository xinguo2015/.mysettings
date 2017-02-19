#!/bin/bash

# root dir
if [ $# -ge 1 ]; then
	rdir=$(realpath "$1")
else
	rdir=$(pwd)
fi

op=show
if [ $# -ge 2 ]; then
	op=$2
fi
if [ "$op" != clean ]; then
	op=show
fi

# 遍历所有子.mk5list文件
if [ $op = "show" ]; then
	echo "show .md5list*"
	find "$rdir" -type f -name ".md5list*" | while read mdf
	do 
		echo "$mdf"
		cat "$mdf"
	done
else 
	echo "clean .md5list*"
	find "$rdir" -type f -name ".md5list*" | while read mdf
	do 
		rm -rf "$mdf"
	done
fi

