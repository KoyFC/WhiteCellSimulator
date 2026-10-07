import fried.physics.Collider;

class World {
	public static inline var WIDTH = 1920;
	public static inline var HEIGHT = 1080;

	public static inline function clamp(value:Float, min:Float, max:Float):Float {
		return value < min ? min : (value > max ? max : value);
	}

	public static function keepInside(collider:Collider):Void {
		var transform = collider.transform;
		transform.x += clamp(collider.left, 0, WIDTH - (collider.right - collider.left)) - collider.left;
		transform.y += clamp(collider.top, 0, HEIGHT - (collider.bottom - collider.top)) - collider.top;
	}
}
