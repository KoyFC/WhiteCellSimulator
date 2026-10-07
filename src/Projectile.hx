import fried.Time;
import fried.physics.Collider;
import fried.physics.Physics;
import fried.scene.Component;

class Projectile extends Component {
	static inline var DAMAGE = 1;

	static var overlapping:Array<Collider> = [];

	var velocityX:Float = 0;
	var velocityY:Float = 0;

	public var collider(default, null):Collider;

	public function new(collider:Collider) {
		super();
		this.collider = collider;
	}

	public function fire(x:Float, y:Float, directionX:Float, directionY:Float, speed:Float):Void {
		var length = Math.sqrt(directionX * directionX + directionY * directionY);
		if (length == 0) {
			return;
		}
		velocityX = directionX / length * speed;
		velocityY = directionY / length * speed;
		transform.x = x - (collider.centerX - transform.x);
		transform.y = y - (collider.centerY - transform.y);
		transform.rotation = Math.atan2(velocityY, velocityX) * 180 / Math.PI + 90;
		gameObject.isActive = true;
	}

	public function deactivate():Void {
		gameObject.isActive = false;
	}

	override function update():Void {
		transform.translate(velocityX * Time.deltaSeconds, velocityY * Time.deltaSeconds);
		if (collider.right < 0 || collider.left > World.WIDTH || collider.bottom < 0 || collider.top > World.HEIGHT) {
			deactivate();
			return;
		}

		Physics.overlapBoxAll(gameObject.scene, collider.left, collider.top, collider.right - collider.left, collider.bottom - collider.top,
			overlapping, collider);
		for (other in overlapping) {
			var enemy = other.gameObject.getComponent(Enemy);
			if (enemy != null) {
				enemy.health.takeDamage(DAMAGE);
				deactivate();
				return;
			}
		}
	}
}
