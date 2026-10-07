import fried.graphics.Color;
import fried.graphics.Renderer;
import fried.scene.Camera;
import fried.scene.GameObject;
import fried.scene.Scene;
import fried.scene.SceneLayer;

class GameLayer extends SceneLayer {
	static inline var PLAYER_SCALE = 4;
	static inline var PLAYER_SPEED = 300;
	static inline var PLAYER_PRIORITY = 10;
	static inline var BACKGROUND_PRIORITY = -100;
	static inline var TILE_SIZE = 64;
	static inline var PROJECTILE_POOL_SIZE = 20;

	public var player(default, null):Player;

	public function new(renderer:Renderer) {
		super(new Scene("Game"));

		var background = scene.add(new GameObject("Background"));
		background.priority = BACKGROUND_PRIORITY;
		background.addComponent(new Checkerboard(World.WIDTH, World.HEIGHT, TILE_SIZE, Color.rgb(110, 50, 50), Color.rgb(135, 70, 70)));

		var cameraObject = scene.add(new GameObject("Camera"));
		var camera = cameraObject.addComponent(new Camera());
		scene.camera = camera;

		var projectiles = new ProjectilePool(scene, renderer, PROJECTILE_POOL_SIZE);

		var playerObject = scene.add(new GameObject("Player"));
		playerObject.priority = PLAYER_PRIORITY;
		playerObject.transform.setScale(PLAYER_SCALE);
		player = playerObject.addComponent(new Player(renderer, camera, projectiles, PLAYER_SPEED));
		playerObject.transform.x = (World.WIDTH - (player.collider.right - player.collider.left)) / 2;
		playerObject.transform.y = (World.HEIGHT - (player.collider.bottom - player.collider.top)) / 2;

		cameraObject.addComponent(new CameraFollow(player.collider, renderer));
	}
}
