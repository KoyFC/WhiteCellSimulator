package components;

import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Rect;
import fried.scene.Component;

@:serializable
class Checkerboard extends Component {
	public var width:Int;
	public var height:Int;
	public var tileSize:Int;
	public var colorA:Color;
	public var colorB:Color;

	var tile:Rect;

	public function new(width:Int, height:Int, tileSize:Int, colorA:Color, colorB:Color) {
		super();
		this.width = width;
		this.height = height;
		this.tileSize = tileSize;
		this.colorA = colorA;
		this.colorB = colorB;
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

		var scene = gameObject.scene;
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
				DrawQueue.submitFillRect(gameObject.priority, tile, (x + y) % 2 == 0 ? colorA : colorB);
			}
		}
	}
}
