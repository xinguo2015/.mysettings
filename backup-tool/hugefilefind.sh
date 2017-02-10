#!/bin/bash

# 通过在文件系统中建立md5sum索引值，检查文件的唯一性。
# 对于同名的不同文件，按照时间顺序、目录位置，建立列表。
#   然后通过手工标记，确定文件取舍。

MDS=md5sum
let MB=( 1024*1024 )
let GB=( $MB*1024 )
if [ $# -ge 1 ]; then
	targetdir=$(realpath $1)
else
	targetdir=$(pwd)
fi

if [ ! -d $targetdir ]; then
	echo $targetdir is not a valid directory
	exit
fi

if [ $# -ge 2 ]; then
	let minsize=$2
else
	let minsize=500000000
fi

#echo Finding huge files in: $targetdir

# 遍历所有的文件
find "$targetdir" | while read f
do
	if [ -f "$f" ] && [ -r "$f" ]; then
		let fs=$(stat -c %s "$f")
		if [ $fs -gt $minsize ]; then
			let m=( $fs / $GB )
			let n=( $fs % $GB * 100 / $GB )
			echo $fs "("$m.$n"G)"  \"$f\"
		fi
	fi
done
