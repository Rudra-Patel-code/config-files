#!/bin/bash

# Define the wallpaper directory
WALLPAPER_DIR="$HOME/.config/wallpapers"

# Check if the wallpaper file is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <wallpaper-file>"
  exit 1
fi

# Get the wallpaper file path from the argument
WALLPAPER_FILE="$1"

# Verify if the specified wallpaper file exists
if [ ! -f "$WALLPAPER_FILE" ]; then
  echo "Error: Wallpaper file '$WALLPAPER_FILE' not found."
  exit 1
fi

# Extract the filename from the path
WALLPAPER_BASE=$(basename "$WALLPAPER_FILE")

echo "Step 1: Moving wallpaper file to $WALLPAPER_DIR..."
# Move the wallpaper file to the wallpapers directory
if [ -f "$WALLPAPER_DIR/$WALLPAPER_BASE" ]; then
  read -p "File '$WALLPAPER_BASE' already exists in $WALLPAPER_DIR. Overwrite? (y/n): " overwrite
  case $overwrite in
    [Yy]* )
      mv -f "$WALLPAPER_FILE" "$WALLPAPER_DIR/$WALLPAPER_BASE"
      ;;
    * )
      echo "Operation aborted."
      exit 1
      ;;
  esac
else
  mv "$WALLPAPER_FILE" "$WALLPAPER_DIR/$WALLPAPER_BASE"
fi

echo "Step 2: Stopping hyprpaper (if running)..."
# Stop hyprpaper (if running)
pgrep hyprpaper > /dev/null && killall hyprpaper

echo "Step 3: Clearing hyprpaper.conf..."
# Clear hyprpaper.conf
echo "" > ~/.config/hypr/hyprpaper.conf

echo "Step 4: Updating hyprpaper.conf..."
# Update hyprpaper.conf
echo "preload = $WALLPAPER_DIR/$WALLPAPER_BASE" >> ~/.config/hypr/hyprpaper.conf
echo "wallpaper = ,$WALLPAPER_DIR/$WALLPAPER_BASE" >> ~/.config/hypr/hyprpaper.conf

echo "Step 5: Restarting hyprpaper..."
# Restart hyprpaper
hyprpaper &

echo "Step 6: Generating colors using pywal..."
# Generate colors using pywal
wal -i "$WALLPAPER_DIR/$WALLPAPER_BASE"

echo "Step 7: Applying generated colors to your terminal (if configured)..."
# Apply the generated colors to your terminal (optional)
# Example for Alacritty:
# cat ~/.cache/wal/colors-alacritty.yml > ~/.config/alacritty/colors.yml

echo "Wallpaper and colors updated!"
