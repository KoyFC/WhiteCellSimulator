import fried.Log;
import fried.audio.Music;
import fried.audio.Sound;
import fried.graphics.Renderer;
import fried.io.Assets;
import fried.scene.SceneLayer;

class GameManager {
	var renderer:Renderer;
	var touchPad:Null<Renderer>;
	var game:GameLayer;
	var hud:HudLayer;
	var menu:MenuLayer;
	var music:Music;

	public function new(renderer:Renderer, ?touchPad:Renderer) {
		this.renderer = renderer;
		this.touchPad = touchPad;
		GameState.loadHighScore();
		music = new Music(Assets.game("sounds/music.wav"));
		menu = renderer.pushLayer(new StartLayer());
	}

	public function update():Void {
		if (menu != null && menu.isConfirmed) {
			close(menu);
			menu = null;
			Sound.from(Assets.game("sounds/confirm.wav")).play();
			music.play();
			game = renderer.pushLayer(new GameLayer(renderer, touchPad));
			hud = renderer.pushLayer(new HudLayer(game.player));
		} else if (game != null && game.isGameOver) {
			Log.info('Game over with ${GameState.score} points, high score ${GameState.highScore}');
			GameState.saveHighScore();
			closeGame();
			music.stop();
			Sound.from(Assets.game("sounds/game_over.wav")).play();
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
		music.destroy();
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
