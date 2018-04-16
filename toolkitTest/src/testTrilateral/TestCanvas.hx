package testTrilateral;
import js.Browser;
import htmlHelper.canvas.CanvasWrapper;
import js.html.CanvasRenderingContext2D;
import htmlHelper.tools.AnimateTimer; 
import justDrawing.Surface;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import testTrilateral.TrilateralTest;
import khaMath.Matrix4;
class TestCanvas {
    var surface:            Surface;
    var trilateralTest:     TrilateralTest;
    var stageRadius:        Float = 570;
    public static function main(){ new TestCanvas(); } public function new(){
        var canvas = new CanvasWrapper();
        canvas.width = 1024;
        canvas.height = 768;
        Browser.document.body.appendChild( cast canvas );
        surface = new Surface( canvas.getContext2d() );
        trilateralTest =  new TrilateralTest( stageRadius );
        trilateralTest.setup();
        render(0);
    }
    inline
    function render( i: Int ):Void{
        var tri: Triangle;
        var s = 1.;
        var ox = 0.;
        var oy = 0.;
        var g = surface;
        g.beginFill( 0x181818, 1. );
        g.lineStyle( 0., 0x000000, 0. );
        g.drawRect( 1, 1, 1024-2, 768-2 );
        g.endFill();
        var triangles = trilateralTest.triangles;
        var triangleColors = trilateralTest.appColors;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            if( tri.mark != 0 ){
                g.beginFill( triangleColors[ tri.mark ] );
            } else {
                g.beginFill( triangleColors[ tri.colorID ] );
                g.lineStyle( 0., triangleColors[ tri.colorID ], 1. );
            }
            g.drawTri( [   ox + tri.ax * s, oy + tri.ay * s
                        ,  ox + tri.bx * s, oy + tri.by * s
                        ,  ox + tri.cx * s, oy + tri.cy * s ] );
            g.endFill();
        }
    }
}