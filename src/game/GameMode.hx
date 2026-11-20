package game;

import fried.Application;

class GameMode {
	public static var is3D:Bool = false;

	public static var isLite(get, never):Bool;

	public static inline function step(full:Int, lite:Int):Int {
		return isLite ? lite : full;
	}

	static inline function get_isLite():Bool {
		return Application.platformName == "nds";
	}
}
