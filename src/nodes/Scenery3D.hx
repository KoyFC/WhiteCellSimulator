package nodes;

import fried.graphics.Color;
import fried.graphics3d.MeshShape;
import fried.scene.MeshInstance;
import fried.scene.Node3D;
import game.GameMode;
import game.VoxelModels;
import game.World;
import game.World3D;

@:serializable
class Scenery3D extends Node3D {
	static inline var WALL_HEIGHT = 0.6;
	static inline var WALL_THICKNESS = 1.5;
	static inline var SPACING = 7.0;

	public function new() {
		super();
		name = "Scenery3D";
	}

	override function ready():Void {
		var width = World.WIDTH / World3D.UNIT;
		var depth = World.HEIGHT / World3D.UNIT;
		addBox(width / 2, -0.07, depth / 2, 140, 0.1, 120, Color.rgb(70, 14, 26));
		addBox(width / 2, WALL_HEIGHT / 2, -WALL_THICKNESS / 2, width + WALL_THICKNESS * 2, WALL_HEIGHT, WALL_THICKNESS, Color.rgb(120, 30, 44));
		addBox(width / 2, WALL_HEIGHT / 2, depth + WALL_THICKNESS / 2, width + WALL_THICKNESS * 2, WALL_HEIGHT, WALL_THICKNESS, Color.rgb(120, 30, 44));
		addBox(-WALL_THICKNESS / 2, WALL_HEIGHT / 2, depth / 2, WALL_THICKNESS, WALL_HEIGHT, depth, Color.rgb(120, 30, 44));
		addBox(width + WALL_THICKNESS / 2, WALL_HEIGHT / 2, depth / 2, WALL_THICKNESS, WALL_HEIGHT, depth, Color.rgb(120, 30, 44));
		addBox(width / 2, WALL_HEIGHT + 0.1, -WALL_THICKNESS / 2, width + WALL_THICKNESS * 2, 0.2, WALL_THICKNESS, Color.rgb(176, 58, 70));
		addBox(width / 2, WALL_HEIGHT + 0.1, depth + WALL_THICKNESS / 2, width + WALL_THICKNESS * 2, 0.2, WALL_THICKNESS, Color.rgb(176, 58, 70));
		addBox(-WALL_THICKNESS / 2, WALL_HEIGHT + 0.1, depth / 2, WALL_THICKNESS, 0.2, depth, Color.rgb(176, 58, 70));
		addBox(width + WALL_THICKNESS / 2, WALL_HEIGHT + 0.1, depth / 2, WALL_THICKNESS, 0.2, depth, Color.rgb(176, 58, 70));

		if (GameMode.isLite) {
			return;
		}
		var margin = WALL_THICKNESS + 2;
		var index = 0;
		var gridZ = -14.0;
		while (gridZ <= 42) {
			var gridX = -21.0;
			while (gridX <= 56) {
				index++;
				var x = gridX + (random(index, 1) - 0.5) * SPACING * 0.7;
				var z = gridZ + (random(index, 2) - 0.5) * SPACING * 0.7;
				gridX += SPACING;
				if (x > -margin && x < width + margin && z > -margin && z < depth + margin) {
					continue;
				}
				var cell = new MeshInstance();
				cell.mesh = VoxelModels.bloodCell();
				cell.x = x;
				cell.z = z;
				cell.rotationY = random(index, 3) * 360;
				cell.setScale(2.5 + random(index, 4) * 2.5);
				addChild(cell);
			}
			gridZ += SPACING;
		}
	}

	function addBox(x:Float, y:Float, z:Float, sizeX:Float, sizeY:Float, sizeZ:Float, color:Color):Void {
		var box = new MeshInstance();
		box.shape = MeshShape.Cube;
		box.color = color;
		box.x = x;
		box.y = y;
		box.z = z;
		box.scaleX = sizeX;
		box.scaleY = sizeY;
		box.scaleZ = sizeZ;
		addChild(box);
	}

	static function random(index:Int, channel:Int):Float {
		var value = Math.sin(index * 12.9898 + channel * 78.233) * 43758.5453;
		return value - Math.floor(value);
	}
}
