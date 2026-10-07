import fried.scene.Component;
import fried.scene.Sprite;

class InvincibilityBlink extends Component {
	static inline var BLINKS_PER_SECOND = 10;

	var sprite:Sprite;
	var health:Health;

	public function new(sprite:Sprite, health:Health) {
		super();
		this.sprite = sprite;
		this.health = health;
	}

	override function update():Void {
		sprite.enabled = !health.isInvincible || Std.int(health.invincibilityTimer * BLINKS_PER_SECOND) % 2 == 1;
	}
}
