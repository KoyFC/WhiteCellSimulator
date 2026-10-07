import fried.Application;
import fried.Project;
import fried.Window;
import fried.graphics.Color;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.io.Assets;

class Main {
	public static function main():Void {
		Application.init();

		var window = new Window(Project.windowTitle(), 960, 540);
		window.setIcon(Assets.game("icon.png"));
		window.onClose = function() {
			Application.quit();
		};

		var renderer = Application.createRenderer(window);
		renderer.drawColor = Color.rgb(24, 24, 32);

		var gameManager = new GameManager(renderer);

		Application.run(function() {
			if (Input.isKeyDown(Key.Escape) || Input.isGamepadButtonDown(GamepadButton.Select)) {
				Application.quit();
			}
			gameManager.update();
		});

		gameManager.destroy();
		Application.destroyRenderer(renderer);
		window.destroy();
		Application.shutdown();
	}
}
