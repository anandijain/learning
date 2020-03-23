get_audio(){
    $# < 2 ? return 
    youtube-dl -f251 $1 -o - | ffmpeg -i pipe: -ac 2 -f wav $2
}