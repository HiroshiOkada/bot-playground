#!/bin/sh

MAX_IMG_SIZE=104857600
src=$1
out_png=/home/bot/out.png

svg2png () {
  inkscape --without-gui --file="$1" --export-png="$out_png" 2>&1 | \
    grep -v -e 'Failed to get connection' -e 'dbus_g_proxy_' -e 'Background RRGGBBAA:' -e 'Bitmap saved as:' -e 'dbus_g_connection_register_g_object'
}

case "$src" in
 *.asm) nasm -f elf64 -o a.o "$src" &&  ld -s -o a.out a.o && ./a.out ;;
 *.bc) bc -l "$src" ;;
 *.bf|*.b) beef -d "$src" ;;
 *.cpp) clang++ "$src" && ./a.out ;;
 *.cs) mcs "$src" && mono "${src%.cs}.exe" ;;
 *.c) gcc "$src" && ./a.out ;;
 *.dot) dot -T png -o "$out_png" "$src" ;;
 *.f|*.f90|*.f95) gfortran "$src" && ./a.out ;;
 *.go) go run "$src" ;;
 *.hs) runghc "$src" ;;
 *.java) javac "$src" && java "${src%.java}" ;;
 *.js) node "$src" ;;
 *.lsp|*.lisp) clisp -q < "$src" ;;
 *.lua) lua5.3 "$src" ;;
 *.ml) ocaml "$src" ;;
 *.php) php "$src" ;;
 *.plt|*.gnuplot|*.gpi) gnuplot -e "set terminal png size 800,800; set output 'out.png'" "$src" ;;
 *.py2) python2 "$src" ;;
 *.py3|*.py) python3 "$src" ;;
 *.pl) perl "$src" ;;
 *.rb) ruby "$src" ;;
 *.scm) guile -s "$src" 2>/dev/null ;;
 *.sh|*.bash) bash "$src" ;;
 *.sql) sqlite3 "${src%.sql}.db" < "$src" ;;
 *.svg) svg2png "$src" ;;
 *.ts) tsc "$src" && node "${src%.ts}".js ;;
 *.vim) LANG=ja_JP.UTF-8 vim -X -N -u NONE -i NONE --not-a-term --cmd "source $src | qall!" ;;
 *.zsh) zsh "$src" ;;
 *.html|*.htm) LANG=ja_JP.UTF-8 xvfb-run phantomjs /usr/local/etc/render.js "$src" 2>/dev/null | grep -P '^[A-Z]+:' | sed -e 's/^CONSOLE://' ;;

 script) cp "$src" /tmp/
    rm -f "$src"
    mv /tmp/"$src" "$src"
    chmod +x "$src" && ./"$src"
    ;;

  *) echo "This file is not supported."
     exit
     ;;
esac

if [ "$src" != "out.svg" -a -e "out.svg" ]; then
  svg2png out.svg
fi

if [ -e "$out_png" ]; then
  if [ "$(stat --format=%s $out_png)" -gt "$MAX_IMG_SIZE" ]; then
    rm -f "$out_png"
  fi
fi
