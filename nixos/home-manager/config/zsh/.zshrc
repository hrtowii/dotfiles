# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
alias ldid="/Users/ibarahime/Downloads/ldid_macosx_arm64"
alias ct_bypass="/Users/ibarahime/ChOma/ct_bypass"
alias ipaddr="ipconfig getifaddr en0"
# alias bruh="/Users/ibarahime/bruh/bin/bruh-arm64"
alias ghidra="/Users/ibarahime/Downloads/stuff/ghidra_10.3.2_PUBLIC/ghidraRun"
alias iometa="/Users/ibarahime/iometa-muirey/iometa/iometa"
alias "ls"="eza --icons=always --color=always --hyperlink -1"
alias legit="/Users/ibarahime/legit/target/release/legit"
alias "checkra1n"='sudo /Applications/checkra1n.app/Contents/MacOS/checkra1n'
export EDITOR=nvim
export DOTNET_ROOT="/usr/local/share/dotnet/sdk/8.0.204"
export NNN_OPTS="H"
alias bkcrack="/Users/ibarahime/dev/bkcrack/install/./bkcrack"
alias kcache_extract="/Users/ibarahime/dev/iosreformyself/rust-kernelcache-extractor/target/release/kcache_extract"
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
alias discordo="/Users/ibarahime/dev/discordo/discordo"
export PATH="/Users/ibarahime/.bun/bin:$PATH"
alias create_jupyter_kernel="uv venv --seed; uv pip install pydantic; uv pip install jupyterlab; .venv/bin/jupyter lab"
create_vite_tailwind_app() {
    # Check if the app name is provided
    if [ -z "$1" ]; then
        echo "Usage: create_vite_tailwind_app <app-name>"
        return 1
    fi

    # Step 1: Create a new Vite project
    bun create vite@latest "$1" -- --template vanilla
    cd "$1" || return

    # Step 2: Install Tailwind CSS and its dependencies
    bun i -D tailwindcss postcss autoprefixer

    # Step 3: Initialize Tailwind CSS configuration
    bunx tailwindcss init -p

    # Step 4: Configure Tailwind to remove unused styles in production
    echo "/* Tailwind CSS setup */" > ./temp.txt
    echo "@tailwind base;" >> ./temp.txt
    echo "@tailwind components;" >> ./temp.txt
    echo "@tailwind utilities;" >> ./temp.txt
    cat temp.txt ./src/App.css > temp && mv temp ./src/App.css
    rm temp.txt
    # Update the Tailwind config to include your source files
    sed -i '' 's/content: \[\]/content: \[".\/index.html", ".\/src\/*.{js,ts,jsx,tsx}"\]/' tailwind.config.js

    # Step 5: Add the Tailwind import to your main CSS file
    # echo "@import './style.css';" >> ./src/main.tsx

    # Step 6: Build and start the project
    bun dev
}

# bun completions
[ -s "/Users/ibarahime/.bun/_bun" ] && source "/Users/ibarahime/.bun/_bun"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
# Load Angular CLI autocompletion.
#source <(ng completion script)
cfetch
# echo """
# TMUX SHORTCUTS:
# ctrl-b + c -> creates new window
# ctrl-b + <number> -> jumps to new window
# ctrl-b + % -> splits vertically
# ctrl-b + \" -> splits horizontally
# ctrl-b + x -> closes selected panel
# ctrl-b + arrowkey -> moves to selected tmux panel
# """
echo """
ZELLIJ SHORTCUTS:
alt + p -> pane mode, X for delete, C for create,
alt + r -> resize
alt + t -> create tab
"""
echo """
nvim shortcuts:
:Neotree
:Telescope
:shift H in neotree to toggle showing dotfiles
"""
eval "$(uv generate-shell-completion zsh)"


# Created by `pipx` on 2024-05-16 03:05:45
# export PATH="$PATH:/Users/ibarahime/.local/bin"# export PATH="/opt/homebrew/opt/ffmpeg@5/bin:$PATH"
# export PATH="/opt/homebrew/opt/dotnet@6/bin:$PATH"
# alias "streamtoswitch"="dotnet ~/Downloads/stuff/SysDVR-Client/SysDVR-Client.dll bridge 192.168.10.222"
# export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
# export PATH="/opt/procursus/bin:/opt/procursus/sbin:/opt/procursus/games:$PATH"
# export CPATH="$CPATH:/opt/procursus/include"
# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
# export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/zlib/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"
# export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# eval "$(starship init zsh)"
# export PATH="$PATH:/opt/homebrew/Cellar/john-jumbo/1.9.0_1/share/john/"
# export PATH=/usr/local/anaconda3/bin:$PATH
# export PATH=/opt/homebrew/anaconda3/bin:$PATH
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
    command nohup zellij action rename-tab $title >/dev/null 2>&1
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
