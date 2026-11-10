package components;

import fried.graphics.Texture;
import fried.physics.Collider;
import fried.scene.Component;
import fried.scene.GameObject;
import fried.scene.Sprite;

// Keeps the projectiles of a scene and reuses them, since shooting makes a lot of them and they are cheap to hide.
@:serializable
class ProjectilePool extends Component {
	static inline var SCALE = 1;
	static inline var PRIORITY = 5;

	public var texture:Texture;
	public var initialSize:Int;

	var projectiles:Array<Projectile> = [];

	public function new(texture:Texture, initialSize:Int) {
		super();
		this.texture = texture;
		this.initialSize = initialSize;
	}

	override function start():Void {
		for (i in 0...initialSize) {
			create();
		}
	}

	public function fire(x:Float, y:Float, directionX:Float, directionY:Float, speed:Float):Projectile {
		var spawnedProjectile = null;
		for (projectile in projectiles) {
			if (!projectile.gameObject.isActive) {
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
		var object = gameObject.scene.add(new GameObject("Projectile"));
		object.priority = PRIORITY;
		object.transform.setScale(SCALE);
		object.addComponent(new Sprite(texture));
		var collider = object.addComponent(new Collider(texture.width, texture.height));
		var projectile = object.addComponent(new Projectile(collider));
		object.isActive = false;
		projectiles.push(projectile);
		return projectile;
	}
}
