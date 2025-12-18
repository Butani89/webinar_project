from PIL import Image

# Define colors (R, G, B)
T = (0, 0, 0, 0)      # Transparent
R = (220, 50, 50)     # Red (Cap)
W = (255, 255, 255)   # White (Spots/Stalk)
S = (240, 220, 180)   # Stalk shadow/outline
B = (60, 40, 40)      # Dark Brown (Outline)

# 16x16 Pixel Art Mushroom
pixels = [
    T, T, T, T, T, B, B, B, B, B, B, T, T, T, T, T,
    T, T, T, B, B, R, R, R, R, R, R, B, B, T, T, T,
    T, T, B, R, R, R, R, W, W, R, R, R, R, B, T, T,
    T, B, R, R, W, W, R, W, W, R, R, R, R, R, B, T,
    T, B, R, R, W, W, R, R, R, R, R, W, W, R, B, T,
    B, R, R, R, R, R, R, R, R, R, R, W, W, R, R, B,
    B, R, R, R, R, R, R, R, R, R, R, R, R, R, R, B,
    B, R, W, W, R, R, R, R, R, R, R, R, R, R, R, B,
    B, R, W, W, R, R, R, R, R, R, R, R, R, R, R, B,
    T, B, R, R, R, B, B, B, B, B, B, R, R, R, B, T,
    T, T, B, B, B, W, W, W, W, W, W, B, B, B, T, T,
    T, T, T, B, W, W, W, W, W, W, W, W, B, T, T, T,
    T, T, T, B, W, W, W, W, W, W, W, W, B, T, T, T,
    T, T, T, B, W, W, W, W, W, W, W, W, B, T, T, T,
    T, T, T, B, W, W, W, W, W, W, W, W, B, T, T, T,
    T, T, T, T, B, B, B, B, B, B, B, B, T, T, T, T
]

# Create image
img = Image.new('RGBA', (16, 16))
img.putdata(pixels)

# Resize to 32x32 for better visibility (nearest neighbor to keep pixel look)
img = img.resize((32, 32), Image.NEAREST)

# Save as favicon.png and logo.png
img.save('favicon.png')
img.save('logo.png')
print("Generated favicon.png and logo.png")
