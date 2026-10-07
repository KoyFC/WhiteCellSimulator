import fried.Application;
import fried.Project;
import fried.Window;
import fried.graphics.Color;
import fried.input.GamepadButton;
import fried.input.Input;
import fried.input.Key;
import fried.io.Assets;
import fried.scene.Camera;
import fried.scene.GameObject;
import fried.scene.Scene;

class Main {
	static inline var PLAYER_SCALE = 4;
	static inline var PLAYER_SPEED = 300;
	static inline var PLAYER_PRIORITY = 10;
	static inline var BACKGROUND_PRIORITY = -100;
	static inline var TILE_SIZE = 64;
	static inline var PROJECTILE_POOL_SIZE = 20;

	public static function main():Void {
		Application.init();

		var window = new Window(Project.windowTitle(), 960, 540);
		window.setIcon(Assets.game("icon.png"));
		window.onClose = function() {
			Application.quit();
		};

		var renderer = Application.createRenderer(window);
		renderer.drawColor = Color.rgb(24, 24, 32);

		var scene = new Scene("Main");

		var background = scene.add(new GameObject("Background"));
		background.priority = BACKGROUND_PRIORITY;
		background.addComponent(new Checkerboard(World.WIDTH, World.HEIGHT, TILE_SIZE, Color.rgb(110, 50, 50), Color.rgb(135, 70, 70)));

		var cameraObject = scene.add(new GameObject("Camera"));
		var camera = cameraObject.addComponent(new Camera());
		scene.camera = camera;

		var projectiles = new ProjectilePool(scene, renderer, PROJECTILE_POOL_SIZE);

		var player = scene.add(new GameObject("Player"));
		player.priority = PLAYER_PRIORITY;
		player.transform.setScale(PLAYER_SCALE);
		var controller = player.addComponent(new Player(renderer, camera, projectiles, PLAYER_SPEED));
		player.transform.x = (World.WIDTH - (controller.collider.right - controller.collider.left)) / 2;
		player.transform.y = (World.HEIGHT - (controller.collider.bottom - controller.collider.top)) / 2;

		cameraObject.addComponent(new CameraFollow(controller.collider, renderer));

		Application.run(function() {
			if (Input.isKeyDown(Key.Escape) || Input.isGamepadButtonDown(GamepadButton.Start)) {
				Application.quit();
			}

			scene.update();
			scene.draw(renderer);
		});

		scene.destroy();
		Application.destroyRenderer(renderer);
		window.destroy();
		Application.shutdown();
	}
}
