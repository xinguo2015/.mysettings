#!/bin/bash

# parameters: <working dir> <reuseflag> [excludesize]

# command to calc mds
MDS=md5sum

# working directory
wdir=

# name of the mds file
mdf=

# name of the previous mds file
mdfold=

# temp file for swap
mdftmp=

# reuse previous calcualted mds?
reuseFlag=

# exclude huge sized file
excludesize=0

# input parameter count
if [ $# -lt 2 ]; then
	echo "usage: <working dir> <reuseflag> [skip size]"
	exit
fi
if [ $# -ge 3 ] ; then
	excludesize=$(( $3 * 1024 * 1024))
fi
#echo exclude size for huge file is: $(($excludesize/1024/1024)) MB

# get the working dir
wdir=$(realpath "$1")
if [ ! -d "$wdir" ] || [ ! -x "$wdir" ]; then
	echo not a valid dir: $wdir
	exit
fi

# get reusing flag
reuseFlag=$2
if [ $reuseFlag != yes ]; then
	reuseFlag=no
fi

# file name of the md5 list
mdf=$wdir/.md5list
mdfold=$mdf.old
mdftmp=$mdf.tmp

# clean the mds file
[ -f "$mdf" ] && rm -rf "$mdf"

# confirm reuse
[ ! -f "$mdfold" ] && reuseFlag=no

# 遍历目录下的所有文件,  排除 .md5list*
find "$wdir" -maxdepth 1 -type f -not -name ".md5list*" | while read f
do
	if [ -r "$f" ]; then
		# get file information: size date time
		finfo=$(stat -c "%s %y" "$f")
		# there is a possible bug dealing with file"
		# "Downloads/Functional maps A Flexible Representation of Maps Between Shapes-yunhai.pptx"
		# which make stat wrong
		if [ $? = 1 ]; then
			echo skip file %f
			continue
		fi
		finfo=${finfo%%.*}
		fbname=$(basename "$f")
		# file size
		fss=$(echo "$finfo" | cut -d ' ' -f 1)
		# find if exist
		newMDS=
		if [ "$reuseFlag" = yes ]; then
			# to find existing mds item
			#   using here document to avoid sub shell with pipe
			HEREDOC=`grep -E "$finfo .*/$fbname$" "$mdfold"`
			while read rmm rss rdd rtt rff
			do
				[ $rmm ] && newMDS="$rmm $f"
				break;
			done<<EOF 
$HEREDOC 
EOF
# ! NOTE EOF can NOT be indented !
		fi

		# echo "if not found, then run md5sum"
		if [ -z "$newMDS" ] ; then
			if [ $excludesize -eq 0 ] || [ $fss -le $excludesize ]; then
				# echo "run $MDS $f"
				newMDS=$($MDS "$f")
				echo $newMDS >> "$mdf"
			else
				echo skip huge file "$f"
			fi
		else
			echo $newMDS >> "$mdf"
		fi
		# echo "save the mds into file
	fi
done

# when the fold is empty except folders, then there will be no .md5list
if [ -f "$mdf" ]; then
	# 插入文件的大小和最后修改时间
	rm -rf "$mdftmp"
	cat "$mdf" | while read rmm rff
	do
		finfo=$(stat -c "%s %y" "$rff")
		if [ $? = 1 ]; then
			echo add info - skip file %f
			continue
		fi
		finfo=${finfo%%.*}
		echo $rmm $finfo $rff >> "$mdftmp"
	done
	# 排序md5 
	sort "$mdftmp" > "$mdf"
	rm -rf "$mdftmp"
fi

