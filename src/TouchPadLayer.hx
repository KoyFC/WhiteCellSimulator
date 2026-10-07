import fried.Layer;
import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Rect;
import fried.input.Input;

class TouchPadLayer extends Layer {
	static inline var BORDER = 2;
	static inline var LINE = 2;
	static inline var MARKER_SIZE = 12;

	var lineColor:Color = Color.rgb(255, 255, 255);
	var markerColor:Color = Color.rgb(255, 0, 0);
	var rect:Rect = new Rect(0, 0, 0, 0);

	public function new() {
		super("Touch Pad");
	}

	override function draw():Void {
		var width = renderer.width;
		var height = renderer.height;

		fill(0, 0, width, BORDER, lineColor);
		fill(0, height - BORDER, width, BORDER, lineColor);
		fill(0, 0, BORDER, height, lineColor);
		fill(width - BORDER, 0, BORDER, height, lineColor);
		fill(0, Std.int(height / 2) - Std.int(LINE / 2), width, LINE, lineColor);
		fill(Std.int(width / 2) - Std.int(LINE / 2), 0, LINE, height, lineColor);

		if (Input.getTouchCount() > 0) {
			fill(Input.getTouchX(0) - Std.int(MARKER_SIZE / 2), Input.getTouchY(0) - Std.int(MARKER_SIZE / 2), MARKER_SIZE, MARKER_SIZE, markerColor);
		}
	}

	function fill(x:Int, y:Int, width:Int, height:Int, color:Color):Void {
		rect.x = x;
		rect.y = y;
		rect.width = width;
		rect.height = height;
		DrawQueue.submitFillRect(0, rect, color);
	}
}
