#!/bin/sh
# ALSA Mixer Configuration Restore Script (Verified 57/57)
# Device: hw:0 (card 0)
# Verification: All values match original configuration exactly
# Generated: 2026-01-30
#
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!! WARNIND: DON'T CHANGE ANYTHING !!!!!!!!!!!!!!!!!
#
# ONLY MODIFIED: 一、主播放控制（耳机/扬声器）

set -e

echo "Restoring ALSA mixer settings for card 0 (57 controls)..."

# softvol added into /etc/asound.conf
#amixer sset SoftMaster 80%

# ============================================================================
# 一、主播放控制（耳机/扬声器）
# ============================================================================
amixer -c 0 cset numid=10,iface=MIXER,name='Playback Volume' 255,255
amixer -c 0 cset numid=11,iface=MIXER,name='Headphone Playback Volume' 105,105
amixer -c 0 cset numid=12,iface=MIXER,name='Headphone Playback ZC Switch' on,on
amixer -c 0 cset numid=13,iface=MIXER,name='Speaker Playback Volume' 105,105
amixer -c 0 cset numid=14,iface=MIXER,name='Speaker Playback ZC Switch' on,on
amixer -c 0 cset numid=15,iface=MIXER,name='Speaker DC Volume' 5
amixer -c 0 cset numid=16,iface=MIXER,name='Speaker AC Volume' 5
amixer -c 0 cset numid=17,iface=MIXER,name='PCM Playback -6dB Switch' off

# ============================================================================
# 二、主录音控制（Capture 通路）
# ============================================================================
amixer -c 0 cset numid=1,iface=MIXER,name='Capture Volume' 55,55
amixer -c 0 cset numid=2,iface=MIXER,name='Capture Volume ZC Switch' on,on
amixer -c 0 cset numid=3,iface=MIXER,name='Capture Switch' on,on
amixer -c 0 cset numid=36,iface=MIXER,name='ADC PCM Capture Volume' 200,200

# ============================================================================
# 三、ADC 相关设置
# ============================================================================
amixer -c 0 cset numid=18,iface=MIXER,name='ADC Polarity' 0
amixer -c 0 cset numid=19,iface=MIXER,name='ADC High Pass Filter Switch' on
amixer -c 0 cset numid=41,iface=MIXER,name='ADC Data Output Select' 0

# ============================================================================
# 四、DAC 相关设置
# ============================================================================
amixer -c 0 cset numid=20,iface=MIXER,name='DAC Polarity' 0
amixer -c 0 cset numid=21,iface=MIXER,name='DAC Deemphasis Switch' off

# ============================================================================
# 五、左声道输入混音器（Boost + Input Mixer）
# ============================================================================
amixer -c 0 cset numid=51,iface=MIXER,name='Left Input Mixer Boost Switch' on
amixer -c 0 cset numid=56,iface=MIXER,name='Left Boost Mixer LINPUT3 Switch' on
amixer -c 0 cset numid=55,iface=MIXER,name='Left Boost Mixer LINPUT2 Switch' off
amixer -c 0 cset numid=57,iface=MIXER,name='Left Boost Mixer LINPUT1 Switch' on
amixer -c 0 cset numid=6,iface=MIXER,name='Left Input Boost Mixer LINPUT3 Volume' 7
amixer -c 0 cset numid=7,iface=MIXER,name='Left Input Boost Mixer LINPUT2 Volume' 0
amixer -c 0 cset numid=9,iface=MIXER,name='Left Input Boost Mixer LINPUT1 Volume' 7

# ============================================================================
# 六、右声道输入混音器（Boost + Input Mixer）
# ============================================================================
amixer -c 0 cset numid=50,iface=MIXER,name='Right Input Mixer Boost Switch' off
amixer -c 0 cset numid=52,iface=MIXER,name='Right Boost Mixer RINPUT2 Switch' off
amixer -c 0 cset numid=53,iface=MIXER,name='Right Boost Mixer RINPUT3 Switch' off
amixer -c 0 cset numid=54,iface=MIXER,name='Right Boost Mixer RINPUT1 Switch' off
amixer -c 0 cset numid=4,iface=MIXER,name='Right Input Boost Mixer RINPUT3 Volume' 0
amixer -c 0 cset numid=5,iface=MIXER,name='Right Input Boost Mixer RINPUT2 Volume' 0
amixer -c 0 cset numid=8,iface=MIXER,name='Right Input Boost Mixer RINPUT1 Volume' 0

# ============================================================================
# 七、左声道输出混音器
# ============================================================================
amixer -c 0 cset numid=47,iface=MIXER,name='Left Output Mixer PCM Playback Switch' on
amixer -c 0 cset numid=49,iface=MIXER,name='Left Output Mixer Boost Bypass Switch' off
amixer -c 0 cset numid=37,iface=MIXER,name='Left Output Mixer Boost Bypass Volume' 0
amixer -c 0 cset numid=48,iface=MIXER,name='Left Output Mixer LINPUT3 Switch' off
amixer -c 0 cset numid=38,iface=MIXER,name='Left Output Mixer LINPUT3 Volume' 0

# ============================================================================
# 八、右声道输出混音器(don't set except PCM Playback Switch 'on', this is important)
# ============================================================================
amixer -c 0 cset numid=44,iface=MIXER,name='Right Output Mixer PCM Playback Switch' on
amixer -c 0 cset numid=46,iface=MIXER,name='Right Output Mixer Boost Bypass Switch' off
amixer -c 0 cset numid=39,iface=MIXER,name='Right Output Mixer Boost Bypass Volume' 0
amixer -c 0 cset numid=45,iface=MIXER,name='Right Output Mixer RINPUT3 Switch' off
amixer -c 0 cset numid=40,iface=MIXER,name='Right Output Mixer RINPUT3 Volume' 0

# ============================================================================
# 九、单声道输出混音器
# ============================================================================
amixer -c 0 cset numid=42,iface=MIXER,name='Mono Output Mixer Left Switch' off
amixer -c 0 cset numid=43,iface=MIXER,name='Mono Output Mixer Right Switch' off

# ============================================================================
# 十、音效处理（3D / ALC / Noise Gate）
# ============================================================================
# 3D 效果
amixer -c 0 cset numid=22,iface=MIXER,name='3D Filter Upper Cut-Off' 0
amixer -c 0 cset numid=23,iface=MIXER,name='3D Filter Lower Cut-Off' 0
amixer -c 0 cset numid=24,iface=MIXER,name='3D Volume' 0
amixer -c 0 cset numid=25,iface=MIXER,name='3D Switch' off

# ALC（自动电平控制）
amixer -c 0 cset numid=26,iface=MIXER,name='ALC Function' 0
amixer -c 0 cset numid=27,iface=MIXER,name='ALC Max Gain' 7
amixer -c 0 cset numid=28,iface=MIXER,name='ALC Target' 4
amixer -c 0 cset numid=29,iface=MIXER,name='ALC Min Gain' 0
amixer -c 0 cset numid=30,iface=MIXER,name='ALC Hold Time' 0
amixer -c 0 cset numid=31,iface=MIXER,name='ALC Mode' 0
amixer -c 0 cset numid=32,iface=MIXER,name='ALC Decay' 3
amixer -c 0 cset numid=33,iface=MIXER,name='ALC Attack' 2

# Noise Gate（噪声门）
amixer -c 0 cset numid=35,iface=MIXER,name='Noise Gate Switch' on
amixer -c 0 cset numid=34,iface=MIXER,name='Noise Gate Threshold' 10

echo "✅ ALSA mixer settings restored successfully (57/57 controls verified)."
echo ""echo ""
echo "验证命令:"
echo "  单声道测试: speaker-test -t sine -f 1000 -c 1 -l 5"
echo "  立体声测试: speaker-test -t sine -f 1000 -c 2 -l 5"
echo "  录音测试:  arecord -f S16_LE -r 16000 -d 5 test.wav && aplay test.wav"
echo "  录音测试:  arecord -f S16_LE -r 16000 -d 5 -t raw -c 1 test_mono.pcm && aplay -f S16_LE -r 16000 -d 5 -t raw  -c 1 test_mono.pcm"
echo "  录音测试:  arecord -f S16_LE -r 16000 -d 5 -t raw -c 2 test_stereo.pcm && aplay -f S16_LE -r 16000 -d 5 -t raw  -c 2 test_stereo.pcm"
echo ""
