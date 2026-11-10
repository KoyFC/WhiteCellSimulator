package components;

import fried.scene.Camera;
import fried.scene.Component;
import fried.scene.GameObject;
import fried.physics.Collider;
import game.World;

@:serializable
class CameraFollow extends Component {
	// The object whose Collider the camera keeps in view.
	public var target:GameObject;

	var collider:Collider;
	var camera:Camera;

	public function new(target:GameObject) {
		super();
		this.target = target;
	}

	override function start():Void {
		camera = gameObject.getComponent(Camera);
		collider = target == null ? null : target.getComponent(Collider);
		if (camera == null || collider == null) {
			throw 'A CameraFollow needs a Camera on ${gameObject.name} and a target with a Collider.';
		}
	}

	override function update():Void {
		if (target.isDestroyed) {
			return;
		}
		var scene = gameObject.scene;
		var halfViewWidth = scene.viewWidth / camera.zoom / 2;
		var halfViewHeight = scene.viewHeight / camera.zoom / 2;
		camera.lookAt(follow(collider.centerX, halfViewWidth, World.WIDTH), follow(collider.centerY, halfViewHeight, World.HEIGHT));
	}

	static function follow(position:Float, halfView:Float, worldSize:Float):Float {
		if (halfView * 2 >= worldSize) {
			return worldSize / 2;
		}
		return World.clamp(position, halfView, worldSize - halfView);
	}
}
