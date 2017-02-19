#!/bin/bash

# parameters: [dir] [size threhold in MB]
# working directory
wdir=
# minimum size for huge file
msize=

let KB=( 1024 )
let MB=( $KB * $KB )
let GB=( $MB * $KB )

if [ $# -ge 1 ]; then
	wdir=$(realpath $1)
else
	wdir=$(pwd)
fi

if [ ! -d $wdir ]; then
	echo $wdir is not a valid directory
	exit
fi

if [ $# -ge 2 ]; then
	let msize=( $2 * $MB )
else
	let msize=( 200 * $MB )
fi

# echo Finding huge files in: $wdir
# 遍历所有的文件
find "$wdir" -type f -not -name ".md5list*" | while read f
do
	if [ -f "$f" ] && [ -r "$f" ]; then
		let fs=$(stat -c %s "$f")
		if [ $fs -gt $msize ]; then
			#x=$(awk 'BEGIN{printf "%.2f", '$fs'/'$GB'}')
			#echo $fs "$x"G  \"$f\"
			let x=( $fs / $MB )
			echo $fs "$x"M  \"$f\"
		fi
	fi
done
