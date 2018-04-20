package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import trilateral.nodule.*;
import kha.Assets;
import trilateral.path.Base;
import trilateral.path.Fine;
import trilateral.path.MediumOverlap;
import trilateral.justPath.SvgPath;
import trilateralXtra.kDrawing.ImageDrawingPolyK;
import trilateralXtra.kDrawing.ImageDrawing;
import trilateral.tri.TriangleGradient;
import trilateralXtra.color.AppColors;
import trilateral.justPath.transform.ScaleContext;
import trilateral.justPath.transform.ScaleTranslateContext;
import trilateral.justPath.transform.TranslationContext;
import trilateralXtra.kDrawing.SceneXtras; // sky, grass
class Main {
    var imageDrawing:   ImageDrawing;
    var gradientImage:  Image;
    var background:     Image;
    var appColors:      Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                           , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                           , BlueAlpha, GreenAlpha, RedAlpha ];
    public static 
    function main() {
        System.init( {  title: "PolyPainter & LinearGradient"
                     ,  width: 800, height: 600
                     ,  samplesPerPixel: 4 }
                     , function()
                     {
                        new Main();
                     } );
    }
    public function new(){
        imageDrawing = new ImageDrawing( 800, 600 );
        imageDrawing.colors = appColors;
        
        background = backgroundDraw();
        
        
        imageDrawing = new ImageDrawing( 800, 600 );
        imageDrawing.triangles = [];
        imageDrawing.colors = appColors;
        drawGradients();
        gradientImage = renderGradientToImage();
        imageDrawing.triangles = [];
        drawVectorOutlines();
        startRendering();
    }
    function drawGradients(){
        var gradientOrder = [ 1,2,3,4,5,6,7 ];
        TriangleGradient.multiGradient( 0, true, 0., 0., 500., 500.
                                    , imageDrawing.triangles, gradientOrder, TriangleGradient.gradientFunction( quadEaseIn )
                                    , 0, 0., 0. );
        var gradientOrder2 = [ 3,1,3,4,1,6,7,3 ];
        TriangleGradient.multiGradient( 10, true, 200., 200., 400., 400.
                                    , imageDrawing.triangles, gradientOrder2, null,-Math.PI/8, 0.5, 0.5 );
        TriangleGradient.multiGradient( 10, true, 200., 200., 400., 400.
                                    , imageDrawing.triangles, gradientOrder2, null, Math.PI/8, -0.5, -0.5 );
    }
    public static function quadEaseIn( t: Float, b: Float, c: Float, d: Float ): Float {
        return c * ( t /= d ) * t + b;
    }
    public static function expEaseInOut( t: Float, b: Float, c: Float, d: Float ): Float{
        if ( t == 0 ) return b;
        if ( t == d ) return b+c;
        if ( ( t /= d / 2 ) < 1 ) return c / 2 * Math.pow( 2, 10 * ( t - 1 ) ) + b - c * 0.0005;
        return c / 2 * 1.0005 * ( -Math.pow( 2, -10 * --t ) + 2 ) + b;
    }
    function renderGradientToImage(){
        var scale = 1;
        var x = 0.;
        var y = 0.;
        imageDrawing.startImage();
        imageDrawing.renderGradientTriangles( scale, x, y, 0.6 );
        imageDrawing.end();
        return imageDrawing.image;
    }
    function startRendering(){
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    function drawVectorOutlines(){
        var path: Base = new MediumOverlap( null, null, both );
        path.width = 4;
        bird( path );
        grid( path );
        imageDrawing.triangles.addArray( 6
                                     ,   path.trilateralArray
                                     ,   8 ); // this color is not used as we use image for color.
    }
    function bird( path: Base ){
        var scaleContext = new ScaleTranslateContext( path, 100, 0, 1, 1 );
        var p = new SvgPath( scaleContext );
        p.parse( bird_d );
    }
    function grid( path: Base ){ // horizontal and vertical lines
        var x0: Float = 0.;
        var y0: Float = 0.;
        for( i in 0...Std.int( 2000/30 + 1 ) ){
            path.moveTo( x0, y0 );
            path.lineTo( 2000., y0 );
            y0+=30;
        }
        var x0: Float = 0.;
        var y0: Float = 0.;
        for( i in 0...Std.int( 2000/30 + 1 ) ){
            path.moveTo( x0, y0 );
            path.lineTo( x0, 2000. );
            x0+=30;
        }
    }
    function render( framebuffer: Framebuffer ): Void {
        var g2 = framebuffer.g2;
        var poly = imageDrawing.polyPainter;
        var scale = 1;
        var x = 0.;
        var y = 0.;
        imageDrawing.startFrame( framebuffer );
        poly.drawImage( background );
        poly.drawImage( gradientImage, 0, 0, 1024, 768, 0.5 );
        imageDrawing.renderImageTriangles( scale, x, y );
        imageDrawing.end();
    }
    function backgroundDraw(){
        var poly        = imageDrawing.polyPainter;
        var gradientOrder = [ 4,3 ];
        TriangleGradient.multiGradient( 0, false, 0., 400., 800., 200.
                                    , imageDrawing.triangles, gradientOrder, TriangleGradient.gradientFunction( quadEaseIn )
                                    , 0, 0., 0. );
        imageDrawing.startImage();
        SceneXtras.sky( poly );
        imageDrawing.renderGradientTriangles( 1, 0, 0, 0.7 );
        imageDrawing.end();
        return imageDrawing.image;
    }
    var bird_d = "M210.333,65.331C104.367,66.105-12.349,150.637,1.056,276.449c4.303,40.393,18.533,63.704,52.171,79.03c36.307,16.544,57.022,54.556,50.406,112.954c-9.935,4.88-17.405,11.031-19.132,20.015c7.531-0.17,14.943-0.312,22.59,4.341c20.333,12.375,31.296,27.363,42.979,51.72c1.714,3.572,8.192,2.849,8.312-3.078c0.17-8.467-1.856-17.454-5.226-26.933c-2.955-8.313,3.059-7.985,6.917-6.106c6.399,3.115,16.334,9.43,30.39,13.098c5.392,1.407,5.995-3.877,5.224-6.991c-1.864-7.522-11.009-10.862-24.519-19.229c-4.82-2.984-0.927-9.736,5.168-8.351l20.234,2.415c3.359,0.763,4.555-6.114,0.882-7.875c-14.198-6.804-28.897-10.098-53.864-7.799c-11.617-29.265-29.811-61.617-15.674-81.681c12.639-17.938,31.216-20.74,39.147,43.489c-5.002,3.107-11.215,5.031-11.332,13.024c7.201-2.845,11.207-1.399,14.791,0c17.912,6.998,35.462,21.826,52.982,37.309c3.739,3.303,8.413-1.718,6.991-6.034c-2.138-6.494-8.053-10.659-14.791-20.016c-3.239-4.495,5.03-7.045,10.886-6.876c13.849,0.396,22.886,8.268,35.177,11.218c4.483,1.076,9.741-1.964,6.917-6.917c-3.472-6.085-13.015-9.124-19.18-13.413c-4.357-3.029-3.025-7.132,2.697-6.602c3.905,0.361,8.478,2.271,13.908,1.767c9.946-0.925,7.717-7.169-0.883-9.566c-19.036-5.304-39.891-6.311-61.665-5.225c-43.837-8.358-31.554-84.887,0-90.363c29.571-5.132,62.966-13.339,99.928-32.156c32.668-5.429,64.835-12.446,92.939-33.85c48.106-14.469,111.903,16.113,204.241,149.695c3.926,5.681,15.819,9.94,9.524-6.351c-15.893-41.125-68.176-93.328-92.13-132.085c-24.581-39.774-14.34-61.243-39.957-91.247c-21.326-24.978-47.502-25.803-77.339-17.365c-23.461,6.634-39.234-7.117-52.98-31.273C318.42,87.525,265.838,64.927,210.333,65.331zM445.731,203.01c6.12,0,11.112,4.919,11.112,11.038c0,6.119-4.994,11.111-11.112,11.111s-11.038-4.994-11.038-11.111C434.693,207.929,439.613,203.01,445.731,203.01z";
}