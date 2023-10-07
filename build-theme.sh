#!/bin/zsh

# A script that can build a single specified theme (eg. ./build-theme.sh sweet) and install it via pacman
# in order to see the changes you have to reapply the theme:
#  - change to an archcraft style that is using this theme (right click desktop -> Preferences -> Change style -> ...)
#  - or via the Openbox configuration manager

# the script will ask you if you want to execute the ~/archcraft-openbox/apply-config.sh script
#  - this is my custom thing, cause I have the archcraft repos in my home folder and I modify only the Default theme

if [ -z "$1" ]; then
    echo "Please provide the unique theme name to be installed"
    echo "  Example: \`./build-theme.sh sweet\` <- archcraft-gtk-theme-sweet will be installed"
    exit 1
fi

## Dirs
DIR=$(dirname $(readlink -f "$0"))
PKG=(`ls -d "$DIR"/*-$1 | sed "s@$DIR/@@g" | cut -f1 -d'/'`)
PKGDIR="$DIR/packages"

PATH_CONF="$HOME/.config"
APPLY_SH="$PATH_CONF/openbox-themes/themes/$1/apply.sh"

if [ ! -d "$PKGDIR" ]; then
    mkdir "$PKGDIR"
fi

if [ ! -d "$DIR/$PKG" ]; then
    echo "Theme $PKG does not exist?"
    exit 1
fi

echo -e "Building $PKG..."
cd "$DIR/$PKG" && makepkg -sf
mv *.pkg.tar.zst "$PKGDIR" && rm -rf src pkg

# Verify
while true; do
	set -- "$PKGDIR"/"$PKG"-*
	if [[ -e "$1" ]]; then
		echo -e "\nPackage '$PKG' generated successfully.\n"
		break
    else
		echo -e "\nFailed to build '$PKG', Exiting...\n"
		exit 1;
    fi
done

echo "Installing selected theme $PKG..."
sudo pacman -U "$PKGDIR"/"$PKG"*.pkg.tar.zst

# custom stuff START

if read -q "choice?Execute $APPLY_SH? (y/n) "; then
    if [ -f "$APPLY_SH" ]; then
        bash ${APPLY_SH}
    fi
else
    echo "\nApply the theme in either Openbox configuration manager or change to an archcraft style that is using it (archcraft-openbox/apply-config.sh?)"
fi

# custom stuff END