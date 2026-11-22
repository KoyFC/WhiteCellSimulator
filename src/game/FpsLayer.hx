package game;

import fried.Layer;
import fried.Time;
import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Font;
import fried.graphics.Rect;

// Shows the frames a second the game runs at, averaged over a fraction of a second so the number can be read.
class FpsLayer extends Layer {
	static inline var REFRESH_SECONDS = 0.5;
	static inline var MARGIN = 6;
	static inline var PADDING = 4;

	var font:Font;
	var textColor:Color = Color.rgb(255, 255, 255);
	var backgroundColor:Color = Color.rgba(0, 0, 0, 160);
	var rect:Rect = new Rect(0, 0, 0, 0);
	var text:String = "FPS 0";
	var textWidth:Int;
	var lastFrame:Int;
	var lastTime:Float;

	public function new(font:Font) {
		super("FPS");
		this.font = font;
		textWidth = font.measureWidth(text);
		lastFrame = Time.frameCount;
		lastTime = Time.unscaledElapsedSeconds;
	}

	override function update(delta:Float):Void {
		var interval = Time.unscaledElapsedSeconds - lastTime;
		if (interval < REFRESH_SECONDS) {
			return;
		}
		text = "FPS " + Math.round((Time.frameCount - lastFrame) / interval);
		textWidth = font.measureWidth(text);
		lastFrame = Time.frameCount;
		lastTime = Time.unscaledElapsedSeconds;
	}

	override function draw():Void {
		rect.width = textWidth + PADDING * 2;
		rect.height = font.lineHeight + PADDING * 2;
		rect.x = MARGIN;
		rect.y = renderer.height - MARGIN - rect.height;
		DrawQueue.submitFillRect(0, rect, backgroundColor);
		DrawQueue.submitText(1, font, text, rect.x + PADDING, rect.y + PADDING, textWidth, font.lineHeight, textColor);
	}
}
