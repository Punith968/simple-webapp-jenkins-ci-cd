from PIL import Image, ImageDraw, ImageFont
import os

OUT_DIR = os.path.join(os.getcwd(), 'screenshots')
SIZE = (1280, 720)
BG = (245, 247, 250)
FG = (20, 38, 61)
ACCENT = (15, 108, 189)

TEXTS = [
    ("jenkins_build.png", "Jenkins Build #10 — 4/4 Stages SUCCESS\nReplace with real screenshot"),
    ("docker_ps.png", "Docker ps — simple-webapp-demo 8090→80\nReplace with real screenshot"),
    ("app_browser.png", "App in Browser — http://localhost:8090\nReplace with real screenshot"),
]


def make_image(filename, text):
    img = Image.new('RGB', SIZE, BG)
    draw = ImageDraw.Draw(img)
    # Header bar
    draw.rectangle([(0, 0), (SIZE[0], 60)], fill=ACCENT)
    # Title
    title = filename.replace('.png', '').replace('_', ' ').title()
    draw.text((30, 15), title, fill=(255, 255, 255))
    # Center text
    lines = text.split('\n')
    y = SIZE[1] // 2 - 30
    for i, line in enumerate(lines):
        w, h = draw.textlength(line), 20
        x = (SIZE[0] - w) // 2
        draw.text((x, y + i * 28), line, fill=FG)
    img.save(os.path.join(OUT_DIR, filename))


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    for fn, txt in TEXTS:
        make_image(fn, txt)
    print("Created placeholder screenshots in:", OUT_DIR)


if __name__ == '__main__':
    main()
