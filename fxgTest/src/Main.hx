package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import trilateral.nodule.*;
import kha.Assets;
import trilateral.parsing.fxg.Group;
import trilateralXtra.parsing.FillDrawPolyK;
import trilateralXtra.kDrawing.ImageDrawing;
import trilateral.parsing.FillDraw;
// import trilateralXtra.parsing.FillDraw2Tri;  currently poly2trihx is rather fragile to use with fxg even if it's better for holes etc.
import trilateralXtra.kDrawing.SceneXtras; // sky, grass
class Main {
    var imageDrawing: ImageDrawing;
    var fillDraw:     FillDraw;
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
        fillDraw     = new FillDrawPolyK( 800, 600 );
        imageDrawing = new ImageDrawing( fillDraw );
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        toTriangles();
        parrot      = toImage();
        background  = backgroundToImage();
        startRendering();
    }
    function toTriangles(){
        var parrotStr       = Assets.blobs.Parrot_fxg.toString();
        var nodule: Nodule  = ReadXML.toNodule( parrotStr );
        var group:  Group   = nodule.firstChild;
        group.render( fillDraw );
    }
    function toImage(){
        imageDrawing.startImage();
        var scale = 0.5;
        var x = 0.;
        var y = 0.;
        imageDrawing.renderTriangles( scale, x, y );
        imageDrawing.end();
        return imageDrawing.image;
    }
    function backgroundToImage(){
        imageDrawing = new ImageDrawing( new FillDraw( 800, 600 ) );
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
            poly.drawImage( parrot, dx + i*dW, 290, w+0.1*w*Math.sin( theta ), h+0.1*h*Math.sin(theta) );
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