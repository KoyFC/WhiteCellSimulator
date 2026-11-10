package components;

import fried.Time;
import fried.audio.Sound;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.input.MouseButton;
import fried.io.Assets;
import fried.scene.Component;
import fried.scene.SceneManager;

// Waits for the confirm input, after an optional delay that keeps a button held from the game from skipping the menu, and starts the game.
@:serializable
class MenuController extends Component {
	public var inputDelay:Float;
	public var nextScene:String;

	public function new(inputDelay:Float, nextScene:String) {
		super();
		this.inputDelay = inputDelay;
		this.nextScene = nextScene;
	}

	override function update():Void {
		if (inputDelay > 0) {
			inputDelay -= Time.deltaSeconds;
			return;
		}
		if (Input.isKeyDown(Key.Space) || Input.isKeyDown(Key.Enter) || Input.isGamepadButtonDown(GamepadButton.Start)
			|| Input.isGamepadButtonDown(Input.gamepadAcceptButton) || Input.isButtonDown(MouseButton.Left) || Input.isTouchDown()) {
			Sound.from(Assets.game("sounds/confirm.wav")).play();
			SceneManager.load(nextScene);
			enabled = false;
		}
	}
}
