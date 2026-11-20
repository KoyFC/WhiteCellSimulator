package nodes;

import fried.graphics.Color;
import fried.graphics3d.Mesh;
import fried.scene.MeshInstance;
import fried.scene.Node3D;
import game.GameMode;
import game.World;
import game.World3D;

@:serializable
class CheckerFloor3D extends Node3D {
	static inline var BLOCK_TILES = 6;

	public var width:Int;
	public var height:Int;
	public var tileSize:Int;
	public var colorA:Color;
	public var colorB:Color;

	public function new(width:Int = 0, height:Int = 0, tileSize:Int = 64, colorA:Color = null, colorB:Color = null) {
		super();
		name = "CheckerFloor3D";
		this.width = width;
		this.height = height;
		this.tileSize = tileSize;
		this.colorA = colorA != null ? colorA : Color.rgb(0, 0, 0);
		this.colorB = colorB != null ? colorB : Color.rgb(255, 255, 255);
	}

	override function ready():Void {
		if (GameMode.isLite) {
			tileSize *= 2;
		}
		var tilesX = Math.ceil(width / tileSize);
		var tilesY = Math.ceil(height / tileSize);
		var blockY = 0;
		while (blockY < tilesY) {
			var blockX = 0;
			while (blockX < tilesX) {
				addBlock(blockX, blockY, Std.int(Math.min(tilesX, blockX + BLOCK_TILES)), Std.int(Math.min(tilesY, blockY + BLOCK_TILES)));
				blockX += BLOCK_TILES;
			}
			blockY += BLOCK_TILES;
		}
	}

	function addBlock(firstX:Int, firstY:Int, endX:Int, endY:Int):Void {
		var left = firstX * tileSize;
		var right = Math.min(width, endX * tileSize);
		var top = firstY * tileSize;
		var bottom = Math.min(height, endY * tileSize);
		var centerX = World3D.toX((left + right) / 2);
		var centerZ = World3D.toZ((top + bottom) / 2);

		var vertices:Array<Float> = [];
		var indices:Array<Int> = [];
		var colors:Array<Color> = [];
		for (tileY in firstY...endY) {
			for (tileX in firstX...endX) {
				var x0 = World3D.toX(tileX * tileSize) - centerX;
				var x1 = World3D.toX(Math.min(width, (tileX + 1) * tileSize)) - centerX;
				var z1 = World3D.toZ(tileY * tileSize) - centerZ;
				var z0 = World3D.toZ(Math.min(height, (tileY + 1) * tileSize)) - centerZ;
				var base = Std.int(vertices.length / 3);
				vertices.push(x0);
				vertices.push(0.0);
				vertices.push(z0);
				vertices.push(x1);
				vertices.push(0.0);
				vertices.push(z0);
				vertices.push(x1);
				vertices.push(0.0);
				vertices.push(z1);
				vertices.push(x0);
				vertices.push(0.0);
				vertices.push(z1);
				indices.push(base + 3);
				indices.push(base + 2);
				indices.push(base + 1);
				indices.push(base + 3);
				indices.push(base + 1);
				indices.push(base);
				var color = (tileX + tileY) % 2 == 0 ? colorA : colorB;
				colors.push(color);
				colors.push(color);
			}
		}
		var block = new MeshInstance();
		block.mesh = new Mesh(vertices, indices, colors);
		block.x = centerX;
		block.z = centerZ;
		addChild(block);
	}
}
