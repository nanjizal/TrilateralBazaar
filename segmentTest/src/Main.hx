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
import hxPolyK.PolyK; // used for iterating triangle simply ( lazy ;) )
import org.poly2tri.VisiblePolygon;
import trilateral.path.Fine;
import trilateral.path.Crude;
import trilateral.path.FillOnly;
import trilateral.tri.Triangle;
import trilateral.justPath.SvgPath;
import trilateral.tri.TriangleArray;
import trilateral.segment.SixteenSeg;
import trilateral.segment.SevenSeg;
import trilateral.geom.Algebra;
import Shapes;
import Metrophobic;
class Main {
    var appColors = [ Color.Red, Color.Blue, Color.Green, Color.Yellow, Color.Purple, Color.White, Color.Orange ];
    var triangles = new TriangleArray();
    var dy: Float = 100;// appox height between Segments
    var wSpacing: Array<Float> = [ 14., 102., 14., 62., 22., 129., 32., 62., 20., 62., 14. ];
    var w2Spacing: Array<Float> = [ 18., 82., 33., 51., 60., 59., 71., 60., 28., 51. ];
    var bgClock: Int = 0xff312923;
    var orangeClock: Int = 0xffd643e;
    var limeClock: Int = 0xff82ce7f;
    var yellowClock: Int = 0xfff2ba8c;
    var dark: Int = 0xff100C0B;
    var marron: Int = 0xff401310;
    var topTextCol: Int = 0xFF794b29;
    var bottomTextCol: Int = 0xff747272;
    var hSpacing:   Array<Float> = [ 9, 13, 4, 42, 6, 13, 6 ];
    var botTopWid:  Float = 200;
    var botMidWid:  Float = 170;
    var botBotWid:  Float = 241;
    var panelWid:   Float = 540;
    var panelHi:    Float = 298;
    var colors = [ /* bgClock        0 */ 0xff312923
                ,  /* orangeClock    1 */ 0xffe4563c
                ,  /* limeClock      2 */ 0xff82ce7f
                ,  /* yellowClock    3 */ 0xfff2ba8c
                ,  /* dark           4 */ 0xff100C0B
                ,  /* marron         5 */ 0xff401310
                ,  /* topTextCol     6 */ 0xFF794b29
                ,  /* bottomTextCol  7 */ 0xff747272 ];
    // Kha2 example
    public static function main() {
        System.init({title: "Trilateral Segment test", width: 1024, height: 768, samplesPerPixel: 4 }, function(){ new Main(); } );
    }
    public function new() {
        var stageRadius = 570;
        drawPanels( 100., 100. );
        System.notifyOnRender( render );
    }
    function addSixteenString( txt: String, x: Float, y: Float, colorID: Int ){
        var sixteen = new SixteenSeg( 20, 30 );
        sixteen.add( txt, x, y );
        triangles.addArray( count++
                        ,   sixteen.triArr
                        ,   colorID );
    }
    function addSevenString( txt: String, x: Float, y: Float, colorID: Int ){
        var seven = new SevenSeg( 20, 30 );
        seven.addString( txt, x, y );
        triangles.addArray( count++
                        ,   seven.triArr
                        ,   colorID );
    }
    function addSixteenNumber( no: Int, x: Float, y: Float, colorID: Int ){
        var sixteen = new SixteenSeg( 20, 30 );
        sixteen.addNumber( no, x, y );
        triangles.addArray( count++
                        ,   sixteen.triArr
                        ,   colorID );
    }
    function addSevenNumber( no: Int, x: Float, y: Float, colorID: Int ){
        var seven = new SevenSeg( 20, 30 );
        seven.addNumber( no, x, y );
        triangles.addArray( count++
                        ,   seven.triArr
                        ,   colorID );
    }
    function drawPanels( x: Float, y: Float ){
        // For small text we don't need accuracy so we can use straight lines...
        Algebra.quadStep = 10;
        Algebra.cubicStep = 10;
        var svgText  = [ Metrophobic.destinationTime()
                    ,    Metrophobic.presentTime()
                    ,    Metrophobic.lastTimeDeparted() ];
        var svgText2 = [ Metrophobic.month()
                    ,    Metrophobic.day()
                    ,    Metrophobic.year()
                    ,    Metrophobic.hour()
                    ,    Metrophobic.min() ];
        var shapes = new Shapes( triangles, colors );
        shapes.rectangle( x - 3, y - 3, panelWid + 6, panelHi + 6, 4 );
        shapes.rectangle( x, y, panelWid, panelHi, 0 );
        var dx: Float = x;
        var dy: Float = y + hSpacing[0] + hSpacing[1];
        var px: Float = dx;
        var py: Float = hSpacing[0] + dy;
        var months = ['OCT','NOV','OCT'];
        var day = [ 21, 12, 26 ];
        var ledCol = [ 1, 2 , 3 ];
        var year = [ 2015, 1955, 1985 ];
        var hour = [ '04','06','01' ];
        var min = [ '30','00','21'];
        var field = 0;
        for( i in 0...wSpacing.length ){
            px += wSpacing[ i ];
            if( ( i  )%2 == 0 ){
                for( j in 0...3 ){
                    // draw the LED backgrounds and numbers
                    shapes.rectangle( px , py + j*100, wSpacing[ i+1 ], hSpacing[3], 4  );
                    if( field == 0 ) addSixteenString( months[j], px + 15, py + j*100 + 6, ledCol[j] );
                    if( field == 1 ) addSevenNumber( day[j], px + 10, py + j*100 + 6, ledCol[j] );
                    if( field == 2 ) addSevenNumber( year[j], px + 10, py + j*100 + 6, ledCol[j] );
                    if( field == 3 ) addSevenString( hour[j], px + 10, py + j*100 + 6, ledCol[j] );
                    if( field == 4 ) addSevenString( min[j], px + 10, py + j*100 + 6, ledCol[j] );
                }
                field++;
            }
        }
        py = y + hSpacing[0];
        px = dx;
        field = 0;
        for( i in 0...w2Spacing.length ){
            px += w2Spacing[ i ];
            if( ( i  )%2 == 0 ){
                for( j in 0...3 ){
                    // draw top backgrounds and text
                    shapes.rectangle( px , py + j*100, w2Spacing[ i+1 ], hSpacing[1], 5  );
                    renderD( svgText2[field], px +  w2Spacing[ i+1 ]*.25, py + j*100 + 3, 0.22, 7 );
                }
                field++;
            }
        }
        var pxs = [ botTopWid, botMidWid, botBotWid ];
        var k= 0;
        dy = y + hSpacing[0] + hSpacing[1]+ hSpacing[2] + hSpacing[3] + hSpacing[4] + 5;
        for( d in svgText ){
            // draw labels below the LED
            shapes.rectangle( x + ( panelWid - pxs[k] )/2 , dy + k*100, pxs[k], hSpacing[5], 4 );
            renderD( d, x + ( panelWid - pxs[k]*0.5 )/2 , dy + k*100 + 2, 0.25, 7 );
            k++;
        }
        trace( triangles.length );
    }

    var count: Int = 0;
    public function renderD( d: String, x: Float, y: Float, scaleText: Float, colorID: Int ){
        var fine = new Crude();
        fine.width = 1;
        var p = new SvgPath( fine );
        p.parse( d, x, y, scaleText, scaleText );
        //fillPolyK( 50, fine.points, 5 );
        triangles.addArray( count++
                        ,   fine.trilateralArray
                        ,   colorID );

    }

    public function fillPolyK( id: Int, p: Array<Array<Float>>, colorID: Int ){
        var l = p.length;
        var j = 0;
        for( i in 0...l ){
            if( p[ i ].length != 0 ){ // only try to fill empty arrays
                if( j == appColors.length - 2 ) j = 0;
                fillK( i, p[ i ], j );
                j++;
            }
        }
    }
    public function fillK( id: Int, poly: Array<Float>, colorID: Int ){
        var tgs = PolyK.triangulate( poly ); 
        var triples = new ArrayTriple( tgs );
        var count = 0;
        for( tri in triples ){
            var a: Int = Std.int( tri.a*2 );
            var b: Int = Std.int( tri.b*2 );
            var c: Int = Std.int( tri.c*2 );
            triangles.drawTriangle(  id, { x: poly[ a ], y: poly[ a + 1 ] }
                                      , { x: poly[ b ], y: poly[ b + 1 ] }
                                      , { x: poly[ c ], y: poly[ c + 1 ] }, colorID );
        }
    }
    
    public function fillPoly2trihx( id: Int, points: Array<Array<Float>>, colorID: Int ){
        var vp = new VisiblePolygon();
        var l = points.length;
        var p: Array<Float>;
        for( i in 0...l ){
            p = points[ i ];
            if( p.length != 0 ) {
                var p2t: Array<org.poly2tri.Point> = [];
                var pairs = new ArrayPairs<Float>( p );
                var p0 = pairs[0].x;
                var p1 = pairs[0].y;
                for( pair in pairs ) p2t.push( new org.poly2tri.Point( pair.x, pair.y ) );
                var l2 = p2t.length;
                if( p0 == p2t[ l2 - 1 ].x && p1 == p2t[ l2 - 1 ].y ){
                    p2t.pop();
                }
                vp.addPolyline( p2t );
            }
        }
        vp.performTriangulationOnce();
        var pt = vp.getVerticesAndTriangles();
        var tri = pt.triangles;
        var vert = pt.vertices;
        var triples = new ArrayTriple( tri );
        var i: Int;
        for( tri in triples ){
            var a: Int = Std.int( tri.a*3 );
            var b: Int = Std.int( tri.b*3 );
            var c: Int = Std.int( tri.c*3 );
            triangles.drawTriangle(  id, { x: vert[ a ], y: vert[ a + 1 ] }
                                       , { x: vert[ b ], y: vert[ b + 1 ] }
                                       , { x: vert[ c ], y: vert[ c + 1 ] }, colorID );
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
        System.removeRenderListener( render );
    }
}