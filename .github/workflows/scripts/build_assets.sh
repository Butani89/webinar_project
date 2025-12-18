#!/bin/bash
set -e

# 1. Minify CSS
echo "Optimizing CSS..."
# Simple sed-based minification: remove newlines, multiple spaces, and comments
sed -i 's/\/\*.*\*\///g; s/^[ \t]*//g; s/[ \t]*$//g; s/\n//g; s/[ \t]\+/ /g; s/{\s*}/{/g; s/\s*}/}/g; s/:\s*/:/g; s/;\s*/;/g' app/static/css/main.css

# 2. Minify JS (Basic)
echo "Optimizing JS..."
# Remove comments and empty lines (very basic, usually requires a real tool like terser)
sed -i '/^\s*\/\//d; /^\s*$/d' app/static/js/app.js

# 3. Optimize Images (Convert to WebP)
echo "Converting images to WebP..."
# Requires 'webp' package (cwebp)
# Find all PNG/JPG in static/img
find app/static/img -type f \( -iname "*.jpg" -o -iname "*.png" \) | while read -r img; do
    webp_file="${img%.*}.webp"
    cwebp -q 80 "$img" -o "$webp_file"
    echo "Converted $img -> $webp_file"
    # Note: We keep the original for fallback or manual verification, or delete if aggressive.
    # rm "$img" 
done

# 4. Update HTML references to use .webp
echo "Updating HTML references..."
sed -i 's/\.png/\.webp/g' app/static/index.html
sed -i 's/\.jpg/\.webp/g' app/static/index.html
# Also update the favicon reference explicitly just in case, though usually .ico or .png is preferred for favicon compatibility.
# Reverting favicon to .png for broad compatibility (or keep .webp if targeting modern browsers only)
# Let's keep favicon.png in HTML for safety, but logos/content images become webp.
sed -i 's/favicon\.webp/favicon.png/g' app/static/index.html

echo "Build Optimization Complete."

