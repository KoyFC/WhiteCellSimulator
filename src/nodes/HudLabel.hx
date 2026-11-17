package nodes;

import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Rect;
import fried.scene.Label;

// A Label on a filled box with padding around it. With a maxViewFraction it shrinks, and never grows, until the line fits in that fraction of the view's width, so a line is not cut off by a screen narrower than the one the scene was made for. The padding keeps its size while the text is scaled.
@:serializable
class HudLabel extends Label {
	public var backgroundColor:Color;
	public var paddingX:Int;
	public var paddingY:Int;
	public var maxViewFraction:Float;

	var rect:Rect = new Rect(0, 0, 0, 0);

	public function new(backgroundColor:Color = null, paddingX:Int = 0, paddingY:Int = 0, maxViewFraction:Float = 0.0) {
		super();
		name = "HudLabel";
		this.backgroundColor = backgroundColor != null ? backgroundColor : Color.rgb(0, 0, 0);
		this.paddingX = paddingX;
		this.paddingY = paddingY;
		this.maxViewFraction = maxViewFraction;
	}

	override function ensureWorld():Void {
		if (maxViewFraction > 0 && scene != null) {
			var width = textWidth + paddingX * 2;
			var fit = width > 0 ? Math.min(1, scene.viewWidth * maxViewFraction / width) : 1;
			if (fit != scaleX || fit != scaleY) {
				scaleX = fit;
				scaleY = fit;
			}
		}
		super.ensureWorld();
	}

	override function draw():Void {
		rect.x = Std.int(worldX) - paddingX;
		rect.y = Std.int(worldY) - paddingY;
		rect.width = Std.int(rectWidth) + paddingX * 2;
		rect.height = Std.int(rectHeight) + paddingY * 2;
		DrawQueue.submitFillRect(priority, rect, backgroundColor);
		super.draw();
	}
}
