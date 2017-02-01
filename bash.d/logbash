# log utilities function

logfile=`realpath ~/.working.log`

#  logadd 
logadd() 
{
	echo $* >> $logfile
}

#  lognew 
lognew() 
{
	echo "" >> $logfile # new line
	echo "	" `date` >> $logfile
	echo "" >> $logfile # new line
	logadd $*
}

# edit log with vim
logvim()
{
	vim $logfile
}

# cat the cat the log file
logcat()
{
	cat $logfile
}

