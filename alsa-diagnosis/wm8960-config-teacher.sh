ECORD_VOLUME_PERCENT=100    # Capture音量百分比 (0-100)
INPUT_GAIN_PERCENT=100       # 输入增益百分比 (0-100)
ADC_VOLUME_PERCENT=100       # ADC PCM音量百分比 (0-100)

# 播放设置（百分比）
PLAYBACK_VOLUME_PERCENT=95   # PCM播放音量百分比 (0-100)
HEADPHONE_VOLUME_PERCENT=95  # 耳机音量百分比 (0-100)
SPEAKER_VOLUME_PERCENT=95    # 扬声器音量百分比 (0-100)
BYPASS_VOLUME_PERCENT=95     # 旁路音量百分比 (0-100)

# 输入源选择（true/false）
USE_LINPUT1=true
USE_LINPUT2=false
USE_LINPUT3=true
USE_RINPUT1=false
USE_RINPUT2=false
USE_RINPUT3=false

# 功能开关
ENABLE_ADC_HIGH_PASS=false   # ADC高通滤波器
ENABLE_CAPTURE_ZC=true      # Capture零交叉
ENABLE_ALC=true            # 自动电平控制
ENABLE_NOISE_GATE=true     # 噪声门
ENABLE_HEADPHONE_ZC=true   # 耳机零交叉
ENABLE_SPEAKER_ZC=true     # 扬声器零交叉
ENABLE_PCM_MINUS_6DB=true  # PCM -6dB衰减

# ========== 计算实际值 ==========
# 录音相关计算
record_vol=$((RECORD_VOLUME_PERCENT * 255 / 100))
input_gain=$((INPUT_GAIN_PERCENT * 7 / 100))  # 0-7范围
adc_vol=$((ADC_VOLUME_PERCENT * 255 / 100))

# 播放相关计算
playback_vol=$((PLAYBACK_VOLUME_PERCENT * 255 / 100))
headphone_vol=$((HEADPHONE_VOLUME_PERCENT * 127 / 100))  # 0-127范围
speaker_vol=$((SPEAKER_VOLUME_PERCENT * 127 / 100))      # 0-127范围
bypass_vol=$((BYPASS_VOLUME_PERCENT * 127 / 100))        # 0-127范围

# 布尔值转换
adc_hp_value=$([ "$ENABLE_ADC_HIGH_PASS" = "true" ] && echo "on" || echo "off")
capture_zc_value=$([ "$ENABLE_CAPTURE_ZC" = "true" ] && echo "on" || echo "off")
alc_value=$([ "$ENABLE_ALC" = "true" ] && echo "on" || echo "off")
noise_gate_value=$([ "$ENABLE_NOISE_GATE" = "true" ] && echo "on" || echo "off")
headphone_zc_value=$([ "$ENABLE_HEADPHONE_ZC" = "true" ] && echo "on" || echo "off")
speaker_zc_value=$([ "$ENABLE_SPEAKER_ZC" = "true" ] && echo "on" || echo "off")
pcm_6db_value=$([ "$ENABLE_PCM_MINUS_6DB" = "true" ] && echo "on" || echo "off")

# ========== 配置执行 ==========
echo "=== WM8960音频配置 ==="
echo "配置参数:"
echo "- 录音: Capture=${RECORD_VOLUME_PERCENT}%($record_vol), 输入增益=${INPUT_GAIN_PERCENT}%($input_gain), ADC=${ADC_VOLUME_PERCENT}%($adc_vol)"
echo "- 播放: PCM=${PLAYBACK_VOLUME_PERCENT}%($playback_vol), 耳机=${HEADPHONE_VOLUME_PERCENT}%($headphone_vol)"

# 1. 重置输入开关
echo "1. 重置输入开关..."
amixer -c 0 cset numid=3,iface=MIXER,name='Capture Switch' off
amixer -c 0 cset numid=57,iface=MIXER,name='Left Boost Mixer LINPUT1 Switch' off
amixer -c 0 cset numid=55,iface=MIXER,name='Left Boost Mixer LINPUT2 Switch' off
amixer -c 0 cset numid=56,iface=MIXER,name='Left Boost Mixer LINPUT3 Switch' off
amixer -c 0 cset numid=54,iface=MIXER,name='Right Boost Mixer RINPUT1 Switch' off
amixer -c 0 cset numid=52,iface=MIXER,name='Right Boost Mixer RINPUT2 Switch' off
amixer -c 0 cset numid=53,iface=MIXER,name='Right Boost Mixer RINPUT3 Switch' off

# 2. 配置ADC
echo "2. 配置ADC..."
amixer -c 0 cset numid=19,iface=MIXER,name='ADC High Pass Filter Switch' $adc_hp_value
amixer -c 0 cset numid=36,iface=MIXER,name='ADC PCM Capture Volume' $adc_vol

# 3. 配置输入增益
echo "3. 配置输入增益..."
amixer -c 0 cset numid=9,iface=MIXER,name='Left Input Boost Mixer LINPUT1 Volume' $input_gain
amixer -c 0 cset numid=7,iface=MIXER,name='Left Input Boost Mixer LINPUT2 Volume' $input_gain
amixer -c 0 cset numid=6,iface=MIXER,name='Left Input Boost Mixer LINPUT3 Volume' $input_gain
amixer -c 0 cset numid=8,iface=MIXER,name='Right Input Boost Mixer RINPUT1 Volume' $input_gain
amixer -c 0 cset numid=5,iface=MIXER,name='Right Input Boost Mixer RINPUT2 Volume' $input_gain
amixer -c 0 cset numid=4,iface=MIXER,name='Right Input Boost Mixer RINPUT3 Volume' $input_gain
amixer -c 0 cset numid=51,iface=MIXER,name='Left Input Mixer Boost Switch' on
amixer -c 0 cset numid=50,iface=MIXER,name='Right Input Mixer Boost Switch' on

# 4. 选择输入源
echo "4. 选择输入源..."
if [ "$USE_LINPUT1" = "true" ]; then
    amixer -c 0 cset numid=57,iface=MIXER,name='Left Boost Mixer LINPUT1 Switch' on
fi
if [ "$USE_LINPUT2" = "true" ]; then
    amixer -c 0 cset numid=55,iface=MIXER,name='Left Boost Mixer LINPUT2 Switch' on
fi
if [ "$USE_LINPUT3" = "true" ]; then
    amixer -c 0 cset numid=56,iface=MIXER,name='Left Boost Mixer LINPUT3 Switch' on
fi
if [ "$USE_RINPUT1" = "true" ]; then
    amixer -c 0 cset numid=54,iface=MIXER,name='Right Boost Mixer RINPUT1 Switch' on
fi
if [ "$USE_RINPUT2" = "true" ]; then
    amixer -c 0 cset numid=52,iface=MIXER,name='Right Boost Mixer RINPUT2 Switch' on
fi
if [ "$USE_RINPUT3" = "true" ]; then
    amixer -c 0 cset numid=53,iface=MIXER,name='Right Boost Mixer RINPUT3 Switch' on
fi

# 5. 配置Capture通道
echo "5. 配置Capture通道..."
amixer -c 0 cset numid=2,iface=MIXER,name='Capture Volume ZC Switch' $capture_zc_value
amixer -c 0 cset numid=1,iface=MIXER,name='Capture Volume' $record_vol,$record_vol
amixer -c 0 cset numid=3,iface=MIXER,name='Capture Switch' on

# 6. 配置自动控制功能
echo "6. 配置自动控制..."
amixer -c 0 cset numid=26,iface=MIXER,name='ALC Function' $alc_value
amixer -c 0 cset numid=35,iface=MIXER,name='Noise Gate Switch' $noise_gate_value





mixer cset name='Capture Volume' 100,100
 
#PCM
amixer sset 'PCM Playback -6dB' on
amixer sset 'Playback' 255
amixer sset 'Right Output Mixer PCM' on
amixer sset 'Left Output Mixer PCM' on
 
#ADC PCM
amixer sset 'ADC PCM' 200
 
#Turn on Headphone
amixer sset 'Headphone Playback ZC' on
#Set the volume of your headphones(98% volume...127 is the MaxVolume)
amixer sset Headphone 125,125
#Turn on the speaker
amixer sset 'Speaker Playback ZC' on
#Set the volume of your Speaker(98% volume...127 is the MaxVolume)
amixer sset Speaker 125,125
#Set the volume of your Speaker AC(80% volume...100 is the MaxVolume)
amixer sset 'Speaker AC' 4
#Set the volume of your Speaker AC(80% volume...5 is the MaxVolume)
amixer sset 'Speaker DC' 4
 
#音频输入，左声道管理
#Turn on Left Input Mixer Boost
amixer sset 'Left Input Mixer Boost' on

#Turn on Left Boost Mixer LINPUT1
amixer sset 'Left Boost Mixer LINPUT1' on
amixer sset 'Left Input Boost Mixer LINPUT1' 3

#Turn off Left Boost Mixer LINPUT2
amixer sset 'Left Boost Mixer LINPUT2' off
amixer sset 'Left Input Boost Mixer LINPUT2' 0

#Turn on Left Boost Mixer LINPUT3
amixer sset 'Left Boost Mixer LINPUT3' on
amixer sset 'Left Input Boost Mixer LINPUT3' 7

#音频输入，右声道管理，全部关闭
#Turn on Right Input Mixer Boost
amixer sset 'Right Input Mixer Boost' off
amixer sset 'Right Boost Mixer RINPUT1' off
amixer sset 'Right Input Boost Mixer RINPUT2' 0
amixer sset 'Right Boost Mixer RINPUT2' off
amixer sset 'Right Input Boost Mixer RINPUT2' 0
amixer sset 'Right Boost Mixer RINPUT3' off
amixer sset 'Right Input Boost Mixer RINPUT3' 0
