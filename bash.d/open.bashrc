# mount iso, open folder
openiso()
{
	local mediapath=`echo ${HOME} | sed 's/home/media/'`
	thefile=$(pwd)/$1
	if [ -f $thefile ]; then
		mountpoint=${mediapath}/$1
		sudo mkdir -p "$mountpoint"
		sudo mount -o loop "$thefile" "$mountpoint"
		sudo -K
		nautilus "$mountpoint"
		cd "$mountpoint"
	fi
}

# colors

function open() 
{ 
	if [ -d $1 ]; then
		nautilus $1
	elif [ -f $1 ]; then
		case $1 in 
			*.pdf)  evince $1     
				;; 
			*.iso)  openiso $1
				;;
			*) echo "'$1' cannot be recognized" 
				;; 
        esac 
     fi 
}
