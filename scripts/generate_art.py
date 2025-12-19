from PIL import Image
import random
import os

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

    def set_pixel(x, y, color):
        if 0 <= x < 16 and 0 <= y < 16:
            pixels[y * 16 + x] = color

    # Draw mushroom base shape (simplified outline, then fill)
    # Stalk
    for y in range(10, 16):
        for x in range(6, 10):
            set_pixel(x, y, stalk_fill_color)
            if x == 6 or x == 9 or y == 15: # Stalk outline
                 set_pixel(x,y, OUTLINE_BROWN)
    
    # Cap
    # Fill cap area
    for y in range(1, 10):
        for x in range(3, 13):
            # Roughly define the cap shape
            if (y == 1 and 5 <= x <= 10) or \
               (y == 2 and 4 <= x <= 11) or \
               (y == 3 and 3 <= x <= 12) or \
               (y > 3 and 2 <= x <= 13) and y < 10:
                set_pixel(x, y, cap_fill_color)
    
    # Cap outline (simplified)
    # Top
    for x in range(5,11): set_pixel(x, 1, OUTLINE_BROWN)
    set_pixel(4,2, OUTLINE_BROWN)
    set_pixel(11,2, OUTLINE_BROWN)
    set_pixel(3,3, OUTLINE_BROWN)
    set_pixel(12,3, OUTLINE_BROWN)
    
    for y in range(4, 10):
        set_pixel(2, y, OUTLINE_BROWN)
        set_pixel(13, y, OUTLINE_BROWN)
    
    # Bottom edge of cap
    for x in range(3, 13): set_pixel(x, 9, OUTLINE_BROWN)
    
    # Connect cap to stalk
    for y in range(9, 11):
        if y == 9: # From cap bottom to stalk top
            for x in range(6, 10):
                set_pixel(x, y, OUTLINE_BROWN)
        elif y == 10: # Stalk top outline
            set_pixel(5, y, OUTLINE_BROWN)
            set_pixel(10, y, OUTLINE_BROWN)


    # Random spots on cap
    num_spots = random.randint(3, 7)
    for _ in range(num_spots):
        spot_x = random.randint(3, 12)
        spot_y = random.randint(3, 8)
        # Ensure spot is on the cap and not too close to edges
        if pixels[spot_y * 16 + spot_x] == cap_fill_color:
            set_pixel(spot_x, spot_y, spot_color)
            # Make spots slightly larger sometimes
            if random.random() < 0.3: # 30% chance for a larger spot
                if pixels[(spot_y+1) * 16 + spot_x] == cap_fill_color:
                    set_pixel(spot_x, spot_y + 1, spot_color)
                if pixels[spot_y * 16 + (spot_x+1)] == cap_fill_color:
                    set_pixel(spot_x + 1, spot_y, spot_color)
                if pixels[(spot_y+1) * 16 + (spot_x+1)] == cap_fill_color:
                    set_pixel(spot_x + 1, spot_y + 1, spot_color)

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
    print("Generating example mushrooms...")
    for i in range(5):
        generate_mushroom(i, f'example_mushroom_{i}.png')
    print("Generated 5 example mushrooms (example_mushroom_0.png to example_mushroom_4.png)")
