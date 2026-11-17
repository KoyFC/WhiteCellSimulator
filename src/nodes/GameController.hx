package nodes;

import fried.Log;
import fried.audio.Sound;
import fried.io.Assets;
import fried.scene.Node;
import fried.scene.SceneManager;
import game.GameAudio;
import game.GameState;

// Runs one game: the music and the interface while it lasts, and the way out to the game over scene when the player dies.
@:serializable
class GameController extends Node {
	public var interfaceScene:String;
	public var gameOverScene:String;
	public var player:Player;

	var isGameOver:Bool = false;

	public function new(interfaceScene:String = "", gameOverScene:String = "", player:Player = null) {
		super("GameController");
		this.interfaceScene = interfaceScene;
		this.gameOverScene = gameOverScene;
		this.player = player;
	}

	override function ready():Void {
		var health = player == null ? null : player.findChild(Health);
		if (health == null) {
			throw 'A GameController needs a player with a Health child.';
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
