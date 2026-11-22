package nodes;

import fried.scene.Node;
import fried.scene.Sprite;
import game.GameState;

// Blinks the Sprite it is a child of while its Health is invincible.
@:serializable
class InvincibilityBlink extends Node {
	static inline var BLINKS_PER_SECOND = 10;

	var sprite:Sprite;
	var health:Health;

	public function new() {
		super("InvincibilityBlink");
	}

	override function ready():Void {
		sprite = Std.downcast(parent, Sprite);
		health = parent == null ? null : parent.findChild(Health);
		if (sprite == null || health == null) {
			throw 'An InvincibilityBlink needs a Sprite as its parent and a Health beside it on $name.';
		}
	}

	override function update(delta:Float):Void {
		if (GameState.isPaused) {
			return;
		}
		sprite.visible = !health.isInvincible || Std.int(health.invincibilityTimer * BLINKS_PER_SECOND) % 2 == 1;
	}
}
