import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Font;
import fried.graphics.Rect;
import fried.scene.Component;
import fried.scene.GameObject;
import fried.scene.Scene;
import fried.scene.Text;

class Label extends Component {
	var text:Text;
	var backgroundColor:Color;
	var paddingX:Int;
	var paddingY:Int;
	var rect:Rect = new Rect(0, 0, 0, 0);

	public function new(text:Text, backgroundColor:Color, paddingX:Int, paddingY:Int) {
		super();
		this.text = text;
		this.backgroundColor = backgroundColor;
		this.paddingX = paddingX;
		this.paddingY = paddingY;
	}

	public static function create(scene:Scene, font:Font, content:String, color:Color, backgroundColor:Color, paddingX:Int, paddingY:Int):Text {
		var object = scene.add(new GameObject(content));
		var text = new Text(font, content, color);
		object.addComponent(new Label(text, backgroundColor, paddingX, paddingY));
		object.addComponent(text);
		return text;
	}

	override function draw():Void {
		rect.x = Std.int(transform.x) - paddingX;
		rect.y = Std.int(transform.y) - paddingY;
		rect.width = text.width + paddingX * 2;
		rect.height = text.height + paddingY * 2;
		DrawQueue.submitFillRect(gameObject.priority, rect, backgroundColor);
	}
}
