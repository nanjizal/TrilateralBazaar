package jigsawxKha.tileImage;
import kha.Image;
import jigsawxKha.tileImage.JigsawShape;
import trilateral.parsing.FillDraw;
import trilateralXtra.kDrawing.ImageDrawing;
import trilateralXtra.parsing.FillDrawPolyK;
class FillSheet{
    var scaleImg         = 1;//.2;
    var imageDrawing:    ImageDrawing;
    var fillDraw:        FillDraw;
    public function new(){
        fillDraw     = new FillDrawPolyK( 1024, 768 );
        imageDrawing = new ImageDrawing( fillDraw );
    }
    public inline
    function render( imageIn: Image, jigsawShapes: Array<JigsawShape> ): Image {
        var poly = imageDrawing.polyPainter;
        var jigsawShape: JigsawShape;
        var scale = 1.;
        var x = 0.;
        var y = 0.;
        imageDrawing.startImage();
        for( i in 0...jigsawShapes.length ){
            jigsawShape = jigsawShapes[ i ];
            fillDraw.triangles = jigsawShape.triangles;
            var dx = jigsawShape.x*scaleImg;
            var dy = jigsawShape.y*scaleImg;
            imageDrawing.renderImageTrianglesOffset( imageIn, scale, dx, dy, -dx, -dy );
        }
        imageDrawing.end();
        return imageDrawing.image;
    }
}