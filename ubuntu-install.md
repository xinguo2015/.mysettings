## Ubuntu系统安装

### 安装ubuntu 16.04
- UEFI启动
- 分区创建
	- 创建uef分区（否则不能启动）
	- swap分区，boot分区，／分区，home 分区

### 安装CUDA 8.0
- 下载cuda 8.0安装文件（run文件）
- sudo vim /etc/modprobe.d/blacklist-noveau.conf
```
blacklist nouveau
options nouveau modeset=0
alias nouveau off
```
- sudo update-initramfs -u
- sudo reboot
- ctrl+alt+F1进入console login
- sudo service lightdm stop
- sudo killall Xorg
- chmod +x cudaXXX.run
- ./cudaXXX.run（运行安装文件）
    - yes, install driver 
	- yes, nvidia-xconfig
    - yes，intall opengl libraries
	- no, install sample (以后可以随时安装）
- 设置PATH和LD_LIBRARY_PATH
- sudo reboot





  
	
