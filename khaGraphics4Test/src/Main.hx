package;
import kha.*;
import kha.graphics4.*;
import kha.math.*;
import kha.input.*;
//import khaMath.Matrix4;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import testTrilateral.TrilateralTest;
// contributed by Dave 
// have removed some old code left in from before and tweaked formatting to my style in places.
class Main {
    public static function main() {
        System.init({ title: "Test Graphics 4", width: 1024, height: 1024, samplesPerPixel: 4 }, function() { new Main(); } );
    }
    var initialized:        Bool = false;
    var xPos:               Float;
    var yPos:               Float;
    var keys:               Array<Bool> = [ for( i in 0...4 ) false ];
    var trilateralTest:     TrilateralTest;
    var pipeline:           PipelineState;
    var vertexBuffer:       VertexBuffer;
    var indexBuffer:        IndexBuffer;
    var transformed:        FastMatrix4;
    var mvp:                FastMatrix4;
    var mvpID:              ConstantLocation;
    var z                   = 1.;
    var structureLength     = 6;
    var scale:              Float;
    var stageRadius:        Float;
    var timeSlice           = 0.;
    var r = 0.0;
    var ibi = 0;
    var yr = 0.0;
    var xr = 0.0;
    public function new() {
        Assets.loadEverything( loadingFinished );
    }
 
    function loadingFinished() {
        stageRadius = 512;
        scale = 1/( stageRadius );
        trilateralTest =  new TrilateralTest( stageRadius );
        trilateralTest.setup();
        setup3d();
        Keyboard.get().notify( keyDown, keyUp );
        Mouse.get().notify( null, null, mouseMove, null );
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1 / 60 );
    }
 
    function setup3d() {
        // Define vertex structure
        var structure = new VertexStructure();
        structure.add( "pos", VertexData.Float3 );
        structure.add( "col", VertexData.Float3 );
        // Save length - we store position and color data
 
 
        // Compile pipeline state
        // Shaders are located in 'Sources/Shaders' directory
        // and Kha includes them automatically
        pipeline                = new PipelineState();
        pipeline.inputLayout    = [ structure ];
        pipeline.fragmentShader = Shaders.simple_frag;
        pipeline.vertexShader   = Shaders.simple_vert;
        // Set depth mode
        pipeline.depthWrite     = false;
        pipeline.depthMode      = CompareMode.Less;
        pipeline.compile();
        // transform to fit stage.
        var scaled              = FastMatrix4.scale( scale/1.1, scale/1.1, 1 );
        var translated          = FastMatrix4.translation( -stageRadius, -stageRadius,0 );
        transformed             = scaled.multmat( translated );
        // Get a handle for our "MVP" uniform
        mvpID = pipeline.getConstantLocation( "MVP" );
 
        updateMvp();
 
        // vertexBufferLen = Std.int(vertices.length / 3)
        // Create vertex buffer
        vertexBuffer = new VertexBuffer(
            trilateralTest.triangles.length * 3, // Vertex count - 3 floats per vertex
            structure, // Vertex structure
            Usage.DynamicUsage // Vertex data will stay the same
        );
        // indicesLen = indices.length;
        // Create index buffer
        indexBuffer = new IndexBuffer(
            trilateralTest.triangles.length * 3, // Number of indices for our cube
            Usage.StaticUsage // Index data will stay the same
        );
 
        var iData = indexBuffer.lock();
        for( i in 0...100000 ){
            iData[ i ] = i;
        }
        indexBuffer.unlock();
        var triangles   = trilateralTest.triangles;
        var gameColors  = trilateralTest.appColors;
        var vbData      = vertexBuffer.lock();
        for( t in 0...triangles.length ){
            var tri = triangles[ t ];
            var i = t * 18;
            var col = gameColors[ tri.colorID ];
            var r = _r( col );
            var g = _g( col );
            var b = _b( col );
            vbData[   i ] = tri.ax;
            vbData[ ++i ] = tri.ay;
            vbData[ ++i ] = z;
            vbData[ ++i ] = r;
            vbData[ ++i ] = g;
            vbData[ ++i ] = b;
            vbData[ ++i ] = tri.bx;
            vbData[ ++i ] = tri.by;
            vbData[ ++i ] = z;
            vbData[ ++i ] = r;
            vbData[ ++i ] = g;
            vbData[ ++i ] = b;
            vbData[ ++i ] = tri.cx;
            vbData[ ++i ] = tri.cy;
            vbData[ ++i ] = z;
            vbData[ ++i ] = r;
            vbData[ ++i ] = g;
            vbData[ ++i ] = b;
        }
        vertexBuffer.unlock();
    }
    public function keyDown( keyCode: Int ){
        switch( keyCode ){
            case KeyCode.Left:
                keys[ 0 ] = true;
            case KeyCode.Right:
                keys[ 1 ] = true;
            case KeyCode.Up:
                keys[ 2 ] = true;
            case KeyCode.Down:
                keys[ 3 ] = true;
            case KeyCode.Space:
                yr+= 0.1;
                updateMvp();
            case KeyCode.Shift:
                xr-= 0.1;
                updateMvp();
            default:
        }
    }
 
    public function keyUp( keyCode: Int ) {
        switch( keyCode ){
            case KeyCode.Left:
                keys[ 0 ] = false;
            case KeyCode.Right:
                keys[ 1 ] = false;
            case KeyCode.Up:
                keys[ 2 ] = false;
            case KeyCode.Down:
                keys[ 3 ] = false;
            default:
        }
    }
 
    function mouseMove( x: Int, y: Int, movementX: Int, movementY: Int ) {
        r += movementX < 0 ? 0.01 : -0.01;
        updateMvp();
    }
 
    function updateMvp() {
        var aspect = kha.System.windowWidth() / kha.System.windowHeight();
        var projection = FastMatrix4.perspectiveProjection( Math.PI / 4, aspect, 0.1, 1000.0 );
 
        var view = FastMatrix4.lookAt( new FastVector3( 0, 0, -1 ), // Camera is at (4, 3, 3), in World Space
                                       new FastVector3( 0, 0, 0  ), // and looks at the origin
                                       new FastVector3( 0, -1, 0  ) // Head is up (set to (0, -1, 0) to look upside-down)
        );
 
        // Model matrix: an identity matrix (model will be at the origin)
        var model = FastMatrix4.rotationZ( r ).multmat( FastMatrix4.rotationY( yr ) ).multmat( FastMatrix4.rotationX( xr )).multmat( FastMatrix4.translation( xPos, yPos, 0 ) );
        // Our ModelViewProjection: multiplication of our 3 matrices
        // Remember, matrix multiplication is the other way around
        mvp = FastMatrix4.identity();
        mvp = mvp.multmat( projection );
        mvp = mvp.multmat( view );
        mvp = mvp.multmat( model ).multmat( transformed );
    }
    var delta = (1/1024);
    public function update(): Void {
        var updateTrue = false;
        if( keys[ 0 ] ){
            xPos -= delta;
            updateTrue = true;
        } else if( keys[ 1 ] ){
            xPos += delta;
            updateTrue = true;
        }
        if( keys[ 2 ] ){
            yPos -= delta;
            updateTrue = true;
        } else if( keys[ 3 ] ){
            yPos += delta;
            updateTrue = true;
        }
        if( updateTrue ) updateMvp();
    }
 
    public static inline function _r( int: Int ) : Float
        return ((int >> 16) & 255) / 255;
 
    public static inline function _g( int: Int ) : Float
        return ((int >> 8) & 255) / 255;
 
    public static inline function _b( int: Int ) : Float
        return (int & 255) / 255;
 
    public function render( framebuffer: Framebuffer ){
        var g4 = framebuffer.g4;
        g4.begin();
        g4.clear( Color.fromValue( 0xff000000 ) );
        g4.setVertexBuffer( vertexBuffer );
        g4.setIndexBuffer( indexBuffer );
        g4.setPipeline( pipeline );
        g4.setMatrix( mvpID, mvp );
        g4.drawIndexedVertices( 0, trilateralTest.triangles.length * 3 );
        g4.end();
    }
}