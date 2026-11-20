package nodes;

import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Rect;
import fried.scene.CanvasItem;

@:serializable
class Backdrop extends CanvasItem {
	static inline var BANDS = 32;

	public var topColor:Color;
	public var bottomColor:Color;

	var rect:Rect = new Rect(0, 0, 0, 0);

	public function new(topColor:Color = null, bottomColor:Color = null) {
		super("Backdrop");
		this.topColor = topColor != null ? topColor : Color.rgb(20, 4, 12);
		this.bottomColor = bottomColor != null ? bottomColor : Color.rgb(150, 40, 50);
		priority = -1000;
	}

	override function draw():Void {
		var width = scene.viewWidth;
		var height = scene.viewHeight;
		if (width <= 0) {
			return;
		}
		for (band in 0...BANDS) {
			var t = band / (BANDS - 1);
			rect.x = 0;
			rect.y = Std.int(band * height / BANDS);
			rect.width = width;
			rect.height = Std.int((band + 1) * height / BANDS) - rect.y + 1;
			DrawQueue.submitFillRect(priority, rect, Color.rgb(mix(topColor.red, bottomColor.red, t), mix(topColor.green, bottomColor.green, t), mix(topColor.blue, bottomColor.blue, t)));
		}
	}

	static inline function mix(a:Int, b:Int, t:Float):Int {
		return Std.int(a + (b - a) * t);
	}
}
