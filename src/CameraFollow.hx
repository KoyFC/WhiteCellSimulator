import fried.graphics.Renderer;
import fried.physics.Collider;
import fried.scene.Camera;
import fried.scene.Component;

class CameraFollow extends Component {
	var target:Collider;
	var renderer:Renderer;
	var camera:Camera;

	public function new(target:Collider, renderer:Renderer) {
		super();
		this.target = target;
		this.renderer = renderer;
	}

	override function start():Void {
		camera = gameObject.getComponent(Camera);
	}

	override function update():Void {
		if (target.gameObject == null || target.gameObject.isDestroyed) {
			return;
		}
		var halfViewWidth = renderer.width / camera.zoom / 2;
		var halfViewHeight = renderer.height / camera.zoom / 2;
		camera.lookAt(follow(target.centerX, halfViewWidth, World.WIDTH), follow(target.centerY, halfViewHeight, World.HEIGHT));
	}

	static function follow(position:Float, halfView:Float, worldSize:Float):Float {
		if (halfView * 2 >= worldSize) {
			return worldSize / 2;
		}
		return World.clamp(position, halfView, worldSize - halfView);
	}
}
