#!/bin/bash
#配置插件及脚本
export home=/home/AC
export bin1=$home/bin
export bin2=$home/script
export outpull=$home/outpull
export work=$home/work
export temp=$home/temporary
export PATH=$home/bin:$home/script:$PATH
export version=BUILD_V0.1
source $temp/theme/`cat $temp/theme/prefer` 2>/dev/null
function first
{
echo -n "欢迎使用AstralCore(简称AC)"
pause
echo -n "输入用户名:"
read username
echo $username > $temp/user/name
echo  "为$username设置密码?"
decide opt n
if [ "$opt" == "y" ]
	then
		echo -n "输入密码:"
		read password
		echo $password > $temp/user/password
fi
echo  "欢迎你$username"
pause
}
function error
{
	echo -e ERROR:"\e[31m输入错误!\e[0m"
	echo -n "按下任意键继续:"
	read wait_key
}
function pause
{
echo -n "按下任意键继续:"
read wait_key
}
function theme
{
while :
do
clear
echo "当前主题为`cat $temp/theme/prefer`"
echo -e "\e[${background_select};${font_select}m
1.更改为green主题
2.更改为king主题
3.更改为colorful主题
8.更改为默认主题
9.自定义主题
0.返回上一级\e[0m"
choose cheme
if [ "$cheme" == "1" ]
then
	echo green > $temp/theme/prefer
	echo "更换成功,重启工具即可看到效果"
	pause
elif [ "$cheme" == "2" ]
then
	echo king > $temp/theme/prefer
	echo "更换成功,重启工具即可看到效果"
	pause
elif [ "$cheme" == "3" ]
then
	echo colorful > $temp/theme/prefer
	echo "更换成功,重启工具即可看到效果"
	pause
elif [ "$cheme" == "8" ]
then
	echo default > $temp/theme/prefer
	echo "更换成功,重启工具即可看到效果"
	pause
elif [ "$cheme" == "9" ]
then
	echo -n "输入主题名称:"
	read name	
echo "颜色代码表:
30:黑色 31:红色 32:绿色
33:黄色 34:蓝色 35:紫色
36:天蓝 37:白色  0:无色"
	echo -n "输入标题背景颜色:"
	read a
	let a=$a+10
	echo -n "输入标题字体颜色:"
	read b
	echo -n "输入菜单背景颜色:"
	read c
	let c=$c+10
	echo -n "输入菜单字体颜色:"
	read d
	echo "export backgroud_title=$a">$temp/theme/$name
	echo "export font_title=$b">>$temp/theme/$name
	echo "export backgroud_select=$c">>$temp/theme/$name
	echo "export font_select=$d">>$temp/theme/$name
	echo $name > $temp/theme/prefer
	echo "重启工具即可看到效果"
	pause
elif [ "$cheme" == "0" ]
then
break 1
else
	error
fi
done
}
function change_passwd
{
while :
do
clear
echo -e "\e[${background_title};${font_title}m->密码管理<-\e[0m
\e[${background_select};${font_select}m
1.设置密码
2.更换密码
3.删除密码
0.返回菜单\e[0m"
choose pawd
if [ "$pawd" == "1" ]
then
	if [ -f $temp/user/password ]
	then
		echo "已存在密码,无法继续"
		pause
	else
		echo "用户:$user未设置密码"
		echo "是否设置?"
		decide chpass n
		if [ "$chpass" == "y" ]
		then
			echo -n "输入密码:"
			read tmp
			echo $tmp > $temp/user/password
			echo "创建成功"
			pause
			continue
		else
			continue
		fi
	fi
elif [ "$pawd" == "2" ]
then
		if [ ! -f $temp/user/password ]
		then
		echo "未设置密码,无法继续"
		pause
		continue
		fi
	echo "为用户$user更改密码?"
	decide chpass n
	if [ "$chpass" == "y" ]
	then
	check_passwd
		if [ "$?" == "0" ]
		then
			echo -n "输入要更改的密码:"
			read newpass
			echo $newpass > $temp/user/password
			echo "更改成功"
			pause
			continue
		fi
	fi
elif [ "$pawd" == "3" ]
then
	echo "删除用户$user的密码?"
	decide chpass n
	if [ "$chpass" == "y" ]
	then
	check_passwd
		if [ "$?" == "0" ]
		then
			rm $temp/user/password
			echo "删除成功"
			pause
			continue
		fi
		else
			continie
	fi
elif [ "$pawd" == "0" ]
then
	break 1
else
	error
fi
done
}
function help
{
clear
	echo "AstralCore"
		echo "AC--$version"
		echo "	1.工具必须依赖busybox
	2.工具不开源,但热衷于分享
	3.官方群号68641685
	4.作者QQ:2269214749
	5.欢迎指导交流,一起讨论,一起学习"
			echo -e "\e[32mCopyright (c) - 2014\e[0m"
			echo "Author:@AstralCore"
		pause
}
function opoion
{
	echo "请输入你的意见:"
		read can
		if [ ! -f $temp/user/opoion ]
			then
				echo "AstralCore" > $temp/user/opoion
		fi
		echo "`$date`" >> $temp/user/opoion
		echo $can >> $temp/user/opoion
		echo "感谢你的反馈"
		pause
}
function choose
{
echo -n -e "\e[037m->输入选项:\e[0m"
read $1
}
function decide
{
echo -n -e "[y/n_默认$2]  \e[36;1m>>>>_\e[0m"
read $1
}
function check_passwd
{
	saved=`cat $temp/user/password`
	for ((i=1;i<=3;i++))
	do
		echo -n "为用户$user核对密码:"
		read opt
		if [ "$opt" != "$saved" ]
			then
				if [ "$i" -eq "3" ]
				then
					echo -n "密码已输错3次,工具将在3秒后退出"
					sleep 3
					echo
					exit
				else
			echo "密码输入核对错误"
			pause
				fi
		else
			echo "密码正确,欢迎你$user"
			return 0
			break
		fi
	done
}
###########################################
#主循环
	#判断是否需要初始化
	if [ ! -f $temp/user/name ]
	then
	first
	fi
	export user=`cat $temp/user/name 2>/dev/null`
  #判断是否设置了密码
	if [ -f $temp/user/password ]
	then
	check_passwd
	fi
while :
do
clear
echo -e "\e[36mWelcome_$user\e[0m\n`date`\n$version"
echo -e "\e[${background_title};${font_title}m->主菜单<-\e[0m
\e[${background_select};${font_select}m
1.插件管理
2.基础工具
3.增量工具
9.工具设置
0.退出工具\e[0m"
choose check_out
case $check_out in
	1)
	#内嵌一层循环
	while :
	do
	clear
	echo -e "\e[${background_title};${font_title}m->插件管理<-\e[0m
\e[${background_select};${font_select}m
1.GCC插件     
2.JDK插件     
3.厨房插件    
4.安装所有插件
8.卸载所有插件
9.完全卸载工具
0.返回菜单    \e[0m"
	choose check_manage
		if [ "$check_manage" == "1" ]
		then
			manage gcc
		elif [ "$check_manage" == "2" ]
		then
			manage jdk
		elif [ "$check_manage" == "3" ]
		then
			manage kitchen
		elif [ "$check_manage" == "4" ]
		then
			manage install_all
		elif [ "$check_manage" == "8" ]
		then
		 manage	uninstall_all
		elif [ "$check_manage" == "9" ]
		then
			manage delete_me
		elif [ "$check_manage" == "0" ]
		then
			break 1 #退出一层循环
		else
			error
		fi
		done
	;;
	2)
	 #内嵌一层循环
	while :
	do
	clear
	echo -e "\e[${background_title};${font_title}m->基础工具<-\e[0m
\e[${background_select};${font_select}m
1.解包工具
2.镜像工具
3.安卓厨房
4.APK工具 
5.GCC编译 
6.JAVA编译
7.获取分区
0.返回菜单\e[0m"
		choose menu1
		if [ "$menu1" == "1" ]
		then
			boot_tool
		elif [ "$menu1" == "2" ]
		then
			img_tool
		elif [ "$menu1" == "3" ]
		then
			rom_tool
		elif [ "$menu1" == "4" ]
		then
			apk_tool
		elif [ "$menu1" == "5" ]
		then
			gcc_tool
		elif [ "$menu1" == "6" ]
		then
			java_tool
		elif [ "$menu1" == "7" ]
		then
			get_partition
		elif [ "$menu1" == "0" ]
		then
			break 1 #退出一层循环
		else
				error
		fi
	done
	;;
	3)
	while :
	do
	clear
	echo -e "\e[${background_title};${font_title}m->增量工具<-\e[0m
\e[${background_select};${font_select}m
1.WIFI密码
2.手机信息
3.虚拟按键
4.制作镜像
5.获取lun 
9.清理缓存
0.返回菜单\e[0m"
		choose menu2
		if [ "$menu2" == "1" ]
		then
			show_wifi
		elif [ "$menu2" == "2" ]
		then
			get_cpu_info
		elif [ "$menu2" == "3" ]
		then
			virtual
		elif [ "$menu2" == "4" ]
		then
			mk_loop
		elif [ "$menu2" == "5" ]
		then
			get_lun
		elif [ "$menu2" == "9" ]
		then
			clean_swap
		elif [ "$menu2" == "7" ]
		then
			get_partition
		elif [ "$menu2" == "0" ]
		then
			break 1 #退出一层循环
		else
				error
		fi
	done
	;;
	9)
	while :
	do
	clear
	echo -e "\e[${background_title};${font_title}m->工具设置<-\e[0m
\e[${background_select};${font_select}m
1.用户设置
2.主题设置
3.反馈意见
4.查看帮助
9.密码管理
0.返回菜单\e[0m"
	choose set
		if [ "$set" == "1" ]
		then
			change_name
		elif [ "$set" == "2" ]
		then
			theme
		elif [ "$set" == "3" ]
		then
			opoion
		elif [ "$set" == "4" ]
		then
			help
		elif [ "$set" == "9" ]
		then
			change_passwd
		elif [ "$set" == "0" ]
		then
			break 1 #退出一层循环
		else
				error
		fi
	done
	;;
	0)
		echo "Goodbye $user!"
		break
	;;
	*)
		error
	;;
esac
done
