package jigsawxKha.tileImage.outline;
import jigsawx.JigsawPiece;
import jigsawxKha.tileImage.JigsawShape;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrilateralArray;
import trilateral.path.Base;
import trilateral.path.Fine;
import trilateral.path.Crude;
import trilateral.path.MediumOverlap;
import trilateral.path.Fine;
import trilateral.path.FillOnly;
class OutlineBuilder {
    var base: Base = new Fine( null, null, both );
    public function new(){}
    public inline
    function draw( jigsawPieces: Array<JigsawPiece> ): Array<JigsawShape>{
        var path = base;
        path.width = 3;
        var jigs = jigsawPieces;
        var jig = jigs[ 0 ];
        var ox: Float;
        var oy: Float;
        var scale = 1.;
        var count: Int = 0;
        var shapeArray = new Array<JigsawShape>();
        for( i in 0...jigs.length ){
            jig = jigs[ i ];
            path.reset();
            ox = scale*jig.xy.x;
            oy = scale*jig.xy.y;
            var first = jig.getFirst();
            path.moveTo( scale*first.x + ox, scale*first.y + oy );
            var p = jig.getPoints();
            var skip: Bool = true;
            for( v in  p ) path.lineTo( scale*v.x + ox, scale*v.y + oy );
            path.lineTo( scale*first.x + ox, scale*first.y + oy );
            var triangles = new TriangleArray();
            triangles.addArray( count
                            ,   path.trilateralArray
                            ,   1 );
            shapeArray[ i ] = new JigsawShape( jig, triangles, ox, oy );
            count++;
        }
        return shapeArray;
    }
}