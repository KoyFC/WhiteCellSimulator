package nodes;

import fried.Time;
import fried.audio.Sound;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.input.MouseButton;
import fried.io.Assets;
import fried.scene.Node;
import fried.scene.SceneManager;

// Waits for the confirm input, after an optional delay that keeps a button held from the game from skipping the menu, and starts the game.
@:serializable
class MenuController extends Node {
	public var inputDelay:Float;
	public var nextScene:String;

	public function new(inputDelay:Float = 0.0, nextScene:String = "") {
		super("MenuController");
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
			active = false;
		}
	}
}
