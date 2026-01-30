
# "=== 验证2:1分频问题 ==="

# 测试多个采样率（避免数组语法）
TEST_RATES="8000 16000 32000 44100 48000 96000"

for desired_rate in $TEST_RATES; do
    set_rate=$((desired_rate * 2))
    echo -e "\n测试期望${desired_rate}Hz → 设置${set_rate}Hz"
    
    # 录音
	arecord -D plughw:0,0 \
		-f S16_LE \
		-r $set_rate \
		-c 1 \
		-d 1 \
		-t raw \
		./test_${set_rate}.pcm


    #actual_size=$(stat -c%s ./test_${set_rate}.pcm 2>/dev/null || echo "0")
	actual_size=$(ls -l ./test_${set_rate}.pcm  2>/dev/null | awk '{print $5}')
    
    # 计算实际采样率
    # 文件大小 = 采样率 × 2字节 × 时间 × 声道数
    actual_rate=$((actual_size / (2 * 1 * 1)))
    
    echo "设置: ${set_rate}Hz, 文件: ${actual_size}字节"
    echo "实际: ${actual_rate}Hz, 期望: ${desired_rate}Hz"
    
    if [ $actual_rate -eq $desired_rate ]; then
        echo "✓ 符合2:1分频规律"
    else
        echo "✗ 不符合2:1规律"
    fi
done
