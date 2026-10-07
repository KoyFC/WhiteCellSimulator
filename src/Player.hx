import fried.Time;
import fried.graphics.Renderer;
import fried.graphics.Texture;
import fried.input.GamepadAxis;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.input.MouseButton;
import fried.io.Assets;
import fried.physics.Collider;
import fried.scene.Camera;
import fried.scene.Component;
import fried.scene.Sprite;

// Twin stick controls: WASD or the left stick move, and the arrows, the d-pad,
// the right stick or the mouse aim. Aiming with a key or a stick fires on its
// own, the mouse fires while its left button is held, and either way the
// player moves at half speed while shooting.
class Player extends Component {
	static inline var SHOOT_COOLDOWN = 0.1;
	static inline var SHOOTING_SPEED_FACTOR = 0.5;
	static inline var PROJECTILE_SPEED = 500;
	static inline var MAX_HEALTH = 3;
	static inline var INVINCIBILITY_TIME = 1.5;

	var speed:Float;
	var renderer:Renderer;
	var camera:Camera;
	var projectiles:ProjectilePool;

	var sprite:Sprite;

	public var collider(default, null):Collider;
	public var health(default, null):Health;

	var shootCooldown:Float = 0;
	var aimX:Float = 0;
	var aimY:Float = -1;
	var isAimingWithPointer:Bool = false;
	var lastMouseX:Int;
	var lastMouseY:Int;

	public function new(renderer:Renderer, camera:Camera, projectiles:ProjectilePool, speed:Float) {
		super();
		this.renderer = renderer;
		this.camera = camera;
		this.projectiles = projectiles;
		this.speed = speed;
	}

	override function start():Void {
		var texture = Texture.from(renderer, Assets.game("white.bmp"));
		sprite = gameObject.addComponent(new Sprite(texture));
		collider = gameObject.addComponent(new Collider(texture.width, texture.height));
		health = gameObject.addComponent(new Health(MAX_HEALTH, INVINCIBILITY_TIME));
		gameObject.addComponent(new InvincibilityBlink(sprite, health));
		lastMouseX = Input.mouseX;
		lastMouseY = Input.mouseY;
	}

	override function update():Void {
		if (shootCooldown > 0) {
			shootCooldown -= Time.deltaSeconds;
		}

		var shootX = Input.getGamepadAxis(GamepadAxis.RightX);
		var shootY = Input.getGamepadAxis(GamepadAxis.RightY);
		if (shootX == 0 && shootY == 0) {
			shootX = axis(Key.Left, Key.Right, GamepadButton.DpadLeft, GamepadButton.DpadRight);
			shootY = axis(Key.Up, Key.Down, GamepadButton.DpadUp, GamepadButton.DpadDown);
		}
		var isAimingWithStick = shootX != 0 || shootY != 0;

		var mouseMoved = Input.mouseX != lastMouseX || Input.mouseY != lastMouseY;
		lastMouseX = Input.mouseX;
		lastMouseY = Input.mouseY;
		if (isAimingWithStick) {
			isAimingWithPointer = false;
		} else if (mouseMoved || Input.isButtonPressed(MouseButton.Left)) {
			isAimingWithPointer = true;
		}

		var isShootingWithMouse = isAimingWithPointer && Input.isButtonPressed(MouseButton.Left);
		var isShooting = isAimingWithStick || isShootingWithMouse;

		move(isShooting ? speed * SHOOTING_SPEED_FACTOR : speed);

		if (isAimingWithStick) {
			aimX = shootX;
			aimY = shootY;
		} else if (isAimingWithPointer) {
			// Recomputed every frame rather than when the mouse moves, since the
			// camera moving under a still pointer changes what it points at.
			aimX = camera.screenToWorldX(Input.mouseX, renderer) - collider.centerX;
			aimY = camera.screenToWorldY(Input.mouseY, renderer) - collider.centerY;
		}
		if (aimX != 0 || aimY != 0) {
			transform.rotation = Math.atan2(aimY, aimX) * 180 / Math.PI + 90;
		}

		if (isShooting && shootCooldown <= 0 && (aimX != 0 || aimY != 0)) {
			projectiles.fire(collider.centerX, collider.centerY, aimX, aimY, PROJECTILE_SPEED);
			shootCooldown = SHOOT_COOLDOWN;
		}
	}

	function move(currentSpeed:Float):Void {
		var dx = Input.getGamepadAxis(GamepadAxis.LeftX);
		var dy = Input.getGamepadAxis(GamepadAxis.LeftY);
		if (Input.isKeyPressed(Key.A)) {
			dx -= 1;
		}
		if (Input.isKeyPressed(Key.D)) {
			dx += 1;
		}
		if (Input.isKeyPressed(Key.W)) {
			dy -= 1;
		}
		if (Input.isKeyPressed(Key.S)) {
			dy += 1;
		}

		// Normalised only past unit length, so a stick held halfway still walks
		// at half speed while a diagonal on the keys is no faster than a straight line.
		var length = Math.sqrt(dx * dx + dy * dy);
		if (length > 1) {
			dx /= length;
			dy /= length;
		}

		transform.translate(dx * currentSpeed * Time.deltaSeconds, dy * currentSpeed * Time.deltaSeconds);
		World.keepInside(collider);
	}

	static function axis(negativeKey:Key, positiveKey:Key, negativeButton:GamepadButton, positiveButton:GamepadButton):Float {
		var value:Float = 0;
		if (Input.isKeyPressed(negativeKey) || Input.isGamepadButtonPressed(negativeButton)) {
			value -= 1;
		}
		if (Input.isKeyPressed(positiveKey) || Input.isGamepadButtonPressed(positiveButton)) {
			value += 1;
		}
		return value;
	}
}
