package components;

import fried.scene.Component;
import fried.scene.GameObject;

// Places an object from the size of the view, which a scene file cannot know: a fraction of the view, minus a fraction of the object's own size, plus an offset. An object can instead sit under another one, with a gap.
@:serializable
class ScreenAnchor extends Component {
	public var anchorX:Float;
	public var anchorY:Float;
	public var pivotX:Float;
	public var pivotY:Float;
	public var offsetX:Float;
	public var offsetY:Float;

	// When set, the object is placed under this one instead of by anchorY, with offsetY as the gap.
	public var below:GameObject;

	public function new(anchorX:Float, anchorY:Float, pivotX:Float, pivotY:Float, offsetX:Float, offsetY:Float) {
		super();
		this.anchorX = anchorX;
		this.anchorY = anchorY;
		this.pivotX = pivotX;
		this.pivotY = pivotY;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	override function layoutAfter():Null<GameObject> {
		return below;
	}

	override function layoutPosition():Void {
		var scene = gameObject.scene;
		transform.x = scene.viewWidth * anchorX - widthOf(gameObject) * pivotX + offsetX;
		if (below != null) {
			transform.y = below.transform.y + heightOf(below) + offsetY;
		} else {
			transform.y = scene.viewHeight * anchorY - heightOf(gameObject) * pivotY + offsetY;
		}
	}

	static function widthOf(object:GameObject):Float {
		return object.intrinsicWidth() * object.transform.scaleX;
	}

	static function heightOf(object:GameObject):Float {
		return object.intrinsicHeight() * object.transform.scaleY;
	}
}
