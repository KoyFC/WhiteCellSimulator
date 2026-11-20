package nodes;

import game.GameState;
import game.World;
import game.GameMode;
import game.VoxelModels;
import fried.audio.Sound;
import fried.io.Assets;
import fried.physics.Collider;
import fried.physics.Physics;
import fried.graphics.Texture;
import fried.scene.Sprite;

class Enemy extends Sprite {
	static inline var BASE_SPEED = 50;
	static inline var SPEED_PER_STEP = 10;
	static inline var MAX_SPEED = 150;
	static inline var MAX_HEALTH = 3;
	static inline var INVINCIBILITY_TIME = 0.5;
	static inline var CONTACT_DAMAGE = 1;
	static inline var BASE_POINTS = 10;
	static inline var POINTS_PER_STEP = 5;

	static var overlapping:Array<Collider> = [];

	var target:Player;

	public var collider(default, null):Collider;
	public var health(default, null):Health;

	public function new(texture:Texture, target:Player) {
		super(texture);
		name = "Enemy";
		this.target = target;
		collider = addChild(new Collider(texture.width, texture.height));
		health = addChild(new Health(MAX_HEALTH, INVINCIBILITY_TIME));
		addChild(new InvincibilityBlink());
	}

	override function ready():Void {
		MeshMirror.attach(this, VoxelModels.virus(GameMode.step(1, 4)));
		var hitSound = Sound.from(Assets.game("sounds/enemy_hit.wav"));
		var deathSound = Sound.from(Assets.game("sounds/enemy_death.wav"));
		health.onDamage = function(_) {
			if (health.isAlive) {
				hitSound.play();
			}
		};
		health.onDeath = function() {
			deathSound.play();
			GameState.addScore(BASE_POINTS + GameState.difficultyStep() * POINTS_PER_STEP);
			destroy();
		};
	}

	override function draw():Void {
		if (scene.camera3D == null) {
			super.draw();
		}
	}

	override function update(delta:Float):Void {
		var targetCollider = target.collider;
		if (collider.overlaps(targetCollider)) {
			target.health.takeDamage(CONTACT_DAMAGE);
			destroy();
			return;
		}

		var dx = targetCollider.centerX - collider.centerX;
		var dy = targetCollider.centerY - collider.centerY;
		var distance = Math.sqrt(dx * dx + dy * dy);
		if (distance > 0) {
			rotation = Math.atan2(dy, dx) * 180 / Math.PI + 90;
			var step = Math.min(MAX_SPEED, BASE_SPEED + GameState.difficultyStep() * SPEED_PER_STEP) * delta;
			translate(dx / distance * step, dy / distance * step);
		}

		separateFromOtherEnemies();
		World.keepInside(collider);
	}

	function separateFromOtherEnemies():Void {
		Physics.overlapBoxAll(scene, collider.left, collider.top, collider.right - collider.left, collider.bottom - collider.top,
			overlapping, collider);
		for (other in overlapping) {
			if (Std.downcast(other.parent, Enemy) == null) {
				continue;
			}
			var overlapX = Math.min(collider.right - other.left, other.right - collider.left);
			var overlapY = Math.min(collider.bottom - other.top, other.bottom - collider.top);
			if (overlapX < overlapY) {
				x += (collider.centerX < other.centerX ? -overlapX : overlapX) / 2;
			} else {
				y += (collider.centerY < other.centerY ? -overlapY : overlapY) / 2;
			}
		}
	}
}
