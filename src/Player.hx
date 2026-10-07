import fried.Time;
import fried.graphics.Renderer;
import fried.graphics.Texture;
import fried.input.GamepadAxis;
import fried.input.Input;
import fried.input.Key;
import fried.io.Assets;
import fried.physics.Collider;
import fried.scene.Component;
import fried.scene.Sprite;

class Player extends Component {
	var speed:Float;
	var renderer:Renderer;

	var sprite:Sprite;
	var collider:Collider;

	public function new(renderer:Renderer, speed:Float) {
		super();
		this.renderer = renderer;
		this.speed = speed;
	}

	override function start():Void {
		var texture = Texture.from(renderer, Assets.game("white.bmp"));
		sprite = gameObject.addComponent(new Sprite(texture));

		var width = sprite.texture.width * transform.scaleX;
		var height = sprite.texture.height * transform.scaleY;
		collider = gameObject.addComponent(new Collider(width, height));
	}

	override function update():Void {
		var dx:Float = 0;
		var dy:Float = 0;
		dx += Input.getGamepadAxis(GamepadAxis.LeftX);
		dy += Input.getGamepadAxis(GamepadAxis.LeftY);

		if (Input.isKeyPressed(Key.Left) || Input.isKeyPressed(Key.A)) {
			dx -= 1;
		}
		if (Input.isKeyPressed(Key.Right) || Input.isKeyPressed(Key.D)) {
			dx += 1;
		}
		if (Input.isKeyPressed(Key.Up) || Input.isKeyPressed(Key.W)) {
			dy -= 1;
		}
		if (Input.isKeyPressed(Key.Down) || Input.isKeyPressed(Key.S)) {
			dy += 1;
		}

		transform.x += dx * speed * Time.deltaSeconds;
		transform.y += dy * speed * Time.deltaSeconds;
	}
}
