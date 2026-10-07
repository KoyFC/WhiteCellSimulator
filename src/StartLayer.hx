import fried.graphics.Color;
import fried.graphics.Renderer;

class StartLayer extends MenuLayer {
	public function new(renderer:Renderer) {
		super("Start", renderer);
		addLine("Blood Borne Defense", 64, Color.rgb(255, 255, 255), 1 / 3);
		addLine('Hi-Score: ${GameState.highScore}', 32, Color.rgb(255, 255, 0), 1 / 2);
		addLine("Press Space or Start", 32, Color.rgb(255, 255, 0), 2 / 3);
	}
}
