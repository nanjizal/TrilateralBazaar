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
import trilateral.path.Fine;
import trilateral.justPath.SvgPath;
import trilateral.justPath.transform.M3; // use with TransformationContext
import trilateral.justPath.transform.TransformationContext; // used for more complex transformations
import trilateral.justPath.transform.ScaleTranslateContext;
class Main {
    var countID:    Int = 0;
    var polyPainter:  PolyPainter;
    var triangles   = new TriangleArray();
    var colors      = new Array<Int>();
    var crimson     = 0xFFDC143C;
    var silver      = 0xFFC0C0C0;
    var gainsboro   = 0xFFDCDCDC;
    var lightGray   = 0xFFD3D3D3;
    var arc0_0      = "M 100 200 A 100 50 0.0 0 1 250 150";
    var arc0_1      = "M 100 200 A 100 50 0.0 1 0 250 150";
    var arc0_2      = "M 100 200 A 100 50 0.0 1 1 250 150";
    var arc0_3      = "M 100 200 A 100 50 0.0 0 0 250 150";
    var arc1_0      = "M 100 200 A 100 50 0.0 0 0 250 150";
    var arc1_1      = "M 100 200 A 100 50 0.0 1 0 250 150";
    var arc1_2      = "M 100 200 A 100 50 0.0 1 1 250 150";
    var arc1_3      = "M 100 200 A 100 50 0.0 0 1 250 150";
    var arc2_0      = "M 100 200 A 100 50 -15 0 0 250 150";
    var arc2_1      = "M 100 200 A 100 50 -15 0 1 250 150";
    var arc2_2      = "M 100 200 A 100 50 -15 1 1 250 150";
    var arc2_3      = "M 100 200 A 100 50 -15 1 0 250 150";
    var arc3_0      = "M 100 200 A 100 50 -15 0 0 250 150";
    var arc3_1      = "M 100 200 A 100 50 -15 0 1 250 150";
    var arc3_2      = "M 100 200 A 100 50 -15 1 0 250 150";
    var arc3_3      = "M 100 200 A 100 50 -15 1 1 250 150";
    var arc4_0      = "M 100 200 A 100 50 -44 1 0 250 150";
    var arc4_1      = "M 100 200 A 100 50 -44 0 1 250 150";
    var arc4_2      = "M 100 200 A 100 50 -44 1 1 250 150";
    var arc4_3      = "M 100 200 A 100 50 -44 0 0 250 150";
    var arc5_0      = "M 100 200 A 100 50 -44 0 0 250 150";
    var arc5_1      = "M 100 200 A 100 50 -44 1 1 250 150";
    var arc5_2      = "M 100 200 A 100 50 -44 1 0 250 150";
    var arc5_3      = "M 100 200 A 100 50 -44 0 1 250 150";
    var arc6_0      = "M 100 200 A 100 50 -45 0 0 250 150";
    var arc6_1      = "M 100 200 A 100 50 -45 0 1 250 150";
    var arc6_2      = "M 100 200 A 100 50 -45 1 1 250 150";
    var arc6_3      = "M 100 200 A 100 50 -45 1 0 250 150";
    var arc7_0      = "M 100 200 A 100 50 -45 0 0 250 150";
    var arc7_1      = "M 100 200 A 100 50 -45 0 1 250 150";
    var arc7_2      = "M 100 200 A 100 50 -45 1 0 250 150";
    var arc7_3      = "M 100 200 A 100 50 -45 1 1 250 150";
    static function main() {
        System.init(
            { title: "elliptical arc examples", width: 800, height: 600, samplesPerPixel: 4 }
            , function() { new Main(); } );
    }
    public function new(){
        initPolyPainter();
        setupSomeColors();
        drawEllipticalArcs();
        Scheduler.addTimeTask( function () { update(); }, 0, 1 / 60);
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    // pushes some colors for development.
    function setupSomeColors(){
        colors.push( crimson );
        colors.push( silver );
        colors.push( gainsboro );
        colors.push( lightGray );
    }
    function id( color: Int ) return colors.indexOf( color );
    // draws the ellipse to triangles.
    function drawEllipticalArcs(){
        var arcs0  = [ arc0_0, arc0_1, arc0_2, arc0_3 ];
        var arcs1  = [ arc1_0, arc1_1, arc1_2, arc1_3 ];
        var arcs2  = [ arc2_0, arc2_1, arc2_2, arc2_3 ];
        var arcs3  = [ arc3_0, arc3_1, arc3_2, arc3_3 ];
        var arcs4  = [ arc4_0, arc4_1, arc4_2, arc4_3 ];
        var arcs5  = [ arc5_0, arc5_1, arc5_2, arc5_3 ];
        var arcs6  = [ arc6_0, arc6_1, arc6_2, arc6_3 ];
        var arcs7  = [ arc7_0, arc7_1, arc7_2, arc7_3 ];
        var pallet = [ silver, gainsboro, lightGray, crimson ];
        var x0 = 130;
        var x1 = 450;
        var yPos = [ -30, 100, 250, 400 ];
        var arcs = [ arcs0, arcs1, arcs2, arcs3, arcs4, arcs5, arcs6, arcs7 ];
        for( i in 0...yPos.length ){
            drawSet( arcs.shift(), pallet, x0, yPos[i], 0.6 );
            drawSet( arcs.shift(), pallet, x1, yPos[i], 0.6 );
        }
    }
    // draws a set of svg ellipses.
    function drawSet( arcs: Array<String>, col:Array<Int>, x: Float, y: Float, s: Float ){    
        for( i in 0...arcs.length ) draw_d( arcs[ i ], x, y, s, 3, id( col[ i ] ) );
    }
    // draws an svg ellipse
    function draw_d( d: String, x: Float, y: Float, s: Float, w: Float, colorID: Int ){
        var path = new Fine();
        path.width = w;
        // create transformation
        // var m3: M3 = M3.transformation( x, y, s, s );
        // var trans = new TransformationContext( path, m3 );
        // ScaleTranslateContext is lighter than matrix approach.
        // Concept is that one pathContext modifies before passing to the actual drawing one. 
        var trans = new ScaleTranslateContext( path, x, y, s, s );
        var p = new SvgPath( trans );
        // draws the shape outlines to triangles
        p.parse( d );
        // adds color to the triangles
        triangles.addArray( countID++
                        ,   path.trilateralArray
                        ,   colorID );
    }
    // initiallizes the triangle shader renderer used.
    function initPolyPainter(){
        polyPainter = new PolyPainter();
        // this is for repeat textures and not used in this demo.
        polyPainter.textureAddressingX = Repeat;
        polyPainter.textureAddressingY = Repeat;
    }
    function update(): Void {}
    function render( framebuffer: Framebuffer ): Void {
        var g2 = framebuffer.g2;
        // sets the canvas for drawing on
        polyPainter.framebuffer = framebuffer;    
        polyPainter.begin( true, 0xFF181818 );
        renderOutlines(); // draws the triangles to screen
        polyPainter.end();
        stopRender();
    }
    // kills the rendering after the first render.
    function stopRender() System.removeRenderListener( render );
    // passes internal triangles to the shaders
    function renderOutlines(){
        var tri: Triangle;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            polyPainter.drawFillTriangle( tri.ax, tri.ay, tri.bx, tri.by, tri.cx, tri.cy, colors[ tri.colorID ] );
        }
    }
}