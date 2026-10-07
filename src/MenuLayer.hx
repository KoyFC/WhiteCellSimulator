import fried.Time;
import fried.graphics.Color;
import fried.graphics.Font;
import fried.graphics.Renderer;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.input.MouseButton;
import fried.io.Assets;
import fried.scene.GameObject;
import fried.scene.Scene;
import fried.scene.SceneLayer;
import fried.scene.Text;

class MenuLayer extends SceneLayer {
	static inline var BACKGROUND_PRIORITY = -100;
	static inline var TILE_SIZE = 64;
	static inline var PADDING_X = 20;
	static inline var PADDING_Y = 10;

	public var isConfirmed(default, null):Bool = false;

	var screenWidth:Int;
	var screenHeight:Int;
	var inputDelay:Float;

	public function new(name:String, renderer:Renderer, inputDelay:Float = 0) {
		super(new Scene(name));
		screenWidth = renderer.width;
		screenHeight = renderer.height;
		this.inputDelay = inputDelay;

		var background = scene.add(new GameObject("Background"));
		background.priority = BACKGROUND_PRIORITY;
		background.addComponent(new Checkerboard(renderer.width, renderer.height, TILE_SIZE, Color.rgb(110, 50, 50), Color.rgb(135, 70, 70)));
	}

	function addLine(content:String, size:Int, color:Color, topFraction:Float):Text {
		var font = Font.from(Assets.engine("NunitoSans.ttf"), size);
		var text = Label.create(scene, font, content, color, Color.rgb(0, 0, 0), PADDING_X, PADDING_Y);
		text.transform.x = (screenWidth - text.width) / 2;
		text.transform.y = screenHeight * topFraction;
		return text;
	}

	override function update():Void {
		super.update();
		if (inputDelay > 0) {
			inputDelay -= Time.deltaSeconds;
			return;
		}
		if (Input.isKeyDown(Key.Space) || Input.isKeyDown(Key.Enter) || Input.isGamepadButtonDown(GamepadButton.Start)
			|| Input.isGamepadButtonDown(Input.gamepadAcceptButton) || Input.isButtonDown(MouseButton.Left) || Input.isTouchDown()) {
			isConfirmed = true;
		}
	}
}
