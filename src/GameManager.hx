import fried.Log;
import fried.graphics.Renderer;
import fried.scene.SceneLayer;

class GameManager {
	var renderer:Renderer;
	var touchPad:Null<Renderer>;
	var game:GameLayer;
	var hud:HudLayer;
	var menu:MenuLayer;

	public function new(renderer:Renderer, ?touchPad:Renderer) {
		this.renderer = renderer;
		this.touchPad = touchPad;
		GameState.loadHighScore();
		menu = renderer.pushLayer(new StartLayer());
	}

	public function update():Void {
		if (menu != null && menu.isConfirmed) {
			close(menu);
			menu = null;
			game = renderer.pushLayer(new GameLayer(renderer, touchPad));
			hud = renderer.pushLayer(new HudLayer(game.player));
		} else if (game != null && game.isGameOver) {
			Log.info('Game over with ${GameState.score} points, high score ${GameState.highScore}');
			GameState.saveHighScore();
			closeGame();
			menu = renderer.pushLayer(new GameOverLayer());
		}
	}

	public function destroy():Void {
		GameState.saveHighScore();
		closeGame();
		if (menu != null) {
			close(menu);
			menu = null;
		}
	}

	function closeGame():Void {
		if (game == null) {
			return;
		}
		close(hud);
		close(game);
		hud = null;
		game = null;
	}

	function close(layer:SceneLayer):Void {
		renderer.removeLayer(layer);
		layer.scene.destroy();
	}
}
