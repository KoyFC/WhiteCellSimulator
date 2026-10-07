class World {
	public static inline var WIDTH = 1920;
	public static inline var HEIGHT = 1080;

	public static inline function clamp(value:Float, min:Float, max:Float):Float {
		return value < min ? min : (value > max ? max : value);
	}
}
