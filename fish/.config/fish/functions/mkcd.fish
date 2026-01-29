#-----------------------------------------
# FUNCIONES ÚTILES (FISH)
#-----------------------------------------

# Función para crear un directorio y entrar inmediatamente
function mkcd --description 'Crear directorio y entrar en él'
    mkdir -p $argv[1]; and cd $argv[1]
end

# Función para extraer archivos comprimidos de diferentes formatos
function extract --description 'Extraer archivos comprimidos'
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
                echo "'$argv[1]' no puede ser extraído automáticamente"
        end
    else
        echo "'$argv[1]' no es un archivo válido"
    end
end