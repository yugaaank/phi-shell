#!/bin/bash
# A simple script to parse .desktop files into JSON
echo "[" > ~/.config/myshell/apps.json
first=true
for dir in /usr/share/applications ~/.local/share/applications; do
    if [ -d "$dir" ]; then
        for f in "$dir"/*.desktop; do
            [ -f "$f" ] || continue
            name=$(grep -m 1 "^Name=" "$f" | cut -d= -f2 | tr -d '"\')
            exec=$(grep -m 1 "^Exec=" "$f" | cut -d= -f2- | sed 's/ %[a-zA-Z]//g' | tr -d '"\')
            icon=$(grep -m 1 "^Icon=" "$f" | cut -d= -f2 | tr -d '"\')
            
            if [ -n "$name" ] && [ -n "$exec" ]; then
                if [ "$first" = true ]; then
                    first=false
                else
                    echo "," >> ~/.config/myshell/apps.json
                fi
                # Escape json manually
                name=$(echo "$name" | jq -R -s -c . | sed 's/^"//;s/"$//')
                exec=$(echo "$exec" | jq -R -s -c . | sed 's/^"//;s/"$//')
                icon=$(echo "$icon" | jq -R -s -c . | sed 's/^"//;s/"$//')
                echo "  {\"name\": \"$name\", \"exec\": \"$exec\", \"icon\": \"$icon\"}" >> ~/.config/myshell/apps.json
            fi
        done
    fi
done
echo "]" >> ~/.config/myshell/apps.json
