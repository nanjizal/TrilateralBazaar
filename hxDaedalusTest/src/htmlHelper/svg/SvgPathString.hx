package htmlHelper.svg;
import StringTools;
@:forward( length )
abstract SvgPathString( String ) from String to String {
    inline public function new( ?s: String ){
        if( s == null ){
            this = '';
        } else {
            this = s;
        }
    }
    inline public function close(){
        this = this + 'z';
    }
    inline public function rtrim(){
        this = StringTools.rtrim( this );
    }
    inline public function moveTo( x: Float, y: Float ): Void {
        this = this + 'M $x $y ';
    }
    inline public function lineTo( x: Float, y: Float ): Void {
        this = this + 'L $x $y ';
    }
    inline public function quadTo( x1: Float, y1: Float
                                 , x2: Float, y2: Float ): Void {
        this = this + 'Q $x1 $y1, $x2 $y2 ';
    }
    inline public function curveTo( x1: Float, y1: Float
                                  , x2: Float, y2: Float
                                  , x3: Float, y3: Float ): Void {
        this = this + 'C $x1 $y1, $x2 $y2, $x3 $y3 ';
    }
}
