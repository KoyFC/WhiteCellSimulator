import fried.Application;
import fried.Project;
import fried.Window;
import fried.graphics.Color;
import fried.graphics.Renderer;
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
		Screen.init(renderer);

		var touchWindow:Window = null;
		var touchRenderer:Renderer = null;
		if (Window.maxCount > 1) {
			touchWindow = new Window(Project.windowTitle(), 320, 240);
			touchRenderer = Application.createRenderer(touchWindow);
			touchRenderer.drawColor = Color.rgb(0, 0, 0);
			touchRenderer.pushLayer(new TouchPadLayer());
		}

		var gameManager = new GameManager(renderer, touchRenderer);

		Application.run(function() {
			if (Input.isKeyDown(Key.Escape) || Input.isGamepadButtonDown(GamepadButton.Select)) {
				Application.quit();
			}
			gameManager.update();
		});

		gameManager.destroy();
		if (touchRenderer != null) {
			Application.destroyRenderer(touchRenderer);
			touchWindow.destroy();
		}
		Application.destroyRenderer(renderer);
		window.destroy();
		Application.shutdown();
	}
}
