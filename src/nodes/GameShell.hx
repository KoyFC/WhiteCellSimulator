package nodes;

import fried.Application;
import fried.Bootstrap;
import fried.Project;
import fried.Window;
import fried.audio.Music;
import fried.audio.Sound;
import fried.graphics.Color;
import fried.graphics.Font;
import fried.graphics.Renderer;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.io.Assets;
import fried.scene.Node;
import game.GameAudio;
import game.FpsLayer;
import game.GameState;
import game.TouchPad;
import game.TouchPadLayer;

// What this game needs beyond its scenes, kept as an autoload so it outlives them: the saved score, the music, and the 3DS's touch screen, which is a second window.
@:serializable
class GameShell extends Node {
	var touchWindow:Window;
	var touchRenderer:Renderer;
	var fpsFont:Font;

	public function new() {
		super("GameShell");
	}

	override function ready():Void {
		GameState.loadHighScore();
		GameAudio.music = new Music(Assets.game("sounds/music.wav"));
		Sound.from(Assets.game("sounds/game_over.wav"));

		if (Window.maxCount > 1) {
			touchWindow = new Window(Project.windowTitle(), 320, 240);
			touchRenderer = Application.createRenderer(touchWindow);
			touchRenderer.drawColor = Color.rgb(0, 0, 0);
			touchRenderer.pushLayer(new TouchPadLayer());
			TouchPad.renderer = touchRenderer;
			TouchPad.width = touchRenderer.width;
			TouchPad.height = touchRenderer.height;
			TouchPad.isAvailable = true;
		}

		// The second screen where there is one, so the counter does not cover the game.
		var fpsRenderer = touchRenderer != null ? touchRenderer : Bootstrap.renderer;
		fpsFont = Font.from(Assets.game("UiFont.ttf"), fpsRenderer.legibleSize(24, 12));
		fpsRenderer.pushLayer(new FpsLayer(fpsFont));
	}

	override function update(delta:Float):Void {
		if (!GameState.inGame && (Input.isKeyDown(Key.Escape) || Input.isGamepadButtonDown(GamepadButton.Select))) {
			Application.quit();
		}
	}

	override function destroyed():Void {
		GameState.saveHighScore();
		GameAudio.music.destroy();
		fpsFont.destroy();
		if (touchRenderer != null) {
			Application.destroyRenderer(touchRenderer);
			touchWindow.destroy();
		}
	}
}
