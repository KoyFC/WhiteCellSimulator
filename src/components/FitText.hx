package components;

import fried.scene.Component;
import fried.scene.Text;

// Shrinks the Text of the same object, and the Label around it, until the line fits in a fraction of the view's width, so a line is never cut off by a screen narrower than the one the scene was made for. It never grows a line, and the ScreenAnchor of the object places it from the size this leaves.
@:serializable
class FitText extends Component {
	public var maxViewFraction:Float;

	public function new(maxViewFraction:Float) {
		super();
		this.maxViewFraction = maxViewFraction;
	}

	override function layoutSize():Void {
		var text = gameObject.getComponent(Text);
		if (text == null) {
			return;
		}
		var label = gameObject.getComponent(Label);
		var padding = label == null ? 0 : label.paddingX * 2;
		var width = text.width + padding;
		var scale = width > 0 ? Math.min(1, gameObject.scene.viewWidth * maxViewFraction / width) : 1;
		transform.scaleX = scale;
		transform.scaleY = scale;
	}
}
