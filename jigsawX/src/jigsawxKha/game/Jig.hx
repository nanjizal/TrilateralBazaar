package jigsawxKha.game;

class Jig{
    public var x:           Float;
    public var y:           Float;
    public var depth:       Int = 0;
    public var rotation:    Float = 0;
    public var enabled:     Bool  = true;
    public function new( x_: Float, y_: Float, depth_: Int ){
        x = x_;
        y = y_;
        depth = depth_;
    }
}