import os
import sys
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer
from fontTools import subset

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE = os.path.join(ROOT, "engine", "assets", "NunitoSans.ttf")
OUT = os.path.join(ROOT, "assets", "UiFont.ttf")


def main():
    options = subset.Options()
    options.layout_features = ["kern"]
    options.hinting = False
    options.desubroutinize = True
    font = subset.load_font(SOURCE, options)
    subsetter = subset.Subsetter(options)
    subsetter.populate(unicodes=list(range(0x20, 0x7F)))
    subsetter.subset(font)
    if "fvar" in font:
        location = {axis.axisTag: axis.defaultValue for axis in font["fvar"].axes}
        font = instancer.instantiateVariableFont(font, location)
        for table in ("STAT", "MVAR", "HVAR", "avar"):
            if table in font:
                del font[table]
    font.save(OUT)
    print(OUT, os.path.getsize(OUT), "bytes")


main()
