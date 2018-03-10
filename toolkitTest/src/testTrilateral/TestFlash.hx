package testTrilateral;
import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.display.Graphics;
import flash.Vector;
import testTrilateral.TrilateralTest;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
class TestFlash extends Sprite{ 
    var trilateralTest:     TrilateralTest;
    var g:                  Graphics;
    var viewSprite:         Sprite;
    var stageRadius:        Float = 570;
    public static function main(): Void { Lib.current.addChild( new TestFlash() ); }
    public function new(){
        super();
        viewSprite = new Sprite();
        g = viewSprite.graphics;
        addChild( viewSprite );
        trilateralTest =  new TrilateralTest( stageRadius );
        trilateralTest.setup();
        renderTriangles();
    }
    inline 
    function renderTriangles(){ 
        var triangles = trilateralTest.triangles;
        var gameColors = trilateralTest.appColors;
        var tri: Triangle;
        var s = 1.;
        var ox = -1.;
        var oy = 1.;
        g.clear();
        for( i in 0...triangles.length ){// for NME use setTriangle for more speed.
            tri = triangles[ i ];
            #if openfl 
            g.lineStyle( 0, gameColors[ tri.colorID ], 1 );
            #end
            g.moveTo( ox + tri.ax * s, oy + tri.ay * s );
            g.beginFill( gameColors[ tri.colorID ] );
            g.lineTo( ox + tri.ax * s, oy + tri.ay * s );
            g.lineTo( ox + tri.bx * s, oy + tri.by * s );
            g.lineTo( ox + tri.cx * s, oy + tri.cy * s );
            g.endFill();
        }
    }
}