import sys
import json
import subprocess
import os

if len(sys.argv) < 2:
    print("Usage: generate_colors.py <image_path_or_hex_color>")
    sys.exit(1)

input_arg = sys.argv[1]

cmd = ["matugen"]
if input_arg.startswith("#"):
    cmd.extend(["color", "hex", input_arg])
else:
    cmd.extend(["image", input_arg])

cmd.extend(["-j", "hex"])

try:
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    data = json.loads(result.stdout)
    
    colors = data.get("colors", {})
    
    def get_color(name):
        return colors.get(name, {}).get("default", {}).get("color", "#000000")
        
    out = {
        "background": get_color("background"),
        "surface": get_color("surface"),
        "surfaceBorder": get_color("outline_variant"),
        "primary": get_color("primary"),
        "onPrimaryColor": get_color("on_primary"),
        "secondary": get_color("secondary"),
        "foreground": get_color("on_surface")
    }
    
    config_dir = os.path.expanduser("~/.config/myshell")
    with open(os.path.join(config_dir, "colors.json"), "w") as f:
        json.dump(out, f, indent=4)
        
    print("Generated colors.json successfully!")
    
except Exception as e:
    print(f"Failed to generate colors: {e}")
    sys.exit(1)
