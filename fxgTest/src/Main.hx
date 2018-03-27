package;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import trilateral.nodule.*;
import polyPainter.PolyPainter;
import kha.Assets;
import kha.graphics4.TextureAddressing;
import trilateral.tri.TriangleArray;
import trilateral.tri.Triangle;
import trilateral.fxg.Group;
import trilateral.path.Fine;
import trilateral.path.Medium;
import trilateral.path.Base;
import trilateral.geom.Contour; // used for the 'both' line end style
import hxPolyK.PolyK;
class Main {
    static var polyPainter:   PolyPainter;
    static var renderTarget: kha.Image;
    static var triangles = new TriangleArray();
    static var colors    = new Array<Int>();
    static var step = 0.1;
    static function update(): Void {
        zoom += step;
        if( zoom > 2 ) step = -0.1;
        if( zoom < 1 ) step = 0.1;
    }
    static var zoom = 1.;
    static var theta = 0.;
    static function render( framebuffer: Framebuffer ): Void {
        var g2 = framebuffer.g2;
        polyPainter.framebuffer = framebuffer;    
        polyPainter.begin( true, 0xFFFFFFFF );
        sky();
        grass();
        foreGround( zoom, -408*zoom + 408 + zoom*50*Math.sin( theta+= 0.2 ), -55.9*zoom + 55.9 );
        polyPainter.end();
        //System.removeRenderListener( render );
    }
    // Uses some gradient triangles to create an interesting sky using bit of red and green on either sides.
    public static inline function sky(){
        var blueRed = 0xFF6F73F3;//blueWithBitOfRed
        var blueGreen = 0xFFB0EaF5;//blueWithBitOfGreen
        var topUp = -200;// cheat moved top up to soften the darkest blue, rather than tweaking all colors.
        polyPainter.drawGradientTriangle( 0, topUp, 400, topUp, 0, 400, blueRed, 0xFF4F78EE, 0xFFAECFF5 );
        polyPainter.drawGradientTriangle( 0, 400, 400, topUp, 400, 400, 0xFFAECFF5, 0xFF4F78EE, 0xFF8CA9EE );
        polyPainter.drawGradientTriangle( 400, topUp, 800, topUp, 400, 400, 0xFF4F78EE, 0xFF1D5FEC, 0xFF8CA9EE );
        polyPainter.drawGradientTriangle( 400, 400, 800, topUp, 800, 400, 0xFF8CA9EE, 0xFF1D5FEC, blueGreen );
    }
    public static inline function grass(){
        var grassImage =  kha.Assets.images.Grass;
        // use the gradient version to tint image to give a bit more life to the tiling.
        polyPainter.drawImageTriangleGradient( 0, 400, 800, 400, 800, 600, 0, 0, 8, 0, 8, 2, grassImage, 0xa000ff00, 0xe0f0ffff, 0xe0f0ffff );
        polyPainter.drawImageTriangleGradient( 0, 400, 800, 600, 0, 600, 0, 0, 8, 2, 0, 2, grassImage , 0xa000ff00, 0xe0f0ffff, 0xe0f0ffff );
    }
    // This renders the parrot FXG that is now ArrayTriangle.
    public static inline function foreGround( scale: Float, cx: Float, cy: Float ){
        var tri: Triangle;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            polyPainter.drawFillTriangle( tri.ax * scale + cx, tri.ay * scale + cy
                                        , tri.bx * scale + cx, tri.by * scale + cy
                                        , tri.cx * scale + cx, tri.cy * scale + cy, colors[ tri.colorID ] );
        }
    }
    // This is the fill function implementation passed to the fxg renderer.
    public static function fill( triangles: TriangleArray, id: Int, poly: Array<Float>, colorID: Int ):Void{
        var tgs = PolyK.triangulate( poly ); 
        var triples = new ArrayTriple( tgs );
        for( tri in triples ){
            var a: Int = Std.int( tri.a*2 );
            var b: Int = Std.int( tri.b*2 );
            var c: Int = Std.int( tri.c*2 );
            triangles.drawTriangle(  id, { x: poly[ a ], y: poly[ a + 1 ] }
                                      , { x: poly[ b ], y: poly[ b + 1 ] }
                                      , { x: poly[ c ], y: poly[ c + 1 ] }, colorID );
        }
    }
    // This is passed to the fxg renderer to determine the pen used to draw from Crude -> Fine.
    public static function pathFactory(): Base {
        var pen = new Fine( null, null, null );// both );
        return cast pen;
    }
    static function onLoaded(){
        Scheduler.addTimeTask( function () { update(); }, 0, 1 / 12 );
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
        var nodule: Nodule = ReadXML.toNodule( Assets.blobs.Parrot_fxg.toString() );
        var group: Group = nodule.firstChild;
        // colors and triangles are appended by the FXG as it's renderered.
        group.render( 0, triangles, colors, pathFactory, fill );

    }
    public static function main() {
        System.init({title: "PolyPainter & FXG Parrot", width: 800, height: 600, samplesPerPixel: 4 }, function() {
            polyPainter = new PolyPainter();
            // This sets texturing in PolyPainter so that textures will repeat ie: the grass.
            polyPainter.textureAddressingX = Repeat;
            polyPainter.textureAddressingY = Repeat;
            kha.Assets.loadEverything( onLoaded );
        });
    }
}
