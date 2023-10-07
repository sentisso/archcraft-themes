#!/bin/zsh

# A script that can replace a given color of a specified theme
# Note: shebang has to be zsh, cause the sed replace on line #9 won't work in bash idk
# Example: ./change-color.sh sweet c50ed2 13cada <- every #c50ed2 will be replaced with #14cada in ./archcraft-gtk-theme-sweet

# location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

replace() {
    echo "$1 -> $2"
    sed -i -- "s/$1/$2/g" **/*(D.)
}

replace_sddm() {
    if [ -d "/usr/share/sddm/themes/archcraft" ]; then
        echo "\nReplacing the color in sddm..."
        cd /usr/share/sddm/themes/archcraft

        current=${current:u}
        new=${new:u}
        replace $current $new
        current=${current:l}
        new=${new:l}
        replace $current $new
    else
        echo "sddm config folder not found"
    fi
}

if [ -z "$1" ] && [ -z "$2" ] && [ -z "$3" ]; then
    echo "Please specify both colors and the theme name to be replaced!"
    echo "  Example: ./change-color.sh sweet c50ed2 13cada <- every #c50ed2 will be replaced with #14cada in ./archcraft-gtk-theme-sweet"
    exit 1
fi

if [ ! -d "./archcraft-gtk-theme-$1" ]; then
    echo "Please provide the theme name!"
    echo "  Example: ./change-color.sh sweet c50ed2 13cada <- every #c50ed2 will be replaced with #14cada in ./archcraft-gtk-theme-sweet"
    exit 1
fi

theme="$1"

new="$3"
current="$2"

if read -q "choice?Replace color in ./archcraft-gtk-theme-$theme? (y/n) "; then
    echo "\nReplacing every $current with $new in archcraft-gtk-theme-$theme..."
    cd ./archcraft-gtk-theme-"$theme"

    replace $current $new

    current=${current:u}
    new=${new:u}
    replace $current $new
else
    echo "\n"
fi

echo "$theme: \"$current\" -> \"$new\"" >> "$DIR/changelog.txt"