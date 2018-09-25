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
//import trilateralXtra.kDrawing.ImageDrawingPolyK;
//import trilateralXtra.kDrawing.ImageDrawing2Tri;
import trilateralXtra.kDrawing.ImageDrawing;
import trilateral.tri.TriangleGradient;
import trilateralXtra.color.AppColors;
import trilateral.justPath.transform.ScaleContext;
import trilateral.justPath.transform.ScaleTranslateContext;
import trilateral.justPath.transform.TranslationContext;
import trilateralXtra.kDrawing.SceneXtras; // sky, grass
import trilateralXtra.kDrawing.PolyPainter;
class Main {
    var imageDrawing:   ImageDrawing;
    var fillDraw:       FillDraw;
    var catImage:       Image;
    var showBackground  = false; // useful for debug
    var backgroundAlpha = 0.3;
    var once            = true; // only render the first time after loading.
    var appColors:      Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                           , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                           , BlueAlpha, GreenAlpha, RedAlpha ];
    public static 
    function main() {
        System.init( {  title: "PolyPainter & Mask"
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
    public function loadAll(){
        trace( 'loadAll' );
        fillDraw.colors = appColors;
        catImage = drawCat();
        drawCatMask();
        startRendering();
    }
    function startRendering(){
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    function drawCatMask(){
        var path: Base = new FillOnly();
        catSvg( path );
        fillDraw.fill( path.points, appColors[1] ); // red but this is just used to generation of mask.
    }
    function catSvg( path: Base ){
        var scaleContext = new ScaleTranslateContext( path, 0, 0, 1, 1 );
        var pathContextTrace = new PathContextTrace();
        var p = new SvgPath( scaleContext );
        p.parse( suma_cat_d );
        
    }
    function render( framebuffer: Framebuffer ): Void {
        if( once ){
            var g2 = framebuffer.g2;
            var poly = imageDrawing.polyPainter;
            var scale = 1.;
            var x = 0.;
            var y = 0.;
            imageDrawing.startFrame( framebuffer );
            if( showBackground ) poly.drawImage( Assets.images.SumaCat, 0, 0, 500, 667, backgroundAlpha );
            imageDrawing.renderImageTriangles( scale, x, y );
            imageDrawing.end();
            once = false;
        }
    }
    function drawCat(){
        var poly        = imageDrawing.polyPainter;
        imageDrawing.startImage();
        poly.drawImage( Assets.images.SumaCat );
        imageDrawing.end();
        return imageDrawing.image;
    }
    // Suma cat outline
    var suma_cat_d = "M476.65 64 Q475.9 74.65 474.35 85.2 L471.25 107.55 Q468.7 126.8 465.55 145.9 463.2 160.2 457 173 464.05 186.9 464.5 202.7 465.15 224.4 454 243 L480.95 264.1 453 246 438.5 268.5 444.5 276.5 Q457.05 279.4 467.7 286 473.85 289.75 478.9 294.7 L446.5 279.5 449.3 290.75 Q472.25 307.95 481.3 335.25 476.3 325.8 470.65 316.85 459.3 299 440.75 288.65 L439 290 Q464.4 313.1 479.7 344.1 462.05 314.95 437.5 291.5 438.5 296 440.8 299.7 L455.8 323.8 Q470.1 347.1 464.1 374.1 465.55 355.55 460.75 337.7 455.3 317.7 439.5 304.5 444.4 333.85 448.1 363.6 L440 328 Q425.8 403.1 379.95 464.5 367.25 481.55 363.9 501.05 356.35 545.45 353.7 590.5 353.2 598.55 358 605 372.75 603.3 380.1 616 385.5 625.25 381.3 635.6 380.05 638.6 377.4 640.5 373.25 643.35 368.05 644.35 345.05 648.95 327.45 632.45 324.7 629.9 324.1 626.6 311.2 557 295.5 487.5 244.25 559.1 257.5 648.5 L261.05 651.55 Q264.05 654.3 265.3 658.1 266.75 662.6 265.45 667 L208.8 667 Q213.9 605.75 200.5 545.5 L190.65 546.6 Q180.55 554.2 167.4 547.7 165.4 546.7 164.45 545.25 113.1 464.65 122 364 L111 373 Q103.65 399.9 104.9 425.65 104.3 425.45 104.3 426.75 104.2 437.1 104.95 447.15 108.25 491.65 114.75 535.45 107.05 545 95.9 550.3 87.7 554.25 80 549 73.1 550.75 68.9 545.4 62.95 537.95 63.35 528 65.6 469.15 58 411.6 47.55 332.55 23.1 256.15 9.85 214.85 3.75 171.9 1.1 153.2 5.1 134.95 10.15 111.75 25.05 90.95 41.65 67.75 70.95 62.15 112.4 54.1 147.75 78.3 214.2 123.8 276 175.7 278.55 140 273.35 103.8 270.5 83.7 277.15 64.5 280.35 55.3 288.05 50.65 291.6 48.6 295.3 50.35 308.35 56.75 316.65 68.55 333.05 91.95 340 120 376.15 117.35 412 122 L413.75 119.15 Q424.75 101.45 437.75 85 450.9 68.35 470 61 L476.55 63.1 476.65 64 M432.5 280.5 L448.2 289.9 444.6 278.75 432.5 276.6 432.5 280.5 M183.5 422.5 L170.5 406.5 168.5 406.05 164.5 423.5 170.5 465.5 183.5 495.5 200.5 515.5 200.5 478.5 183.5 422.5";
}