alias ldid="~/Downloads/ldid_macosx_arm64"
alias ct_bypass="~/ChOma/ct_bypass"
alias ipaddr="ipconfig getifaddr en0"
# alias bruh="/Users/ibarahime/bruh/bin/bruh-arm64"
alias ghidra="~/Downloads/stuff/ghidra_10.3.2_PUBLIC/ghidraRun"
alias iometa="~/iometa-muirey/iometa/iometa"
alias "ls"="eza --icons=always --color=always --sort=modified"
alias "tree"="eza --tree"
alias legit="~/legit/target/release/legit"
export EDITOR=nvim
export NNN_OPTS="H"
alias bkcrack="/Users/ibarahime/dev/bkcrack/install/./bkcrack"
alias kcache_extract="~/dev/iosreformyself/rust-kernelcache-extractor/target/release/kcache_extract"
alias gaster="~/dev/gaster/gaster"
alias achilles="~/dev/AchillesBin"
alias checkra1n="~/dev/checkra1n-013372"
alias bootpongo="~/dev/checkra1n-013372 -k ~/dev/PongoOS/build/Pongo.bin -p"
alias pongoterm="~/dev/PongoOS/scripts/pongoterm"
alias cfetch="/Users/ibarahime/dev/fetchc/cfetch"
alias create-slint-app="cargo generate --git https://github.com/slint-ui/slint-rust-template --name"
alias x86brew='arch -x86_64 /usr/local/bin/brew'
alias start_openwebui='docker run -d -p 127.0.0.1:3000:8080 -e WEBUI_AUTH=False -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main'
alias disarm="~/Downloads/disarm/binaries/disarm.AAPLSi"
alias discordo="~/dev/discordo/discordo"
alias nix-rebuild="nh darwin switch ~/dev/dotfiles/nixos/ --hostname homura"
export PATH="~/.bun/bin:$PATH"
export PATH="~/.cargo/bin:$PATH"
alias create_jupyter_kernel="uv venv --seed; uv pip install pydantic; uv pip install jupyterlab; .venv/bin/jupyter lab"
create_vite_tailwind_app() {
    if [ -z "$1" ]; then
        echo "Usage: create_vite_tailwind_app <app-name>"
        return 1
    fi

    bun create vite@latest "$1" -- --template vanilla
    cd "$1" || return

    bun i -D tailwindcss postcss autoprefixer

    bunx tailwindcss init -p

    echo "@tailwind base;" >> ./temp.txt
    echo "@tailwind components;" >> ./temp.txt
    echo "@tailwind utilities;" >> ./temp.txt
    cat temp.txt ./src/App.css > temp && mv temp ./src/App.css
    rm temp.txt
    sed -i '' 's/content: \[\]/content: \[".\/index.html", ".\/src\/*.{js,ts,jsx,tsx}"\]/' tailwind.config.js

    # echo "@import './style.css';" >> ./src/main.tsx

    bun dev
}

# [ -s "/Users/ibarahime/.bun/_bun" ] && source "/Users/ibarahime/.bun/_bun"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
cfetch
export LOCAL_NOTEBOOK_DEV=1
export PATH="/opt/homebrew/opt/dotnet@8/bin:$PATH"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
function current_dir() {
    local current_dir=$PWD
    if [[ $current_dir == $HOME ]]; then
        current_dir="~"
    else
        current_dir=${current_dir##*/}
    fi
    
    echo $current_dir
}

function change_tab_title() {
    local title=$1
    [[ -z $ZELLIJ ]] && return
    zellij action rename-tab $title &>/dev/null &!
}

function set_tab_to_working_dir() {
    local result=$?
    local title=$(current_dir)
    # uncomment the following to show the exit code after a failed command
    # if [[ $result -gt 0 ]]; then
    #     title="$title [$result]" 
    # fi

    change_tab_title $title
}

function set_tab_to_command_line() {
    local cmdline=$1
    change_tab_title $cmdline
}

if [[ -n $ZELLIJ ]]; then
    add-zsh-hook precmd set_tab_to_working_dir
    add-zsh-hook preexec set_tab_to_command_line
fi
