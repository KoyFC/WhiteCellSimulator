import fried.graphics.Color;
import fried.graphics.Font;
import fried.graphics.Renderer;
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

	var screenWidth:Int;
	var player:Player;

	var livesText:Text;
	var scoreText:Text;
	var highScoreText:Text;

	var shownLives:Int = -1;
	var shownScore:Int = -1;
	var shownHighScore:Int = -1;

	public function new(renderer:Renderer, player:Player) {
		super(new Scene("HUD"));
		screenWidth = renderer.width;
		this.player = player;

		var font = Font.from(Assets.engine("NunitoSans.ttf"), FONT_SIZE);
		var background = Color.rgb(0, 0, 0);
		livesText = Label.create(scene, font, "", Color.rgb(255, 0, 0), background, PADDING_X, PADDING_Y);
		highScoreText = Label.create(scene, font, "", Color.rgb(255, 255, 0), background, PADDING_X, PADDING_Y);
		scoreText = Label.create(scene, font, "", Color.rgb(255, 255, 255), background, PADDING_X, PADDING_Y);

		livesText.transform.x = MARGIN + PADDING_X;
		livesText.transform.y = MARGIN + PADDING_Y;
		highScoreText.transform.y = MARGIN + PADDING_Y;
		scoreText.transform.y = highScoreText.transform.y + highScoreText.height + PADDING_Y * 2 + LINE_SPACING;

		refresh();
	}

	override function update():Void {
		refresh();
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
			highScoreText.transform.x = screenWidth - MARGIN - PADDING_X - highScoreText.width;
		}
		if (GameState.score != shownScore) {
			shownScore = GameState.score;
			scoreText.text = 'Score: $shownScore';
			scoreText.transform.x = screenWidth - MARGIN - PADDING_X - scoreText.width;
		}
	}
}
