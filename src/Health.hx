import fried.Time;
import fried.scene.Component;

class Health extends Component {
	public var maxHealth(default, null):Int;
	public var current(default, null):Int;
	public var invincibilityTime:Float;
	public var invincibilityTimer(default, null):Float = 0;

	public var isAlive(get, never):Bool;
	public var isInvincible(get, never):Bool;

	public var onDamage:Null<Int->Void>;
	public var onDeath:Null<Void->Void>;

	public function new(maxHealth:Int, invincibilityTime:Float = 0) {
		super();
		this.maxHealth = maxHealth;
		this.invincibilityTime = invincibilityTime;
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

	override function update():Void {
		if (invincibilityTimer > 0) {
			invincibilityTimer -= Time.deltaSeconds;
		}
	}

	inline function get_isAlive():Bool {
		return current > 0;
	}

	inline function get_isInvincible():Bool {
		return invincibilityTimer > 0;
	}
}
