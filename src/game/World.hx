package game;

import fried.physics.Collider;
import fried.scene.Node2D;

class World {
	public static inline var WIDTH = 1920;
	public static inline var HEIGHT = 1080;

	public static inline function clamp(value:Float, min:Float, max:Float):Float {
		return value < min ? min : (value > max ? max : value);
	}

	public static function keepInside(collider:Collider):Void {
		var owner = Std.downcast(collider.parent, Node2D);
		if (owner == null) {
			return;
		}
		owner.x += clamp(collider.left, 0, WIDTH - (collider.right - collider.left)) - collider.left;
		owner.y += clamp(collider.top, 0, HEIGHT - (collider.bottom - collider.top)) - collider.top;
	}
}
