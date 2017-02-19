#!/bin/bash

# 通过在文件系统中建立md5sum索引值，检查文件的唯一性。
# 对于同名的不同文件，按照时间顺序、目录位置，建立列表。
#   然后通过手工标记，确定文件取舍。

if [ $# -ne 1 ] || [ ! -f "$1" ] || [ ! -r "$1" ]; then
	exit
fi
ff=$1

# 整体排序
#ss=`mktemp`
#sort "$ff" > "$ss"
#mkflist=`mktemp`
#cut -d " "  -f 1 "$ss" | uniq -c | awk '$1>1 { print $2, $1}' > "$mkflist"
#join "$mkflist" "$ss" > "${ff}.dup"
newsize=yes
cat "${ff}.dup" | while read vn vg vf; do
	if [ $newsize != $vn ]; then
		echo $vn $vf $fg 
		newsize=$vn
	else
		echo $vn $vf $fg DEL
	fi
done

