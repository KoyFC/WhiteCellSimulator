package components;

import fried.scene.Component;
import fried.scene.Sprite;

@:serializable
class InvincibilityBlink extends Component {
	static inline var BLINKS_PER_SECOND = 10;

	var sprite:Sprite;
	var health:Health;

	override function start():Void {
		sprite = gameObject.getComponent(Sprite);
		health = gameObject.getComponent(Health);
		if (sprite == null || health == null) {
			throw 'An InvincibilityBlink needs a Sprite and a Health on ${gameObject.name}.';
		}
	}

	override function update():Void {
		sprite.enabled = !health.isInvincible || Std.int(health.invincibilityTimer * BLINKS_PER_SECOND) % 2 == 1;
	}
}
