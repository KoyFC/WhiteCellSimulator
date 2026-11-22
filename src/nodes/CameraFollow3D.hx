package nodes;

import fried.physics.Collider;
import fried.scene.Camera3D;
import fried.scene.Node;
import game.GameState;
import game.World3D;

@:serializable
class CameraFollow3D extends Node {
	public var target:Collider;
	public var height:Float;
	public var distance:Float;

	var camera:Camera3D;

	public function new(target:Collider = null, height:Float = 14.0, distance:Float = 9.0) {
		super("CameraFollow3D");
		this.target = target;
		this.height = height;
		this.distance = distance;
	}

	override function ready():Void {
		camera = Std.downcast(parent, Camera3D);
		if (camera == null || target == null) {
			throw 'A CameraFollow3D needs a Camera3D as its parent and a target Collider on $name.';
		}
		follow();
	}

	override function update(delta:Float):Void {
		if (GameState.isPaused) {
			return;
		}
		if (target.isDestroyed) {
			return;
		}
		follow();
	}

	function follow():Void {
		var focusX = World3D.toX(target.centerX);
		var focusZ = World3D.toZ(target.centerY);
		camera.x = focusX;
		camera.y = height;
		camera.z = focusZ - distance;
		camera.lookAt(focusX, 0, focusZ);
	}
}
