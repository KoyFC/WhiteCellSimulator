package nodes;

import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Rect;
import fried.scene.Node2D;

@:serializable
class Checkerboard extends Node2D {
	public var width:Int;
	public var height:Int;
	public var tileSize:Int;
	public var colorA:Color;
	public var colorB:Color;

	var tile:Rect;

	public function new(width:Int = 0, height:Int = 0, tileSize:Int = 64, colorA:Color = null, colorB:Color = null) {
		super();
		name = "Checkerboard";
		this.width = width;
		this.height = height;
		this.tileSize = tileSize;
		this.colorA = colorA != null ? colorA : Color.rgb(0, 0, 0);
		this.colorB = colorB != null ? colorB : Color.rgb(255, 255, 255);
		tile = new Rect(0, 0, tileSize, tileSize);
	}

	override function draw():Void {
		tile.width = tileSize;
		tile.height = tileSize;
		var tilesX = Math.ceil(width / tileSize);
		var tilesY = Math.ceil(height / tileSize);
		var firstX = 0;
		var firstY = 0;
		var lastX = tilesX - 1;
		var lastY = tilesY - 1;

		var camera = scene.camera;
		var viewWidth = scene.viewWidth;
		var viewHeight = scene.viewHeight;
		if (viewWidth > 0) {
			var left = camera != null ? camera.screenToWorldX(0) : 0;
			var top = camera != null ? camera.screenToWorldY(0) : 0;
			var right = camera != null ? camera.screenToWorldX(viewWidth) : viewWidth;
			var bottom = camera != null ? camera.screenToWorldY(viewHeight) : viewHeight;
			firstX = Std.int(Math.max(0, Math.floor(left / tileSize)));
			firstY = Std.int(Math.max(0, Math.floor(top / tileSize)));
			lastX = Std.int(Math.min(lastX, Math.floor(right / tileSize)));
			lastY = Std.int(Math.min(lastY, Math.floor(bottom / tileSize)));
		}

		for (y in firstY...lastY + 1) {
			for (x in firstX...lastX + 1) {
				tile.x = x * tileSize;
				tile.y = y * tileSize;
				DrawQueue.submitFillRect(priority, tile, (x + y) % 2 == 0 ? colorA : colorB);
			}
		}
	}
}
