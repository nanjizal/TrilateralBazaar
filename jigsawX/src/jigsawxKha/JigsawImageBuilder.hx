package jigsawxKha;
import trilateral.path.FillOnly;
import trilateralXtra.parsing.FillDrawPolyK;
import trilateralXtra.kDrawing.ImageDrawing;
import trilateralXtra.kDrawing.PolyPainter;
import trilateral.path.Base;
import trilateral.path.Fine;
import trilateral.path.MediumOverlap;
import trilateral.path.FillOnly;
import kha.Image;
import jigsawx.JigsawPiece;
import jigsawx.math.Vec2;
import jigsawxKha.JigsawShape;
import trilateral.parsing.FillDraw; 
class JigsawImageBuilder {
    var showBackground   = false; // useful for debug
    var backgroundAlpha  = 0.3;
    var imageDrawing:    ImageDrawing;
    var fillDraw:        FillDraw;
    var scaleImg         = 1;//.2;
    var jigsawShapeArray = new Array<JigsawShape>();
    var jigs:            Array<JigsawPiece>;
    //var appColors:      Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
    //                                       , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
    //                                       , BlueAlpha, GreenAlpha, RedAlpha ];//fillDraw.colors = appColors;
    public
    function new( jigs_: Array<JigsawPiece> ){
        jigs = jigs_;
        PolyPainter.bufferSize = 3000000;
        fillDraw     = new FillDrawPolyK( 1024, 768 );
        imageDrawing = new ImageDrawing( fillDraw );
    }
    public inline
    function drawMask(){
        var path: Base = new FillOnly(); // try to reuse rather than new?
        var jig = jigs[ 0 ];
        var image: Image;
        var ox: Float;
        var oy: Float;
        var count: Int = 0;
        for( i in 0...jigs.length ){
            jig = jigs[ i ];
            path.trilateralArray  = [];
            path.points           = [];
            path.dim              = [];
            ox = jig.xy.x;
            oy = jig.xy.y;
            var first = jig.getFirst();
            path.moveTo( first.x + ox, first.y + oy );
            var p = jig.getPoints();
            for( v in  p )  {  path.lineTo( v.x + ox, v.y + oy ); }
            // clear triangle data from fillDraw.
            fillDraw.triangles  = [];
            fillDraw.fill( path.points, 0 );
            jigsawShapeArray[ count ] = new JigsawShape( jig, fillDraw.triangles, ox, oy );
            count++;
        }
    }
    public inline
    function hitTest( x: Float, y: Float ){
        var hits = [];  // collate all hitShapes
        var hitCount = 0;
        var jigsawShape: JigsawShape;
        var ox: Float;
        var oy: Float;
        var xy;
        // assumes pieces are not moved!
        for( s in 0...jigsawShapeArray.length ){
            jigsawShape = jigsawShapeArray[ s ];
            ox = jigsawShape.x;
            oy = jigsawShape.y;
            xy = jigs[ s ].xy;
            for( t in jigsawShape.triangles ){
                if( t.fullHit( x + - xy.x + ox, y + - xy.y + oy ) ){
                    hits[ hitCount ] = s;
                    hitCount++;
                    break;
                }
            }
        }
        return hits;
    }
    public
    function isInPlace( id: Int, jig: JigsawPiece ): Bool {
        var shape = jigsawShapeArray[ id ];
        var xy = jig.xy;
        var dist = distP( xy.x, xy.y, shape.x, shape.y );
        return ( dist < 40 );
    }
    public function getShapeXY( id: Int ):{ x: Float, y: Float } {
        var shape = jigsawShapeArray[ id ];
        return { x: shape.x, y: shape.y };
    }
    inline function distP( px: Float, py: Float, x: Float, y: Float ): Float {
        return Math.pow( x - px, 2 ) + Math.pow( y - py, 2 );
    }
    public inline
    function renderJigsaw( imageIn: Image ): Image {
        var poly = imageDrawing.polyPainter;
        var jigsawShape: JigsawShape;
        var scale = 1;
        var x = 0.;
        var y = 0.;
        imageDrawing.startImage();
        if( showBackground ) poly.drawImage( imageIn, 0, 0, imageIn.width, imageIn.height, backgroundAlpha );
        for( i in 0...jigsawShapeArray.length ){
            jigsawShape = jigsawShapeArray[ i ];
            fillDraw.triangles = jigsawShape.triangles;
            var dx = jigsawShape.x*scaleImg;
            var dy = jigsawShape.y*scaleImg;
            imageDrawing.renderImageTrianglesOffset( imageIn, scale, dx, dy, -dx, -dy );
        }
        imageDrawing.end();
        return imageDrawing.image;
    }
}