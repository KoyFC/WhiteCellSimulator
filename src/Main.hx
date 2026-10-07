import fried.Application;
import fried.Log;
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

		GameState.loadHighScore();
		var gameLayer = renderer.pushLayer(new GameLayer(renderer));

		Application.run(function() {
			if (Input.isKeyDown(Key.Escape) || Input.isGamepadButtonDown(GamepadButton.Start)) {
				Application.quit();
			}

			if (gameLayer.isGameOver) {
				Log.info('Game over with ${GameState.score} points, high score ${GameState.highScore}');
				GameState.saveHighScore();
				renderer.removeLayer(gameLayer);
				gameLayer.scene.destroy();
				gameLayer = renderer.pushLayer(new GameLayer(renderer));
			}
		});

		GameState.saveHighScore();
		renderer.removeLayer(gameLayer);
		gameLayer.scene.destroy();
		Application.destroyRenderer(renderer);
		window.destroy();
		Application.shutdown();
	}
}
