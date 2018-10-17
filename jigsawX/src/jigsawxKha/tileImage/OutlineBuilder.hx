package jigsawxKha.tileImage;
import jigsawx.JigsawPiece;
import jigsawxKha.tileImage.JigsawShape;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrilateralArray;
import trilateral.path.Base;
import trilateral.path.Fine;
import trilateral.path.Crude;
import trilateral.path.MediumOverlap;
import trilateral.path.FillOnly;
class OutlineBuilder {
    var base: Base = new MediumOverlap( null, null, both );
    public function new(){}
    public inline
    function draw( jigsawPieces: Array<JigsawPiece> ): Array<JigsawShape>{
        var path = base;
        path.width = 2;
        var jigs = jigsawPieces;
        var jig = jigs[ 0 ];
        var ox: Float;
        var oy: Float;
        var count: Int = 0;
        var shapeArray = new Array<JigsawShape>();
        for( i in 0...jigs.length ){
            jig = jigs[ i ];
            path.reset();
            ox = jig.xy.x;
            oy = jig.xy.y;
            var first = jig.getFirst();
            path.moveTo( first.x + ox, first.y + oy );
            var p = jig.getPoints();
            for( v in  p )  {  path.lineTo( v.x + ox, v.y + oy ); }
            path.lineTo( first.x + ox, first.y + oy );
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