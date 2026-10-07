import fried.graphics.Color;

class StartLayer extends MenuLayer {
	public function new() {
		super("Start");
		addLine("Blood Borne Defense", 64, Color.rgb(255, 255, 255), 1 / 3);
		addLine('Hi-Score: ${GameState.highScore}', 32, Color.rgb(255, 255, 0), 1 / 2);
		addLine(confirmPrompt("to Play"), 32, Color.rgb(255, 255, 0), 2 / 3);
	}
}
