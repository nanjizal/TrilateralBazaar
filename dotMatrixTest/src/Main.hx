package;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.Assets;
import kha.Font;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import trilateral.path.Fine;
import trilateral.path.Crude;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import trilateral.geom.Algebra;
import trilateralXtra.segment.DotMatrix;
import trilateral.polys.Shapes;
import trilateralXtra.segment.Character5x7;
class Main {
    var appColors = [ Color.Red, Color.Blue, Color.Green, Color.Yellow, Color.Purple, Color.White, Color.Orange ];
    var triangles = new TriangleArray();
    var colors = [ /* bgClock        0 */ 0xff312923
                ,  /* orangeClock    1 */ 0xffe4563c
                ,  /* limeClock      2 */ 0xff82ce7f
                ,  /* yellowClock    3 */ 0xfff2ba8c
                ,  /* dark           4 */ 0xff100C0B
                ,  /* marron         5 */ 0xff401310
                ,  /* topTextCol     6 */ 0xFF794b29
                ,  /* bottomTextCol  7 */ 0xff747272
                ,  /* bgColor        8 */ 0xFF181818 ];
    var arrDotMatrix: Array<DotMatrix>;
    var display:      Array<Character5x7>;
    // Kha2 example
    public static function main() {
        System.init({title: "Trilateral Dot Matrix test", width: 1024, height: 768, samplesPerPixel: 4 }, function(){ new Main(); } );
    }
    public function new() {
        var stageRadius = 570;
        drawPanels();
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1/30 );
    }
    function drawPanels(){
        var shapes = new Shapes( triangles, colors );
        var scale = 5.;
        var dw = 2*5*scale;
        var dh = 2*7*scale;
        arrDotMatrix = DotMatrix.display( "Trialateral Dot Matix test, using Kha.. What message would you like to send.. you can choose between pixel shapes; Circle, Square, Portrait, LandScape, Star, RoundedPortrait, RoundedLandScape.  You can have it scrolling the other way and scale it as it's all drawn with triangles      " );
        var dx = 100.;
        var dy = 50.;
        display = [];
        for( i in 0...10 ){
            var char = new Character5x7( shapes, Star, 1, 5, 4, Character5x7.GOLDEN_RATIO );
            char.dotMatrix = arrDotMatrix[ i ];
            char.draw( dx, dy, dw, dh, 0.8*scale, scale );
            display[ i ] = char;
            char.updateColor();
            dx += dw + 0.5*scale;
        }
    }
    public function update(): Void {
        DotMatrix.displayLeft( arrDotMatrix, 6 );
        for( i in 0...display.length ) {
            var char = display[ i ];
            char.updateColor();
        }
    }
    function render( framebuffer: Framebuffer ): Void {
        var g = framebuffer.g2;
        g.begin( 0xFF181818 );
        renderTriangles( g );
        g.end();
    }
    inline function renderTriangles( g: kha.graphics2.Graphics ){
        var tri: Triangle;
        if( triangles.length == 0 ) return;
        var triangles = triangles;
        var gameColors = colors;
        var s = 1;
        var ox = 1;
        var oy = 1;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            g.color = gameColors[ tri.colorID ];
            g.fillTriangle( ox + tri.ax * s, oy + tri.ay * s
                        ,   ox + tri.bx * s, oy + tri.by * s
                        ,   ox + tri.cx * s, oy + tri.cy * s );
        }
    }
}