
 "=== 完全重置WM8960音频设置 ==="

# 1. 立即静音所有输出
echo "1. 静音所有音频输出..."
amixer -c 0 cset numid=13,iface=MIXER,name='Speaker Playback Volume' 0
amixer -c 0 cset numid=11,iface=MIXER,name='Headphone Playback Volume' 0
amixer -c 0 cset numid=10,iface=MIXER,name='Playback Volume' 0

# 2. 关闭所有开关和混合器
echo "2. 关闭所有开关和混合器..."
# 关闭所有输出混合器
amixer -c 0 cset numid=47,iface=MIXER,name='Left Output Mixer PCM Playback Switch' off
amixer -c 0 cset numid=44,iface=MIXER,name='Right Output Mixer PCM Playback Switch' off
amixer -c 0 cset numid=49,iface=MIXER,name='Left Output Mixer Boost Bypass Switch' off
amixer -c 0 cset numid=46,iface=MIXER,name='Right Output Mixer Boost Bypass Switch' off
amixer -c 0 cset numid=48,iface=MIXER,name='Left Output Mixer LINPUT3 Switch' off
amixer -c 0 cset numid=45,iface=MIXER,name='Right Output Mixer RINPUT3 Switch' off
amixer -c 0 cset numid=42,iface=MIXER,name='Mono Output Mixer Left Switch' off
amixer -c 0 cset numid=43,iface=MIXER,name='Mono Output Mixer Right Switch' off

# 关闭所有输入混合器
amixer -c 0 cset numid=57,iface=MIXER,name='Left Boost Mixer LINPUT1 Switch' off
amixer -c 0 cset numid=55,iface=MIXER,name='Left Boost Mixer LINPUT2 Switch' off
amixer -c 0 cset numid=56,iface=MIXER,name='Left Boost Mixer LINPUT3 Switch' off
amixer -c 0 cset numid=54,iface=MIXER,name='Right Boost Mixer RINPUT1 Switch' off
amixer -c 0 cset numid=52,iface=MIXER,name='Right Boost Mixer RINPUT2 Switch' off
amixer -c 0 cset numid=53,iface=MIXER,name='Right Boost Mixer RINPUT3 Switch' off
amixer -c 0 cset numid=51,iface=MIXER,name='Left Input Mixer Boost Switch' off
amixer -c 0 cset numid=50,iface=MIXER,name='Right Input Mixer Boost Switch' off

# 关闭录音通道
amixer -c 0 cset numid=3,iface=MIXER,name='Capture Switch' off

# 3. 重置所有音量到中等水平
echo "3. 重置所有音量..."
# 录音音量设为中等
amixer -c 0 cset numid=1,iface=MIXER,name='Capture Volume' 128,128
amixer -c 0 cset numid=36,iface=MIXER,name='ADC PCM Capture Volume' 128

# 播放音量设为中等
amixer -c 0 cset numid=10,iface=MIXER,name='Playback Volume' 128
amixer -c 0 cset numid=11,iface=MIXER,name='Headphone Playback Volume' 64
amixer -c 0 cset numid=13,iface=MIXER,name='Speaker Playback Volume' 64

# 扬声器放大器设为安全值
amixer -c 0 cset numid=15,iface=MIXER,name='Speaker DC Volume' 2
amixer -c 0 cset numid=16,iface=MIXER,name='Speaker AC Volume' 2

# 输入增益设为最低
amixer -c 0 cset numid=9,iface=MIXER,name='Left Input Boost Mixer LINPUT1 Volume' 0
amixer -c 0 cset numid=7,iface=MIXER,name='Left Input Boost Mixer LINPUT2 Volume' 0
amixer -c 0 cset numid=6,iface=MIXER,name='Left Input Boost Mixer LINPUT3 Volume' 0
amixer -c 0 cset numid=8,iface=MIXER,name='Right Input Boost Mixer RINPUT1 Volume' 0
amixer -c 0 cset numid=5,iface=MIXER,name='Right Input Boost Mixer RINPUT2 Volume' 0
amixer -c 0 cset numid=4,iface=MIXER,name='Right Input Boost Mixer RINPUT3 Volume' 0

# 旁路音量设为0
amixer -c 0 cset numid=37,iface=MIXER,name='Left Output Mixer Boost Bypass Volume' 0
amixer -c 0 cset numid=39,iface=MIXER,name='Right Output Mixer Boost Bypass Volume' 0
amixer -c 0 cset numid=38,iface=MIXER,name='Left Output Mixer LINPUT3 Volume' 0
amixer -c 0 cset numid=40,iface=MIXER,name='Right Output Mixer RINPUT3 Volume' 0

# 4. 关闭所有功能开关
echo "4. 关闭所有功能开关..."
amixer -c 0 cset numid=19,iface=MIXER,name='ADC High Pass Filter Switch' off
amixer -c 0 cset numid=2,iface=MIXER,name='Capture Volume ZC Switch' off
amixer -c 0 cset numid=12,iface=MIXER,name='Headphone Playback ZC Switch' off
amixer -c 0 cset numid=14,iface=MIXER,name='Speaker Playback ZC Switch' off
amixer -c 0 cset numid=17,iface=MIXER,name='PCM Playback -6dB Switch' off
amixer -c 0 cset numid=26,iface=MIXER,name='ALC Function' off
amixer -c 0 cset numid=35,iface=MIXER,name='Noise Gate Switch' off

# 5. 设置ADC为默认状态
echo "5. 重置ADC设置..."
amixer -c 0 cset numid=41,iface=MIXER,name='ADC Data Output Select' 0
amixer -c 0 cset numid=18,iface=MIXER,name='ADC Polarity' 0

echo "=== WM8960已完全重置 ==="
echo "当前状态：所有功能关闭，音量中等"
