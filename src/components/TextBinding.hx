package components;

import fried.Application;
import fried.input.Input;
import fried.scene.Component;
import fried.scene.Text;
import game.GameState;

// Keeps the Text of the same object showing a value of the game. The format has {value} where it goes, and the source is score, highScore, lives or confirmKey, the name of the key that confirms on this platform.
@:serializable
class TextBinding extends Component {
	public var format:String;
	public var source:String;

	var text:Text;
	var shown:String;

	public function new(format:String, source:String) {
		super();
		this.format = format;
		this.source = source;
	}

	override function start():Void {
		text = gameObject.getComponent(Text);
		if (text == null) {
			throw 'A TextBinding needs a Text on ${gameObject.name}.';
		}
		refresh();
	}

	override function update():Void {
		refresh();
	}

	function refresh():Void {
		var current = StringTools.replace(format, "{value}", valueOf());
		if (current != shown) {
			shown = current;
			text.text = current;
		}
	}

	function valueOf():String {
		return switch (source) {
			case "score": Std.string(GameState.score);
			case "highScore": Std.string(GameState.highScore);
			case "lives": Std.string(GameState.lives);
			case "confirmKey":
				if (Input.isGamepadConnected) "Start" else if (Application.platformName == "cg50") "EXE" else "Space";
			case other: throw 'The TextBinding on ${gameObject.name} has the unknown source "$other".';
		}
	}
}
