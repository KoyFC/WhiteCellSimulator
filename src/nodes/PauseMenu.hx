package nodes;

import fried.Application;
import fried.Bootstrap;
import fried.Project;
import fried.audio.Sound;
import fried.graphics.Color;
import fried.graphics.Font;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.io.Assets;
import fried.scene.Button;
import fried.scene.Control;
import fried.scene.Label;
import fried.scene.Node;
import fried.scene.Scene;
import fried.scene.SceneManager;
import game.GameAudio;
import game.GameState;
import game.PauseLayer;
import game.TouchPad;

// The menu that stops a game in progress: it opens on Escape, P or Start and offers to resume, go back to the main menu or quit. It is kept as an autoload, so it is there for every game, and the nodes of the game stop on GameState.isPaused. Its buttons are on the touch screen where there is one, and answer to the pointer as well as to the keys and the pad.
@:serializable
class PauseMenu extends Node {
	static inline var RESUME = 0;
	static inline var MAIN_MENU = 1;
	static inline var QUIT = 2;
	static inline var OPTIONS = 3;

	var menuScene:Scene;
	var layer:PauseLayer;
	var titleFont:Font;
	var buttonFont:Font;
	var buttons:Array<Button> = [];
	var selected:Int = 0;
	var normalColor:Color = Color.rgb(60, 60, 80);
	var selectedColor:Color = Color.rgb(140, 120, 30);

	public function new() {
		super("PauseMenu");
	}

	override function ready():Void {
		var renderer = TouchPad.isAvailable ? TouchPad.renderer : Bootstrap.renderer;
		var large = renderer.height >= 400;
		titleFont = Font.from(Assets.game("UiFont.ttf"), renderer.legibleSize(large ? 64 : 32, 12));
		buttonFont = Font.from(Assets.game("UiFont.ttf"), renderer.legibleSize(large ? 32 : 20, 12));

		var buttonHeight = large ? 56 : 40;
		var buttonWidth = Std.int(Math.min(renderer.width * 0.7, 360));
		var spacing = large ? 14 : 8;
		var gap = large ? 24 : 12;
		var top = -(titleFont.lineHeight + gap + OPTIONS * buttonHeight + (OPTIONS - 1) * spacing) / 2;

		menuScene = new Scene("Pause");
		var title = menuScene.add(new Label(titleFont, "Paused", Color.rgb(255, 255, 255)));
		center(title, top);

		var labels = ["Resume", "Main Menu", "Quit"];
		var actions = [close, goToMainMenu, Application.quit];
		for (index in 0...OPTIONS) {
			var button = menuScene.add(new Button(buttonWidth, buttonHeight, buttonFont, labels[index], actions[index]));
			button.name = labels[index];
			center(button, top + titleFont.lineHeight + gap + index * (buttonHeight + spacing));
			buttons.push(button);
		}

		layer = renderer.pushLayer(new PauseLayer(menuScene));
	}

	override function update(delta:Float):Void {
		if (!GameState.inGame) {
			if (GameState.isPaused) {
				close();
			}
			return;
		}
		var toggle = Input.isKeyDown(Key.Escape) || Input.isKeyDown(Key.P) || Input.isGamepadButtonDown(GamepadButton.Start);
		if (!GameState.isPaused) {
			if (toggle) {
				open();
			}
			return;
		}
		if (toggle) {
			close();
			return;
		}
		var up = Input.isKeyDown(Key.Up) || Input.isKeyDown(Key.W) || Input.isGamepadButtonDown(GamepadButton.DpadUp);
		var down = Input.isKeyDown(Key.Down) || Input.isKeyDown(Key.S) || Input.isGamepadButtonDown(GamepadButton.DpadDown);
		if (up || down) {
			select((selected + (down ? 1 : OPTIONS - 1)) % OPTIONS);
			Sound.from(Assets.game("sounds/confirm.wav")).play();
		}
		if (Input.isKeyDown(Key.Enter) || Input.isKeyDown(Key.Space) || Input.isGamepadButtonDown(Input.gamepadAcceptButton)) {
			buttons[selected].onClick();
		}
	}

	override function destroyed():Void {
		menuScene.destroy();
		titleFont.destroy();
		buttonFont.destroy();
	}

	function center(control:Control, offsetY:Float):Void {
		control.anchorMinX = 0.5;
		control.anchorMaxX = 0.5;
		control.anchorMinY = 0.5;
		control.anchorMaxY = 0.5;
		control.pivotX = 0.5;
		control.pivotY = 0;
		control.offsetX = 0;
		control.offsetY = offsetY;
	}

	function select(index:Int):Void {
		selected = index;
		for (position in 0...OPTIONS) {
			buttons[position].color = position == selected ? selectedColor : normalColor;
		}
	}

	function open():Void {
		GameState.isPaused = true;
		GameAudio.music.pause();
		select(RESUME);
		layer.isEnabled = true;
	}

	function close():Void {
		GameState.isPaused = false;
		GameAudio.music.resume();
		layer.isEnabled = false;
	}

	function goToMainMenu():Void {
		close();
		GameState.inGame = false;
		GameState.saveHighScore();
		GameAudio.music.stop();
		SceneManager.load(Project.startScene());
	}
}
