package htmlHelper.canvas;
import js.html.CanvasRenderingContext2D;
abstract Surface( CanvasRenderingContext2D ) from CanvasRenderingContext2D to CanvasRenderingContext2D {
    inline public function new( surface_: CanvasRenderingContext2D ){
        this = surface_;
    }
    inline public function lineStyle( wid: Float, col: Int, ?alpha: Float ){
        this.lineWidth = wid;
        if( alpha != null && alpha != 1.0 ){
            var r = (col >> 16) & 0xFF;
            var g = (col >> 8) & 0xFF;
            var b = (col) & 0xFF;
            this.strokeStyle = 'rgba($r,$g,$b,$alpha)';
        } else {
            this.strokeStyle = '#' + StringTools.hex( col, 6 );
        }
    }
    inline public function beginFill( col: Int, ?alpha:Float ){
        if( alpha != null && alpha != 1.0 ){
            var r = (col >> 16) & 0xFF;
            var g = (col >> 8) & 0xFF;
            var b = (col) & 0xFF;
            this.fillStyle = 'rgba($r,$g,$b,$alpha)';
        } else {
            this.fillStyle = '#' + StringTools.hex( col, 6 );
        }
        this.beginPath();
    }
    inline public function endFill(){
        this.stroke();
        this.closePath();
        this.fill();
    }
    inline public function moveTo( x: Float, y: Float ): Void {
        this.moveTo( x, y );
    }
    inline public function lineTo( x: Float, y: Float ): Void {
        this.lineTo( x, y );
    }
    inline public function quadTo( x1: Float, y1: Float
                          , x2: Float, y2: Float ): Void {
        this.quadraticCurveTo( x1, y1, x2, y2 );
    }
    inline public function curveTo( x1: Float, y1: Float
                           , x2: Float, y2: Float
                           , x3: Float, y3: Float ): Void {
        this.bezierCurveTo( x1, y1, x2, y2, x3, y3 );
    }
}
