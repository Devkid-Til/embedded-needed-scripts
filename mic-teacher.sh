amixer cset name='Capture Volume' 127,127
 
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
