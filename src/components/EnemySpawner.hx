package components;

import fried.Time;
import fried.graphics.Texture;
import game.GameState;
import game.World;
import fried.physics.Collider;
import fried.scene.Component;
import fried.scene.GameObject;
import fried.scene.Sprite;

@:serializable
class EnemySpawner extends Component {
	static inline var INITIAL_ENEMIES = 4;
	static inline var MAX_ENEMIES = 20;
	static inline var SAFE_RADIUS = 200;
	static inline var BASE_INTERVAL = 2.0;
	static inline var INTERVAL_PER_STEP = 0.25;
	static inline var MIN_INTERVAL = 0.5;
	static inline var SCALE = 2;
	static inline var PRIORITY = 8;

	public var texture:Texture;

	// The object with the Player and the Collider that enemies come for.
	public var target:GameObject;

	var player:Player;
	var targetCollider:Collider;
	var enemies:Array<Enemy> = [];
	var spawnTimer:Float = BASE_INTERVAL;

	public function new(texture:Texture, target:GameObject) {
		super();
		this.texture = texture;
		this.target = target;
	}

	override function start():Void {
		player = target == null ? null : target.getComponent(Player);
		targetCollider = target == null ? null : target.getComponent(Collider);
		if (player == null || targetCollider == null) {
			throw 'An EnemySpawner needs a target with a Player and a Collider.';
		}
		for (i in 0...INITIAL_ENEMIES) {
			spawn();
		}
	}

	override function update():Void {
		var index = enemies.length;
		while (index-- > 0) {
			var enemy = enemies[index];
			if (enemy.gameObject == null || enemy.gameObject.isDestroyed) {
				enemies.splice(index, 1);
			}
		}
		if (enemies.length >= MAX_ENEMIES) {
			return;
		}
		spawnTimer -= Time.deltaSeconds;
		if (spawnTimer <= 0) {
			spawnTimer = Math.max(MIN_INTERVAL, BASE_INTERVAL - GameState.difficultyStep() * INTERVAL_PER_STEP);
			spawn();
		}
	}

	function spawn():Void {
		var width = texture.width * SCALE;
		var height = texture.height * SCALE;
		var x:Float;
		var y:Float;
		do {
			x = Math.random() * (World.WIDTH - width);
			y = Math.random() * (World.HEIGHT - height);
		} while (distanceToTarget(x + width / 2, y + height / 2) <= SAFE_RADIUS);

		var object = gameObject.scene.add(new GameObject("Enemy", x, y));
		object.priority = PRIORITY;
		object.transform.setScale(SCALE);
		object.addComponent(new Sprite(texture));
		var collider = object.addComponent(new Collider(texture.width, texture.height));
		enemies.push(object.addComponent(new Enemy(collider, player)));
	}

	function distanceToTarget(x:Float, y:Float):Float {
		var dx = x - targetCollider.centerX;
		var dy = y - targetCollider.centerY;
		return Math.sqrt(dx * dx + dy * dy);
	}
}
