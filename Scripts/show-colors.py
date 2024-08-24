import re

# Path to the colors.sh file
colors_file_path = '/home/rudra/.cache/wal/colors.sh'

# Function to convert hex color to RGB
def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

# Function to print color block
def print_color_block(rgb, name, hex_color):
    print(f"\033[48;2;{rgb[0]};{rgb[1]};{rgb[2]}m    \033[0m {name}: {hex_color}")

# Read the colors.sh file
with open(colors_file_path, 'r') as file:
    lines = file.readlines()

# Regex to match color variables
color_regex = re.compile(r'^(background|foreground|cursor|color\d+)=\'(#(?:[0-9a-fA-F]{6}))\'$')

# Extract and display color blocks
for line in lines:
    match = color_regex.match(line.strip())
    if match:
        name, hex_color = match.groups()
        rgb = hex_to_rgb(hex_color)
        print_color_block(rgb, name, hex_color)

