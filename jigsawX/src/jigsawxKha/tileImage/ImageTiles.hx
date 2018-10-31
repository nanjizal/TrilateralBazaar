package jigsawxKha.tileImage;
import kha.Image;
import jigsawxKha.tileImage.fill.ShapeBuilder;
import jigsawxKha.tileImage.outline.OutlineBuilder;
import jigsawxKha.tileImage.fill.FillSheet;
import jigsawxKha.tileImage.outline.OutlineSheet;
import jigsawx.JigsawPiece;
import trilateralXtra.kDrawing.PolyPainter;
class ImageTiles{
    public var fillImage:       Image;
    public var outlineImage:    Image;
    public var jigsawShapeArray = new Array<JigsawShape>();
    var jigsawShapeArrayOutline = new Array<JigsawShape>();
    var shapeBuilder            = new ShapeBuilder();
    var outlineBuilder          = new OutlineBuilder();
    var widthMax:               Int;
    var heightMax:              Int;
    public function new( widthMax_: Int, heightMax_: Int ){
        PolyPainter.bufferSize = 6145334; // move this?
        widthMax    = widthMax_;
        heightMax   = heightMax_;
    }
    inline 
    public function draw( jigs: Array<JigsawPiece>, picture: Image
                        , inputScale: Float, canvasScale: Float ){
        drawFill( jigs, picture, inputScale, canvasScale );
        drawOutline( jigs );
    }
    inline
    function drawFill( jigs: Array<JigsawPiece>, picture: Image
                     , inputScale: Float, canvasScale: Float ){
        jigsawShapeArray            = shapeBuilder.draw( jigs );
        var fillSheet               = new FillSheet( widthMax, heightMax );
        fillImage                   = fillSheet.render( picture, jigsawShapeArray
                                                      , inputScale, canvasScale );
    }
    inline 
    function drawOutline( jigs: Array<JigsawPiece> ){
        jigsawShapeArrayOutline     = outlineBuilder.draw( jigs );
        var outlineSheet            = new OutlineSheet();
        outlineImage                = outlineSheet.render( jigsawShapeArrayOutline );
    }
}