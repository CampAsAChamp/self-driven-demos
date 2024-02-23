#!/usr/bin/env zsh

function cowecho() {
    local input="$1"
    cow=$(shuf -n 1 -e $(cowsay -l | perl -p -e 's/Cow files.*//'))
    echo "$input" | cowsay -f "$cow" | lolcat -a -t --duration 2
}

function gumbox() {
    local input="$1"
    gum style \
        --border normal --margin "1" \
        --padding "1 2" --border-foreground 212 \
        "${input}"
}

function gumtext() {
    local input="$1"
    gum style --foreground 212 "${input}"
}

function gumspin() {
    local type="$1"
    local input="$2"
    gum spin -s $type --title "${input}" -- sleep 8
}

function guminput() {
    local input="$1"
    gum input --placeholder "${input}"
}

function press_to_continue() {
    PROMPT=$(guminput "Press any button to continue...")
}

function press_to_continue_and_clear() {
    press_to_continue
    clear
}

# Check if pr-reqs are installed, prior to running the demo
function check_prereqs() {
    if ! which gum >/dev/null; then
        echo "You need 'gum' to run this demo. Installation instructions here: https://github.com/charmbracelet/gum#installation"
        exit 1
    fi

    if ! which cowsay >/dev/null; then
        echo "You need 'cowsay' to run this demo. Installation instructions here: https://letmegooglethat.com/?q=how+to+install+cowsay"
        exit 1
    fi

    if ! which shuf >/dev/null; then
        echo "You need 'shuf' to run this demo. Installation instructions here: https://letmegooglethat.com/?q=how+to+install+shuf+on+command+line"
        exit 1
    fi

    if ! which lolcat >/dev/null; then
        echo "You need 'lolcat' to run this demo. Installation instructions here: https://github.com/busyloop/lolcat#installation"
        exit 1
    fi

    if ! which bat >/dev/null; then
        echo "You need 'bat' to run this demo. Installation instructions here: https://github.com/sharkdp/bat#installation"
        exit 1
    fi

    if ! which eza >/dev/null; then
        echo "You need 'eza' to run this demo. Installation instructions here: https://the.eza.website/"
        exit 1
    fi

    if ! which pytest >/dev/null; then
        echo "You need 'pytest' to run this demo. Installation instructions here: https://docs.pytest.org/en/7.4.x/"
        exit 1
    fi

    # if ! which playwright >/dev/null; then
    #     echo "You need 'playwright' to run this demo. Installation instructions here: https://playwright.dev/"
    #     exit 1
    # fi
}

function intro() {
    check_prereqs

    gumbox "Hello! Welcome to $(gumtext 'The Self-Driven Demo about Self-Driven Demos!')"
    press_to_continue
    echo -e "$(gumtext "LET'S DO IT!")"

    press_to_continue_and_clear

    cowecho "In this demo, we have a simple Flask application that utilizes a Redis instance to count how many times the app has been accessed. "
    cowecho "We'll be using docker-compose to start up the application and the Redis instance."

    press_to_continue_and_clear

    echo -e "$(gumtext "The directory structure is quite simple for this demo 🗂️")"
    eza -aT --color=always --group-directories-first --icons --ignore-glob="node_modules*|.venv*|.pytest_cache*|__pycache__*|.git*|.dockerignore|.intuitgithookrc"
    press_to_continue_and_clear

    echo -e "$(gumtext "The application is a Flask app that looks like this 👇")"
    sleep 2
    bat app.py
    echo -e "$(gumtext "The dependencies for the app are as follows 👇")"
    bat requirements.txt

    press_to_continue_and_clear

    echo -e "$(gumtext "The Dockerfile is as follows👇")"
    sleep 2
    bat Dockerfile

    press_to_continue_and_clear

    echo -e "$(gumtext "The Docker Compose setup looks like this 👇")"
    sleep 2
    bat docker-compose.yaml

    press_to_continue_and_clear

    echo -e "$(gumtext "Finally, the test/demo orchestrator looks like this 👇")"
    sleep 2
    bat test_app.py

    press_to_continue_and_clear
}

function start() {
    # Set variables
    SCRIPT_SOURCE=$(dirname "${BASH_SOURCE[0]}")
    cd $SCRIPT_SOURCE

    gumspin globe "We're now going to start the application and Redis..."
    docker-compose stop && docker-compose down
    docker volume prune -f
    docker-compose up -d
    gumspin monkey "Waiting for the Redis instance and the application to start up..."
    cowecho "... and done!"

    press_to_continue_and_clear

    gumspin dot "We're now going to demo the application"
    pytest
    cowecho "... and done!"

    press_to_continue_and_clear

    cowecho "Rad! We just did a simple application demo that was self-driven. What tools did we use here?"

    press_to_continue_and_clear
    # TODO: Add list of all the tools we used

    gumbox "Thank you for attending! Any questions?"
    press_to_continue
}

function main() {
    intro
    start
}

main
