#!/bin/bash  

function tarHome()
{
	sudo tar zcvpf $1 \
		--exclude=/home/xinguo/.cache \
		--exclude=/home/xinguo/.nv \
		--exclude=/home/xinguo/Videos \
		--exclude=/home/xinguo/Pictures \
		--exclude=/home/xinguo/Music \
		--exclude=/home/xinguo/Downloads \
		--exclude=/home/xinguo/Samples \
		--exclude=/home/xinguo/temp \
		/home/xinguo
}

function tarBoot()
{
	sudo tar zcvfp $1 \
		/boot
}

function tarOS()
{
	sudo tar zcvpf $1 \
		--exclude=/boot \
		--exclude=/data \
		--exclude=/home \
		--exclude=/proc \
		--exclude=/sys \
		--exclude=/srv \
		--exclude=/lost+found \
		--exclude=/cdrom \
		--exclude=/mnt \
		--exclude=/media \
		--exclude=/tmp \
		--exclude=/var/cache \
		--exclude=/run/user/1000/gvfs \
		/
}

# 输入备份文件存放地点
for n in {1..5}; do
	if read -p "Where to store tar files?"
	then 
		if [ ! -z $REPLY ] && [ -d $REPLY ]; then
			break
		else
			# 非法目的地
			echo "not a valide place: " $REPLY
		fi
	fi
done
if [ -z $REPLY ] || [ ! -d $REPLY ]; then
	# 非法目的地
	exit
fi

echo "Tar files will be put in: "$REPLY
basename=$REPLY/$(date +"%Y-%m-%d-%H-%M")
hometgz=$basename"(xinguo).tgz"
boottgz=$basename"(boot).tgz"
ostgz=$basename"(os).tgz"
echo "     Home tar file is: "$hometgz
echo "     Boot tar file is: "$boottgz
echo "       OS tar file is: "$ostgz

##################################
function askYN()
{
	while :  # loop
	do
		if read -p "$1" 
		then
			case $REPLY in
				Y|y) # Yes
					return 1;;
				N|n) # No
					return 0;;
				*)   # input error repeat
					continue
			esac 
		else #timeover
			return 2
		fi 
	done
}

askYN "?Backup home [Y|N]: "
homeflag=$?
askYN "?Bckup boot [Y|N]: "
bootflag=$?
askYN "?Backup OS / [Y|N]: "
osflag=$?

# 没有东西要备份
if [ $homeflag -ne 1 ] && [ $bootflag -ne 1 ] && [ $osflag -ne 1 ] ; then
	echo "You decided nothing to backup"
	exit
fi

# confirm the above selection
askYN "?Do you confirm [Y|N]: "
if [ $? -ne 1 ]; then
	echo "Abort"
	exit
fi

# backup home
if [ $homeflag -eq 1 ]; then
	echo "starting to backup [/home/xinguo] ==> " $hometgz
	tarHome $hometgz
	echo "done!"
fi
# backup boot
if [ $bootflag -eq 1 ]; then
	echo "starting to backup [/boot] ==> " $boottgz
	tarBoot $boottgz
	echo "done!"
fi
# backup os
if [ $osflag -eq 1 ]; then
	echo "starting to backup os [ / ] ==> " $ostgz
	tarOS $ostgz
	echo "done!"
fi

