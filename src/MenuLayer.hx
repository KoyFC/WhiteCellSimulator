import fried.Time;
import fried.graphics.Color;
import fried.graphics.Font;
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
	static inline var MAX_SCREEN_SIZE = 4096;

	public var isConfirmed(default, null):Bool = false;

	var inputDelay:Float;
	var lines:Array<Text> = [];
	var lineFractions:Array<Float> = [];

	public function new(name:String, inputDelay:Float = 0) {
		super(new Scene(name));
		this.inputDelay = inputDelay;

		var background = scene.add(new GameObject("Background"));
		background.priority = BACKGROUND_PRIORITY;
		background.addComponent(new Checkerboard(MAX_SCREEN_SIZE, MAX_SCREEN_SIZE, TILE_SIZE, Color.rgb(110, 50, 50), Color.rgb(135, 70, 70)));
	}

	function addLine(content:String, size:Int, color:Color, topFraction:Float):Text {
		var font = Font.from(Assets.engine("NunitoSans.ttf"), size);
		var text = Label.create(scene, font, content, color, Color.rgb(0, 0, 0), PADDING_X, PADDING_Y);
		lines.push(text);
		lineFractions.push(topFraction);
		return text;
	}

	function confirmPrompt(action:String):String {
		return Input.isGamepadConnected ? 'Press Start $action' : 'Press Space $action';
	}

	override function update():Void {
		for (index in 0...lines.length) {
			lines[index].transform.x = (renderer.width - lines[index].width) / 2;
			lines[index].transform.y = renderer.height * lineFractions[index];
		}
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
