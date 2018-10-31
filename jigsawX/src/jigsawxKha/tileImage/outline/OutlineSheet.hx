package jigsawxKha.tileImage.outline;
import kha.Image;
import kha.Color;
import kha.graphics4.DepthStencilFormat;
import trilateralXtra.kDrawing.PolyPainter;
import trilateral.tri.Triangle;

class OutlineSheet{
    var polyPainter = new PolyPainter();
    var img: Image;

    public function new(){
        img = Image.createRenderTarget( 1024, 768, null, DepthStencilFormat.NoDepthAndStencil, 4 );
        polyPainter.textureAddressingX  = Repeat;
        polyPainter.textureAddressingY  = Repeat;
    }
    public inline
    function render( jigsawShapes: Array<JigsawShape> ): Image {
        var poly = polyPainter;
        var jigsawShape: JigsawShape;
        var scale = 1.;
        var x = 0.;
        var y = 0.;
        var scale = 1.;
        poly.canvas = img;
        poly.begin( GradientMode, true, null );
        var dx: Float;
        var dy: Float;
        for( i in 0...jigsawShapes.length ){
            jigsawShape = jigsawShapes[ i ];
            var triangles = jigsawShape.triangles;
            dx = scale*jigsawShape.x + 1;
            dy = scale*jigsawShape.y + 1;
            var tri: Triangle;
            for( i in 0...triangles.length ){
                tri = triangles[ i ];
                poly.drawFillTriangle( tri.ax+dx, tri.ay+dy, tri.bx+dx, tri.by+dy, tri.cx+dx, tri.cy+dy, Color.White );
            }
        }
        poly.end();
        return img;
    }

}