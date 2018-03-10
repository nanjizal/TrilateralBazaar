package testTrilateral;
import h2d.Graphics;
import hxd.Key in K;
import testTrilateral.TrilateralTest;
import trilateral.tri.Triangle;
class TestHeaps extends hxd.App {
        var g: h2d.Graphics; 
        var trilateralTest: TrilateralTest;
        public inline static var stageRadius: Int = 570;
        override function init() {
            g = new h2d.Graphics(s2d);
            trilateralTest =  new TrilateralTest( stageRadius );
            trilateralTest.setup();
            renderTriangles();
        }
        inline
        function renderTriangles(){
            var tri: Triangle;
            var s = 1.8;
            var ox = 20;
            var oy = 20;
            g.clear();
            var triangles = trilateralTest.triangles;
            var gameColors = trilateralTest.appColors;
            for( i in 0...triangles.length ){
                tri = triangles[ i ];
                trace( tri.ax + ' ' + tri.ay );
                g.beginFill( gameColors[ tri.colorID ] );
                g.lineTo( ox + tri.ax * s, oy + tri.ay * s );
                g.lineTo( ox + tri.bx * s, oy + tri.by * s );
                g.lineTo( ox + tri.cx * s, oy + tri.cy * s );
                g.endFill();
            }
        }
        static function main() {
            new TestHeaps();
        }
    }