#!/bin/bash
LAZYDOCKER=lazydocker
function checker() {
        which "$LAZYDOCKER" | grep -o $LAZYDOCKER > /dev/null &&  return 0 || return 1;
}

if checker "$LAZYDOCKER" == 0 ; then
    lazydocker;
else
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash;
    lazydocker;
fi
