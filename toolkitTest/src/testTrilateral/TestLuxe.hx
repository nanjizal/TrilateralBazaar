package testTrilateral;
import luxe.Sprite;
import luxe.Color;
import phoenix.Batcher.PrimitiveType;
import phoenix.Vector;
import phoenix.geometry.Vertex;
import luxe.Input;
import luxe.Vector;
import lsystem.*;
import phoenix.geometry.Geometry;
import luxe.Color;
import testTrilateral.TrilateralTest;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import testTrilateral.TrilateralTest;
class TestLuxe extends luxe.Game {
    var trilateralTest:     TrilateralTest;
    var shape: Geometry;
    var stageRadius:        Float = 570;
    override function ready() {
        trilateralTest =  new TrilateralTest( stageRadius );
        trilateralTest.setup();
        renderToTriangles();
    }
    inline
    function renderToTriangles(){
        if( shape != null ) shape.drop();
        shape = new Geometry({
                primitive_type:PrimitiveType.triangles,
                batcher: Luxe.renderer.batcher
        });
        //shape.lock = true; ??
        var tri: Triangle;
        var color: Color;
        var s = 1.;
        var ox = 1.;
        var oy = 1.;
        var triangles = trilateralTest.triangles;
        var gameColors = trilateralTest.appColors;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            color =  new Color().rgb( cast gameColors[ tri.colorID ] );
            shape.add( new Vertex( new Vector( ox + tri.ax * s, oy + tri.ay * s ), color ) );
            shape.add( new Vertex( new Vector( ox + tri.bx * s, oy + tri.by * s ), color ) );
            shape.add( new Vertex( new Vector( ox + tri.cx * s, oy + tri.cy * s ), color ) );
        }
    }
    override function onkeyup( e:KeyEvent ) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    }
    override function config( config:luxe.GameConfig ) {
        config.window.width = 1024;
        config.window.height = 768;
        config.render.antialiasing = 4;
        return config;
    }
}