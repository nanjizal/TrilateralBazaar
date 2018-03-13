package;
import js.Browser;
import khaMath.Matrix4;
import htmlHelper.webgl.WebGLSetup;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import htmlHelper.tools.AnimateTimer; 
import trilateral.tri.Triangle;
import TrilateralTest;
import js.html.Event;
import js.html.MouseEvent;
using htmlHelper.webgl.WebGLSetup;
typedef UpDownEvent = Event;
class Main extends WebGLSetup {
    var webgl:          WebGLSetup;
    var trilateralTest: TrilateralTest;
    var scale:          Float;
    var x:              Float;
    var y:              Float;
    // Generic triangle drawing Shaders
    public static inline var vertex: String =
        'attribute vec3 pos;' +
        'attribute vec4 color;' +
        'varying vec4 vcol;' +
        'uniform mat4 modelViewProjection;' +
        'void main(void) {' +
            ' gl_Position = modelViewProjection * vec4(pos, 1.0);' +
            ' vcol = color;' +
        '}';
    public static inline var fragment: String =
        'precision mediump float;'+
        'varying vec4 vcol;' +
        'void main(void) {' +
            ' gl_FragColor = vcol;' +
        '}';
    public static function main(){ new Main(); }
    public inline static var stageRadius: Int = 570;
    public function new(){
        createBackground();
        super( stageRadius*2, stageRadius*2 );
        var dom = cast canvas;
        dom.style.setProperty("pointer-events","none");
        scale = 1/(stageRadius);
        darkBackground();
        modelViewProjection = Matrix4.identity();
        setupProgram( vertex, fragment );
        trilateralTest =  new TrilateralTest( stageRadius, setMatrix, setAnimate );
        trilateralTest.setup();
        setTriangles( trilateralTest.triangles, cast trilateralTest.appColors );
    }
    inline 
    function createBackground(){
        var doc = Browser.document;
        var bg = doc.createDivElement();
        bg.style.backgroundColor = '#cccccc';
        bg.style.width = Std.string( 1024 ) + 'px';
        bg.style.height = Std.string( 1024 ) + 'px';
        bg.style.position = "absolute";
        bg.style.left = '0px';
        bg.style.top = '0px';
        bg.style.zIndex = '-100';
        bg.style.cursor = "default";
        doc.body.appendChild( bg );
        bg.onmousedown = onMouseDown;// click/drag
        bg.onmouseup = onMouseUp;
        bg.onmousemove = onMouseMove;
    }
    
    inline
    function onMouseMove( e: Event ): Void {
        var p: MouseEvent = cast e;
        x = p.clientX;
        y = p.clientY;
        trilateralTest.mouseMove( x, y );
    }
    inline
    function onMouseMoveScale( e: Event ): Void {
        var p: MouseEvent = cast e;
        x = p.clientX/scale;
        y = p.clientY/scale;
        trilateralTest.mouseMove( x, y );
    }
    inline
    function onMouseUp( event: UpDownEvent ): Void {
        trilateralTest.mouseUp( x, y );
    }
    inline
    function onMouseDown( event: UpDownEvent ): Void {
        trilateralTest.mouseDown( x, y );
    }
    
    public inline
    function setAnimate(){
        AnimateTimer.create();
        AnimateTimer.onFrame = render_;
    }
    public inline
    function setMatrix( matrix4: Matrix4 ): Void {
        modelViewProjection = matrix4;
    }
    function darkBackground(){
        var dark = 0x18/256;
        bgRed   = dark;
        bgGreen = dark;
        bgBlue  = dark;
    }
    inline
    function setTriangles( triangles: Array<Triangle>, triangleColors:Array<UInt> ) {
        var rgb: RGB;
        var colorAlpha = 1.;
        var tri: Triangle;
        var count = 0;
        var i: Int = 0;
        var c: Int = 0;
        var j: Int = 0;
        var ox: Float = -1.0;
        var oy: Float = 1.0;
        var no: Int = 0;
        for( tri in triangles ){
            vertices[ i++ ] = tri.ax*scale + ox;
            vertices[ i++ ] = -tri.ay*scale + oy;
            vertices[ i++ ] = tri.depth;
            vertices[ i++ ] = tri.bx*scale + ox;
            vertices[ i++ ] = -tri.by*scale + oy;
            vertices[ i++ ] = tri.depth;
            vertices[ i++ ] = tri.cx*scale + ox;
            vertices[ i++ ] = -tri.cy*scale + oy;
            vertices[ i++ ] = tri.depth;
            if( tri.mark != 0 ){
                rgb = WebGLSetup.toRGB( triangleColors[ tri.mark ] );
            } else {
                rgb = WebGLSetup.toRGB( triangleColors[ tri.colorID ] );
            }
            for( k in 0...3 ){
                colors[ c++ ] = rgb.r;
                colors[ c++ ] = rgb.g;
                colors[ c++ ] = rgb.b;
                colors[ c++ ] = colorAlpha;
                indices[ j++ ] = count++;
            }
        }
        gl.uploadDataToBuffers( program, vertices, colors, indices );
    }
    inline
    function render_( i: Int ):Void{
        render();
    }
    override public 
    function render(){
        trilateralTest.render();
        setTriangles( trilateralTest.triangles, cast trilateralTest.appColors );
        super.render();
    }
}