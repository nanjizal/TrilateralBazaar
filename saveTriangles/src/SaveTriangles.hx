package;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import format.png.Writer;
import format.png.Tools;
import haxe.io.Path;
import haxe.io.Bytes;
import trilateral.tri.Triangle;
import trilateral.parsing.svg.Svg;
import trilateral.nodule.Nodule;
import trilateral.nodule.ReadXML;
import trilateralXtra.parsing.FillDrawPolyK;
import trilateral.parsing.FillDraw;
import trilateralXtra.serialize.FileTriangles;
import trilateralXtra.serialize.FileTrilaterals; // if you just want to save triangles without colors and id.
import trilateral.tri.TriangleArray;
import trilateralXtra.serialize.VectorImage;
import justDrawing.Surface;
import hxPixels.Pixels;
#if neko
import neko.vm.Module;
#end
class SaveTriangles {
    var svgFileName =       'WestCountrySalsa.svg';
    var triangleSaveName =  'WestCountrySalsa.dat';
    var pngSaveName =       'WestCountrySalsa.png';
    public static function main(){ new SaveTriangles(); }
    public function new(){
        // load svg and save as triangles
        var svgStr = loadSvg( svgFileName );
        var fillDraw = svgToTriangles( svgStr );
        saveTriangles( triangleSaveName, fillDraw );
        // load triangles and save as png
        var vectorImage = loadTriangles( triangleSaveName );
        trace( 'triangles loaded in' );
        var pixels = new Pixels( 820, 620 );
        var surface = new Surface( pixels );
        renderToPixels( surface, vectorImage.getTriangles(), vectorImage.colors, 0xFF181818 );
        saveToPNG( pixels, pngSaveName );
    }
    function loadSvg( fileName: String ){
        trace( 'loadSvg' );
        return File.getContent( filePath( fileName ) );
    }
    function saveTriangles( fileName: String, fillDraw: FillDraw ){
        trace( 'saveTriangles' );
        FileTriangles.write( filePath( fileName ), fillDraw.colors, fillDraw.triangles );
    }
    function loadTriangles( fileName: String ){
        trace( 'loadTriangles' );
        return FileTriangles.read( filePath( fileName ) );
    }
    static inline
    function svgToTriangles( svgStr_: String ): FillDraw {
        trace( 'svgToTriangles' );
        var fillDraw_       = new FillDrawPolyK( 820, 620 );
        var nodule: Nodule  = ReadXML.toNodule( svgStr_ );
        var svg:    Svg     = new Svg( nodule );
        svg.render( fillDraw_ );
        svg     = null;
        nodule  = null;
        return fillDraw_;
    } 
    public var dir( get, never ): String;
    function get_dir(): String {
        #if neko
        var dir = Path.directory( Module.local().name );
        #else
        var dir = Path.directory( Sys.executablePath() );
        #end
        return dir;
    }
    function filePath( fname: String ){
        return Path.join( [ dir, fname ] );
    }
    function renderToPixels( g: Surface, triangles: TriangleArray, colors: Array<Int>, bgColor: Int ): Void {
        trace( 'renderToPixels' );
        var tri: Triangle;
        var s = 1.;
        var ox = -20.;
        var oy = -20.;
        g.beginFill( bgColor, 1. );
        g.lineStyle( 0., 0xFF000000, 0. );
        g.drawRect( 1, 1, 820, 620 );
        g.endFill();
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            if( tri.mark != 0 ){
                g.beginFill( colors[ tri.mark ] );
            } else {
                g.beginFill( colors[ tri.colorID ], 1. );
                g.lineStyle( 0., colors[ tri.colorID ], 1. );
            }
            // not really too sure why ax and bx need to be swapped.
            g.drawTri( [   ox + tri.bx * s, oy + tri.by * s
                        ,  ox + tri.ax * s, oy + tri.ay * s
                        ,  ox + tri.cx * s, oy + tri.cy * s ] );
            g.endFill();
        }
    }
    function saveToPNG( pixels: Pixels, fileName: String ) {
        trace( 'saveToPNG' );
        var file = File.write( filePath( fileName ), true );
        var pngWriter = new Writer( file );
        pixels.convertTo( PixelFormat.ARGB );
        var pngData = Tools.build32ARGB( pixels.width, pixels.height, pixels.bytes );
        pngWriter.write( pngData );
    }
}