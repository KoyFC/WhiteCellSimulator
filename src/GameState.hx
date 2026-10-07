class GameState {
	static inline var POINTS_PER_DIFFICULTY_STEP = 300;

	public static var score:Int = 0;

	public static inline function difficultyStep():Int {
		return Std.int(score / POINTS_PER_DIFFICULTY_STEP);
	}

	public static function reset():Void {
		score = 0;
	}
}
