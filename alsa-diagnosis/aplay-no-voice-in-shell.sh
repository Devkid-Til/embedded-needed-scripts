echo "plughw:0,0:"
aplay -D plughw:0,0 -f S16_LE -r 16000 -t raw  -c 1 $1
echo "default:"
aplay -f S16_LE -r 16000 -t raw  -c 1 $1
echo "direct:"
aplay -D direct -f S16_LE -r 16000 -t raw  -c 1 $1
