## 安装CUDA前的检查工作

卸载cuda(runfile)
```
sudo /usr/local/cuda-X.Y/bin/uninstall_cuda_X.Y.pl
```

卸载nvidia驱动 (runfile)
```
sudo /usr/bin/nvidia-uninstall
```

卸载nvidia驱动 (PRM/Deb)
```
$ sudo yum remove <package_name> # Redhat/CentOS 
$ sudo dnf remove <package_name> # Fedora 
$ sudo zypper remove <package_name> # OpenSUSE/SLES 
$ sudo apt-get --purge remove <package_name> # Ubuntu
```

确认显卡型号
```
$ lspci | grep -i nvidia 
```

确认系统版本
```
$ uname -m && cat /etc/*release
```

确认系统内核
```
$ uname -r
```

安装系统内核头文件和开发包
```
$ sudo apt-get install linux-headers-$(uname -r)
```

## 安装CUDA（Ubuntu）
```
$ sudo dpkg -i cuda-repo-<distro>_<version>_<architecture>.deb
$ sudo apt-get update
$ sudo apt-get install cuda
```

## 安装CUDA事后工作
  - 将路径**/usr/local/cuda-8.0.61/bin**添加到PATH中
```
export PATH=/usr/local/cuda-8.0.61/bin${PATH:+:${PATH}}
```
  - 安装例程（a copy in /usr/local/cuda-8.0.61/samples）
```
$ cuda-install-samples-8.0.61.sh <dir>
```
  - 验证驱动正确
```
cat /proc/driver/nvidia/version
```


