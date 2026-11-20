package nodes;

import fried.Application;
import fried.input.Input;
import fried.scene.Label;
import fried.scene.Node;
import game.GameMode;
import game.GameState;

// Keeps the Label it is a child of showing a value of the game. The format has {value} where it goes, and the source is score, highScore, lives, mode or confirmKey, the name of the key that confirms on this platform.
@:serializable
class TextBinding extends Node {
	public var format:String;
	public var source:String;

	var label:Label;
	var shown:String;

	public function new(format:String = "{value}", source:String = "score") {
		super("TextBinding");
		this.format = format;
		this.source = source;
	}

	override function ready():Void {
		label = Std.downcast(parent, Label);
		if (label == null) {
			throw 'A TextBinding needs a Label as its parent on $name.';
		}
		refresh();
	}

	override function update(delta:Float):Void {
		refresh();
	}

	function refresh():Void {
		var current = StringTools.replace(format, "{value}", valueOf());
		if (current != shown) {
			shown = current;
			label.text = current;
		}
	}

	function valueOf():String {
		return switch (source) {
			case "score": Std.string(GameState.score);
			case "highScore": Std.string(GameState.highScore);
			case "lives": Std.string(GameState.lives);
				case "mode": GameMode.is3D ? "3D" : "2D";
			case "confirmKey":
				if (Input.isGamepadConnected) "Start" else if (Application.platformName == "cg50") "EXE" else "Space";
			case other: throw 'The TextBinding on $name has the unknown source "$other".';
		}
	}
}
