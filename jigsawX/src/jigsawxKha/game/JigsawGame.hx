package jigsawxKha.game;
import kha.Image;
import kha.Color;
import kha.graphics2.Graphics;   
//import kha.Assets;
import trilateralXtra.kDrawing.GridSheet;
import jigsawxKha.tileImage.JigsawShape;
import jigsawxKha.geom.Rotation;
import jigsawx.Jigsawx;
import jigsawx.JigsawPiece;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import trilateral.angle.Angles;
import jigsawxKha.game.Jig;
import jigsawxKha.tileImage.ImageTiles;
class JigsawGame {
    var enable          = true;
    var jigsawx:        Jigsawx;
    public var jigs     = new Array<Jig>();
    var imageTiles:     ImageTiles;
    var inputScale      = 4.;
    var outputScale     = 1.2;
    var canvasScale     = 1.;
    var showBoxes       = false;
    var gridDefFill:    GridSheetDef;
    var gridDefOutline: GridSheetDef;
    var gridFill:       GridSheet;
    var gridOutline:    GridSheet;
    var outLineEdge:    OutLineEdge;
    var wid             = 45;//45;//100;//45;
    var hi              = 45;//100;//45;
    var rows            = 6;//3;//6;
    var cols            = 8;//3;//8;
    var offX:           Float;
    var offY:           Float;
    var selected:       Jig;
    var selectedID:     Int;
    var topDepth        = 100;
    var jigsawShapeArray: Array<JigsawShape>;
    public function new(){
        init();
    }
    inline
    function init(){
        jigsawx       = new Jigsawx( wid, hi, rows, cols );
        createJigs();
        randomizePieces();
    }
    public function restart( image: Image ){
        init();
        start( image );
    }
    public function start( image: Image ){
        imageTiles = new ImageTiles( 4096, 4096 );
        imageTiles.draw( jigsawx.jigs, image, inputScale, canvasScale );
        jigsawShapeArray = imageTiles.jigsawShapeArray;
        outLineEdge = new OutLineEdge( this );
        setupImageGrid();
    }
    inline public
    function render( g: Graphics ){
        var fillImage = imageTiles.fillImage;
        //g.drawScaledImage( fillImage, 0, 0, fillImage.width, fillImage.height );
        //g.drawImage( imageTiles.outlineImage , 0, 0 );
        //gridOutline.renderGrid( g, cast outLineEdge, showBoxes );
        gridFill.renderGrid( g, cast this, showBoxes );
    }
    inline
    public function createJigs(){
        var jig: JigsawPiece;
        var jj = jigsawx.jigs;
        for( i in 0...jj.length ){
            jig = jj[ i ];
            jigs[ i ] = new Jig( jig.xy.x*outputScale, jig.xy.y*outputScale, i );
        }
    }
    inline
    function randomizePieces(){
        var left   = wid*cols + 10;
        var top    = hi*rows + 10;
        var xRange = 370.;
        var yRange = 250.;
        for( jig in jigs ){
            if( randomizeMost() ){
                jig.x = Math.random()*xRange + left;
                jig.y = Math.random()*yRange + top;
                jig.rotation = getRandomRotation();
            } else {
                jig.enabled = false;
            }
        }
    }
    inline
    function randomizeMost(): Bool {
        var factor = 4; // 1 in 5 ( as includes 0 ).
        return Std.int( Math.random() * factor ) != 0;
    }
    inline
    function getRandomRotation(): Float {
        return Math.random()*Math.PI*2 - Math.PI;
    }
    inline
    function getItem( col: Int, row: Int ): GridItemDef {
        var id  = row*cols + col;
        var jig = jigs[ id ];
        var color = Color.White;
        var depth = jig.depth;
        var redHighLight = Color.fromValue( 0xFFFEDDDD );
        var transform: FastMatrix3 = FastMatrix3.identity();
        var x = jig.x;
        var y = jig.y;
        var dx = x + wid*outputScale;
        var dy = y + hi*outputScale;
        var rotation = jig.rotation;
        if( rotation != 0 ) transform = Rotation.offsetRotation( rotation, dx, dy );
        if( jig == selected ){
            color = redHighLight;
            depth = topDepth++;
            jig.depth = topDepth;
        }
        var alpha = 0.8;
        if( jig.enabled == false ) {
            alpha = 1.;
            color = Color.White;
        }
        return {    x: x,       y: y
                ,   color:      color
                ,   alpha:      alpha
                ,   transform:  transform
                ,   depth:      depth };
    }
    inline public
    function updateRotations( theta: Float ){
        if( selected != null ){
            selected.rotation -= theta;
        }
    }
    public inline
    function hitTest( mousex: Float, mousey: Float ){
        var hits = [];  // collate all hitShapes
        var hitCount = 0;
        var jigsawShape: JigsawShape;
        var ox: Float;
        var oy: Float;
        var jig: Jig;
        var dx: Float;
        var dy: Float; 
        var pos: FastVector2;
        var cx: Float;
        var cy: Float;
        for( s in 0...jigsawShapeArray.length ){
            jigsawShape = jigsawShapeArray[ s ];
            ox = jigsawShape.x;
            oy = jigsawShape.y;
            jig = jigs[ s ];
            dx = mousex - jig.x + ox - ( outputScale - 1 ) * wid;
            dy = mousey - jig.y + oy - ( outputScale - 1 ) * hi;
            cx = ox + wid/2;
            cy = oy + hi/2;
            pos = transformedMouse( dx, dy, cx, cy, jig.rotation );
            for( t in jigsawShape.triangles ){
                if( t.fullHit( pos.x, pos.y ) ){                
                    hits[ hitCount ] = s;
                    hitCount++;
                    break;
                }
            }
        }
        return hits;
    }
    function transformedMouse( mousex: Float, mousey: Float
                             , centreX: Float, centreY: Float
                             , rotation: Float ): FastVector2 {
        var rotate    = FastMatrix3.rotation( rotation );
        var scale     = FastMatrix3.scale( 1/outputScale, 1/outputScale );
        var tran0     = FastMatrix3.translation( centreX, centreY );
        var tran1     = FastMatrix3.translation( -centreX, -centreY );
        var transform = tran0.multmat( scale ).multmat( rotate ).multmat( tran1 );                     
        var pos       = transform.multvec( new FastVector2( mousex, mousey ) );
        return pos;
    } 
    public
    function isInPlace( id: Int, jig: Jig ): Bool {
        var shape = jigsawShapeArray[ id ];
        var dist = distP( jig.x, jig.y, shape.x*outputScale, shape.y*outputScale );
        return ( dist < 40 );
    }
    public function getShapeXY( id: Int ):{ x: Float, y: Float } {
        var shape = jigsawShapeArray[ id ];
        return { x: shape.x, y: shape.y };
    }
    inline
    function setupImageGrid(){
        gridDefFill = { gridX:          wid*2,  gridY:     hi*2
                      , totalRows:      rows,  totalCols: cols
                      , scaleX:         outputScale,  scaleY: outputScale
                      , inputScale:     inputScale
                      , image:          imageTiles.fillImage  
                      }; // sets image
        gridDefOutline = { gridX:          wid*2,  gridY:     hi*2
                         , totalRows:       rows,  totalCols: cols
                         , scaleX:            1.,  scaleY:     1.
                         , inputScale:        1.
                         , image:             imageTiles.outlineImage
                         }; // sets image     
        gridFill = new GridSheet( gridDefFill );
        gridFill.dx = -wid/2 + 1; // 1 is because had to move jigsaw in one to stop it being strange.
        gridFill.dy = -hi/2 + 1;
        gridOutline = new GridSheet( gridDefOutline );
        gridOutline.dx = -wid/2 + 1; // 1 is because had to move jigsaw in one to stop it being strange.
        gridOutline.dy = -hi/2 + 1;
    }
    inline
    function sortByDistance( arr: Array<Int>, x: Float, y: Float ){
        var mx = x;
        var my = y;
        haxe.ds.ArraySort.sort( arr, function( a, b ): Int {
            var j = jigs[ a ];
            var k = jigs[ b ];
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
    inline
    function distP( px: Float, py: Float, x: Float, y: Float ): Float {
        return Math.pow( x - px, 2 ) + Math.pow( y - py, 2 );
    }
    inline public
    function selectCheck( x: Float, y: Float ){
        var arr = hitTest( x - wid/2, y - hi/2 );
        arr = arr.filter( function( i: Int ){ return jigs[ i ].enabled; });
        if( arr.length > 1 ) sortByDistance( arr, x - wid, y - hi );
        if( arr.length > 0 ) {
            selectedID = arr[ 0 ];
            var jig = jigs[ selectedID ];
            selected = jig;
            storeMouseOffset( x, y );
        }
    }
    inline public
    function storeMouseOffset( x: Float, y: Float ){
        offX = ( x - wid*outputScale ) - selected.x;
        offY = ( y - hi*outputScale  ) - selected.y; 
    }
    inline public
    function deselect(){
        selected = null;
        selectedID = null;
    }
    inline public
    function clampCorrect(){
        if( selected != null ){
            var id = selectedID;
            selected.rotation = Angles.pi2pi( selected.rotation ); // change angle to be between plus minus pi.
            if( selected.rotation < Math.PI/16 && selected.rotation > -Math.PI/16 ){
                if( isInPlace( id, selected ) ) {  
                    selected.rotation = 0;
                    selected.enabled = false;
                    var p = getShapeXY( id ); // set to final piece postion obtained from the item.
                    selected.x = p.x*outputScale;
                    selected.y = p.y*outputScale;
                }
            }
        }
    } 
    inline public
    function moveSelected( x: Int, y: Int ){
        if( selected != null ){
            selected.x = x - wid*outputScale - offX;
            selected.y = y - hi*outputScale - offY;
            offX = offX/1.025;// ease to hold piece in centre
            offY = offY/1.025;
        }
    }
}

// NEED TO REFACTOR THIS AS APPROACH NOT IDEAL!!
// Controls the outside edge of the piece
class OutLineEdge{
    // just pointers to props in main game
    var main: JigsawGame;
    public function new( main_: JigsawGame ){
        main = main_;
    }
    @:access( jigsawxKha.game.JigsawGame )
    inline
    function getItem( col: Int, row: Int ): GridItemDef {
        var id = row*main.cols + col;
        var jig = main.jigs[ id ];
        var color = Color.White;
        var depth = jig.depth;
        var redHighLight = Color.fromValue( 0xFFFEDDDD );
        var x = jig.x;
        var y = jig.y;
        var dx = x + main.wid;
        var dy = y + main.hi;
        var rotation = jig.rotation;
        var transform: FastMatrix3 = FastMatrix3.identity();
        if( rotation != 0 ) transform = Rotation.offsetRotation( rotation, dx, dy );
        if( jig == main.selected ){
            color = redHighLight;
            depth = main.topDepth++;
            jig.depth = main.topDepth;
        }
        var alpha = 0.8;
        if( jig.enabled == false ) {
            alpha = 1.;
            color = Color.fromValue( 0x00FFFFFF );
        }
        return {    x: x,       y: y
                ,   color:      color
                ,   alpha:      alpha
                ,   transform:  transform
                ,   depth:      depth };
    }
}

// Old render stuff...
//var blueBackTint = Color.fromValue( 0xFF5555FE );
//g.color = blueBackTint;
//g.drawImage( Assets.images.tablecloth, wid/2 + 1, hi/2 + 1 );
//grids.render( g, cast outLineEdge, cast here );
//gridOutline.renderGrid( g, cast outLineEdge, false );
//gridFill.renderGrid( g, cast this, false );
//g.drawImage( imgJigsaw, 0, 0 );
//g.drawImage( imgOutline, 0, 0 );