package components;

import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Rect;
import fried.scene.Component;
import fried.scene.Text;

// A filled box behind the Text of the same object, with padding around it.
@:serializable
class Label extends Component {
	public var backgroundColor:Color;
	public var paddingX:Int;
	public var paddingY:Int;

	var text:Text;
	var rect:Rect = new Rect(0, 0, 0, 0);

	public function new(backgroundColor:Color, paddingX:Int, paddingY:Int) {
		super();
		this.backgroundColor = backgroundColor;
		this.paddingX = paddingX;
		this.paddingY = paddingY;
	}

	override function start():Void {
		text = gameObject.getComponent(Text);
		if (text == null) {
			throw 'A Label needs a Text on ${gameObject.name}.';
		}
	}

	override function draw():Void {
		// The padding keeps its size while the text is scaled by the object's transform, as a FitText does.
		rect.x = Std.int(transform.x) - paddingX;
		rect.y = Std.int(transform.y) - paddingY;
		rect.width = Std.int(text.width * transform.scaleX) + paddingX * 2;
		rect.height = Std.int(text.height * transform.scaleY) + paddingY * 2;
		DrawQueue.submitFillRect(gameObject.priority, rect, backgroundColor);
	}
}
