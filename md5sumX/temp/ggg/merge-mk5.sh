#!/bin/bash

# root dir
if [ $# -eq 1 ]; then
	rdir=$(realpath "$1")
else
	rdir=$(pwd)
fi

# 遍历所有子.mk5list文件
find "$rdir" -type f -name ".md5list" | while read mdf
do 
	dd=$(dirname "$mdf")
	echo hhh $mdf
	#format: md5 size date time filename
	cat "$mdf" | while read mm ss aa tt ff; 
	do
		###echo "$mm" \""$ff"\"
		echo "$mm" $ss $aa $tt \""$dd"/$(basename "$ff")\"
	done
done

