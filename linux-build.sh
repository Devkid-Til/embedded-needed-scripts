#! /bin/bash


# tftp
TFTP_PATH=$(grep "TFTP_DIRECTORY" /etc/default/tftpd-hpa | cut -d '"' -f 2)
# nfs
NFS_PATH=$(grep -v '^#' /etc/exports | awk '{print $1}' | sort -u)

# systemctl check list
SERVICES=("tftpd-hpa" "nfs-kernel-server")

# 工具函数：检查单个服务状态
check_single_service() {
    local service="$1"

    # 1. 检查服务是否存在（避免查询不存在的服务报错）
    if ! systemctl list-unit-files --type=service --full --all | grep -q "^$service.service"; then
        echo "服务 $service 不存在（未安装或服务名错误）"
        return 1
    fi

    # 2. 获取基础状态（active/inactive/failed）
    local status=$(systemctl is-active "$service" 2>/dev/null)

    # 4. 输出结果（根据状态上色提示）
    case "$status" in
        active)
            echo -e "[\033[32m$status\033[0m]$service" # 绿色
            ;;
        inactive)
            echo -e "[\033[33m$status\033[0m]$service" # 绿色
            ;;
        failed)
            echo -e "[\033[31m$status\033[0m]$service" # 绿色
            ;;
        *)
            echo -e "[\033[37m$status\033[0m]$service" # 绿色
            ;;
    esac

    # 5. 若服务启动失败，输出错误日志（帮助排查问题）
    if [ "$status" = "failed" ]; then
		echo -e "\nerror log(least 3 lines)"
        journalctl -u "$service" --no-pager -n 3 2>/dev/null || echo "无法获取日志（需root权限）"
    fi

}


echo "checking tftpd-hpa, nfs-kernel-server status"

for service in "${SERVICES[@]}"; do
    check_single_service "$service"
done

echo -e "tftp: $TFTP_PATH"
echo -e "nfs : $NFS_PATH"


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
			echo "Copying .config to arch/arm/configs/imx_v7_smartcar_defconfig"
			cp .config arch/arm/configs/imx_v7_smartcar_defconfig
			;;
		"zImage")
			#echo 'zImage'
			make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8
			echo "Copying arch/arm/boot/zImage to $TFTP_PATH"
			cp arch/arm/boot/zImage $TFTP_PATH
			;;
		"uImage")
			#echo 'uImage'
			make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j9 uImage LOADADDR=0x80800000
			;;
		"dtb")
			#echo 'dtbs'
			make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs
			echo "Copying arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb to $TFTP_PATH"
			cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb $TFTP_PATH
			echo "Copying arch/arm/boot/dts/imx6ull-14x14-smartcar.dts to ../../kernel/linux-imx-driver/learn-driver/device-tree/"
			#cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dts ../../kernel/linux-imx-driver/learn-driver/device-tree/
			#cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb ../../kernel/linux-imx-driver/learn-driver/device-tree/
			;;
		*)
			echo "Usage: $0 <defconfig|menuconfig|zImage|uImage|dtb>"
			exit
			;;
	esac
fi
