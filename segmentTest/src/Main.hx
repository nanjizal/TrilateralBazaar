package;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.Assets;
import kha.Font;
import kha.Image;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import kha.graphics4.DepthStencilFormat;
import trilateral.path.Fine;
import trilateral.path.Crude;
import trilateral.path.FillOnly;
import trilateral.tri.Triangle;
import trilateral.justPath.SvgPath;
import trilateral.tri.TriangleArray;
import trilateralXtra.segment.SixteenSeg;
import trilateralXtra.segment.SevenSeg;
import trilateralXtra.segment.SevenSegColor;
import trilateralXtra.segment.SixteenSegColor;
import trilateral.geom.Algebra;
import trilateral.justPath.transform.ScaleContext;
import trilateral.justPath.transform.ScaleTranslateContext;
import trilateral.justPath.transform.TranslationContext;
import trilateral.polys.Shapes;
import Metrophobic;
class Main {
    var triangles       = new TriangleArray();
    var background: Image;
    var dy:             Float = 100;// appox height between Segments
    var wSpacing:       Array<Float> = [ 14., 102., 14., 62., 22., 129., 32., 62., 20., 62., 14. ];
    var w2Spacing:      Array<Float> = [ 18., 82., 33., 51., 60., 59., 71., 60., 28., 51. ];
    var bgClock:        Int = 0xff312923;
    var orangeClock:    Int = 0xffd643e;
    var limeClock:      Int = 0xff82ce7f;
    var yellowClock:    Int = 0xfff2ba8c;
    var dark:           Int = 0xff100C0B;
    var marron:         Int = 0xff401310;
    var topTextCol:     Int = 0xFF794b29;
    var bottomTextCol:  Int = 0xff747272;
    var hSpacing:       Array<Float> = [ 9, 13, 4, 42, 6, 13, 6 ];
    var botTopWid:      Float = 200;
    var botMidWid:      Float = 170;
    var botBotWid:      Float = 241;
    var panelWid:       Float = 540;
    var panelHi:        Float = 298;
    var months = ['OCT','NOV','OCT'];
    var day = [ '21', '12', '26' ];
    var ledCol = [ 1, 2 , 3 ];
    var year = [ 2015, 1955, 1985 ];
    var hour = [ '04','06','01' ];
    var min = [ '30','00','21'];
    var monthNames = [ 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN','JUL','AUG','SEP','OCT','NOV','DEC' ];
    // feb 29 but detail
    var daysMonth = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
    var sevenArr =      new Array<SevenSegColor>();
    var sixteenArr =    new Array<SixteenSegColor>();
    var colors = [ /* bgClock        0 */ 0xff312923
                ,  /* orangeClock    1 */ 0xffe4563c
                ,  /* limeClock      2 */ 0xff82ce7f
                ,  /* yellowClock    3 */ 0xfff2ba8c
                ,  /* dark           4 */ 0xff100C0B
                ,  /* marron         5 */ 0xff401310
                ,  /* topTextCol     6 */ 0xFF794b29
                ,  /* bottomTextCol  7 */ 0xff747272
                ,  /* marron dark    8 */ 0xcc401310 ];
    // Kha2 example
    public static function main() {
        System.init({title: "Trilateral Segment test", width: 1024, height: 768, samplesPerPixel: 4 }, function(){ new Main(); } );
    }
    public function new() {
        drawBackgroundToImage();
        triangles = new TriangleArray(); // clear background triangles.
        drawDigits( 100., 100. );
        System.notifyOnRender( render );
        Scheduler.addTimeTask( function () { updatePresentTime(); }, 0, 1 / 60 );
    }
    function drawBackgroundToImage(){
        drawPanels( 100., 100. );
        background = Image.createRenderTarget( 1024, 768, null, DepthStencilFormat.NoDepthAndStencil, 4 );
        var g2 = background.g2;
        g2.begin( 0xFF181818 );
        renderTriangles( g2 );
        g2.end();
    }
    var speed = 0.1;
    public function updatePresentTime(){
        speed += 0.1;
        speed *= 1.0001;
        // You can adjust the middle row animation here, you can get it to act more like a clock as per nested structure.
        if( sevenArr.length > 1 ){// &&  year[1] < 2015 ){
            /*if( speed < 60 ){
                if( updateMin() ){
                    if(updateHour()){
                        if(updateDay()){
                            if( updateMonth() ) updateYear();
                        }
                    }
                }
            } else {*/
                if( updateMin() ){
                     if(updateHour() ) updateYear();
                     updateDay();
                     updateMonth();
                }
            //}
        }
        /*if( year[1] == 2015 ){
            setPresentToDestination();
        }*/
    }
    function setPresentToDestination(){
        sevenArr[ 10 ].changeString( min[  0 ] );
        sevenArr[ 7  ].changeString( hour[ 0 ] );
        sevenArr[ 1  ].changeString( day[  0 ] );
    }
    function updateMin():Bool{
        var rollover: Bool = false;
        var m = Std.parseInt( min[ 1 ] );
        if( speed < 60 ){
             m+= Math.round( speed );
        } else {
            m+=1;
        }
        if( m > 60 ) {
            m = 60 - m;
            rollover = true;
        }
        if( m < 10 ){
            min[ 1 ] = '0' + Std.string( m );
        } else {
            min[ 1 ] = Std.string( m );
        }
        sevenArr[ 10 ].changeString( min[ 1 ] );
        return rollover;
    }
    function updateHour():Bool{
        var rollover: Bool = false;
        var h = Std.parseInt( hour[ 1 ] ) + 1;
        if( h > 12 ){ 
            h = 0;
            rollover = true;
        }
        if( h < 10 ){
            hour[ 1 ] = '0' + Std.string( h );
        } else {
            hour[ 1 ] = Std.string( h );
        }
        sevenArr[ 7 ].changeString( hour[ 1 ] );
        return rollover;
    }
    function updateDay():Bool {
        var rollover: Bool = false;
        var noDays = daysMonth[ monthNames.indexOf( months[1] ) ];
        var d = Std.parseInt( day[ 1 ] ) + 1;
        if( d > noDays ) {
            d = 1;
            rollover = true;
        }
        if( d < 10 ){
            day[ 1 ] = '0' + Std.string( d );
        } else {
            day[ 1 ] = Std.string( d );
        }
        sevenArr[ 1 ].changeString( day[ 1 ] );
        return rollover;
    }
    function updateMonth(){
        var rollover: Bool = false;
        var noMonth = monthNames.indexOf( months[1] );
        var m = noMonth + 1;
        if( m > monthNames.length - 1 ) {
            m = 1;
            rollover = true;
        }
        months[ 1 ] = monthNames[ m ];
        sixteenArr[ 1 ].changeString( months[ 1 ] );
        return rollover;
    }
    function updateYear(){
        var y = year[ 1 ] + 1;
        year[ 1 ] = y;
        sevenArr[ 4 ].changeNumber( year[ 1 ] );
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
        var field = 0;
        for( i in 0...wSpacing.length ){
            px += wSpacing[ i ];
            if( ( i  )%2 == 0 ){ // draw the LED backgrounds
                for( j in 0...3 ) shapes.rectangle( px , py + j*100, wSpacing[ i + 1 ], hSpacing[ 3 ], 4  );
                field++;
            }
        }
        py = y + hSpacing[0];
        px = dx;
        field = 0;
        for( i in 0...w2Spacing.length ){
            px += w2Spacing[ i ];
            if( ( i  )%2 == 0 ){
                for( j in 0...3 ){ // draw top backgrounds and text
                    shapes.rectangle( px , py + j*100, w2Spacing[ i+1 ], hSpacing[1], 5  );
                    renderD( svgText2[field], px +  w2Spacing[ i+1 ]*.25, py + j*100 + 3, 0.22, 7 );
                }
                field++;
            }
        }
        var pxs = [ botTopWid, botMidWid, botBotWid ];
        var k= 0;
        dy = y + hSpacing[0] + hSpacing[1]+ hSpacing[2] + hSpacing[3] + hSpacing[4] + 5;
        for( d in svgText ){ // draw labels below the LED
            shapes.rectangle( x + ( panelWid - pxs[k] )/2 , dy + k*100, pxs[k], hSpacing[5], 4 );
            renderD( d, x + ( panelWid - pxs[k]*0.5 )/2 , dy + k*100 + 2, 0.25, 7 );
            k++;
        }
        trace( 'triangles used for background ' + triangles.length );
    }
    function drawDigits( x: Float, y: Float ){
        var shapes = new Shapes( triangles, colors );
        var dx: Float = x;
        var dy: Float = y + hSpacing[0] + hSpacing[1];
        var px: Float = dx;
        var py: Float = hSpacing[0] + dy;
        var field = 0;
        for( i in 0...wSpacing.length ){
            px += wSpacing[ i ];
            if( ( i  )%2 == 0 ){
                for( j in 0...3 ){
                    // draw the LED backgrounds and numbers
                    if( field == 0 ) sixteenArr.push( addSixteenString( months[ j ], px + 15, py + j*100 + 6, ledCol[ j ], 8 ) );
                    if( field == 1 ) sevenArr.push(   addSevenString(   day[ j ],    px + 10, py + j*100 + 6, ledCol[ j ], 8 ) );
                    if( field == 2 ) sevenArr.push(   addSevenNumber(   year[ j ],   px + 10, py + j*100 + 6, ledCol[ j ], 8 ) );
                    if( field == 3 ) sevenArr.push(   addSevenString(   hour[ j ],   px + 10, py + j*100 + 6, ledCol[ j ], 8 ) );
                    if( field == 4 ) sevenArr.push(   addSevenString(   min[ j ],    px + 10, py + j*100 + 6, ledCol[ j ], 8 ) );
                }
                field++;
            }
        }
        trace( 'triangles used for foreground ' + triangles.length );
    }
    var count: Int = 0;
    public function renderD( d: String, x: Float, y: Float, scaleText: Float, colorID: Int ){
        var fine = new Crude();
        fine.width = 1;
        var scaleTranslateContext = new ScaleTranslateContext( fine, x, y, scaleText, scaleText );
        var p = new SvgPath( scaleTranslateContext );
        p.parse( d );
        //fillPolyK( 50, fine.points, 5 ); // fill not really needed.
        triangles.addArray( count++
                        ,   fine.trilateralArray
                        ,   colorID );

    }
    var firstTime = true;
    function render( framebuffer: Framebuffer ): Void {
        var g = framebuffer.g2;
        if( firstTime ){
            g.begin( 0xFF181818 );
            g.color = Color.White;  // This line is essential!
            g.drawImage( background, 0, 0 );
            g.end();
            firstTime = false;
        }
        g.begin( false, Color.Transparent );
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
    function addSixteenString( txt: String, x: Float, y: Float, lightID: Int, darkID: Int ){
        var sixteen = new SixteenSegColor( 20, 30, lightID, darkID, triangles );
        sixteen.add( txt, x, y );
        return sixteen;
    }
    function addSevenString( txt: String, x: Float, y: Float, lightID: Int, darkID: Int ): SevenSegColor {
        var seven = new SevenSegColor( 20, 30, lightID, darkID, triangles );
        seven.addString( txt, x, y );
        return seven;
    }
    function addSixteenNumber( no: Int, x: Float, y: Float, lightID: Int, darkID: Int ){
        var sixteen = new SixteenSegColor( 20, 30, lightID, darkID, triangles );
        sixteen.addNumber( no, x, y );
        return sixteen;
    }
    function addSevenNumber( no: Int, x: Float, y: Float, lightID: Int, darkID: Int ): SevenSegColor {
        var seven = new SevenSegColor( 20, 30, lightID, darkID, triangles );
        seven.addNumber( no, x, y );
        return seven;
    }
}