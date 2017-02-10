#!/bin/bash

# 通过在文件系统中建立md5sum索引值，检查文件的唯一性。
# 对于同名的不同文件，按照时间顺序、目录位置，建立列表。
#   然后通过手工标记，确定文件取舍。

if [ $# -eq 1 ]; then
	targetdir=$(realpath $1)
else
	targetdir=$(pwd)
fi

echo Processing directory: $targetdir

# file name of the md5 list
if [ -d $targetdir ]; then
	mdfilename=$targetdir/.md5list
else
	mdfilename=$targetdir
fi
echo Processing md5 list: $mdfilename
if [ ! -f $mdfilename ] || [ ! -r $mdfilename ]; then
	echo "need a md5 list file"
	exit
fi

# 整体排序
mkfsorted=`mktemp`
sort "$mdfilename" > "$mkfsorted"
# 提取md5字段，并统计重复次数
mkflist=`mktemp`
cut -d " "  -f 1 "$mkfsorted" | uniq -c | awk '$1>1 { print $2, $1}' > "$mkflist" 
join "$mkflist" "$mkfsorted" > "${mdfilename}.dup"
