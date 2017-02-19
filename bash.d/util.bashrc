# archives
# extrac files from .tgz
untgz()
{
	tar -zxvf $*
}

# extract files from .tar
untar()
{
	tar -xvf $*
}

# mount iso, open folder
openiso()
{
	thefile=$(pwd)/$1
	if [ -f $thefile ]; then
		mountpoint=~/.isomount/$1
		sudo mkdir -p "$mountpoint"
		sudo mount -o loop "$thefile" "$mountpoint"
		sudo -K
		nautilus "$mountpoint"
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
			*) echo "'$1' cannot be recognized" 
				;; 
        esac 
     fi 
}
