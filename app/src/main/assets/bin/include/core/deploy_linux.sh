#
# DogeLand CLI Module
# 
# license: GPL-v2.0
#
deploy_linux(){
echo "- 正在检查"
if [ ! -n "$rootfs2" ]; then
    echo "- 无效安装路径"
    exit 255
    sleep 1000
    else
    echo "">/dev/null
fi
if [ ! -n "$file" ]; then
    echo "- 无效系统包文件"
    exit 255
    sleep 1000
    else
    echo "">/dev/null
fi
if [ ! -n "$cliconf" ]; then
    echo "- 无效系统配置文件"
    exit 255
    sleep 1000
    else
    echo "">/dev/null
fi
echo "- 正在安装 $file"
rm -rf $rootfs2
mkdir $rootfs2/
if [ `id -u` -eq 0 ];then
 tar -xzvf $file -C $rootfs2 >/dev/null
else
 proot --link2symlink $TOOLKIT/busybox tar -xzvf $file -C $rootfs2 >/dev/null
fi
echo "- 正在设置"
sh $TOOLKIT/linuxdeploy-cli/cli.sh -p $cliconf deploy -c >/dev/null
mkdir $rootfs2/sys
mkdir $rootfs2/dev
mkdir $rootfs2/proc
rm -rf $CONFIG_DIR/$confid/rootfs.conf
echo "$rootfs2" >$CONFIG_DIR/$confid/rootfs.conf
#
cp $TOOLKIT/cli.sh $rootfs2/
sed -i '1 i\unset TOOLKIT' $rootfs2/cli.sh
mkdir $rootfs2/include/
cp -R $TOOLKIT/include/* $rootfs2/include/
#
rm -rf $CONFIG_DIR/$confid/cmd.conf
echo "/bin/bash /cli.sh dropbear_start">$CONFIG_DIR/$confid/cmd.conf
echo "!初始化命令行已设置默认启动dropbear"
export rootfs=$rootfs2
export cmd2="/bin/sh 'echo "$username:$password" | chpasswd' "
exec_auto
unset cmd2
echo "- 正在解析包"
if [ -f "$rootfs2/info.log" ];then
cat $rootfs2/info.log
else
echo "- 找不到文件,可能不是官方包或者包损坏也可能解压失败"
fi
echo "- 安装成功"
}
