#-----------------------------------------
# FUNCIONES ÚTILES
#-----------------------------------------
# Función para crear un directorio y entrar inmediatamente
function mkcd --description 'Create directory and cd into it'
    mkdir -p $argv[1] && cd $argv[1]
end

# Función para extraer archivos comprimidos de diferentes formatos
function extract --description 'Extract compressed files'
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar e $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted automatically"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end