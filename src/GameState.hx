import fried.Log;
import fried.io.UserData;

class GameState {
	static inline var POINTS_PER_DIFFICULTY_STEP = 300;
	static inline var HIGH_SCORE_PATH = "highscore.txt";

	public static var score(default, null):Int = 0;
	public static var highScore(default, null):Int = 0;

	static var savedHighScore:Int = 0;

	public static inline function difficultyStep():Int {
		return Std.int(score / POINTS_PER_DIFFICULTY_STEP);
	}

	public static function addScore(amount:Int):Void {
		score += amount;
		if (score > highScore) {
			highScore = score;
		}
	}

	public static function reset():Void {
		score = 0;
	}

	public static function loadHighScore():Void {
		if (!UserData.exists(HIGH_SCORE_PATH)) {
			return;
		}
		var loaded = Std.parseInt(UserData.read(HIGH_SCORE_PATH));
		highScore = loaded == null ? 0 : loaded;
		savedHighScore = highScore;
	}

	public static function saveHighScore():Void {
		if (highScore == savedHighScore) {
			return;
		}
		try {
			UserData.write(HIGH_SCORE_PATH, Std.string(highScore));
			savedHighScore = highScore;
		} catch (error:Dynamic) {
			Log.error('Failed to save the high score: $error');
		}
	}
}
