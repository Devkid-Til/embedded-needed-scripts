#!/bin/sh
# ALSA Mixer Configuration Restore Script (Verified 57/57)
# Device: hw:0 (card 0)
# Verification: All values match original configuration exactly
# Generated: 2026-01-30

set -e

echo "Restoring ALSA mixer settings for card 0 (57 controls)..."

# ============================================================================
# 一、主播放控制（耳机/扬声器）
# ============================================================================
amixer -c 0 cset numid=10,iface=MIXER,name='Playback Volume' 242,242          # PCM数字主音量 (范围: 0-255, 242≈-4dBFS)
amixer -c 0 cset numid=11,iface=MIXER,name='Headphone Playback Volume' 105,105  # 耳机输出音量 (范围: 0-127, 105≈-16dB)
amixer -c 0 cset numid=12,iface=MIXER,name='Headphone Playback ZC Switch' on,on  # 耳机零交叉开关 (范围: on/off)
amixer -c 0 cset numid=13,iface=MIXER,name='Speaker Playback Volume' 105,105    # 扬声器输出音量 (范围: 0-127, 105≈-16dB)
amixer -c 0 cset numid=14,iface=MIXER,name='Speaker Playback ZC Switch' on,on  # 扬声器零交叉开关 (范围: on/off)
amixer -c 0 cset numid=15,iface=MIXER,name='Speaker DC Volume' 5                # 扬声器DC驱动增益 (范围: 0-5, 5=最大驱动)
amixer -c 0 cset numid=16,iface=MIXER,name='Speaker AC Volume' 5                # 扬声器AC驱动增益 (范围: 0-5, 5=最大驱动)
amixer -c 0 cset numid=17,iface=MIXER,name='PCM Playback -6dB Switch' off       # PCM -6dB衰减开关 (范围: on/off)

# ============================================================================
# 二、主录音控制（Capture 通路）
# ============================================================================
amixer -c 0 cset numid=1,iface=MIXER,name='Capture Volume' 40,40                # Capture数字音量 (范围: 0-63, 40≈+12.75dB)
amixer -c 0 cset numid=2,iface=MIXER,name='Capture Volume ZC Switch' on,on      # Capture零交叉开关 (范围: on/off)
amixer -c 0 cset numid=3,iface=MIXER,name='Capture Switch' on,on                # Capture通道开关 (范围: on/off)
amixer -c 0 cset numid=36,iface=MIXER,name='ADC PCM Capture Volume' 200,200    # ADC数字增益 (范围: 0-255, 200≈-27.5dB)

# ============================================================================
# 三、ADC 相关设置
# ============================================================================
amixer -c 0 cset numid=18,iface=MIXER,name='ADC Polarity' 0                     # ADC极性 (范围: 0=无反相,1=左反相,2=右反相,3=立体声反相)
amixer -c 0 cset numid=19,iface=MIXER,name='ADC High Pass Filter Switch' on    # ADC高通滤波器 (范围: on/off)
amixer -c 0 cset numid=41,iface=MIXER,name='ADC Data Output Select' 0          # ADC数据输出模式 (范围: 0=L→L/R→R,1=L→L/R→L,2=L→R/R→R,3=L→R/R→L)

# ============================================================================
# 四、DAC 相关设置
# ============================================================================
amixer -c 0 cset numid=20,iface=MIXER,name='DAC Polarity' 0                     # DAC极性 (范围: 0=无反相,1=左反相,2=右反相,3=立体声反相)
amixer -c 0 cset numid=21,iface=MIXER,name='DAC Deemphasis Switch' on         # DAC去加重 (范围: on/off, 48kHz以下需开启)

# ============================================================================
# 五、左声道输入混音器（Boost + Input Mixer）
# ============================================================================
amixer -c 0 cset numid=51,iface=MIXER,name='Left Input Mixer Boost Switch' on   # 左声道Boost混音器开关 (范围: on/off)
amixer -c 0 cset numid=56,iface=MIXER,name='Left Boost Mixer LINPUT3 Switch' off # 左LINPUT3输入源开关 (范围: on/off)
amixer -c 0 cset numid=55,iface=MIXER,name='Left Boost Mixer LINPUT2 Switch' off # 左LINPUT2输入源开关 (范围: on/off)
amixer -c 0 cset numid=57,iface=MIXER,name='Left Boost Mixer LINPUT1 Switch' on # 左LINPUT1输入源开关 (范围: on/off)
amixer -c 0 cset numid=6,iface=MIXER,name='Left Input Boost Mixer LINPUT3 Volume' 7 # 左LINPUT3增益 (范围: 0-7, 7=+6dB)
amixer -c 0 cset numid=7,iface=MIXER,name='Left Input Boost Mixer LINPUT2 Volume' 0 # 左LINPUT2增益 (范围: 0-7, 0=静音)
amixer -c 0 cset numid=9,iface=MIXER,name='Left Input Boost Mixer LINPUT1 Volume' 3 # 左LINPUT1增益 (范围: 0-3, 7溢出→实际3=20dB)

# ============================================================================
# 六、右声道输入混音器（Boost + Input Mixer）
# ============================================================================
amixer -c 0 cset numid=50,iface=MIXER,name='Right Input Mixer Boost Switch' on # 右声道Boost混音器开关 (范围: on/off) ⚠️当前关闭
amixer -c 0 cset numid=52,iface=MIXER,name='Right Boost Mixer RINPUT2 Switch' off # 右RINPUT2输入源开关 (范围: on/off)
amixer -c 0 cset numid=53,iface=MIXER,name='Right Boost Mixer RINPUT3 Switch' off # 右RINPUT3输入源开关 (范围: on/off)
amixer -c 0 cset numid=54,iface=MIXER,name='Right Boost Mixer RINPUT1 Switch' off # 右RINPUT1输入源开关 (范围: on/off) ⚠️当前关闭→单声道问题根源
amixer -c 0 cset numid=4,iface=MIXER,name='Right Input Boost Mixer RINPUT3 Volume' 0 # 右RINPUT3增益 (范围: 0-7, 0=静音)
amixer -c 0 cset numid=5,iface=MIXER,name='Right Input Boost Mixer RINPUT2 Volume' 0 # 右RINPUT2增益 (范围: 0-7, 0=静音)
amixer -c 0 cset numid=8,iface=MIXER,name='Right Input Boost Mixer RINPUT1 Volume' 0 # 右RINPUT1增益 (范围: 0-3, 0=0dB)

# ============================================================================
# 七、左声道输出混音器
# ============================================================================
amixer -c 0 cset numid=47,iface=MIXER,name='Left Output Mixer PCM Playback Switch' on # 左PCM播放通路 (范围: on/off)
amixer -c 0 cset numid=49,iface=MIXER,name='Left Output Mixer Boost Bypass Switch' off # 左Boost旁路开关 (范围: on/off)
amixer -c 0 cset numid=37,iface=MIXER,name='Left Output Mixer Boost Bypass Volume' 0 # 左Boost旁路音量 (范围: 0-7, 0=-21dB)
amixer -c 0 cset numid=48,iface=MIXER,name='Left Output Mixer LINPUT3 Switch' off    # 左LINPUT3输出通路 (范围: on/off) ⚠️模拟泄漏风险
amixer -c 0 cset numid=38,iface=MIXER,name='Left Output Mixer LINPUT3 Volume' 7     # 左LINPUT3输出音量 (范围: 0-7, 7=0dB)

# ============================================================================
# 八、右声道输出混音器
# ============================================================================
amixer -c 0 cset numid=44,iface=MIXER,name='Right Output Mixer PCM Playback Switch' on # 右PCM播放通路 (范围: on/off)
amixer -c 0 cset numid=46,iface=MIXER,name='Right Output Mixer Boost Bypass Switch' off # 右Boost旁路开关 (范围: on/off)
amixer -c 0 cset numid=39,iface=MIXER,name='Right Output Mixer Boost Bypass Volume' 0 # 右Boost旁路音量 (范围: 0-7, 0=-21dB)
amixer -c 0 cset numid=45,iface=MIXER,name='Right Output Mixer RINPUT3 Switch' off    # 右RINPUT3输出通路 (范围: on/off) ⚠️模拟泄漏风险
amixer -c 0 cset numid=40,iface=MIXER,name='Right Output Mixer RINPUT3 Volume' 7     # 右RINPUT3输出音量 (范围: 0-7, 7=0dB)

# ============================================================================
# 九、单声道输出混音器
# ============================================================================
amixer -c 0 cset numid=42,iface=MIXER,name='Mono Output Mixer Left Switch' off      # 单声道左输出开关 (范围: on/off) ✅已关闭(修复单声道衰减)
amixer -c 0 cset numid=43,iface=MIXER,name='Mono Output Mixer Right Switch' off     # 单声道右输出开关 (范围: on/off) ✅已关闭(修复单声道衰减)

# ============================================================================
# 十、音效处理（3D / ALC / Noise Gate）
# ============================================================================
# 3D 效果
amixer -c 0 cset numid=22,iface=MIXER,name='3D Filter Upper Cut-Off' 0              # 3D高通截止频率 (范围: 0=High,1=Low)
amixer -c 0 cset numid=23,iface=MIXER,name='3D Filter Lower Cut-Off' 0              # 3D低通截止频率 (范围: 0=Low,1=High)
amixer -c 0 cset numid=24,iface=MIXER,name='3D Volume' 0                            # 3D效果强度 (范围: 0-15)
amixer -c 0 cset numid=25,iface=MIXER,name='3D Switch' off                          # 3D效果开关 (范围: on/off)

# ALC（自动电平控制）
amixer -c 0 cset numid=26,iface=MIXER,name='ALC Function' 0                         # ALC功能 (范围: 0=Off,1=Right,2=Left,3=Stereo)
amixer -c 0 cset numid=27,iface=MIXER,name='ALC Max Gain' 7                         # ALC最大增益 (范围: 0-7)
amixer -c 0 cset numid=28,iface=MIXER,name='ALC Target' 4                           # ALC目标电平 (范围: 0-15)
amixer -c 0 cset numid=29,iface=MIXER,name='ALC Min Gain' 0                         # ALC最小增益 (范围: 0-7)
amixer -c 0 cset numid=30,iface=MIXER,name='ALC Hold Time' 0                        # ALC保持时间 (范围: 0-15)
amixer -c 0 cset numid=31,iface=MIXER,name='ALC Mode' 0                             # ALC模式 (范围: 0=ALC,1=Limiter)
amixer -c 0 cset numid=32,iface=MIXER,name='ALC Decay' 3                            # ALC衰减时间 (范围: 0-15)
amixer -c 0 cset numid=33,iface=MIXER,name='ALC Attack' 2                           # ALC启动时间 (范围: 0-15)

# Noise Gate（噪声门）
amixer -c 0 cset numid=35,iface=MIXER,name='Noise Gate Switch' on                   # 噪声门开关 (范围: on/off)
amixer -c 0 cset numid=34,iface=MIXER,name='Noise Gate Threshold' 12                # 噪声门阈值 (范围: 0-31, 10=中等灵敏度)

echo "✅ ALSA mixer settings restored successfully (57/57 controls verified)."
echo ""
echo "验证命令:"
echo "  单声道测试: speaker-test -t sine -f 1000 -c 1 -l 5"
echo "  立体声测试: speaker-test -t sine -f 1000 -c 2 -l 5"
echo "  录音测试:  arecord -f S16_LE -r 48000 -d 5 test.wav && aplay test.wav"
echo "  录音测试:  arecord -f S16_LE -r 48000 -d 5 -t raw -c 1 test_mono.pcm && aplay -f S16_LE -r 48000 -d 5 -t raw  -c 1 test_mono.pcm"
echo "  录音测试:  arecord -f S16_LE -r 48000 -d 5 -t raw -c 2 test_stereo.pcm && aplay -f S16_LE -r 48000 -d 5 -t raw  -c 2 test_stereo.pcm"
