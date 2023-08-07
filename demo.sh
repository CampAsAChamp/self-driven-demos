#!/usr/bin/env zsh

# Check if pr-reqs are installed, prior to running
# the demo
if ! which gum > /dev/null; then
    echo "You need 'gum' to run this demo. Installation instructions here: https://github.com/charmbracelet/gum#installation"
    exit 1
fi

if ! which cowsay > /dev/null; then
    echo "You need 'cowsay' to run this demo. Installation instructions here: https://letmegooglethat.com/?q=how+to+install+cowsay"
    exit 1
fi

if ! which shuf > /dev/null; then
    echo "You need 'shuf' to run this demo. Installation instructions here: https://letmegooglethat.com/?q=how+to+install+shuf+on+command+line"
    exit 1
fi

if ! which lolcat > /dev/null; then
    echo "You need 'lolcat' to run this demo. Installation instructions here: https://github.com/busyloop/lolcat#installation"
    exit 1
fi

if ! which bat > /dev/null; then
    echo "You need 'bat' to run this demo. Installation instructions here: https://github.com/sharkdp/bat#installation"
    exit 1
fi

if ! which exa > /dev/null; then
    echo "You need 'exa' to run this demo. Installation instructions here: https://the.exa.website/"
    exit 1
fi

if ! which pytest > /dev/null; then
    echo "You need 'pytest' to run this demo. Installation instructions here: https://docs.pytest.org/en/7.4.x/"
    exit 1
fi

if ! which playwright > /dev/null; then
    echo "You need 'playwright' to run this demo. Installation instructions here: https://playwright.dev/"
    exit 1
fi

# Set variables
SCRIPT_SOURCE=$(dirname "${BASH_SOURCE[0]}")
export APP_URL="http://localhost:8000"

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

# Introduction
gumbox "Hello! Welcome to $(gumtext 'The Self-Driven Demo about Self-Driven Demos!')"
PROMPT=$(guminput "Press any button to continue... (except the power button 😅)")

echo -e "$(gumtext "LET'S DO IT!")"

sleep 4; clear

cowecho "In this demo, we have a simple Flask application that utilizes a Redis instance to count how many times the app has been accessed. "
cowecho "We'll be using docker-compose to start up the application and the Redis instance."

sleep 10; clear

echo -e "$(gumtext "The directory structure is quite simple for this demo 🗂️")"
exa -aT --color=always --group-directories-first --icons

sleep 25; clear

echo -e "$(gumtext "The application is a Flask app that looks like this 👇")"
sleep 3
bat app.py
echo -e "$(gumtext "The dependencies for the app are as follows 👇")"
bat requirements.txt

sleep 20; clear

echo -e "$(gumtext "The Dockerfile is as follows👇")"
sleep 3
bat Dockerfile

sleep 20; clear

echo -e "$(gumtext "The Docker Compose setup looks like this 👇")"
sleep 3
bat docker-compose.yaml

sleep 20; clear

echo -e "$(gumtext "Finally, the demo orchestrator looks like this 👇")"
sleep 3
bat test_app.py

sleep 60; clear

# Start the instances
cd $SCRIPT_SOURCE
gumspin globe "We're now going to start the application and Redis..."
docker-compose stop && docker-compose down
docker volume prune -f
docker-compose up -d
gumspin monkey "Waiting for the Redis instance and the application to start up..."
cowecho "... and done!"

sleep 5; clear

gumspin dot "We're now going to demo the application"
pytest
cowecho "... and done!"

sleep 5; clear

cowecho "Rad! We just did a simple application demo that was self-driven. What tools did we use here?"
sleep 3; clear

cat > /tmp/open-links.py <<EOF
import time
from playwright.sync_api import sync_playwright

with sync_playwright() as playwright:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()
    page.goto("https://github.com/charmbracelet/gum")
    time.sleep(5)
    page.goto("https://en.wikipedia.org/wiki/Cowsay")
    time.sleep(5)
    page.goto("https://github.com/busyloop/lolcat")
    time.sleep(5)
    page.goto("https://playwright.dev/")
    time.sleep(5)
    page.goto("https://github.com/sharkdp/bat")
    time.sleep(5)
    page.goto("https://the.exa.website/")
    time.sleep(5)
    browser.close()
EOF
python3 /tmp/open-links.py
rm /tmp/open-links.py
clear

gumbox "Thank you for attending! Any questions?"
sleep 400
