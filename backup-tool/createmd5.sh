#!/bin/bash

# 通过在文件系统中建立md5sum索引值，检查文件的唯一性。
# 对于同名的不同文件，按照时间顺序、目录位置，建立列表。
#   然后通过手工标记，确定文件取舍。

MDS=md5sum
if [ $# -eq 1 ]; then
	targetdir=$(realpath $1)
else
	targetdir=$(pwd)
fi

echo Processing directory: $targetdir

# file name of the md5 list
# mdfilename=$(date +"%Y-%m-%d-%s").md5sum
mdfilename=$targetdir/.md5list
# delete it if alread exists
if [ -f "$mdfilename" ]; then
	rm -rf "$mdfilename"
fi

# 遍历所有的文件
find "$targetdir" | while read f
do
	if [ -d "$f" ]; then
		# skip folder
		echo "$f"
	elif [ -f "$f" ] && [ -r "$f" ] && [ "$(basename "$f")" != md5list ]; then
		$MDS "$f" >> "$mdfilename"
	fi
done
