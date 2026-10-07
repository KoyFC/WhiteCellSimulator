import fried.Time;
import fried.physics.Collider;
import fried.physics.Physics;
import fried.scene.Component;

class Enemy extends Component {
	static inline var BASE_SPEED = 50;
	static inline var SPEED_PER_STEP = 10;
	static inline var MAX_SPEED = 150;

	static var overlapping:Array<Collider> = [];

	var target:Collider;

	public var collider(default, null):Collider;

	public function new(collider:Collider, target:Collider) {
		super();
		this.collider = collider;
		this.target = target;
	}

	override function update():Void {
		var dx = target.centerX - collider.centerX;
		var dy = target.centerY - collider.centerY;
		var distance = Math.sqrt(dx * dx + dy * dy);
		if (distance > 0) {
			transform.rotation = Math.atan2(dy, dx) * 180 / Math.PI + 90;
		}

		if (!collider.overlaps(target) && distance > 0) {
			var step = Math.min(MAX_SPEED, BASE_SPEED + GameState.difficultyStep() * SPEED_PER_STEP) * Time.deltaSeconds;
			transform.translate(dx / distance * step, dy / distance * step);
		}

		separateFromOtherEnemies();
		World.keepInside(collider);
	}

	function separateFromOtherEnemies():Void {
		Physics.overlapBoxAll(gameObject.scene, collider.left, collider.top, collider.right - collider.left, collider.bottom - collider.top,
			overlapping, collider);
		for (other in overlapping) {
			if (other.gameObject.getComponent(Enemy) == null) {
				continue;
			}
			var overlapX = Math.min(collider.right - other.left, other.right - collider.left);
			var overlapY = Math.min(collider.bottom - other.top, other.bottom - collider.top);
			if (overlapX < overlapY) {
				transform.x += (collider.centerX < other.centerX ? -overlapX : overlapX) / 2;
			} else {
				transform.y += (collider.centerY < other.centerY ? -overlapY : overlapY) / 2;
			}
		}
	}
}
