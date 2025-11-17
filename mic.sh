#!/bin/sh

# 音频子系统检查
if ! amixer info >/dev/null 2>&1; then
    logger -t audio-config "Warning: No sound card detected, skipping audio setup"
    exit 0  # 或 exit 1，取决于是否必需
fi

# 配置文件存在性检查
#if [ ! -f /etc/audio/default.conf ]; then
#    logger -t audio-config "Warning: Default config not found, using built-in defaults"
#fi

# 音量调节函数
set_volume() {
    local vol=$1
    # 限制范围 0-127
    vol=$((vol > 127 ? 127 : vol))
    vol=$((vol < 0 ? 0 : vol))
    amixer sset 'Headphone' $vol,$vol
    amixer sset 'Speaker' $vol,$vol
	exit 0
}


if [ $# -eq 1 ]; then
	set_volume $1
	exit 0
fi


# 获取 WM8960 控件列表（调试用）
# amixer controls | grep -i wm8960

# 录音音量设置（0-127，建议 60-80）
amixer cset name='Capture Volume' 100,100

# 启用输出通路（在设置音量前）
amixer sset 'Right Output Mixer PCM' on
amixer sset 'Left Output Mixer PCM' on

# PCM 播放音量（0-255，建议 200-240）
amixer sset 'Playback' 235
#ADC PCM
amixer sset 'ADC PCM' 200
# 耳机配置
amixer sset 'Headphone Playback ZC' on
amixer sset 'Headphone' 110,110

# 扬声器配置  
amixer sset 'Speaker Playback ZC' on
amixer sset 'Speaker' 120,120

#Set the volume of your Speaker AC(80% volume...100 is the MaxVolume)
amixer sset 'Speaker AC' 4
#Set the volume of your Speaker AC(80% volume...5 is the MaxVolume)
amixer sset 'Speaker DC' 4

# 左声道输入配置
amixer sset 'Left Input Mixer Boost' on

# 启用需要的输入通道（根据硬件连接调整）
amixer sset 'Left Boost Mixer LINPUT1' on
amixer sset 'Left Input Boost Mixer LINPUT1' 3   # 麦克风输入
amixer sset 'Left Boost Mixer LINPUT1' off
amixer sset 'Left Input Boost Mixer LINPUT2' 0   # 禁用
amixer sset 'Left Boost Mixer LINPUT3' on
amixer sset 'Left Input Boost Mixer LINPUT3' 6   # 线路输入

# 右声道输入配置（单声道录音场景）
amixer sset 'Right Input Boost Mixer RINPUT1' 0
amixer sset 'Right Input Boost Mixer RINPUT2' 0
amixer sset 'Right Input Boost Mixer RINPUT3' 0

# 可选：如果需要立体声录音，启用右声道
# amixer sset 'Right Input Boost Mixer RINPUT1' 3

echo "Audio configuration completed successfully!"

alsactl store  # 保存到 /var/lib/alsa/asound.state

#alsactl restore
