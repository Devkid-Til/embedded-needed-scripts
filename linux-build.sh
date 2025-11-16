#! /bin/bash

if [ $# -lt 1 ]
then
	echo "Usage: $0 <defconfig|menuconfig|zImage|uImage|dtb>"
	exit
else
	case "$1" in
		"defconfig")
			#echo 'defconfig'
			make ARCH=arm imx_v7_defconfig
			;;
		"menuconfig")
			#echo 'menuconfig'
			make ARCH=arm menuconfig
			;;
		"zImage")
			#echo 'zImage'
			make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j32
			echo 'Copying arch/arm/boot/zImage to ../../tftpboot/' 
			cp arch/arm/boot/zImage ../../tftpboot/
			;;
		"uImage")
			#echo 'uImage'
			make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j32 uImage LOADADDR=0x80800000
			;;
		"dtb")
			#echo 'dtb'
			make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs
			echo 'Copying arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb to ../../tftpboot/' 
			cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb ../../tftpboot/
			echo 'Copying arch/arm/boot/dts/imx6ull-14x14-smartcar.dts to ../../kernel/linux-imx-driver/learn-driver/device-tree/' 
			cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dts ../../kernel/linux-imx-driver/learn-driver/device-tree/
			cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb ../../kernel/linux-imx-driver/learn-driver/device-tree/
			;;
		*)
			echo "Usage: $0 <defconfig|menuconfig|zImage|uImage|dtb>"
			exit
			;;
	esac
fi


