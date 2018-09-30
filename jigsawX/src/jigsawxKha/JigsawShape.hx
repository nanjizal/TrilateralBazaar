package jigsawxKha;
import trilateral.tri.TriangleArray;
import jigsawx.JigsawPiece;
import kha.Image;
class JigsawShape {
    public var x:           Float;
    public var y:           Float;
    public var triangles:   TriangleArray;
    public var jig:         JigsawPiece;
    public function new( jig_: JigsawPiece, triangles_: TriangleArray, x_: Float, y_: Float ){
        jig = jig_;
        triangles = triangles_;
        x = x_;
        y = y_;
    }
}