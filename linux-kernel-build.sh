#!/bin/bash
##############################################################################
# 脚本名称：linux-kernel-build.sh
# 脚本功能：
#   1. 校验TFTP服务配置路径与NFS根文件系统（rootfs）共享路径有效性
#   2. 检查tftpd-hpa、nfs-kernel-server服务状态（含运行状态上色提示与错误日志输出）
#   3. 提供Linux内核编译与部署一站式命令：
#      - defconfig：加载imx_v7_smartcar_defconfig默认配置
#      - menuconfig：启动内核图形化配置界面，并备份.config到自定义配置文件
#      - zImage：编译ARM架构zImage内核镜像，并同步至TFTP路径
#      - uImage：编译指定加载地址（0x80800000）的uImage镜像
#      - dtb：编译设备树文件（imx6ull-14x14-smartcar.dtb），同步至TFTP路径与驱动开发目录
#      - rtl8723bu：将rtl8723bu无线网卡驱动ko文件同步至NFS根文件系统
# 作    者：JiaqiShi
# 联系邮箱：shijiaqi_develop@163.com
# 编写日期：2025-11-18
# 版    本：v1.0
# 依赖环境：
#   - 系统架构：ARM架构开发环境（适配imx6ull芯片）
#   - 工具链：arm-linux-gnueabihf-交叉编译工具链（需提前配置环境变量）
#   - 服务依赖：tftpd-hpa（TFTP服务）、nfs-kernel-server（NFS服务）
#   - 内核源码：需在Linux内核源码根目录执行（依赖arch/arm/configs等内核目录结构）
# 注意事项：
#   1. 需提前配置/etc/default/tftpd-hpa（指定TFTP_DIRECTORY）与/etc/exports（配置rootfs共享）
#   2. 编译线程数（-j8）可根据主机CPU核心数调整，避免资源不足导致编译失败
##############################################################################




# ====================== 1.global parameters ========================
# tftp
TFTP_PATH=$(grep "TFTP_DIRECTORY" /etc/default/tftpd-hpa 2>/dev/null | cut -d '"' -f 2)
# nfs(只取第一个 NFS 共享目录) 1. 过滤 /etc/exports 中非注释行 → 2. 提取第一个字段（共享目录）→ 3. 筛选含 "rootfs" 的路径 → 4. 取第一个有效路径
NFS_PATH=$(grep -v '^#' /etc/exports 2>/dev/null | awk '{print $1}' | grep -F 'rootfs' | head -n 1)
ROOTFS=${NFS_PATH}

# systemctl check list
SERVICES=("tftpd-hpa" "nfs-kernel-server")
# ===================================================================



# ========================   2.function      ========================
# function1: 校验 tftp 和 NFS  
check_nfs_tftp() {
	if [ -z "${TFTP_PATH}" ]; then
		echo "Error: TFTP_DIRECTORY not found in /etc/default/tftpd-hpa";
		exit 1;
	fi

	if [ -z "${NFS_PATH}" ]; then
		echo "Error: No valid NFS directory found in /etc/exports";
		exit 1;
	fi

	if [ ! -d "${NFS_PATH}" ]; then
		echo "Error: NFS(ROOTFS) directory ${NFS_PATH} does not exist";
		exit 1; 
	fi
}

# function2: 检查单个服务状态
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
            echo -e "\033[47;30m[\033[32m$status\033[47;30m]$service\033[0m" # 绿色
            ;;
        inactive)
            echo -e "\033[47;30m[\033[33m$status\033[47;30m]$service\033[0m" # 绿色
            ;;
        failed)
            echo -e "\033[47;30m[\033[31m$status\033[47;30m]$service\033[0m" # 绿色
            ;;
        *)
            echo -e "\033[47;30m[\033[37m$status\033[47;30m]$service\033[0m" # 绿色
            ;;
    esac

    # 5. 若服务启动失败，输出错误日志（帮助排查问题）
    if [ "$status" = "failed" ]; then
		echo -e "\nerror log(least 3 lines)"
        journalctl -u "$service" --no-pager -n 3 2>/dev/null || echo "无法获取日志（需root权限）"
    fi
}
# ===================================================================





# =====================   3.business logic   ========================
# 执行NFS与TFTP路径校验
check_nfs_tftp 
echo -e "\033[45;37mTFTP PATH: $TFTP_PATH\033[0m"
echo -e "\033[45;37mNFS  PATH: $NFS_PATH\033[0m"

echo -e "\033[47;30mChecking tftpd-hpa, nfs-kernel-server status\033[0m"
for service in "${SERVICES[@]}"; do
    check_single_service "$service"
done


if [ $# -lt 1 ]
then
	echo -e "\033[47;30mUsage: $0 <defconfig|menuconfig|zImage|uImage|dtbs>\033[0m"
	exit 1
fi

case "$1" in
	"defconfig")
		#echo 'defconfig'
		make ARCH=imx_v7_smartcar_defconfig
		;;
	"menuconfig")
		#echo 'menuconfig'
		make ARCH=arm menuconfig
		#echo "Backup .config to arch/arm/configs/imx_v7_smartcar_defconfig"
		echo -e "\033[42;30mBackup .config to arch/arm/configs/imx_v7_smartcar_defconfig\033[0m"
		cp .config arch/arm/configs/imx_v7_smartcar_defconfig
		;;
	"zImage")
		#echo 'zImage'
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8
		#echo "Copying arch/arm/boot/zImage to $TFTP_PATH"
		echo -e "\033[42;30mCopying arch/arm/boot/zImage to $TFTP_PATH\033[0m"
		cp arch/arm/boot/zImage $TFTP_PATH
		;;
	"uImage")
		#echo 'uImage'
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8 uImage LOADADDR=0x80800000
		;;
	"dtbs")
		#echo 'dtbs'
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs
		#echo "Copying arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb to $TFTP_PATH"
		echo -e "\033[42;30mCopying arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb to $TFTP_PATH\033[0m"
		cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb $TFTP_PATH
		#echo "Copying arch/arm/boot/dts/imx6ull-14x14-smartcar.dts to ../../linux-driver-dev/smartcar-linux-imx_4.1.15_2.0.0/learn-driver/device-tree/"
		echo -e "\033[42;30mCopying arch/arm/boot/dts/imx6ull-14x14-smartcar.dts to ../../linux-driver-dev/smartcar-linux-imx_4.1.15_2.0.0/learn-driver/device-tree/\033[0m"
		cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dts ../../linux-driver-dev/smartcar-linux-imx_4.1.15_2.0.0/learn-driver/device-tree/
		cp arch/arm/boot/dts/imx6ull-14x14-smartcar.dtb ../../linux-driver-dev/smartcar-linux-imx_4.1.15_2.0.0/learn-driver/device-tree/
		;;
	"rtl8723bu")
		#echo "Copying drivers/net/wireless/rtl8723bu/8723bu.ko $NFS_PATH"
		echo -e "\033[42;30mCopying drivers/net/wireless/rtl8723bu/8723bu.ko $NFS_PATH\033[0m"
		cp drivers/net/wireless/rtl8723bu/8723bu.ko $NFS_PATH
		;;
	*)
		echo -e "\033[42;30mUsage: $0 <defconfig|menuconfig|zImage|uImage|dtbs>\033[0m"
		exit 1
		;;
esac
# ===================================================================
