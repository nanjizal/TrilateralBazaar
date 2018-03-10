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
import testTrilateral.TrilateralTest;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
class Main {
    // Kha2 example
    public static function main() {
        System.init({title: "TestTrilateral", width: 1024, height: 768, samplesPerPixel: 4 }, function(){ new Main(); } );
    }
    var trilateralTest: TrilateralTest;
    
    public function new() {
        var stageRadius = 570;
        trilateralTest =  new TrilateralTest( stageRadius );
        trilateralTest.setup();
        System.notifyOnRender( render );
    } 
    function render( framebuffer: Framebuffer ): Void {
        var g = framebuffer.g2;
        g.begin( 0xFF181818 );
        renderTriangles( g );
        g.end();
    }
    inline function renderTriangles( g: kha.graphics2.Graphics ){
        var tri: Triangle;
        var triangles = trilateralTest.triangles;
        var gameColors = trilateralTest.appColors;
        var s = 1;
        var ox = 1;
        var oy = 1;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            g.color = cast( gameColors[ tri.colorID ], kha.Color );
            g.fillTriangle( ox + tri.ax * s, oy + tri.ay * s
                        ,   ox + tri.bx * s, oy + tri.by * s
                        ,   ox + tri.cx * s, oy + tri.cy * s );
        }
        System.removeRenderListener( render );
    }
}