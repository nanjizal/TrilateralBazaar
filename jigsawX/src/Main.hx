package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import kha.Color;
import kha.Assets;
import trilateralXtra.kDrawing.GridSheet;
import jigsawxKha.JigsawImageBuilder;
import jigsawx.Jigsawx;
import jigsawx.JigsawPiece;
import kha.math.FastMatrix3;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
class Main {
    var once            = true; // only render the first time after loading.
    var jigsawx:        Jigsawx;
    var imgJigsaw:      Image;
    var imgOutline:     Image;
    var jigsawBuilder:  JigsawImageBuilder;
    var gridDef:        GridSheetDef;
    var gridDefOutline: GridSheetDef;
    var gridSheet:        GridSheet;
    var gridSheetOutline: GridSheet;
    var outLineEdge:    OutLineEdge;
    var wid             = 45;
    var hi              = 45;
    var rows            = 6;
    var cols            = 8;
    var offX:           Float;
    var offY:           Float;
    var mouseIsDown:    Bool = false;
    var selected:       JigsawPiece;
    public var depths          = new Array<Int>();
    var topDepth        = 100;
    public static 
    function main() {
        System.init( {  title: "JigsawX Trilateral Kha example"
                     ,  width: 1024, height: 768
                     ,  samplesPerPixel: 4 }
                     , function(){
                        new Main();
                     } );
    }
    public function new(){
        jigsawx       = new Jigsawx( wid, hi, rows, cols );
        jigsawBuilder = new JigsawImageBuilder( jigsawx.jigs );
        Assets.loadEverything( loadAll );
    }
    public function loadAll(){
        trace( 'loadAll' );
        drawJigsawImage();
        outLineEdge = new OutLineEdge( this );
        initDepths();
        setupImageGrid();
        startRendering();
        initInputs();
    }
    inline
    function initDepths(){
        for( i in 0...rows*cols ){ depths[i] = i; }
    }
    inline
    function setupImageGrid(){
        // piece size is 45 ( or 90? )
        gridDef = { gridX:          wid*2,  gridY:     hi*2
                  , totalRows:       rows,  totalCols: cols
                  , scaleX:            1.,  scaleY:      1.
                  , image:       imgJigsaw  
                  }; // sets image
        gridDefOutline = { gridX:          wid*2,  gridY:     hi*2
                         , totalRows:       rows,  totalCols: cols
                         , scaleX:            1.,  scaleY:      1.
                         , image:      imgOutline
                         }; // sets image     
        gridSheet = new GridSheet( cast gridDef );
        gridSheet.dx = -wid/2 + 1; // 1 is because had to move jigsaw in one to stop it being strange.
        gridSheet.dy = -hi/2 + 1;
        gridSheetOutline = new GridSheet( cast gridDefOutline );
        gridSheetOutline.dx = -wid/2 + 1; // 1 is because had to move jigsaw in one to stop it being strange.
        gridSheetOutline.dy = -hi/2 + 1;
    }
    inline
    function drawJigsawImage(){
        jigsawBuilder.drawMask();
        jigsawBuilder.drawOutline();
        imgJigsaw = jigsawBuilder.renderJigsaw( Assets.images.tablecloth );
        imgOutline = jigsawBuilder.renderJigsawOutline();
        randomizePieces();
    }
    inline
    function randomizePieces(){
        var factor = 4; // 1 in 5 ( as includes 0 ).
        var left = 320.;
        var top = 265.;
        var xRange = 370.;
        var yRange = 250.;
        var randomizeMost: Bool; 
        for( jig in jigsawx.jigs ){
            randomizeMost = Std.int( Math.random() * factor ) != 0;
            if( randomizeMost ){
                jig.xy.x = Math.random()*xRange + left;
                jig.xy.y = Math.random()*yRange + top;
            } else {
                jig.enabled = false;
            }
        }
    }
    inline
    function startRendering(){
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    inline
    function render( framebuffer: Framebuffer ): Void {
        var g = framebuffer.g2;
        g.begin();
        var blueBackTint = Color.fromValue( 0xFF5555FE );
        g.color = blueBackTint;
        g.drawImage( Assets.images.tablecloth, wid/2 + 1, hi/2 + 1 );
        gridSheetOutline.renderGrid( g, cast outLineEdge, false );
        gridSheet.renderGrid( g, cast this, false );
        //g.drawImage( imgJigsaw, 0, 0 );
        //g.drawImage( imgOutline, 0, 0 );
        g.end();
    }
    inline
    function getItem( col: Int, row: Int ): GridItemDef {
        var id = row*cols + col;
        var jig = jigsawx.jigs[ id ];
        var color = Color.White;
        var depth = depths[ id ];
        var redHighLight = Color.fromValue( 0xFFFEDDDD );
        if( jig == selected ){
            color = redHighLight;
            depth = topDepth++;
            depths[ id ] = topDepth;
        }
        var alpha = 0.8;
        if( jig.enabled == false ) {
            alpha = 1.;
            color = Color.White;
        }
        var x = jig.xy.x;
        var y = jig.xy.y;
        return {    x: x
                ,   y: y
                ,   color: color
                ,   alpha: alpha
                ,   transform: FastMatrix3.identity()
                ,   depth: depth };
    }
    function initInputs() {
        if (Mouse.get() != null) Mouse.get().notify( mouseDown, mouseUp, mouseMove, null );
    }
    inline
    function sortByDistance( arr: Array<Int>, x: Float, y: Float ){
        var mx = x;
        var my = y;
        var jigs = jigsawx.jigs;
        haxe.ds.ArraySort.sort( arr, function( a, b ): Int {
            var j = jigs[ a ].xy;
            var k = jigs[ b ].xy;
            var distA = distP( mx, my, j.x, j.y );
            var distB = distP( mx, my, k.x, k.y );
            if( distA < distB ){
                return -1;
            } else if ( distA > distB ){ 
                return 1;
            } else {
                return 0;
            }
        });
    }
    inline function distP( px: Float, py: Float, x: Float, y: Float ): Float {
        return Math.pow( x - px, 2 ) + Math.pow( y - py, 2 );
    }
    function mouseDown( button: Int, x: Int, y: Int ): Void {
        var arr = jigsawBuilder.hitTest( x - wid/2, y - hi/2 );
        var jigs = jigsawx.jigs;
        arr = arr.filter( function( i: Int ){ return jigs[ i ].enabled; });
        if( arr.length > 1 ) sortByDistance( arr, x - wid, y - hi );
        if( arr.length > 0 ) {
            var jig = jigs[ arr[ 0 ] ];
            selected = jig;
            var xy = jig.xy;
            offX = ( x - wid ) - xy.x;
            offY = ( y - hi  ) - xy.y; 
        }
        //trace('down');
        mouseIsDown = true;
    }
    function mouseUp( button: Int, x: Int, y: Int ): Void {
        //trace('up');
        mouseIsDown = false;
        if( selected != null ){
            var id = getIdofSelected();
            if( jigsawBuilder.isInPlace( id, selected ) ) {
                selected.enabled = false;
                var p = jigsawBuilder.getShapeXY( id ); // set to final piece postion obtained from the item.
                selected.xy.x = p.x;
                selected.xy.y = p.y;
            }
        }
        selected = null;
    }
    inline
    function getIdofSelected(): Int {
        var id = 0;
        var jigs = jigsawx.jigs;
        for( i in 0...jigs.length ){
            if( jigs[i] == selected ){
                id = i;
                break;
            }
        }
        return id;
    }
    function mouseMove( x: Int, y: Int, movementX: Int, movementY: Int ): Void {
        if( mouseIsDown == false ) return;
        //trace('Move');
        for( j in jigsawx.jigs ){
            if( j == selected ){
                var xy = j.xy;
                xy.x = x - wid - offX;
                xy.y = y - hi - offY;
            }
        }
        offX = offX/1.025;// ease to hold piece in centre
        offY = offY/1.025;
    }
}

class OutLineEdge{
    // just pointers to props in main
    var main: Main;
    public function new( main_: Main ){
        main = main_;
    }
    @:access( Main )
    inline
    function getItem( col: Int, row: Int ): GridItemDef {
        var id = row*main.cols + col;
        var jig = main.jigsawx.jigs[ id ];
        var color = Color.White;
        var depth = main.depths[ id ];
        var redHighLight = Color.fromValue( 0xFFFEDDDD );
        if( jig == main.selected ){
            color = redHighLight;
            depth = main.topDepth++;
            main.depths[ id ] = main.topDepth;
        }
        var alpha = 0.8;
        if( jig.enabled == false ) {
            alpha = 1.;
            color = Color.fromValue( 0x00FFFFFF );
        }
        var x = jig.xy.x;
        var y = jig.xy.y;
        return {    x: x
                ,   y: y
                ,   color: color
                ,   alpha: alpha
                ,   transform: FastMatrix3.identity()
                ,   depth: depth };
    }

}