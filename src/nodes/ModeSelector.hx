package nodes;

import fried.Application;
import fried.audio.Sound;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.io.Assets;
import fried.scene.CanvasItem;
import fried.scene.Node;
import game.GameMode;

@:serializable
class ModeSelector extends Node {
	public function new() {
		super("ModeSelector");
	}

	override function ready():Void {
		if (Application.platformName == "cg50") {
			GameMode.is3D = false;
			var item = Std.downcast(parent, CanvasItem);
			if (item != null) {
				item.visible = false;
			}
			active = false;
		}
	}

	override function update(delta:Float):Void {
		var left = Input.isKeyDown(Key.Left) || Input.isKeyDown(Key.A) || Input.isGamepadButtonDown(GamepadButton.DpadLeft);
		var right = Input.isKeyDown(Key.Right) || Input.isKeyDown(Key.D) || Input.isGamepadButtonDown(GamepadButton.DpadRight);
		if (left || right) {
			GameMode.is3D = !GameMode.is3D;
			Sound.from(Assets.game("sounds/confirm.wav")).play();
		}
	}
}
