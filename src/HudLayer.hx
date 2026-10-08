import fried.graphics.Color;
import fried.graphics.Font;
import fried.io.Assets;
import fried.scene.Scene;
import fried.scene.SceneLayer;
import fried.scene.Text;

class HudLayer extends SceneLayer {
	static inline var FONT_SIZE = 32;
	static inline var MARGIN = 10;
	static inline var PADDING_X = 10;
	static inline var PADDING_Y = 5;
	static inline var LINE_SPACING = 5;

	var player:Player;
	var margin:Int;
	var paddingX:Int;

	var livesText:Text;
	var scoreText:Text;
	var highScoreText:Text;

	var shownLives:Int = -1;
	var shownScore:Int = -1;
	var shownHighScore:Int = -1;

	public function new(player:Player) {
		super(new Scene("HUD"));
		this.player = player;

		margin = Screen.scale(MARGIN);
		paddingX = Screen.scale(PADDING_X);
		var paddingY = Screen.scale(PADDING_Y);

		var font = Font.from(Assets.engine("NunitoSans.ttf"), Screen.fontSize(FONT_SIZE));
		var background = Color.rgb(0, 0, 0);
		livesText = Label.create(scene, font, "", Color.rgb(255, 0, 0), background, paddingX, paddingY);
		highScoreText = Label.create(scene, font, "", Color.rgb(255, 255, 0), background, paddingX, paddingY);
		scoreText = Label.create(scene, font, "", Color.rgb(255, 255, 255), background, paddingX, paddingY);

		livesText.transform.x = margin + paddingX;
		livesText.transform.y = margin + paddingY;
		highScoreText.transform.y = margin + paddingY;
		scoreText.transform.y = highScoreText.transform.y + highScoreText.height + paddingY * 2 + Screen.scale(LINE_SPACING);

		refresh();
	}

	override function update():Void {
		refresh();
		highScoreText.transform.x = renderer.width - margin - paddingX - highScoreText.width;
		scoreText.transform.x = renderer.width - margin - paddingX - scoreText.width;
		super.update();
	}

	function refresh():Void {
		if (player.health.current != shownLives) {
			shownLives = player.health.current;
			livesText.text = 'Lives: $shownLives';
		}
		if (GameState.highScore != shownHighScore) {
			shownHighScore = GameState.highScore;
			highScoreText.text = 'Hi-Score: $shownHighScore';
		}
		if (GameState.score != shownScore) {
			shownScore = GameState.score;
			scoreText.text = 'Score: $shownScore';
		}
	}
}
