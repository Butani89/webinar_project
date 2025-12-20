from PIL import Image
import random
import os
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def _set_pixel(pixels, x, y, color):
    """Helper to set a pixel color on the 16x16 grid."""
    if 0 <= x < 16 and 0 <= y < 16:
        pixels[y * 16 + x] = color

def _draw_stalk(pixels, stalk_fill_color, outline_color):
    """Draws the mushroom stalk."""
    for y in range(10, 16):
        for x in range(6, 10):
            _set_pixel(pixels, x, y, stalk_fill_color)
            if x == 6 or x == 9 or y == 15: # Stalk outline
                 _set_pixel(pixels, x, y, outline_color)

def _draw_cap(pixels, cap_fill_color, outline_color):
    """Draws the mushroom cap."""
    # Fill cap area
    for y in range(1, 10):
        for x in range(3, 13):
            # Roughly define the cap shape
            if (y == 1 and 5 <= x <= 10) or \
               (y == 2 and 4 <= x <= 11) or \
               (y == 3 and 3 <= x <= 12) or \
               (y > 3 and 2 <= x <= 13) and y < 10:
                _set_pixel(pixels, x, y, cap_fill_color)
    
    # Cap outline (simplified)
    # Top
    for x in range(5,11): _set_pixel(pixels, x, 1, outline_color)
    _set_pixel(pixels, 4, 2, outline_color)
    _set_pixel(pixels, 11, 2, outline_color)
    _set_pixel(pixels, 3, 3, outline_color)
    _set_pixel(pixels, 12, 3, outline_color)
    
    for y in range(4, 10):
        _set_pixel(pixels, 2, y, outline_color)
        _set_pixel(pixels, 13, y, outline_color)
    
    # Bottom edge of cap
    for x in range(3, 13): _set_pixel(pixels, x, 9, outline_color)
    
    # Connect cap to stalk
    for y in range(9, 11):
        if y == 9: # From cap bottom to stalk top
            for x in range(6, 10):
                _set_pixel(pixels, x, y, outline_color)
        elif y == 10: # Stalk top outline
            _set_pixel(pixels, 5, y, outline_color)
            _set_pixel(pixels, 10, y, outline_color)

def _draw_spots(pixels, cap_fill_color, spot_color):
    """Draws random spots on the mushroom cap."""
    num_spots = random.randint(3, 7)
    for _ in range(num_spots):
        spot_x = random.randint(3, 12)
        spot_y = random.randint(3, 8)
        # Ensure spot is on the cap and not too close to edges
        if pixels[spot_y * 16 + spot_x] == cap_fill_color:
            _set_pixel(pixels, spot_x, spot_y, spot_color)
            # Make spots slightly larger sometimes
            if random.random() < 0.3: # 30% chance for a larger spot
                if pixels[(spot_y+1) * 16 + spot_x] == cap_fill_color:
                    _set_pixel(pixels, spot_x, spot_y + 1, spot_color)
                if pixels[spot_y * 16 + (spot_x+1)] == cap_fill_color:
                    _set_pixel(pixels, spot_x + 1, spot_y, spot_color)
                if pixels[(spot_y+1) * 16 + (spot_x+1)] == cap_fill_color:
                    _set_pixel(pixels, spot_x + 1, spot_y + 1, spot_color)

def generate_mushroom(seed: int, output_path: str):
    random.seed(seed)

    # Define base colors
    T = (0, 0, 0, 0)      # Transparent
    OUTLINE_BROWN = (60, 40, 40) # Dark Brown (Outline)

    # Palettes for randomization
    CAP_COLORS = [
        (220, 50, 50),     # Red
        (50, 150, 50),     # Green
        (50, 50, 220),     # Blue
        (150, 50, 150),    # Purple
        (100, 70, 40),     # Brown
        (200, 100, 0)      # Orange
    ]
    SPOT_COLORS = [
        (255, 255, 255),   # White
        (255, 255, 0),     # Yellow
        (255, 165, 0)      # Orange
    ]
    STALK_COLORS = [
        (255, 255, 255),   # White
        (240, 220, 180),   # Beige
        (210, 180, 140)    # Tan
    ]

    # Choose random colors
    cap_fill_color = random.choice(CAP_COLORS)
    spot_color = random.choice(SPOT_COLORS)
    stalk_fill_color = random.choice(STALK_COLORS)

    # Initialize a 16x16 pixel grid with transparent pixels
    pixels = [T] * (16 * 16)

    _draw_stalk(pixels, stalk_fill_color, OUTLINE_BROWN)
    _draw_cap(pixels, cap_fill_color, OUTLINE_BROWN)
    _draw_spots(pixels, cap_fill_color, spot_color)

    # Create image
    img = Image.new('RGBA', (16, 16))
    img.putdata(pixels)

    # Resize to 64x64 for better visibility (nearest neighbor to keep pixel look)
    img = img.resize((64, 64), Image.NEAREST)

    # Ensure output directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path)

if __name__ == '__main__':
    # Example usage if script is run directly
    # This part should not be used by the main application,
    # but for testing the generation logic.
    logging.info("Generating example mushrooms...")
    for i in range(5):
        generate_mushroom(i, f'example_mushroom_{i}.png')
    logging.info("Generated 5 example mushrooms (example_mushroom_0.png to example_mushroom_4.png)")
