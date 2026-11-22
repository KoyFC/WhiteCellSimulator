package nodes;

import fried.scene.Node;
import game.GameState;

// Hit points and the short invincibility after a hit. A child of what can be hurt.
@:serializable
class Health extends Node {
	public var maxHealth:Int;
	public var invincibilityTime:Float;

	public var current(default, null):Int;
	public var invincibilityTimer(default, null):Float = 0;

	public var isAlive(get, never):Bool;
	public var isInvincible(get, never):Bool;

	public var onDamage:Null<Int->Void>;
	public var onDeath:Null<Void->Void>;

	public function new(maxHealth:Int = 1, invincibilityTime:Float = 0) {
		super("Health");
		this.maxHealth = maxHealth;
		this.invincibilityTime = invincibilityTime;
		current = maxHealth;
	}

	override function ready():Void {
		current = maxHealth;
	}

	public function takeDamage(amount:Int):Bool {
		if (!isAlive || isInvincible || amount <= 0) {
			return false;
		}
		current = amount >= current ? 0 : current - amount;
		invincibilityTimer = invincibilityTime;
		if (onDamage != null) {
			onDamage(amount);
		}
		if (!isAlive && onDeath != null) {
			onDeath();
		}
		return true;
	}

	override function update(delta:Float):Void {
		if (GameState.isPaused) {
			return;
		}
		if (invincibilityTimer > 0) {
			invincibilityTimer -= delta;
		}
	}

	inline function get_isAlive():Bool {
		return current > 0;
	}

	inline function get_isInvincible():Bool {
		return invincibilityTimer > 0;
	}
}
