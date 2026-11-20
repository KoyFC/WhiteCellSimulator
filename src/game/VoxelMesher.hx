package game;

import fried.graphics.Color;
import fried.graphics3d.Mesh;

class VoxelMesher {
	static var cache:Map<String, Mesh> = new Map();

	public static function build(name:String, step:Int, width:Int, height:Int, heightText:String, colorText:String, palette:Array<Int>):Mesh {
		var key = name + ":" + step;
		var found = cache.get(key);
		if (found != null) {
			return found;
		}
		var gridWidth = Math.ceil(width / step);
		var gridHeight = Math.ceil(height / step);
		var heights:Array<Int> = [];
		var colors:Array<Int> = [];
		for (blockY in 0...gridHeight) {
			for (blockX in 0...gridWidth) {
				var best = 0;
				var bestColor = 0;
				for (y in blockY * step...Std.int(Math.min(height, (blockY + 1) * step))) {
					for (x in blockX * step...Std.int(Math.min(width, (blockX + 1) * step))) {
						var h = digit(heightText, y * width + x);
						if (h > best) {
							best = h;
							bestColor = palette[digit(colorText, y * width + x)];
						}
					}
				}
				heights.push(best == 0 ? 0 : Std.int(Math.max(1, Math.round(best / step))));
				colors.push(bestColor);
			}
		}
		found = mesh(gridWidth, gridHeight, heights, colors, step / width);
		cache.set(key, found);
		return found;
	}

	static function digit(text:String, index:Int):Int {
		var code = text.charCodeAt(index);
		return code >= 97 ? code - 87 : code - 48;
	}

	static function mesh(gridWidth:Int, gridHeight:Int, heights:Array<Int>, colors:Array<Int>, unit:Float):Mesh {
		var vertices:Array<Float> = [];
		var indices:Array<Int> = [];
		var triangleColors:Array<Color> = [];
		var halfWidth = gridWidth * unit / 2;
		var halfHeight = gridHeight * unit / 2;

		inline function heightAt(x:Int, y:Int):Int {
			return x >= 0 && x < gridWidth && y >= 0 && y < gridHeight ? heights[y * gridWidth + x] : 0;
		}

		inline function colorAt(x:Int, y:Int):Int {
			return colors[y * gridWidth + x];
		}

		inline function px(x:Int):Float {
			return x * unit - halfWidth;
		}

		inline function pz(y:Int):Float {
			return halfHeight - y * unit;
		}

		function quad(corners:Array<Float>, nx:Float, ny:Float, nz:Float, color:Int):Void {
			var base = Std.int(vertices.length / 3);
			for (value in corners) {
				vertices.push(value);
			}
			var ax = corners[3] - corners[0];
			var ay = corners[4] - corners[1];
			var az = corners[5] - corners[2];
			var bx = corners[6] - corners[0];
			var by = corners[7] - corners[1];
			var bz = corners[8] - corners[2];
			var dot = (ay * bz - az * by) * nx + (az * bx - ax * bz) * ny + (ax * by - ay * bx) * nz;
			if (dot < 0) {
				indices.push(base);
				indices.push(base + 2);
				indices.push(base + 1);
				indices.push(base);
				indices.push(base + 3);
				indices.push(base + 2);
			} else {
				indices.push(base);
				indices.push(base + 1);
				indices.push(base + 2);
				indices.push(base);
				indices.push(base + 2);
				indices.push(base + 3);
			}
			var packed = Color.rgb((color >> 16) & 255, (color >> 8) & 255, color & 255);
			triangleColors.push(packed);
			triangleColors.push(packed);
		}

		for (y in 0...gridHeight) {
			var x = 0;
			while (x < gridWidth) {
				var h = heightAt(x, y);
				if (h == 0) {
					x++;
					continue;
				}
				var color = colorAt(x, y);
				var end = x + 1;
				while (end < gridWidth && heightAt(end, y) == h && colorAt(end, y) == color) {
					end++;
				}
				var top = h * unit;
				quad([px(x), top, pz(y), px(end), top, pz(y), px(end), top, pz(y + 1), px(x), top, pz(y + 1)], 0, 1, 0, color);
				x = end;
			}
		}

		for (dy in [-1, 1]) {
			for (y in 0...gridHeight) {
				var x = 0;
				while (x < gridWidth) {
					var h = heightAt(x, y);
					var lower = heightAt(x, y + dy);
					if (h <= lower) {
						x++;
						continue;
					}
					var color = colorAt(x, y);
					var end = x + 1;
					while (end < gridWidth && heightAt(end, y) == h && heightAt(end, y + dy) == lower && colorAt(end, y) == color) {
						end++;
					}
					var edge = pz(dy < 0 ? y : y + 1);
					var lo = lower * unit;
					var hi = h * unit;
					quad([px(x), lo, edge, px(end), lo, edge, px(end), hi, edge, px(x), hi, edge], 0, 0, -dy, color);
					x = end;
				}
			}
		}

		for (dx in [-1, 1]) {
			for (x in 0...gridWidth) {
				var y = 0;
				while (y < gridHeight) {
					var h = heightAt(x, y);
					var lower = heightAt(x + dx, y);
					if (h <= lower) {
						y++;
						continue;
					}
					var color = colorAt(x, y);
					var end = y + 1;
					while (end < gridHeight && heightAt(x, end) == h && heightAt(x + dx, end) == lower && colorAt(x, end) == color) {
						end++;
					}
					var edge = px(dx < 0 ? x : x + 1);
					var lo = lower * unit;
					var hi = h * unit;
					quad([edge, lo, pz(y), edge, lo, pz(end), edge, hi, pz(end), edge, hi, pz(y)], dx, 0, 0, color);
					y = end;
				}
			}
		}
		return new Mesh(vertices, indices, triangleColors);
	}
}
