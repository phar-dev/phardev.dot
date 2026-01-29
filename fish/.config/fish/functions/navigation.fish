#-----------------------------------------
# HERRAMIENTAS DE NAVEGACIÓN MEJORADA
#-----------------------------------------

# Zoxide - Inicializar si está instalado
if command -v zoxide >/dev/null 2>&1
    zoxide init fish | source

    # Alias opcionales para zoxide
    alias cd="z"       # Usa 'z' en lugar de 'cd' para navegar con inteligencia
    alias zz="z -"     # Volver al directorio anterior
    alias zi="z -i"    # Modo interactivo
end