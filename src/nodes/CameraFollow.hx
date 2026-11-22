package nodes;

import fried.physics.Collider;
import fried.scene.Camera;
import fried.scene.Node;
import game.GameState;
import game.World;

// Keeps the Collider it follows in view, inside the world. A child of the Camera it moves.
@:serializable
class CameraFollow extends Node {
	public var target:Collider;

	var camera:Camera;

	public function new(target:Collider = null) {
		super("CameraFollow");
		this.target = target;
	}

	override function ready():Void {
		camera = Std.downcast(parent, Camera);
		if (camera == null || target == null) {
			throw 'A CameraFollow needs a Camera as its parent and a target Collider on $name.';
		}
	}

	override function update(delta:Float):Void {
		if (GameState.isPaused) {
			return;
		}
		if (target.isDestroyed) {
			return;
		}
		var halfViewWidth = scene.viewWidth / camera.zoom / 2;
		var halfViewHeight = scene.viewHeight / camera.zoom / 2;
		camera.lookAt(follow(target.centerX, halfViewWidth, World.WIDTH), follow(target.centerY, halfViewHeight, World.HEIGHT));
	}

	static function follow(position:Float, halfView:Float, worldSize:Float):Float {
		if (halfView * 2 >= worldSize) {
			return worldSize / 2;
		}
		return World.clamp(position, halfView, worldSize - halfView);
	}
}
