package nodes;

import fried.graphics.Texture;
import fried.scene.Node;

// Keeps the projectiles of a scene and reuses them, since shooting makes a lot of them and they are cheap to hide.
@:serializable
class ProjectilePool extends Node {
	static inline var SCALE = 1;
	static inline var PRIORITY = 5;

	public var texture:Texture;
	public var initialSize:Int;

	var projectiles:Array<Projectile> = [];

	public function new(texture:Texture = null, initialSize:Int = 0) {
		super("ProjectilePool");
		this.texture = texture;
		this.initialSize = initialSize;
	}

	override function ready():Void {
		for (i in 0...initialSize) {
			create();
		}
	}

	public function fire(x:Float, y:Float, directionX:Float, directionY:Float, speed:Float):Projectile {
		var spawnedProjectile = null;
		for (projectile in projectiles) {
			if (!projectile.active) {
				spawnedProjectile = projectile;
				break;
			}
		}
		if (spawnedProjectile == null) {
			spawnedProjectile = create();
		}
		spawnedProjectile.fire(x, y, directionX, directionY, speed);
		return spawnedProjectile;
	}

	function create():Projectile {
		var projectile = scene.add(new Projectile(texture));
		projectile.priority = PRIORITY;
		projectile.setScale(SCALE);
		projectile.active = false;
		projectiles.push(projectile);
		return projectile;
	}
}
