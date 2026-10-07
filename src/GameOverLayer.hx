import fried.graphics.Color;
import fried.graphics.Renderer;

class GameOverLayer extends MenuLayer {
	static inline var INPUT_DELAY = 0.75;

	public function new(renderer:Renderer) {
		super("Game Over", renderer, INPUT_DELAY);
		addLine("GAME OVER", 72, Color.rgb(255, 0, 0), 1 / 4);
		addLine('Score: ${GameState.score}', 48, Color.rgb(255, 255, 255), 0.42);
		addLine('High Score: ${GameState.highScore}', 48, Color.rgb(255, 255, 0), 0.55);
		addLine("Press Space or Start to Restart", 32, Color.rgb(255, 255, 255), 3 / 4);
	}
}
