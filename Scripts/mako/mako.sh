#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

case $1 in
    "toggle_mode")
        # Get the current mode
        CURRENT_MODE=$(makoctl mode 2>/dev/null) || handle_error "Failed to get current mode"

        if [ "$CURRENT_MODE" = "default" ]; then
            makoctl mode -s do-not-disturb || handle_error "Failed to set mode to do-not-disturb"
            echo "󰂛"
        else
            makoctl mode -s default || handle_error "Failed to set mode to default"
            echo "󰂚"
        fi
        ;;
    *)
        # Get the current mode
        MODE=$(makoctl mode 2>/dev/null) || handle_error "Failed to get current mode"
        
        # Get the count of notifications
        COUNT=$(makoctl list 2>/dev/null | jq '[.data[] | .[].id.data] | length' 2>/dev/null) || handle_error "Failed to get notification count"
        
        # Default icons
        ENABLED="󰂚"
        DISABLED="󰂛"
        
        # Check if COUNT is a valid number
        if [ -z "$COUNT" ] || ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then
            COUNT=0
        fi

        # Update DISABLED icon based on notification count
        if [ "$COUNT" -ne 0 ]; then
            DISABLED="󰂛 $COUNT"
        fi

        # Output based on the current mode
        if [ "$MODE" = "default" ]; then
            echo "$ENABLED"
        else
            echo "$DISABLED"
        fi
        ;;
esac
