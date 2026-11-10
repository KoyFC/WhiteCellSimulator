package game;

import fried.Application;
import fried.Game;
import fried.Project;
import fried.Window;
import fried.audio.Music;
import fried.graphics.Color;
import fried.graphics.Renderer;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.io.Assets;

// What this game needs beyond its scenes: the saved score, the music that outlives a scene, and the 3DS's touch screen, which is a second window.
class WhiteCellGame extends Game {
	var touchWindow:Window;
	var touchRenderer:Renderer;

	override function start():Void {
		GameState.loadHighScore();
		GameAudio.music = new Music(Assets.game("sounds/music.wav"));

		if (Window.maxCount > 1) {
			touchWindow = new Window(Project.windowTitle(), 320, 240);
			touchRenderer = Application.createRenderer(touchWindow);
			touchRenderer.drawColor = Color.rgb(0, 0, 0);
			touchRenderer.pushLayer(new TouchPadLayer());
			TouchPad.width = touchRenderer.width;
			TouchPad.height = touchRenderer.height;
			TouchPad.isAvailable = true;
		}
	}

	override function update():Void {
		if (Input.isKeyDown(Key.Escape) || Input.isGamepadButtonDown(GamepadButton.Select)) {
			Application.quit();
		}
	}

	override function shutdown():Void {
		GameState.saveHighScore();
		GameAudio.music.destroy();
		if (touchRenderer != null) {
			Application.destroyRenderer(touchRenderer);
			touchWindow.destroy();
		}
	}
}
