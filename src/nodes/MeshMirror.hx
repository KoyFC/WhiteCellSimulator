package nodes;

import fried.graphics3d.Mesh;
import fried.physics.Collider;
import fried.scene.MeshInstance;
import fried.scene.Sprite;
import game.World3D;

class MeshMirror extends MeshInstance {
	static inline var LIFT = 0.15;

	var sprite:Sprite;
	var collider:Collider;

	public function new(model:Mesh) {
		super();
		name = "MeshMirror";
		mesh = model;
	}

	public static function attach(sprite:Sprite, model:Mesh):Void {
		if (sprite.scene == null || sprite.scene.camera3D == null) {
			return;
		}
		sprite.addChild(new MeshMirror(model));
	}

	override function ready():Void {
		sprite = Std.downcast(parent, Sprite);
		collider = parent == null ? null : parent.findChild(Collider);
		if (sprite == null || collider == null) {
			throw 'A MeshMirror needs a Sprite with a Collider child as its parent on $name.';
		}
		sync();
	}

	override function update(delta:Float):Void {
		sync();
	}

	function sync():Void {
		var size = (collider.right - collider.left) / World3D.UNIT;
		x = World3D.toX(collider.centerX);
		z = World3D.toZ(collider.centerY);
		y = LIFT;
		rotationY = sprite.rotation;
		setScale(size);
	}
}
