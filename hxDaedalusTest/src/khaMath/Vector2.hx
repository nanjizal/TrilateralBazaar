package khaMath;

class Vector2 {
	public inline function new(x: Float = 0, y: Float = 0): Void {
		this.x = x;
		this.y = y;
	}
	
	public var x: Float;
	public var y: Float;
	public var length(get, set): Float;
	
	private function get_length(): Float {
		return Math.sqrt(x * x + y * y);
	}
	
	private function set_length(length: Float): Float {
		var currentLength = get_length();
		if (currentLength == 0) return 0;
		var mul = length / currentLength;
		x *= mul;
		y *= mul;
		return length;
	}
	
	@:extern public inline function add(vec: Vector2): Vector2 {
		return new Vector2(x + vec.x, y + vec.y);
	}
	
	@:extern public inline function sub(vec: Vector2): Vector2 {
		return new Vector2(x - vec.x, y - vec.y);
	}
	
	@:extern public inline function mult(value: Float): Vector2 {
		return new Vector2(x * value, y * value);
	}
	
	@:extern public inline function div(value: Float): Vector2 {
		return mult(1 / value);
	}
	
	@:extern public inline function dot(v: Vector2): Float {
		return x * v.x + y * v.y;
	}
    
	@:extern public inline function perp( v: Vector2 ): Float {
        	return x * v.y - y * v.x;
	}
    
	// faze out
	@:extern public inline function cross( v: Vector2 ): Float {
        	return x * v.y - y * v.x;
	}
	
        @:extern public inline function mid( v: Vector2 ): Vector2 {
		return new Vector2((x + v.x)/2, (y + v.y)/2);	
	}
	
	@:extern public inline function distSq (v: Vector2 ): Float {
  		var dx = x - v.x;
  		var dy = y - v.y;
  		return dx * dx + dy * dy;
	}
	
	@:extern public inline function span ( v: Vector2 ): Vector2 {
  		return new Vector2( v.x - x, v.y - y );
	}
	
	@:extern public inline function lenSq ( ): Float {
  		return x * x + y * y;
	}
	
	@:extern public inline function normalize(): Void {
		length = 1;
	}
	
    	// Copyright 2000 softSurfer, 2012 Dan Sunday
    	// This code may be freely used and modified for any purpose
    	// providing that this copyright notice is included with it.
    	// iSurfer.org makes no warranty for this code, and cannot be held
    	// liable for any real or imagined damage resulting from its use.
    	// Users of this code must verify correctness for their application.
	// ported to haxe from c, not tested
	// snipts below from Dan Sunday's http://geomalgorithms.com/a01-_area.html	
	
    	// > 0, p is left of line, counterclockwise
    	// = 0, p is on the line, none (degenerate)
	// < 0, p is righ of line, clockwise
	@:extern public inline function isLeft( a: Vector2, b: Vector2 ): Float {
		return (( b.x - a.x )*( y - a.y ) - ( x - a.x )*( b.y - a.y ));
	}
    
    	@:extern public static inline function area( a: Vector2, b: Vector2, c: Vector2 ): Float {
		return Math.abs( a.isLeft( b , c ) / 2. );
    	}
}
