import fried.graphics.Renderer;
import fried.graphics.Texture;
import fried.io.Assets;
import fried.physics.Collider;
import fried.scene.GameObject;
import fried.scene.Scene;
import fried.scene.Sprite;

class ProjectilePool {
	static inline var SCALE = 1;
	static inline var PRIORITY = 5;

	var scene:Scene;
	var texture:Texture;
	var projectiles:Array<Projectile> = [];

	public function new(scene:Scene, renderer:Renderer, initialSize:Int) {
		this.scene = scene;
		texture = Texture.from(renderer, Assets.game("anticuerpo.png"));
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
		var object = scene.add(new GameObject("Projectile"));
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
