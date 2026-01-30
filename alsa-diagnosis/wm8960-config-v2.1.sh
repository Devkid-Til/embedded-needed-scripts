LSA混音器配置脚本
# 按百分比设置各类音量
# 保存为：configure_alsa.sh
# 执行：sudo bash configure_alsa.sh

CARD=0  # 声卡编号

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数：将百分比转换为实际值
# 参数：百分比(0-100) 最小值 最大值
percent_to_value() {
    local percent=$1
    local min=$2
    local max=$3
    local range=$((max - min))
    local value=$(echo "scale=0; $min + ($range * $percent / 100)" | bc)
    echo $value
}

# 函数：设置控件值
# 参数：控件名称 百分比(0-100)
set_control() {
    local control_name=$1
    local percent=$2
    
    # 获取控件信息
    local info=$(amixer -c $CARD get "$control_name" 2>/dev/null)
    if [ -z "$info" ]; then
        echo -e "${RED}错误: 未找到控件 '$control_name'${NC}"
        return 1
    fi
    
    # 提取最小值和最大值
    local min_max=$(echo "$info" | grep -o "min=[0-9]*,max=[0-9]*")
    local min=$(echo "$min_max" | grep -o "min=[0-9]*" | cut -d= -f2)
    local max=$(echo "$min_max" | grep -o "max=[0-9]*" | cut -d= -f2)
    
    # 检查是否为布尔类型
    local type=$(echo "$info" | grep "type=" | head -1)
    if echo "$type" | grep -q "BOOLEAN"; then
        if [ $percent -ge 50 ]; then
            amixer -c $CARD set "$control_name" on
            echo -e "${GREEN}设置 $control_name = on${NC}"
        else
            amixer -c $CARD set "$control_name" off
            echo -e "${GREEN}设置 $control_name = off${NC}"
        fi
        return 0
    fi
    
    # 计算实际值
    local value=$(percent_to_value $percent $min $max)
    
    # 获取通道数
    local channels=$(echo "$info" | grep "values=" | head -1 | cut -d= -f2 | cut -d, -f1)
    
    # 设置值
    if [ "$channels" = "2" ]; then
        amixer -c $CARD set "$control_name" $value,$value
        echo -e "${GREEN}设置 $control_name = $value,$value ($percent%)${NC}"
    else
        amixer -c $CARD set "$control_name" $value
        echo -e "${GREEN}设置 $control_name = $value ($percent%)${NC}"
    fi
}

# 函数：显示当前状态
show_status() {
    echo -e "\n${YELLOW}=== 当前ALSA配置状态 ===${NC}"
    amixer -c $CARD get 'Master' 2>/dev/null || echo "无Master控件"
    amixer -c $CARD get 'Headphone' 2>/dev/null || echo "无Headphone控件"
    amixer -c $CARD get 'Speaker' 2>/dev/null || echo "无Speaker控件"
    amixer -c $CARD get 'Capture' 2>/dev/null || echo "无Capture控件"
}

# 主配置函数
configure_alsa() {
    echo -e "${YELLOW}开始配置ALSA混音器...${NC}"
    
    # ==================== 播放控制 ====================
    echo -e "\n${YELLOW}1. 播放控制配置${NC}"
    read -p "设置主播放音量百分比 (0-100，默认80): " master_vol
    master_vol=${master_vol:-80}
    set_control "Playback Volume" $master_vol
    
    read -p "设置耳机音量百分比 (0-100，默认70): " hp_vol
    hp_vol=${hp_vol:-70}
    set_control "Headphone Playback Volume" $hp_vol
    
    read -p "设置扬声器音量百分比 (0-100，默认60): " speaker_vol
    speaker_vol=${speaker_vol:-60}
    set_control "Speaker Playback Volume" $speaker_vol
    
    # ==================== 录音控制 ====================
    echo -e "\n${YELLOW}2. 录音控制配置${NC}"
    read -p "是否开启录音? (y/n，默认n): " enable_capture
    if [ "$enable_capture" = "y" ] || [ "$enable_capture" = "Y" ]; then
        set_control "Capture Switch" 100
        read -p "设置录音音量百分比 (0-100，默认50): " capture_vol
        capture_vol=${capture_vol:-50}
        set_control "Capture Volume" $capture_vol
        set_control "ADC PCM Capture Volume" $capture_vol
    else
        set_control "Capture Switch" 0
    fi
    
    # ==================== 输入源配置 ====================
    echo -e "\n${YELLOW}3. 输入源配置${NC}"
    echo "选择主输入源:"
    echo "  1) LINPUT1 (麦克风1)"
    echo "  2) LINPUT2 (线路输入2)"
    echo "  3) LINPUT3 (线路输入3)"
    echo "  4) RINPUT1 (麦克风1右)"
    echo "  5) RINPUT2 (线路输入2右)"
    echo "  6) RINPUT3 (线路输入3右)"
    read -p "选择 (1-6，默认1): " input_choice
    input_choice=${input_choice:-1}
    
    # 关闭所有输入
    for switch in 52 53 54 55 56 57; do
        amixer -c $CARD cset numid=$switch 0 >/dev/null 2>&1
    done
    
    # 开启选择的输入
    case $input_choice in
        1) amixer -c $CARD cset numid=57 1 ;; # LINPUT1
        2) amixer -c $CARD cset numid=55 1 ;; # LINPUT2
        3) amixer -c $CARD cset numid=56 1 ;; # LINPUT3
        4) amixer -c $CARD cset numid=54 1 ;; # RINPUT1
        5) amixer -c $CARD cset numid=52 1 ;; # RINPUT2
        6) amixer -c $CARD cset numid=53 1 ;; # RINPUT3
    esac
    
    read -p "设置输入增益百分比 (0-100，默认30): " input_gain
    input_gain=${input_gain:-30}
    case $input_choice in
        1|4) set_control "Left Input Boost Mixer LINPUT1 Volume" $input_gain ;;
        2|5) set_control "Left Input Boost Mixer LINPUT2 Volume" $input_gain ;;
        3|6) set_control "Left Input Boost Mixer LINPUT3 Volume" $input_gain ;;
    esac
    
    # ==================== 输出路由配置 ====================
    echo -e "\n${YELLOW}4. 输出路由配置${NC}"
    read -p "开启PCM播放输出? (y/n，默认y): " enable_pcm
    enable_pcm=${enable_pcm:-y}
    if [ "$enable_pcm" = "y" ] || [ "$enable_pcm" = "Y" ]; then
        set_control "Left Output Mixer PCM Playback Switch" 100
        set_control "Right Output Mixer PCM Playback Switch" 100
    fi
    
    # ==================== 音效处理配置 ====================
    echo -e "\n${YELLOW}5. 音效处理配置${NC}"
    read -p "开启3D音效? (y/n，默认n): " enable_3d
    if [ "$enable_3d" = "y" ] || [ "$enable_3d" = "Y" ]; then
        set_control "3D Switch" 100
        read -p "设置3D强度百分比 (0-100，默认50): " effect_3d
        effect_3d=${effect_3d:-50}
        set_control "3D Volume" $effect_3d
    else
        set_control "3D Switch" 0
    fi
    
    read -p "开启ALC自动电平控制? (y/n，默认y): " enable_alc
    if [ "$enable_alc" = "y" ] || [ "$enable_alc" = "Y" ]; then
        set_control "ALC Function" 100  # 设置为立体声模式
    else
        set_control "ALC Function" 0
    fi
    
    # ==================== 高级设置 ====================
    echo -e "\n${YELLOW}6. 高级设置${NC}"
    read -p "开启过零检测? (y/n，默认n): " enable_zc
    if [ "$enable_zc" = "y" ] || [ "$enable_zc" = "Y" ]; then
        set_control "Headphone Playback ZC Switch" 100
        set_control "Speaker Playback ZC Switch" 100
    fi
    
    read -p "设置ADC数据输出模式 (0-3，默认0): " adc_mode
    adc_mode=${adc_mode:-0}
    amixer -c $CARD cset numid=41 $adc_mode
    
    echo -e "\n${GREEN}配置完成！${NC}"
    show_status
}

# 预设配置函数
apply_preset() {
    echo -e "\n${YELLOW}选择预设配置:${NC}"
    echo "  1) 高音质播放模式"
    echo "  2) 录音模式"
    echo "  3) 会议模式"
    echo "  4) 音乐制作模式"
    echo "  5) 重置为默认"
    read -p "选择 (1-5): " preset
    
    case $preset in
        1) # 高音质播放模式
            echo "应用高音质播放模式..."
            set_control "Playback Volume" 85
            set_control "Headphone Playback Volume" 80
            set_control "Speaker Playback Volume" 70
            set_control "PCM Playback -6dB Switch" 0
            set_control "DAC Deemphasis Switch" 0
            set_control "3D Switch" 0
            set_control "ALC Function" 0
            set_control "Capture Switch" 0
            ;;
        2) # 录音模式
            echo "应用录音模式..."
            set_control "Capture Switch" 100
            set_control "Capture Volume" 60
            set_control "ADC PCM Capture Volume" 70
            set_control "ADC High Pass Filter Switch" 100
            set_control "ALC Function" 100
            amixer -c $CARD cset numid=57 1  # LINPUT1
            set_control "Left Input Boost Mixer LINPUT1 Volume" 40
            ;;
        3) # 会议模式
            echo "应用会议模式..."
            set_control "Playback Volume" 70
            set_control "Speaker Playback Volume" 60
            set_control "Capture Switch" 100
            set_control "Capture Volume" 70
            set_control "ADC PCM Capture Volume" 80
            set_control "ALC Function" 100
            set_control "3D Switch" 100
            set_control "3D Volume" 30
            ;;
        4) # 音乐制作模式
            echo "应用音乐制作模式..."
            set_control "Playback Volume" 90
            set_control "Headphone Playback Volume" 85
            set_control "Capture Switch" 100
            set_control "Capture Volume" 50
            set_control "ADC PCM Capture Volume" 50
            set_control "PCM Playback -6dB Switch" 0
            set_control "ALC Function" 0
            set_control "3D Switch" 0
            set_control "Noise Gate Switch" 100
            ;;
        5) # 重置
            echo "重置为默认..."
            amixer -c $CARD reset
            ;;
        *)
            echo "无效选择"
            return 1
            ;;
    esac
    
    show_status
}

# 主菜单
main_menu() {
    while true; do
        echo -e "\n${YELLOW}=== ALSA混音器配置工具 ===${NC}"
        echo "  1) 交互式配置"
        echo "  2) 应用预设配置"
        echo "  3) 显示当前状态"
        echo "  4) 保存当前配置"
        echo "  5) 恢复保存的配置"
        echo "  6) 退出"
        read -p "选择 (1-6): " choice
        
        case $choice in
            1) configure_alsa ;;
            2) apply_preset ;;
            3) show_status ;;
            4) 
                echo "保存配置到 ~/.asoundrc..."
                alsactl -f ~/.asoundrc store $CARD
                echo "配置已保存"
                ;;
            5) 
                echo "从 ~/.asoundrc 恢复配置..."
                alsactl -f ~/.asoundrc restore $CARD
                echo "配置已恢复"
                ;;
            6) 
                echo "退出"
                exit 0
                ;;
            *) echo "无效选择" ;;
        esac
    done
}

# 检查权限
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}警告: 建议使用sudo运行此脚本以获得完整权限${NC}"
    read -p "是否继续? (y/n): " continue_as_user
    if [ "$continue_as_user" != "y" ] && [ "$continue_as_user" != "Y" ]; then
        exit 1
    fi
fi

# 执行主菜单
main_menu
