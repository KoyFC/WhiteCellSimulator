import fried.Application;
import fried.Project;
import fried.Window;
import fried.graphics.Color;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.io.Assets;
import fried.scene.GameObject;
import fried.scene.Scene;

class Main {
	static inline var PLAYER_SCALE = 4;
	static inline var PLAYER_SPEED = 200;

	public static function main():Void {
		Application.init();

		var window = new Window(Project.windowTitle(), 960, 540);
		window.setIcon(Assets.game("icon.png"));
		window.onClose = function() {
			Application.quit();
		};

		var renderer = Application.createRenderer(window);
		renderer.drawColor = Color.rgb(24, 24, 32);

		var scene = new Scene("Main");

		var player = scene.add(new GameObject("Player", 100, 100));
		player.transform.setScale(PLAYER_SCALE);
		player.addComponent(new Player(renderer, PLAYER_SPEED));

		Application.run(function() {
			if (Input.isKeyDown(Key.Escape) || Input.isGamepadButtonDown(GamepadButton.Start)) {
				Application.quit();
			}

			scene.update();
			scene.draw(renderer);
		});

		scene.destroy();
		Application.destroyRenderer(renderer);
		window.destroy();
		Application.shutdown();
	}
}
