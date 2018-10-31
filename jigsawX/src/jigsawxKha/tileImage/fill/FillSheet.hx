package jigsawxKha.tileImage.fill;
import kha.Image;
import jigsawxKha.tileImage.JigsawShape;
import trilateral.parsing.FillDraw;
import trilateralXtra.kDrawing.ImageDrawing;
import trilateralXtra.parsing.FillDrawPolyK;
class FillSheet{
    var scaleImg         = 1.;//.2;
    var imageDrawing:    ImageDrawing;
    var fillDraw:        FillDraw;
    public function new( widthMax: Int, heightMax: Int ){
        fillDraw     = new FillDrawPolyK( widthMax, heightMax );
        imageDrawing = new ImageDrawing( fillDraw );
    }
    public inline
    function render(  imageIn: Image, jigsawShapes: Array<JigsawShape>
                    , inputScale: Float, canvasScale: Float ): Image {
        var poly = imageDrawing.polyPainter;
        var jigsawShape: JigsawShape;
        var canvasScale = inputScale;
        var imageScale = 1.;
        var x = 0.;
        var y = 0.;
        imageDrawing.startImage();
        for( i in 0...jigsawShapes.length ){
            jigsawShape = jigsawShapes[ i ];
            fillDraw.triangles = jigsawShape.triangles;
            var dx = jigsawShape.x*scaleImg;
            var dy = jigsawShape.y*scaleImg;
            imageDrawing.renderImageTrianglesOffset( imageIn, canvasScale, imageScale, dx, dy );
        }
        imageDrawing.end();
        return imageDrawing.image;
    }
}