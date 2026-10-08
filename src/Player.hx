import fried.Time;
import fried.audio.Sound;
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
// the right stick, a touch or the mouse aim. On a small screen, which is the
// calculator's, the arrows move instead and the digits 1 to 9 aim the way they
// sit around 5, 9 up and right and 1 down and left.
// Aiming with a key, a stick or a touch fires on its own, the mouse fires while
// its left button is held, and either way the player moves at half speed while
// shooting. With a touch pad, a touch aims from the pad's centre rather than at
// the point of the world it lands on, which is how the 3DS aims from its bottom
// screen.
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
	var touchPad:Null<Renderer>;

	var sprite:Sprite;
	var shootSound:Sound;

	public var collider(default, null):Collider;
	public var health(default, null):Health;

	var shootCooldown:Float = 0;
	var aimX:Float = 0;
	var aimY:Float = -1;
	var isAimingWithPointer:Bool = false;
	var lastMouseX:Int;
	var lastMouseY:Int;

	public function new(renderer:Renderer, camera:Camera, projectiles:ProjectilePool, speed:Float, ?touchPad:Renderer) {
		super();
		this.renderer = renderer;
		this.camera = camera;
		this.projectiles = projectiles;
		this.speed = speed;
		this.touchPad = touchPad;
	}

	override function start():Void {
		var texture = Texture.from(renderer, Assets.game("white.png"));
		sprite = gameObject.addComponent(new Sprite(texture));
		collider = gameObject.addComponent(new Collider(texture.width, texture.height));
		health = gameObject.addComponent(new Health(MAX_HEALTH, INVINCIBILITY_TIME));
		gameObject.addComponent(new InvincibilityBlink(sprite, health));
		shootSound = Sound.from(Assets.game("sounds/shoot.wav"));
		var hurtSound = Sound.from(Assets.game("sounds/player_hurt.wav"));
		health.onDamage = function(_) {
			hurtSound.play();
		};
		lastMouseX = Input.mouseX;
		lastMouseY = Input.mouseY;
	}

	override function update():Void {
		if (shootCooldown > 0) {
			shootCooldown -= Time.deltaSeconds;
		}

		var shootX = Input.getGamepadAxis(GamepadAxis.RightX);
		var shootY = Input.getGamepadAxis(GamepadAxis.RightY);
		if (shootX == 0 && shootY == 0 && Screen.isSmall) {
			shootX = keyAxis(Key.Num7, Key.Num9) + keyAxis(Key.Num4, Key.Num6) + keyAxis(Key.Num1, Key.Num3);
			shootY = keyAxis(Key.Num7, Key.Num1) + keyAxis(Key.Num8, Key.Num2) + keyAxis(Key.Num9, Key.Num3);
		} else if (shootX == 0 && shootY == 0) {
			shootX = axis(Key.Left, Key.Right, GamepadButton.DpadLeft, GamepadButton.DpadRight);
			shootY = axis(Key.Up, Key.Down, GamepadButton.DpadUp, GamepadButton.DpadDown);
		}
		var isAimingWithStick = shootX != 0 || shootY != 0;
		var isAimingWithTouch = !isAimingWithStick && Input.getTouchCount() > 0;

		var mouseMoved = Input.mouseX != lastMouseX || Input.mouseY != lastMouseY;
		lastMouseX = Input.mouseX;
		lastMouseY = Input.mouseY;
		if (isAimingWithStick || isAimingWithTouch) {
			isAimingWithPointer = false;
		} else if (mouseMoved || Input.isButtonPressed(MouseButton.Left)) {
			isAimingWithPointer = true;
		}

		var isShootingWithMouse = isAimingWithPointer && Input.isButtonPressed(MouseButton.Left);
		var isShooting = isAimingWithStick || isAimingWithTouch || isShootingWithMouse;

		move(isShooting ? speed * SHOOTING_SPEED_FACTOR : speed);

		if (isAimingWithStick) {
			aimX = shootX;
			aimY = shootY;
		} else if (isAimingWithTouch) {
			aimAtTouch();
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
			shootSound.play();
		}
	}

	function aimAtTouch():Void {
		var touchX = Input.getTouchX(0);
		var touchY = Input.getTouchY(0);
		if (touchPad != null) {
			aimX = touchX - touchPad.width / 2;
			aimY = touchY - touchPad.height / 2;
			return;
		}
		aimX = camera.screenToWorldX(touchX, renderer) - collider.centerX;
		aimY = camera.screenToWorldY(touchY, renderer) - collider.centerY;
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
		if (Screen.isSmall) {
			dx += keyAxis(Key.Left, Key.Right);
			dy += keyAxis(Key.Up, Key.Down);
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

	static function keyAxis(negativeKey:Key, positiveKey:Key):Float {
		var value:Float = 0;
		if (Input.isKeyPressed(negativeKey)) {
			value -= 1;
		}
		if (Input.isKeyPressed(positiveKey)) {
			value += 1;
		}
		return value;
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
