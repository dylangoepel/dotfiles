alias vim="nvim"
alias ytdl-music="youtube-dl --extract-audio --audio-format mp3 --add-metadata -f bestaudio -o '%(creator)s-%(title)s.%(ext)s'"

function latex() {
    outfile=$(echo $1 | sed "s,.tex$,.pdf,g")
    echo LIVE COMPILING LATEX --- $1 $outfile
    echo $1 | entr pdflatex -halt-on-error $1
}

alias pdf="zathura"


PS1="\w λ "
