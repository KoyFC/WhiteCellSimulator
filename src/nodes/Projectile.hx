package nodes;

import game.World;
import fried.physics.Collider;
import fried.physics.Physics;
import fried.graphics.Texture;
import fried.scene.Sprite;

class Projectile extends Sprite {
	static inline var DAMAGE = 1;

	static var overlapping:Array<Collider> = [];

	var velocityX:Float = 0;
	var velocityY:Float = 0;

	public var collider(default, null):Collider;

	public function new(texture:Texture) {
		super(texture);
		name = "Projectile";
		collider = addChild(new Collider(texture.width, texture.height));
	}

	public function fire(x:Float, y:Float, directionX:Float, directionY:Float, speed:Float):Void {
		var length = Math.sqrt(directionX * directionX + directionY * directionY);
		if (length == 0) {
			return;
		}
		velocityX = directionX / length * speed;
		velocityY = directionY / length * speed;
		this.x = x - (collider.centerX - this.x);
		this.y = y - (collider.centerY - this.y);
		rotation = Math.atan2(velocityY, velocityX) * 180 / Math.PI + 90;
		active = true;
	}

	public function deactivate():Void {
		active = false;
	}

	override function update(delta:Float):Void {
		translate(velocityX * delta, velocityY * delta);
		if (collider.right < 0 || collider.left > World.WIDTH || collider.bottom < 0 || collider.top > World.HEIGHT) {
			deactivate();
			return;
		}

		Physics.overlapBoxAll(scene, collider.left, collider.top, collider.right - collider.left, collider.bottom - collider.top,
			overlapping, collider);
		for (other in overlapping) {
			var enemy = Std.downcast(other.parent, Enemy);
			if (enemy != null) {
				enemy.health.takeDamage(DAMAGE);
				deactivate();
				return;
			}
		}
	}
}
