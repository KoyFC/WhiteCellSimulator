import fried.Time;
import fried.physics.Collider;
import fried.physics.Physics;
import fried.scene.Component;
import fried.scene.Sprite;

class Enemy extends Component {
	static inline var BASE_SPEED = 50;
	static inline var SPEED_PER_STEP = 10;
	static inline var MAX_SPEED = 150;
	static inline var MAX_HEALTH = 3;
	static inline var INVINCIBILITY_TIME = 0.5;
	static inline var CONTACT_DAMAGE = 1;
	static inline var BASE_POINTS = 10;
	static inline var POINTS_PER_STEP = 5;

	static var overlapping:Array<Collider> = [];

	var target:Player;

	public var collider(default, null):Collider;
	public var health(default, null):Health;

	public function new(collider:Collider, target:Player) {
		super();
		this.collider = collider;
		this.target = target;
	}

	override function start():Void {
		health = gameObject.addComponent(new Health(MAX_HEALTH, INVINCIBILITY_TIME));
		health.onDeath = function() {
			GameState.addScore(BASE_POINTS + GameState.difficultyStep() * POINTS_PER_STEP);
			gameObject.destroy();
		};
		gameObject.addComponent(new InvincibilityBlink(gameObject.getComponent(Sprite), health));
	}

	override function update():Void {
		var targetCollider = target.collider;
		if (collider.overlaps(targetCollider)) {
			target.health.takeDamage(CONTACT_DAMAGE);
			gameObject.destroy();
			return;
		}

		var dx = targetCollider.centerX - collider.centerX;
		var dy = targetCollider.centerY - collider.centerY;
		var distance = Math.sqrt(dx * dx + dy * dy);
		if (distance > 0) {
			transform.rotation = Math.atan2(dy, dx) * 180 / Math.PI + 90;
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
