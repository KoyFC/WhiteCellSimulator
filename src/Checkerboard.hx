import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Rect;
import fried.scene.Component;

class Checkerboard extends Component {
	var tileSize:Int;
	var width:Int;
	var height:Int;
	var colorA:Color;
	var colorB:Color;
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
		var tilesX = Math.ceil(width / tileSize);
		var tilesY = Math.ceil(height / tileSize);
		var firstX = 0;
		var firstY = 0;
		var lastX = tilesX - 1;
		var lastY = tilesY - 1;

		var camera = gameObject.scene.camera;
		var renderer = DrawQueue.currentRenderTarget;
		if (renderer != null) {
			var left = camera != null ? camera.screenToWorldX(0, renderer) : 0;
			var top = camera != null ? camera.screenToWorldY(0, renderer) : 0;
			var right = camera != null ? camera.screenToWorldX(renderer.width, renderer) : renderer.width;
			var bottom = camera != null ? camera.screenToWorldY(renderer.height, renderer) : renderer.height;
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
