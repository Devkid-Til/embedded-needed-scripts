#!/bin/sh

# ========== 用户可配置参数 ==========
# 录音设置
RECORD_VOLUME_PERCENT=80     # 降低录音音量，减少反馈
INPUT_GAIN_PERCENT=80        # 降低输入增益
ADC_VOLUME_PERCENT=80

# 播放设置
PLAYBACK_VOLUME_PERCENT=80   # 降低播放音量
HEADPHONE_VOLUME_PERCENT=80
SPEAKER_VOLUME_PERCENT=80
BYPASS_VOLUME_PERCENT=50     # 大幅降低旁路音量

# 输入源选择（简化）
USE_LINPUT1=true
USE_LINPUT2=false
USE_LINPUT3=false           # 关闭LINPUT3，可能干扰输出
USE_RINPUT1=false
USE_RINPUT2=false
USE_RINPUT3=false

# 功能开关
ENABLE_ADC_HIGH_PASS=true   # 启用高通滤波，减少低频噪音
ENABLE_CAPTURE_ZC=false
ENABLE_ALC=false
ENABLE_NOISE_GATE=true      # 启用噪声门
ENABLE_HEADPHONE_ZC=false
ENABLE_PCM_MINUS_6DB=false
ENABLE_SPEAKER_ZC=false     # 关闭扬声器零交叉，可能引起噪音

# ========== 计算实际值 ==========
record_vol=$((RECORD_VOLUME_PERCENT * 255 / 100))
input_gain=$((INPUT_GAIN_PERCENT * 3 / 100))   # 限制最大增益为3
adc_vol=$((ADC_VOLUME_PERCENT * 255 / 100))

playback_vol=$((PLAYBACK_VOLUME_PERCENT * 255 / 100))
headphone_vol=$((HEADPHONE_VOLUME_PERCENT * 100 / 100))  # 限制最大值
speaker_vol=$((SPEAKER_VOLUME_PERCENT * 100 / 100))
bypass_vol=$((BYPASS_VOLUME_PERCENT * 3 / 100))          # 限制最大值

# 扬声器放大器（降低值以减少噪音）
speaker_dc_vol=3   # 从5降低到3
speaker_ac_vol=3   # 从5降低到3

# 布尔值转换
adc_hp_value=$([ "$ENABLE_ADC_HIGH_PASS" = "true" ] && echo "on" || echo "off")
capture_zc_value=$([ "$ENABLE_CAPTURE_ZC" = "true" ] && echo "on" || echo "off")
alc_value=$([ "$ENABLE_ALC" = "true" ] && echo "on" || echo "off")
noise_gate_value=$([ "$ENABLE_NOISE_GATE" = "true" ] && echo "on" || echo "off")
headphone_zc_value=$([ "$ENABLE_HEADPHONE_ZC" = "true" ] && echo "on" || echo "off")
pcm_6db_value=$([ "$ENABLE_PCM_MINUS_6DB" = "true" ] && echo "on" || echo "off")
speaker_zc_value=$([ "$ENABLE_SPEAKER_ZC" = "true" ] && echo "on" || echo "off")

# ========== 配置执行 ==========
echo "=== 配置WM8960（优化防噪音版） ==="

# 1. 首先静音所有输出
echo "1. 静音所有输出..."
amixer -c 0 cset numid=13,iface=MIXER,name='Speaker Playback Volume' 0 2>/dev/null
amixer -c 0 cset numid=11,iface=MIXER,name='Headphone Playback Volume' 0 2>/dev/null
amixer -c 0 cset numid=10,iface=MIXER,name='Playback Volume' 0 2>/dev/null

# 2. 重置输入开关
echo "2. 重置输入开关..."
amixer -c 0 cset numid=3,iface=MIXER,name='Capture Switch' off 2>/dev/null
amixer -c 0 cset numid=57,iface=MIXER,name='Left Boost Mixer LINPUT1 Switch' off 2>/dev/null
amixer -c 0 cset numid=55,iface=MIXER,name='Left Boost Mixer LINPUT2 Switch' off 2>/dev/null
amixer -c 0 cset numid=56,iface=MIXER,name='Left Boost Mixer LINPUT3 Switch' off 2>/dev/null
amixer -c 0 cset numid=54,iface=MIXER,name='Right Boost Mixer RINPUT1 Switch' off 2>/dev/null
amixer -c 0 cset numid=52,iface=MIXER,name='Right Boost Mixer RINPUT2 Switch' off 2>/dev/null
amixer -c 0 cset numid=53,iface=MIXER,name='Right Boost Mixer RINPUT3 Switch' off 2>/dev/null

# 3. 配置ADC
echo "3. 配置ADC..."
amixer -c 0 cset numid=19,iface=MIXER,name='ADC High Pass Filter Switch' $adc_hp_value 2>/dev/null
amixer -c 0 cset numid=36,iface=MIXER,name='ADC PCM Capture Volume' $adc_vol 2>/dev/null
amixer -c 0 cset numid=41,iface=MIXER,name='ADC Data Output Select' 0 2>/dev/null

# 4. 配置输入增益（降低值）
echo "4. 配置输入增益..."
amixer -c 0 cset numid=9,iface=MIXER,name='Left Input Boost Mixer LINPUT1 Volume' $input_gain 2>/dev/null
amixer -c 0 cset numid=7,iface=MIXER,name='Left Input Boost Mixer LINPUT2 Volume' 0 2>/dev/null
amixer -c 0 cset numid=6,iface=MIXER,name='Left Input Boost Mixer LINPUT3 Volume' 0 2>/dev/null
amixer -c 0 cset numid=8,iface=MIXER,name='Right Input Boost Mixer RINPUT1 Volume' 0 2>/dev/null
amixer -c 0 cset numid=5,iface=MIXER,name='Right Input Boost Mixer RINPUT2 Volume' 0 2>/dev/null
amixer -c 0 cset numid=4,iface=MIXER,name='Right Input Boost Mixer RINPUT3 Volume' 0 2>/dev/null

amixer -c 0 cset numid=51,iface=MIXER,name='Left Input Mixer Boost Switch' on 2>/dev/null
amixer -c 0 cset numid=50,iface=MIXER,name='Right Input Mixer Boost Switch' on 2>/dev/null

# 5. 选择输入源（只启用必要的）
echo "5. 选择输入源..."
[ "$USE_LINPUT1" = "true" ] && amixer -c 0 cset numid=57,iface=MIXER,name='Left Boost Mixer LINPUT1 Switch' on 2>/dev/null
[ "$USE_LINPUT2" = "true" ] && amixer -c 0 cset numid=55,iface=MIXER,name='Left Boost Mixer LINPUT2 Switch' on 2>/dev/null
[ "$USE_LINPUT3" = "true" ] && amixer -c 0 cset numid=56,iface=MIXER,name='Left Boost Mixer LINPUT3 Switch' on 2>/dev/null

# 6. 配置Capture通道
echo "6. 配置Capture通道..."
amixer -c 0 cset numid=2,iface=MIXER,name='Capture Volume ZC Switch' $capture_zc_value 2>/dev/null
amixer -c 0 cset numid=1,iface=MIXER,name='Capture Volume' $record_vol,$record_vol 2>/dev/null
amixer -c 0 cset numid=3,iface=MIXER,name='Capture Switch' off 2>/dev/null  # 保持关闭状态

# 7. 配置自动控制功能
echo "7. 配置自动控制功能..."
amixer -c 0 cset numid=26,iface=MIXER,name='ALC Function' $alc_value 2>/dev/null
amixer -c 0 cset numid=35,iface=MIXER,name='Noise Gate Switch' $noise_gate_value 2>/dev/null

# 8. 配置输出混合器（简化配置，避免冲突）
echo "8. 配置输出混合器（简化防冲突）..."
# 只启用PCM播放混合器，关闭其他可能冲突的路径
amixer -c 0 cset numid=47,iface=MIXER,name='Left Output Mixer PCM Playback Switch' on 2>/dev/null
amixer -c 0 cset numid=44,iface=MIXER,name='Right Output Mixer PCM Playback Switch' on 2>/dev/null

# 关闭其他输出混合器（防止信号冲突）
amixer -c 0 cset numid=49,iface=MIXER,name='Left Output Mixer Boost Bypass Switch' off 2>/dev/null
amixer -c 0 cset numid=46,iface=MIXER,name='Right Output Mixer Boost Bypass Switch' off 2>/dev/null
amixer -c 0 cset numid=48,iface=MIXER,name='Left Output Mixer LINPUT3 Switch' off 2>/dev/null
amixer -c 0 cset numid=45,iface=MIXER,name='Right Output Mixer RINPUT3 Switch' off 2>/dev/null

# 启用单声道混合器（解决单声道PCM问题）
amixer -c 0 cset numid=42,iface=MIXER,name='Mono Output Mixer Left Switch' on 2>/dev/null
amixer -c 0 cset numid=43,iface=MIXER,name='Mono Output Mixer Right Switch' on 2>/dev/null

# 关闭所有旁路音量
amixer -c 0 cset numid=37,iface=MIXER,name='Left Output Mixer Boost Bypass Volume' 0 2>/dev/null
amixer -c 0 cset numid=39,iface=MIXER,name='Right Output Mixer Boost Bypass Volume' 0 2>/dev/null
amixer -c 0 cset numid=38,iface=MIXER,name='Left Output Mixer LINPUT3 Volume' 0 2>/dev/null
amixer -c 0 cset numid=40,iface=MIXER,name='Right Output Mixer RINPUT3 Volume' 0 2>/dev/null

# 9. 配置输出音量（最后设置音量）
echo "9. 配置输出音量..."
amixer -c 0 cset numid=10,iface=MIXER,name='Playback Volume' $playback_vol 2>/dev/null
amixer -c 0 cset numid=11,iface=MIXER,name='Headphone Playback Volume' $headphone_vol 2>/dev/null
amixer -c 0 cset numid=12,iface=MIXER,name='Headphone Playback ZC Switch' $headphone_zc_value 2>/dev/null
amixer -c 0 cset numid=13,iface=MIXER,name='Speaker Playback Volume' $speaker_vol 2>/dev/null
amixer -c 0 cset numid=14,iface=MIXER,name='Speaker Playback ZC Switch' $speaker_zc_value 2>/dev/null
amixer -c 0 cset numid=15,iface=MIXER,name='Speaker DC Volume' $speaker_dc_vol 2>/dev/null
amixer -c 0 cset numid=16,iface=MIXER,name='Speaker AC Volume' $speaker_ac_vol 2>/dev/null
amixer -c 0 cset numid=17,iface=MIXER,name='PCM Playback -6dB Switch' $pcm_6db_value 2>/dev/null

echo "=== 配置完成 ==="
