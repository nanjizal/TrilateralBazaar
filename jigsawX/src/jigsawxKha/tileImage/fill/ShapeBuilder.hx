package jigsawxKha.tileImage.fill;
import jigsawx.JigsawPiece;
import jigsawxKha.tileImage.JigsawShape;
import trilateralXtra.parsing.FillDrawPolyK;
import trilateralXtra.parsing.FillDrawTess2;
import trilateral.path.Base;
import trilateral.path.Fine;
import trilateral.path.Crude;
import trilateral.path.MediumOverlap;
import trilateral.path.FillOnly;
class ShapeBuilder {
    var base: Base   = new FillOnly(); // try to reuse rather than new?
    var fillDraw     = new FillDrawTess2( 4096, 4096 );//1024, 768 );
    public function new(){}
    public inline
    function draw( jigsawPieces: Array<JigsawPiece> ): Array<JigsawShape>{
        var path = base;
        var jigs = jigsawPieces;
        var jig = jigs[ 0 ];
        var ox: Float;
        var oy: Float;
        var count: Int = 0;
        var scale = 1.;
        var shapeArray = new Array<JigsawShape>();
        for( i in 0...jigs.length ){//jigs.length ){
            jig = jigs[ i ];
            path.reset();
            ox = jig.xy.x*scale;
            oy = jig.xy.y*scale;
            var first = jig.getFirst();
            path.moveTo( scale*first.x + ox, scale*first.y + oy );
            var p = jig.getPoints();
            for( v in  p )  {  path.lineTo( scale*v.x + ox, scale*v.y + oy ); }
            // clear triangle data from fillDraw.
            fillDraw.triangles  = [];
            fillDraw.fill( path.points, 0 );
            shapeArray[ count ] = new JigsawShape( jig, fillDraw.triangles, ox, oy );
            count++;
        }
        return shapeArray;
    }
}