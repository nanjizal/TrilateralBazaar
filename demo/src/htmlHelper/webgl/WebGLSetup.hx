package htmlHelper.webgl;
import js.Browser;
import js.html.Element;
import js.html.CanvasElement;
import js.html.BodyElement;
import js.html.webgl.RenderingContext;
import js.html.webgl.ContextAttributes;
import js.html.webgl.Shader;
import js.html.webgl.Program;
import js.html.webgl.UniformLocation;
import js.html.Float32Array;
import js.html.Uint16Array;
import khaMath.Matrix4;
import htmlHelper.webgl.WebGLSetup;
using htmlHelper.webgl.WebGLSetup;
typedef RGB = {
    var r:Float;
    var g:Float;
    var b:Float;
}
class WebGLSetup {
    public var gl: RenderingContext;
    public var program: Program;
    public var width: Int;
    public var height: Int;
    public var canvas: CanvasElement;
    public var bgRed = 1.;
    public var bgGreen = 1.;
    public var bgBlue = 1.;
    public var bgAlpha = 1.;
    public var modelViewProjection = Matrix4.identity(); // external matrix controlling global 3d position
    var matrix32Array = new Float32Array( ident() ); // internal matrix passed to shader
    var vertices = new Array<Float>();
    var triangleColors:Array<UInt>;
    var indices = new Array<Int>();
    var colors = new Array<Float>();
    public function new( width_: Int, height_: Int, autoChild: Bool = true ){
        width = width_;
        height = height_;
        canvas = Browser.document.createCanvasElement();
        canvas.width = width;
        canvas.height = height;
        var dom = cast canvas;
        var style = dom.style;
        style.paddingLeft = "0px";
        style.paddingTop = "0px";
        style.left = Std.string( 0 + 'px' );
        style.top = Std.string( 0 + 'px' );
        style.position = "absolute";
        if( autoChild ) Browser.document.body.appendChild( cast canvas );
        gl = canvas.getContextWebGL();
    }
    public function setupProgram( vertexString: String, fragmentString: String ): Program {
        var vertex = gl.createVertexShader( vertexString );
        var fragment = gl.createFragmentShader( fragmentString );
        program = gl.createShaderProgram( vertex, fragment );
        return program;
    }
    public function clearVerticesAndColors(){
        vertices = new Array<Float>();
        indices = new Array<Int>();
        colors = new Array<Float>();
    }    
    public function setVerticesAndColors( vertices: Array<Float>, triangleColors: Array<UInt> ){
        var rgb: RGB;
        var colorAlpha = 1.0;
        for (i in 0...Std.int( vertices.length/3 ) ) {
            rgb = toRGB( triangleColors[ i ] );
            for( j in 0...3 ){  // works but...
                colors.push( rgb.r );
                colors.push( rgb.g );
                colors.push( rgb.b );
                colors.push( colorAlpha );
            }
            indices.push( i );
        }
        gl.uploadDataToBuffers( program, vertices, colors, indices );
    }
    public function render(){
        gl.clearColor( bgRed, bgGreen, bgBlue, bgAlpha );
        //gl.enable( RenderingContext.DEPTH_TEST );
        gl.enable( RenderingContext.CULL_FACE ); 
        gl.cullFace( RenderingContext.BACK );
        gl.clear( RenderingContext.COLOR_BUFFER_BIT );
        gl.viewport( 0, 0, canvas.width, canvas.height );
        var modelViewProjectionID = gl.getUniformLocation( program, 'modelViewProjection' );
        transferM4_arr32( matrix32Array, modelViewProjection );
        gl.uniformMatrix4fv( modelViewProjectionID, false, matrix32Array );
        gl.drawArrays( RenderingContext.TRIANGLES, 0, indices.length );
    }
    static inline function createVertexShader( gl: RenderingContext, str: String ): Shader {
        var vertexShader = gl.createShader( RenderingContext.VERTEX_SHADER );
        gl.shaderSource( vertexShader, str );
        gl.compileShader( vertexShader );
        return vertexShader;
    }
    static inline function createFragmentShader( gl: RenderingContext, str: String ): Shader {
        var fragmentShader = gl.createShader( RenderingContext.FRAGMENT_SHADER );
        gl.shaderSource( fragmentShader, str ); 
        gl.compileShader( fragmentShader );
        return fragmentShader;
    }
    static inline function createShaderProgram( gl: RenderingContext, vertex: Shader, fragment: Shader ): Program {
        var program = gl.createProgram();
        gl.attachShader( program, vertex );
        gl.attachShader( program, fragment );
        gl.linkProgram( program );
        gl.useProgram( program );
        return program;
    }
    
    static inline function uploadTriangleDataToBuffers( gl: RenderingContext, program: Program, vertices: Array<Float>, indices: Array<Int> ){
        var vertexBuffer = gl.createBuffer(); // position data
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, vertexBuffer );
        gl.bufferData( RenderingContext.ARRAY_BUFFER, new Float32Array( vertices ), RenderingContext.STATIC_DRAW );
        var position = gl.getAttribLocation( program, "pos" );
        gl.vertexAttribPointer( position, 3, RenderingContext.FLOAT, false, 0, 0 ); 
        gl.enableVertexAttribArray( position );
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, null );
        //var indexBuffer = gl.createBuffer(); // triangle indicies data 
        //gl.bindBuffer( RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer );
        //gl.bufferData( RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16Array( indices ), RenderingContext.STATIC_DRAW );
        //gl.bindBuffer( RenderingContext.ELEMENT_ARRAY_BUFFER, null );
    }
    
    static inline function uploadDataToBuffers( gl: RenderingContext, program: Program, vertices: Array<Float>, colors: Array<Float>, indices: Array<Int> ){
        gl.uploadTriangleDataToBuffers( program, vertices, indices );
        gl.uploadSimpleColorToBuffers( program, colors ); // color data
    }
    
    static inline function uploadFloatToBuffers( gl: RenderingContext, program: Program, name: String, att: Int, arr: Array<Float> ){
        var floatBuffer = gl.createBuffer();
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, floatBuffer );
        gl.bufferData( RenderingContext.ARRAY_BUFFER, new Float32Array( arr ), RenderingContext.STATIC_DRAW );
        var flo = gl.getAttribLocation( program, name );
        gl.vertexAttribPointer( flo, att, RenderingContext.FLOAT, false, 0, 0 ); 
        gl.enableVertexAttribArray( flo );
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, null );
    }
    
    static inline function uploadSimpleColorToBuffers( gl: RenderingContext, program: Program, colors: Array<Float> ){
        var colorBuffer = gl.createBuffer();
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, colorBuffer );
        gl.bufferData( RenderingContext.ARRAY_BUFFER, new Float32Array( colors ), RenderingContext.STATIC_DRAW );
        var col = gl.getAttribLocation( program, "color" );
        gl.vertexAttribPointer( col, 4, RenderingContext.FLOAT, false, 0, 0 ); 
        gl.enableVertexAttribArray( col );
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, null );
    }
    public static inline function toRGB(int:Int) : RGB {
        return {
            r: ((int >> 16) & 255) / 255,
            g: ((int >> 8) & 255) / 255,
            b: (int & 255) / 255
        }
    }
    public static inline function transferM4_arr32( arr: Float32Array, m: Matrix4 ) {
        arr.set([ m._00, m._10, m._20, m._30, m._01, m._11, m._21, m._31, m._02, m._12, m._22, m._32, m._03, m._13, m._23, m._33 ]);
    }
    public static inline function ident(): Array<Float> {
        return [ 1.0, 0.0, 0.0, 0.0,
                 0.0, 1.1, 0.0, 0.0,
                 0.0, 0.0, 1.0, 0.0,
                 0.0, 0.0, 0.0, 1.0
                 ];
    }
}
