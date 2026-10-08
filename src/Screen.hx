import fried.graphics.Renderer;

class Screen {
	static inline var DESIGN_HEIGHT = 540;
	static inline var SMALL_HEIGHT = 240;
	static inline var SMALL_DIVISOR = 3;

	public static var isSmall(default, null):Bool = false;
	public static var zoom(default, null):Float = 1;

	public static function init(renderer:Renderer):Void {
		isSmall = renderer.height < SMALL_HEIGHT;
		zoom = isSmall ? renderer.height / DESIGN_HEIGHT : 1;
	}

	public static function scale(value:Int):Int {
		return isSmall ? Std.int(Math.max(1, Math.round(value / SMALL_DIVISOR))) : value;
	}
}
