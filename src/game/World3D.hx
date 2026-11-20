package game;

import fried.graphics3d.Rotation;
import fried.scene.Camera3D;

class World3D {
	public static inline var UNIT = 64.0;

	public static var resultX:Float = 0;
	public static var resultY:Float = 0;

	static var turn:Array<Float> = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

	public static inline function toX(pixelX:Float):Float {
		return pixelX / UNIT;
	}

	public static inline function toZ(pixelY:Float):Float {
		return (World.HEIGHT - pixelY) / UNIT;
	}

	public static function screenToWorld(camera:Camera3D, screenX:Float, screenY:Float, viewWidth:Float, viewHeight:Float):Bool {
		Rotation.toMatrix(camera.worldRotationX, camera.worldRotationY, camera.worldRotationZ, turn);
		var focalLength = (viewHeight / 2.0) / Math.tan(camera.fieldOfView * Math.PI / 360.0);
		var viewX = (screenX - viewWidth / 2.0) / focalLength;
		var viewY = -(screenY - viewHeight / 2.0) / focalLength;
		var directionY = turn[3] * viewX + turn[4] * viewY + turn[5];
		if (directionY >= -0.0001) {
			return false;
		}
		var directionX = turn[0] * viewX + turn[1] * viewY + turn[2];
		var directionZ = turn[6] * viewX + turn[7] * viewY + turn[8];
		var distance = -camera.worldY / directionY;
		var hitX = camera.worldX + directionX * distance;
		var hitZ = camera.worldZ + directionZ * distance;
		resultX = hitX * UNIT;
		resultY = World.HEIGHT - hitZ * UNIT;
		return true;
	}
}
