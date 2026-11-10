package components;

import fried.Log;
import fried.audio.Sound;
import fried.io.Assets;
import fried.scene.Component;
import fried.scene.GameObject;
import fried.scene.SceneManager;
import game.GameAudio;
import game.GameState;

// Runs one game: the music and the interface while it lasts, and the way out to the game over scene when the player dies.
@:serializable
class GameController extends Component {
	public var interfaceScene:String;
	public var gameOverScene:String;
	public var player:GameObject;

	var isGameOver:Bool = false;

	public function new(interfaceScene:String, gameOverScene:String, player:GameObject) {
		super();
		this.interfaceScene = interfaceScene;
		this.gameOverScene = gameOverScene;
		this.player = player;
	}

	override function start():Void {
		var health = player == null ? null : player.getComponent(Health);
		if (health == null) {
			throw 'A GameController needs a player with a Health.';
		}
		health.onDeath = function() {
			isGameOver = true;
		};
		GameState.reset();
		GameState.lives = health.maxHealth;
		GameAudio.music.play();
		SceneManager.loadAdditive(interfaceScene);
	}

	override function update():Void {
		if (!isGameOver) {
			return;
		}
		isGameOver = false;
		Log.info('Game over with ${GameState.score} points, high score ${GameState.highScore}');
		GameState.saveHighScore();
		GameAudio.music.stop();
		Sound.from(Assets.game("sounds/game_over.wav")).play();
		SceneManager.load(gameOverScene);
	}
}
