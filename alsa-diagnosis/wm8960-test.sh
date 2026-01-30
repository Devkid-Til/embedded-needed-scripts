#!/bin/sh

set -e

mono_file="test_record_mono.pcm"
stereo_file="test_record_stereo.pcm"
duration=5

echo "开始录音测试..."

# 测试录音（单声道，高采样率）
echo "单声道测试，请对着麦克风说话5秒钟..."
arecord -D plughw:0,0 \
    -f S16_LE \
    -r 16000 \
    -c 1 \
    -d ${duration} \
	-V stereo \
    --vumeter=mono \
    -t raw \
	${mono_file}

echo "录音完成！"
echo "文件信息:"
ls -lh ${mono_file}

# channels = 1
echo "播放录音..."
aplay -D plughw:0,0 \
    -f S16_LE \
    -r 16000 \
    -c 1 \
    -t raw \
	${mono_file}

# 测试录音（立体声，高采样率）

echo "立体声测试，请再次对着麦克风说话5秒钟..."
arecord -D plughw:0,0 \
    -f S16_LE \
    -r 16000 \
    -c 2 \
    -d ${duration} \
	-V stereo \
    --vumeter=stereo \
    -t raw \
	${stereo_file}

echo "录音完成！"
echo "文件信息:"
ls -lh ${mono_file}

# channel = 2
echo "播放录音..."
aplay -D plughw:0,0 \
    -f S16_LE \
    -r 16000 \
    -c 2 \
    -t raw \
	${stereo_file}

echo "录音完成！"
echo "文件信息:"
ls -lh ${stereo_file}


echo "测试结束"
