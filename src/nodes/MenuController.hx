package nodes;

import fried.audio.Sound;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.input.MouseButton;
import fried.io.Assets;
import fried.scene.Node;
import fried.scene.SceneManager;
import game.GameMode;

// Waits for the confirm input, after an optional delay that keeps a button held from the game from skipping the menu, and starts the game.
@:serializable
class MenuController extends Node {
	public var inputDelay:Float;
	public var nextScene:String;
	public var nextScene3D:String;

	public function new(inputDelay:Float = 0.0, nextScene:String = "", nextScene3D:String = "") {
		super("MenuController");
		this.inputDelay = inputDelay;
		this.nextScene = nextScene;
		this.nextScene3D = nextScene3D;
	}

	override function update(delta:Float):Void {
		if (inputDelay > 0) {
			inputDelay -= delta;
			return;
		}
		if (Input.isKeyDown(Key.Space) || Input.isKeyDown(Key.Enter) || Input.isGamepadButtonDown(GamepadButton.Start)
			|| Input.isGamepadButtonDown(Input.gamepadAcceptButton) || Input.isButtonDown(MouseButton.Left) || Input.isTouchDown()) {
			Sound.from(Assets.game("sounds/confirm.wav")).play();
			SceneManager.load(GameMode.is3D && nextScene3D != "" ? nextScene3D : nextScene);
			active = false;
		}
	}
}
