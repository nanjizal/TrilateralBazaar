package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import trilateral.nodule.*;
import kha.Assets;
import trilateralXtra.kDrawing.fxg.Group;
import trilateralXtra.kDrawing.ImageDrawingPolyK;
// import trilateralXtra.kDrawing.ImageDrawing2Tri;  currently poly2trihx is rather fragile to use with fxg even if it's better for holes etc.
import trilateralXtra.kDrawing.ImageDrawing;
import trilateralXtra.kDrawing.SceneXtras; // sky, grass
class Main {
    var imageDrawing: ImageDrawing;
    var parrot:       Image;
    var background:   Image;
    public static 
    function main() {
        System.init( {  title: "PolyPainter & FXG Parrot"
                     ,  width: 800, height: 600
                     ,  samplesPerPixel: 4 }
                     , function()
                     {
                        new Main();
                     } );
    }
    public function new(){
        imageDrawing = new ImageDrawingPolyK( 800, 600 );
        Assets.loadEverything( loadParrot );
    }
    function loadParrot(){
        parrotToTriangles();
        parrot      = parrotToImage();
        background  = backgroundToImage();
        startRendering();
    }
    function parrotToTriangles(){
        var parrotStr       = Assets.blobs.Parrot_fxg.toString();
        var nodule: Nodule  = ReadXML.toNodule( parrotStr );
        var group:  Group   = nodule.firstChild;
        var img             = imageDrawing;
        group.render( imageDrawing );
    }
    function parrotToImage(){
        imageDrawing.startImage();
        var scale = 0.5;
        var x = 0.;
        var y = 0.;
        imageDrawing.renderTriangles( scale, x, y );
        imageDrawing.end();
        return imageDrawing.image;
    }
    function backgroundToImage(){
        imageDrawing = new ImageDrawingPolyK( 800, 600 );
        imageDrawing.startImage();
        backgroundDraw();
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
        var dx = 100*Math.sin( theta+= 0.005 );
        var w  = parrot.width;
        var h  = parrot.height;
        poly.drawImage( background );
        var dW = 150;
        for( i in 0...4 ){
            poly.drawImage( parrot, dx + i*dW, 290 + 5*Math.cos( 1/dx ), w+0.1*w*Math.sin( theta ), h+0.1*h*Math.sin(theta) );
            dx = 100*Math.sin( theta+= 0.005 );
        }
        imageDrawing.end();
    }
    function backgroundDraw(){
        var poly        = imageDrawing.polyPainter;
        var grassImage  = kha.Assets.images.Grass;
        SceneXtras.sky( poly );
        SceneXtras.grass( poly, grassImage );
    }
}