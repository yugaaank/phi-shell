#!/bin/bash

IMAGE="$1"
if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image_path>"
    exit 1
fi

MATUGEN_JSON=$(matugen image --prefer saturation -j hex "$IMAGE" 2>/dev/null)

if [ -z "$MATUGEN_JSON" ]; then
    echo "Failed to extract colors using matugen."
    exit 1
fi

echo "$MATUGEN_JSON" | jq '{
    background: .colors.background.default.color,
    foreground: .colors.on_background.default.color,
    primary: .colors.primary.default.color,
    onPrimaryColor: .colors.on_primary.default.color,
    secondary: .colors.secondary.default.color,
    surface: .colors.surface_container.default.color,
    surfaceBorder: .colors.outline_variant.default.color
}' > ~/.config/myshell/colors.json

echo "Colors extracted and saved to ~/.config/myshell/colors.json"
