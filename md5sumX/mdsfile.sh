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
# act now
while read mdf
do 
	if [ -z "$mdf" ] || [ ! -f "$mdf" ]; then
		continue
	fi
	case $action in
		"merge")
			if [ -z "$mdfmerge" ]; then
				mdfmerge="$rdir"/.md5list.merge
				[ -f "$mdfmerge" ] && rm "$mdfmerge"
			fi
			# cat "$mdf" >> "$mdfmerge"
			newdir=$(dirname "$mdf")
			#format: md5 size date time filename
			cat "$mdf" | while read mm ss aa tt ff
			do
				# replace the dirname 
				echo "$mm $ss $aa $tt" \""$newdir"/$(basename "$ff")\" >> "$mdfmerge"
			done
			;;
		"list" | "listold" | "listmerge" )	
			[ $verbose = true ] && echo "list $mdf" 
			cat "$mdf"
			;;
		"del" | "delold") 
			[ $verbose = true ] && echo "rm $mdf" 
			rm -rf "$mdf" 
			;;
		"copy")	
			[ $verbose = true ] && echo "cp $mdf $mdf.old"
			cp -p "$mdf" "$mdf.old"
			;;
		"revert")
			[ $verbose = true ] && echo "cp $mdf ${mdf%%.old}"
			cp -p "$mdf" "${mdf%%.old}"
			;;
	esac
done<<EOF
$HDOC
EOF


