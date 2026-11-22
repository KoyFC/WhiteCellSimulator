package game;

import fried.graphics.Color;
import fried.graphics.DrawQueue;
import fried.graphics.Rect;
import fried.scene.Scene;
import fried.scene.SceneLayer;

// The layer of the pause menu: a scene over a dimmed screen.
class PauseLayer extends SceneLayer {
	var dim:Color = Color.rgba(0, 0, 0, 170);
	var rect:Rect = new Rect(0, 0, 0, 0);

	public function new(scene:Scene) {
		super(scene, "Pause");
		isEnabled = false;
	}

	override function draw():Void {
		rect.width = renderer.width;
		rect.height = renderer.height;
		DrawQueue.submitFillRect(0, rect, dim);
		super.draw();
	}
}
