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
amixer -c 0 cset numid=19,iface=MIXER,name='ADC High Pass Filter Switch' off
amixer -c 0 cset numid=36,iface=MIXER,name='ADC PCM Capture Volume' 200

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
amixer -c 0 cset numid=1,iface=MIXER,name='Capture Volume' 40
amixer -c 0 cset numid=3,iface=MIXER,name='Capture Switch' on

# 6. 配置自动控制功能
echo "6. 配置自动控制..."
amixer -c 0 cset numid=26,iface=MIXER,name='ALC Function' $alc_value
amixer -c 0 cset numid=34,iface=MIXER,name='Noise Gate Threshold' 12
amixer -c 0 cset numid=35,iface=MIXER,name='Noise Gate Switch' $noise_gate_value

# 7. 配置输出混合器
echo "7. 配置输出混合器..."
amixer -c 0 cset numid=47,iface=MIXER,name='Left Output Mixer PCM Playback Switch' on
amixer -c 0 cset numid=44,iface=MIXER,name='Right Output Mixer PCM Playback Switch' on

amixer -c 0 cset numid=42,iface=MIXER,name='Mono Output Mixer Left Switch' on
amixer -c 0 cset numid=43,iface=MIXER,name='Mono Output Mixer Right Switch' on

# 8. 配置输出音量
echo "8. 配置输出音量..."
amixer -c 0 cset numid=10,iface=MIXER,name='Playback Volume' $playback_vol 2>/dev/null

amixer -c 0 cset numid=11,iface=MIXER,name='Headphone Playback Volume' $headphone_vol 2>/dev/null
amixer -c 0 cset numid=12,iface=MIXER,name='Headphone Playback ZC Switch' $headphone_zc_value 2>/dev/null

amixer -c 0 cset numid=13,iface=MIXER,name='Speaker Playback Volume' $speaker_vol 2>/dev/null
amixer -c 0 cset numid=14,iface=MIXER,name='Speaker Playback ZC Switch' $speaker_zc_value 2>/dev/null
amixer -c 0 cset numid=15,iface=MIXER,name='Speaker DC Volume' 4
amixer -c 0 cset numid=16,iface=MIXER,name='Speaker AC Volume' 4

amixer -c 0 cset numid=17,iface=MIXER,name='PCM Playback -6dB Switch' $pcm_6db_value 2>/dev/null


amixer -c 0 cset numid=49,iface=MIXER,name='Left Output Mixer Boost Bypass Switch' off
amixer -c 0 cset numid=37,iface=MIXER,name='Left Output Mixer Boost Bypass Volume' $bypass_vol 2>/dev/null
amixer -c 0 cset numid=46,iface=MIXER,name='Right Output Mixer Boost Bypass Switch' off
amixer -c 0 cset numid=39,iface=MIXER,name='Right Output Mixer Boost Bypass Volume' $bypass_vol 2>/dev/null
amixer -c 0 cset numid=48,iface=MIXER,name='Left Output Mixer LINPUT3 Switch' off
amixer -c 0 cset numid=38,iface=MIXER,name='Left Output Mixer LINPUT3 Volume' $bypass_vol 2>/dev/null
amixer -c 0 cset numid=45,iface=MIXER,name='Right Output Mixer RINPUT3 Switch' off
amixer -c 0 cset numid=40,iface=MIXER,name='Right Output Mixer RINPUT3 Volume' $bypass_vol 2>/dev/null

echo "=== 配置完成 ==="
echo ""
echo "当前配置摘要:"
echo "输入源: LINPUT1=$USE_LINPUT1, LINPUT2=$USE_LINPUT2, LINPUT3=$USE_LINPUT3"
echo "        RINPUT1=$USE_RINPUT1, RINPUT2=$USE_RINPUT2, RINPUT3=$USE_RINPUT3"
echo "录音音量: Capture=${RECORD_VOLUME_PERCENT}%, 输入增益=${INPUT_GAIN_PERCENT}%, ADC=${ADC_VOLUME_PERCENT}%"
echo "播放音量: PCM=${PLAYBACK_VOLUME_PERCENT}%, 耳机=${HEADPHONE_VOLUME_PERCENT}%, 扬声器=${SPEAKER_VOLUME_PERCENT}%"
