package jigsawxKha.gridSheets;
import kha.graphics2.Graphics;
import trilateralXtra.kDrawing.GridSheet;
import kha.Image;
class GridSheetRenderer {
    public var gridFill:    GridSheet;
    public var gridOutline: GridSheet;
    var hi: Float;
    var wid: Float;
    var rows: Int;
    var cols: Int;
    var fillImage: Image;
    var outlineImage: Image;
    public function new( wid_: Float, hi_: Float, rows_: Int, cols_: Int, fillImage_: Image, outlineImage_: Image ){
        wid  = wid_;
        hi   = hi_;
        rows = rows_;
        cols = cols_;
        fillImage = fillImage_;
        outlineImage = outlineImage_;
        setupImageGrid();
    }
    inline
    function setupImageGrid(){
        // piece size is 45 ( or 90? )
        var fillDef: GridSheetDef =   { gridX:          wid*2,  gridY:     hi*2
                                      , totalRows:       rows,  totalCols: cols
                                      , scaleX:            1.,  scaleY:      1.
                                      , image:       fillImage  
                                      }; // sets image
        var outlineDef: GridSheetDef = { gridX:          wid*2,  gridY:     hi*2
                                       , totalRows:       rows,  totalCols: cols
                                       , scaleX:            1.,  scaleY:      1.
                                       , image:      outlineImage
                                       }; // sets image     
        gridFill = new GridSheet( fillDef );
        gridFill.dx = -wid/2 + 1; // 1 is because had to move jigsaw in one to stop it being strange.
        gridFill.dy = -hi/2 + 1;
        gridOutline = new GridSheet( outlineDef );
        gridOutline.dx = -wid/2 + 1; // 1 is because had to move jigsaw in one to stop it being strange.
        gridOutline.dy = -hi/2 + 1;
    }
    
    public function render( g: Graphics, outline: GridItems, fill: GridItems ){
        trace( outline );
        //trace( fill );
        //gridOutline.renderGrid( g, outline, false );
        //gridFill.renderGrid( g, fill, false );
    }
}