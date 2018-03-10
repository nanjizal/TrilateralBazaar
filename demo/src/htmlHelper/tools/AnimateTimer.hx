package htmlHelper.tools;
import js.Browser;
import js.html.StyleElement;
class AnimateTimer {
    // called every frame
    public static var onFrame: Int -> Void;
    public static var counter: Int = 0;
    static var s: StyleElement;
    // rather ugly way to inject add a css enterframe loop for animation 
    // into the head of document.injectCSSenterFrame
    public static inline function create(){
        if( s != null ) return;
        s = Browser.document.createStyleElement();
        s.innerHTML = "@keyframes spin { from { transform:rotate( 0deg ); } to { transform:rotate( 360deg ); } }";
        Browser.document.getElementsByTagName("head")[0].appendChild( s );
        (cast s).animation = "spin 1s linear infinite";
        loop( 60.0 );
    }
    static function loop( tim: Float ): Bool {
        Browser.window.requestAnimationFrame( loop );
        if( onFrame != null ) onFrame( counter );
        counter++;
        return true;
    }
    public static inline function kill(){
        if( s == null ) return;        
        Browser.document.getElementsByTagName("head")[0].removeChild( s );
        onFrame = null;
        s = null;
    }
    // if tween returns null you can kill, or set onFrame to null.
    public static inline function tween( t: Float, b: Float, e: Float, d: Float
                                       , f: Float->Float->Float->Float->Float ): Float {
        if( t > d ) return null;
        return f( t, b, e - b, d );
    }
}
