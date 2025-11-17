#LIB_CONSOLEDEVICE 表示控制台设置，这里不设置，因此为 none。
export TSLIB_CONSOLEDEVICE=none

#TSLIB_FBDEVICE 表示 FB 设备，也就是屏幕LCD，根据实际情况配置，LCD屏设备为/dev/fb0
export TSLIB_FBDEVICE=/dev/fb0

#TSLIB_CALIBFILE 表示校准文件，如果进行屏幕校准的话校准结果就保存在这个文件中，
#这里设置校准文件为/etc/pointercal，此文件可以不存在，校准的时候会自动生成。
export TSLIB_CALIBFILE=/etc/pointercal

#TSLIB_TSDEVICE 表示触摸设备文件，这里设置为/dev/input/event1，这个要根据具体情况设置，
#如果你的触摸设备文件为event2那么就应该设置为/dev/input/event2，以此类推。
export TSLIB_TSDEVICE=/dev/input/event1

#TSLIB_PLUGINDIR 表示 tslib 插件目录位置，目录为/lib/ts。
export TSLIB_PLUGINDIR=/usr/lib/ts

#TSLIB_CONFFILE 表示触摸配置文件，文件为/etc/ts.conf，此文件在移植 tslib 的时候会生成
export TSLIB_CONFFILE=/etc/ts.conf

#指定触摸设备
export QT_QPA_GENERIC_PLUGINS=tslib:/dev/input/event1

#qt 字库的目录
export QT_QPA_FONTDIR=/fonts

#qt 插件的目录
export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt/plugins

#指定LCD帧缓冲设备/dev/fb0
export QT_QPA_PLATFORM=linuxfb:tty=/dev/fb0

#qt 插件的目录
export QT_PLUGIN_PATH=/usr/lib/qt/plugins

#使用 tslib 库
export QT_QPA_FB_TSLIB=1 
#打开应用程序运行的时候输出的log信息 
#export QT_DEBUG_PLUGINS=1
#运行Qt程序之前先加载ts库
export LD_PRELOAD=/usr/lib/libts.so
