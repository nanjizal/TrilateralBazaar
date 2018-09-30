package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import trilateral.nodule.*;
import kha.Assets;
import trilateral.path.Base;
import trilateral.path.Fine;
import trilateral.path.MediumOverlap;
import trilateral.path.FillOnly;
import trilateralXtra.parsing.FillDrawPolyK;
import trilateral.justPath.SvgPath;
import trilateral.justPath.PathContextTrace;
import trilateral.parsing.FillDraw;
import trilateralXtra.kDrawing.ImageDrawing;
import trilateral.tri.TriangleGradient;
import trilateralXtra.color.AppColors;
import trilateral.justPath.transform.ScaleContext;
import trilateral.justPath.transform.ScaleTranslateContext;
import trilateral.justPath.transform.TranslationContext;
import trilateralXtra.kDrawing.PolyPainter;
import trilateral.tri.TriangleArray;
import trilateral.tri.Triangle;
import jigsawx.JigsawPiece;
import jigsawx.Jigsawx;
import jigsawx.math.Vec2;
import jigsawxKha.JigsawShape;
class Main {
    var imageDrawing:   ImageDrawing;
    var fillDraw:       FillDraw;
    var nudeImage:       Image;
    var showBackground  = false; // useful for debug
    var backgroundAlpha = 0.3;
    var once            = true; // only render the first time after loading.
    var imgWidth        = 371;
    var imgHeight       = 262;
    var wid             = 45;
    var hi              = 45;
    var rows            = 7;
    var cols            = 10;
    var count           = 0;
    var scaleImg        = 1.2;
    var jigsawx:        Jigsawx;
    var triangles:      TriangleArray;
    var jigsawShapeArray = new Array<JigsawShape>(); 
    var jigsawImages     = new Array<Image>();    
    var appColors:      Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                           , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                           , BlueAlpha, GreenAlpha, RedAlpha ];
    public static 
    function main() {
        System.init( {  title: "JigsawX Trilateral Kha example"
                     ,  width: 800, height: 600
                     ,  samplesPerPixel: 4 }
                     , function()
                     {
                        new Main();
                     } );
    }
    public function new(){
        // increase before setting up imagDrawing
        PolyPainter.bufferSize = 3000000;
        fillDraw     = new FillDrawPolyK( Math.ceil( imgWidth*scaleImg ), Math.ceil( imgHeight*scaleImg ) );
        imageDrawing = new ImageDrawing( fillDraw );
        jigsawx      = new Jigsawx( wid, hi, rows, cols );
        Assets.loadEverything( loadAll );
    }
    public function loadAll(){
        trace( 'loadAll' );
        fillDraw.colors = appColors;
        nudeImage = drawNude();
        drawMask();
        startRendering();
    }
    function startRendering(){
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    function drawMask(){
        var path: Base = new FillOnly(); // try to reuse rather than new?
        var jig = jigsawx.jigs[ 0 ];
        var image: Image;
        var ox: Float;
        var oy: Float;
        var count: Int = 0;
        for( jig in jigsawx.jigs ){
            path.trilateralArray  = [];
            path.points           = [];
            path.dim              = [];
            ox = jig.xy.x - 45;
            oy = jig.xy.y - 45;
            var first = jig.getFirst();
            path.moveTo( first.x + ox, first.y + oy );
            var p = jig.getPoints();
            for( v in  p )  {  path.lineTo( v.x + ox, v.y + oy ); }
            // clear triangle data from fillDraw.
            fillDraw.triangles  = [];
            fillDraw.fill( path.points, appColors[ 1 ] );
            jigsawShapeArray[ count ] = new JigsawShape( jig, fillDraw.triangles, ox, oy );
            count++;
            //if( count > 10 ) break;
        }
    }
    // render sprite sheet, renderPieceToImage too heavy.
    function render( framebuffer: Framebuffer ): Void {
        if( once ){
            var g2 = framebuffer.g2;
            var poly = imageDrawing.polyPainter;
            var scale = 1;
            var jigsawShape: JigsawShape;
            var x = 0.;
            var y = 0.;
            imageDrawing.startFrame( framebuffer );
            if( showBackground ) poly.drawImage( Assets.images.tablecloth, 0, 0, imgWidth, imgHeight, backgroundAlpha );
            for( i in 0...jigsawShapeArray.length ){
                jigsawShape = jigsawShapeArray[ i ];
                fillDraw.triangles = jigsawShape.triangles;
                var dx = jigsawShape.x/1.5 + 23;
                var dy = jigsawShape.y/1.5 + 23;
                imageDrawing.renderImageTrianglesOffset( scale, dx, dy, -dx, -dy );
            }
            imageDrawing.end();
            once = false;
        }
    }
    function renderPieceToImage(){
        var poly        = imageDrawing.polyPainter;
        imageDrawing.startImage();
        imageDrawing.renderImageTriangles( 1, 0, 0 );
        imageDrawing.end();
        return imageDrawing.image;
    }
    function drawNude(){
        var poly        = imageDrawing.polyPainter;
        imageDrawing.startImage();
        poly.drawImage( Assets.images.tablecloth, -20, -20, imgWidth*scaleImg, imgHeight*scaleImg );
        imageDrawing.end();
        return imageDrawing.image;
    }
}