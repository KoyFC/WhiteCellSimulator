import math
import os
import sys
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "src", "game", "VoxelModels.hx")


def load(name):
    image = Image.open(os.path.join(ROOT, "assets", name)).convert("RGBA")
    width, height = image.size
    pixels = [[image.getpixel((x, y)) for x in range(width)] for y in range(height)]
    return width, height, pixels


def distances(width, height, solid):
    far = 10 ** 6
    dist = [[far] * width for _ in range(height)]
    queue = []
    for y in range(height):
        for x in range(width):
            if not solid[y][x]:
                dist[y][x] = 0
                queue.append((x, y))
    head = 0
    while head < len(queue):
        x, y = queue[head]
        head += 1
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < width and 0 <= ny < height and dist[ny][nx] > dist[y][x] + 1:
                dist[ny][nx] = dist[y][x] + 1
                queue.append((nx, ny))
    for y in range(height):
        for x in range(width):
            if solid[y][x] and dist[y][x] == far:
                dist[y][x] = 1
    return dist


def dome(d, radius, top):
    t = min(d, radius) / radius
    return max(1, round(top * math.sqrt(max(0.0, 1.0 - (1.0 - t) ** 2))))


def is_yellow(c):
    return c[0] > 200 and c[1] > 170 and c[2] < 140


def is_navy(c):
    return c[0] < 40 and c[1] < 50 and c[2] < 110


def cell_heights(width, height, pixels, solid, dist):
    radius = max(max(row) for row in dist)
    heights = [[0] * width for _ in range(height)]
    for y in range(height):
        for x in range(width):
            if not solid[y][x]:
                continue
            h = dome(dist[y][x], radius, 6)
            c = pixels[y][x]
            if dist[y][x] >= 2 and (c[0] + c[1] + c[2]) / 3 < 150:
                h = max(1, h - 1)
            heights[y][x] = h
    return heights


def virus_heights(width, height, pixels, solid, dist):
    radius = max(max(row) for row in dist)
    heights = [[0] * width for _ in range(height)]
    for y in range(height):
        for x in range(width):
            if not solid[y][x]:
                continue
            c = pixels[y][x]
            h = dome(dist[y][x], radius, 9)
            if is_yellow(c):
                h = h + 1 if dist[y][x] >= 3 else max(h, 3)
            elif is_navy(c):
                h = max(1, min(h, 2))
            heights[y][x] = h
    return heights


def antibody_heights(width, height, pixels, solid, dist):
    heights = [[0] * width for _ in range(height)]
    for y in range(height):
        for x in range(width):
            if solid[y][x]:
                heights[y][x] = 2 if is_navy(pixels[y][x]) else 4
    return heights


def blood_cell():
    size = 21
    center = (size - 1) / 2
    radius = size / 2
    pixels = [[(0, 0, 0, 0)] * size for _ in range(size)]
    heights = [[0] * size for _ in range(size)]
    for y in range(size):
        for x in range(size):
            r = math.hypot(x - center, y - center)
            if r > radius - 0.3:
                continue
            t = r / radius
            h = max(1, round(1 + 4 * math.sin(math.pi * min(1.0, t * 1.05))))
            if t < 0.35:
                h = 2
            heights[y][x] = h
            if t < 0.35:
                color = (150, 20, 35, 255)
            elif t > 0.8:
                color = (170, 30, 45, 255)
            else:
                color = (215, 55, 68, 255) if h >= 4 else (195, 42, 56, 255)
            pixels[y][x] = color
    return size, size, pixels, heights


def b36(value):
    return "0123456789abcdefghijklmnopqrstuvwxyz"[value]


def encode(width, height, pixels, heights):
    palette = []
    heights_text = []
    colors_text = []
    for y in range(height):
        for x in range(width):
            h = heights[y][x]
            heights_text.append(b36(h))
            if h == 0:
                colors_text.append("0")
                continue
            c = pixels[y][x]
            packed = (c[0] << 16) | (c[1] << 8) | c[2]
            if packed not in palette:
                palette.append(packed)
            colors_text.append(b36(palette.index(packed)))
    return width, height, "".join(heights_text), "".join(colors_text), palette


def main():
    models = []
    for name, file, fn in (("cell", "white.png", cell_heights), ("virus", "virus.png", virus_heights), ("antibody", "anticuerpo.png", antibody_heights)):
        width, height, pixels = load(file)
        solid = [[pixels[y][x][3] > 0 for x in range(width)] for y in range(height)]
        dist = distances(width, height, solid)
        heights = fn(width, height, pixels, solid, dist)
        models.append((name,) + encode(width, height, pixels, heights))
    width, height, pixels, heights = blood_cell()
    models.append(("bloodCell",) + encode(width, height, pixels, heights))

    lines = ["package game;", "", "import fried.graphics3d.Mesh;", "", "class VoxelModels {"]
    for name, width, height, heights, colors, palette in models:
        lines.append("\tpublic static function %s(step:Int = 1):Mesh {" % name)
        lines.append("\t\treturn VoxelMesher.build(\"%s\", step, %d, %d, \"%s\", \"%s\", [%s]);" % (name, width, height, heights, colors, ", ".join("0x%06X" % c for c in palette)))
        lines.append("\t}")
        lines.append("")
    lines.pop()
    lines.append("}")
    with open(OUT, "w") as f:
        f.write("\n".join(lines) + "\n")
    for name, width, height, heights, colors, palette in models:
        print(name, width, height, len(palette), "colors")


main()
