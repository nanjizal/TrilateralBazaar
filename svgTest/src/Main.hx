package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import trilateral.nodule.*;
import kha.Assets;
import trilateral.parsing.svg.Svg;
import trilateral.tri.TriangleGradient;
import trilateralXtra.parsing.FillDrawPolyK;
import trilateralXtra.kDrawing.ImageDrawing;
import trilateral.parsing.FillDraw;
import trilateralXtra.kDrawing.PolyPainter;
// import trilateralXtra.parsing.FillDraw2Tri;  currently poly2trihx is rather fragile to use with fxg even if it's better for holes etc.
class Main {
    var imageDrawing: ImageDrawing;
    var fillDraw:     FillDraw;
    var svgImg:       Image;
    var background:   Image;
    public static 
    function main() {
        System.init( {  title: "PolyPainter & Salsa Logo"
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
        fillDraw     = new FillDrawPolyK( 800, 600 );
        imageDrawing = new ImageDrawing( fillDraw );
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        toTriangles();
        svgImg = toImage();
        startRendering();
    }
    function toTriangles(){
        var svgStr          = Assets.blobs.westCountrySalsa_svg.toString();
        var nodule: Nodule  = ReadXML.toNodule( svgStr );
        var svg: Svg        = new Svg( nodule );
        // draw orange gradient background
        var i = 0;
        fillDraw.colors[ 0 ] = 0xFFFC3502;
        fillDraw.colors[ 1 ] = 0xFFFA711F;
        fillDraw.colors[ 2 ] = 0x00FFFFFF;
        fillDraw.colors[ 3 ] = 0xFEFFCC01;
        //  Red to Orange horizontally
        var gradientOrder = [ 0, 1 ];
        TriangleGradient.multiGradient( 0, true, 0., 0., 820., 620., fillDraw.triangles, gradientOrder
                                        , TriangleGradient.gradientFunction( quadEaseIn ), 0, 0., 0. );
        // alpha to yellow vertically over the top
        gradientOrder = [ 2, 3 ];
        TriangleGradient.multiGradient( 0, false, 0., 0., 820., 620., fillDraw.triangles, gradientOrder
                                        , TriangleGradient.gradientFunction( quadEaseIn ), 0, 0., 0. );
        // draw Vector image.
        svg.render( fillDraw );
        // svg.render( fillDraw, true ); // show actual triangles drawn.
    }
    public static function quadEaseIn( t: Float, b: Float, c: Float, d: Float ): Float {
        return c * ( t /= d ) * t + b;
    }
    function toImage(){
        imageDrawing.startImage();
        var scale = 1.;
        var x = -20.;
        var y = -20.;
        imageDrawing.renderGradientTriangles( scale, x, y );
        imageDrawing.end();
        return imageDrawing.image;
    }
    function startRendering(){
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    var theta = 0.;
    function render( framebuffer: Framebuffer ): Void {
        var g2 = framebuffer.g2;
        var poly = imageDrawing.polyPainter;
        imageDrawing.startFrame( framebuffer );
        var w  = svgImg.width;
        var h  = svgImg.height;
        poly.drawImage( svgImg );
        imageDrawing.end();
    }
}