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
import hxPolyK.PolyK;
import trilateral.path.Fine;
import trilateral.tri.Triangle;
import trilateral.justPath.SvgPath;
import trilateral.tri.TriangleArray;
class Main {
    var appColors = [ Color.Red, Color.Blue, Color.Green, Color.Yellow, Color.Purple, Color.White, Color.Orange ];
    var triangles = new TriangleArray();
    // Kha2 example
    public static function main() {
        System.init({title: "Trilateral PolyK test", width: 1024, height: 768, samplesPerPixel: 4 }, function(){ new Main(); } );
    }
    public function new() {
        var stageRadius = 570;
        var poly = [ 93., 195., 129., 92., 280., 81., 402., 134., 477., 70., 619., 61., 759., 97., 758., 247., 662., 347., 665., 230., 721., 140., 607., 117., 472., 171., 580., 178., 603., 257., 605., 377., 690., 404., 787., 328., 786., 480., 617., 510., 611., 439., 544., 400., 529., 291., 509., 218., 400., 358., 489., 402., 425., 479., 268., 464., 341., 338., 393., 427., 373., 284., 429., 197., 301., 150., 296., 245., 252., 384., 118., 360., 190., 272., 244., 165., 81., 259., 40., 216.];
        fill( 100, poly, 6 );
        var d = "M 56.16 118.955 L 56.16 102.985 L 61.44 102.985 C 63.64 102.985 65.283 103.432 66.37 104.325 C 67.457 105.225 68 106.522 68 108.215 C 68 109.928 67.463 111.262 66.39 112.215 C 65.323 113.162 63.763 113.635 61.71 113.635 L 59.19 113.635 L 59.19 118.955 L 56.16 118.955 Z M 59.19 110.995 L 61.46 110.995 C 62.607 110.995 63.453 110.788 64 110.375 C 64.54 109.962 64.81 109.265 64.81 108.285 C 64.81 107.338 64.543 106.665 64.01 106.265 C 63.477 105.872 62.62 105.675 61.44 105.675 L 59.19 105.675 L 59.19 110.995 ZM 76.281 119.235 C 75.074 119.235 74.011 118.978 73.091 118.465 C 72.178 117.952 71.471 117.222 70.971 116.275 C 70.471 115.322 70.221 114.218 70.221 112.965 C 70.221 111.712 70.471 110.612 70.971 109.665 C 71.471 108.718 72.178 107.988 73.091 107.475 C 74.011 106.962 75.074 106.705 76.281 106.705 C 77.488 106.705 78.551 106.962 79.471 107.475 C 80.391 107.988 81.098 108.718 81.591 109.665 C 82.091 110.612 82.341 111.712 82.341 112.965 C 82.341 114.218 82.091 115.322 81.591 116.275 C 81.098 117.222 80.391 117.952 79.471 118.465 C 78.551 118.978 77.488 119.235 76.281 119.235 Z M 76.281 116.725 C 77.181 116.725 77.884 116.402 78.391 115.755 C 78.898 115.102 79.151 114.172 79.151 112.965 C 79.151 111.745 78.898 110.812 78.391 110.165 C 77.884 109.525 77.181 109.205 76.281 109.205 C 75.381 109.205 74.678 109.525 74.171 110.165 C 73.664 110.812 73.411 111.745 73.411 112.965 C 73.411 114.172 73.664 115.102 74.171 115.755 C 74.678 116.402 75.381 116.725 76.281 116.725 ZM 85.323 118.955 L 85.323 101.655 L 88.353 101.655 L 88.353 118.955 L 85.323 118.955 ZM 99.747 106.975 L 102.777 106.975 L 95.917 124.275 L 93.057 124.275 L 95.007 119.345 L 90.157 106.975 L 93.237 106.975 L 96.567 115.745 L 99.747 106.975 ZM 114.753 118.955 L 110.023 112.345 L 108.283 114.365 L 108.283 118.955 L 105.253 118.955 L 105.253 102.985 L 108.283 102.985 L 108.283 110.235 L 114.413 102.985 L 118.123 102.985 L 112.093 109.965 L 118.493 118.955 L 114.753 118.955 Z";
        var fine = new Fine();
        fine.width = 5;
        drawAndFill( fine, d );
        triangles.addArray( 50
                        ,   fine.trilateralArray
                        ,   5 );
        System.notifyOnRender( render );
    } 
    function drawAndFill( fine: Fine, d: String ){
        var svg = new SvgPath( fine );
        svg.parse( d, -10, -200, 6, 6 );
        var p = fine.points; 
        var l = p.length;
        var red = 0;
        var j = 0;
        for( i in 0...l ){
            if( p[ i ].length != 0 ){ // only try to fill empty arrays
                if( j == appColors.length - 2 ) j = 0;
                fill( i, p[ i ], j );
                j++;
            }
        }
    }
    function fill( id: Int, poly: Array<Float>, colorID: Int ){
        var tgs = PolyK.triangulate( poly ); 
        var triples = new ArrayTriple( tgs );
        var count = 0;
        for( tri in triples ){
            trace( 'count ' + count );
            var a: Int = Std.int( tri.a*2 );
            var b: Int = Std.int( tri.b*2 );
            var c: Int = Std.int( tri.c*2 );
            trace( poly[a] );
            trace( poly[b] );
            trace( poly[c] );
            trace( poly[a+1] );
            trace( poly[b+1] );
            trace( poly[c+1] );
            triangles.drawTriangle(  id, { x: poly[ a ], y: poly[ a + 1 ] }
                                      , { x: poly[ b ], y: poly[ b + 1 ] }
                                      , { x: poly[ c ], y: poly[ c + 1 ] }, colorID );
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
        var gameColors = appColors;
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