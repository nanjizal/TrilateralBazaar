package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import kha.Color;
import kha.Assets;
import kha.math.FastMatrix3;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import kha.input.Keyboard;
import kha.Scheduler;
import jigsawxKha.game.JigsawGame;
import kha.WindowOptions;
import kha.WindowMode;
import kha.Window;
class Main {
    var mouseIsDown:    Bool = false;
    var key: Int;
    var left:           Bool = false;
    var right:          Bool = false;
    var up:             Bool = false;
    var down:           Bool = false;
    var theta:          Float = 0.035; // minimum amount of rotation
    var jigsaw:         JigsawGame;
    var enable          = true;
    public static 
    function main() {
        System.start( {  title: "JigsawX Trilateral Kha example"
                     ,  width: 4096, height: 4096
                     ,  window: { windowFeatures:    FeatureResizable }
                     , framebuffer: { samplesPerPixel: 4 } }
                     , function( window: Window ){
                        new Main();
                     } );
    }
    public function new(){
        jigsaw        = new JigsawGame();
        Assets.loadEverything( loadAll );
    }
    public function loadAll(){
        trace( 'loadAll' );
        jigsaw.start( Assets.images.tablecloth );
        startRendering();
        initInputs();
    }
    inline
    function startRendering(){
        System.notifyOnFrames( function ( framebuffer ) { render( framebuffer[0] ); } );
        Scheduler.addTimeTask(update, 0, 1 / 60);
    }
    inline
    function render( framebuffer: Framebuffer ): Void {
        var g = framebuffer.g2;
        g.begin();
        jigsaw.render( g );
        g.end();
    }
    inline
    function update(): Void {
        if( left ){
            jigsaw.updateRotations( theta );
        } else if( right ) {
            jigsaw.updateRotations( -theta );  
        }
    }
    function initInputs() {
        if (Mouse.get() != null) Mouse.get().notify( mouseDown, mouseUp, mouseMove, null );
        if( Keyboard.get() != null ) Keyboard.get().notify( keyDown, keyUp, null );
    }
    function mouseDown( button: Int, x: Int, y: Int ): Void {
        jigsaw.deselect();
        jigsaw.selectCheck( x, y );
        mouseIsDown = true;
    }
    function mouseUp( button: Int, x: Int, y: Int ): Void {
        mouseIsDown = false;
        jigsaw.clampCorrect();
        jigsaw.deselect();
    }
    function mouseMove( x: Int, y: Int, movementX: Int, movementY: Int ): Void {
        if( mouseIsDown == false ) return;
        jigsaw.moveSelected( x, y );
    }
    function keyDown( keyCode: Int ):Void{
        key = keyCode;
        if( !enable ) return;
        switch( keyCode ){
            case Left:
                left = true;
            case Right:
                right = true;
            case Up: 
                up = true;
            case Down:
                down = true;
            case _:
                //
        }
    }
    function keyUp( keyCode: Int  ):Void{ 
        if( !enable ) return;
        //trace( keyCode );
        left    = false;
        right   = false;
        up      = false;
        down    = false;
    }
}