package jigsawxKha.tileImage;
import kha.Image;
import jigsawxKha.tileImage.ShapeBuilder;
import jigsawxKha.tileImage.OutlineBuilder;
import jigsawxKha.tileImage.FillSheet;
import jigsawxKha.tileImage.OutlineSheet;
import jigsawx.JigsawPiece;
import trilateralXtra.kDrawing.PolyPainter;
class ImageTiles{
    public var fillImage:       Image;
    public var outlineImage:    Image;
    public var jigsawShapeArray = new Array<JigsawShape>();
    
    var jigsawShapeArrayOutline = new Array<JigsawShape>();
    var shapeBuilder            = new ShapeBuilder();
    var outlineBuilder          = new OutlineBuilder();
    public function new(){
        PolyPainter.bufferSize = 6145334;
    }
    inline 
    public function draw( jigs: Array<JigsawPiece>, picture: Image ){
        jigsawShapeArray            = shapeBuilder.draw( jigs );
        jigsawShapeArrayOutline     = outlineBuilder.draw( jigs );
        var fillSheet               = new FillSheet();
        var outlineSheet            = new OutlineSheet();
        fillImage                   = fillSheet.render( picture, jigsawShapeArray );
        outlineImage                = outlineSheet.render( jigsawShapeArrayOutline );
    }

}