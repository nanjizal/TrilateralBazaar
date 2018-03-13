package htmlHelper.tools;
import js.Browser;
import js.html.StyleElement;
class CSSEnterFrame {
    var s: StyleElement;
    public var onFrame: Void -> Void;
    public function new (){
        s = Browser.document.createStyleElement();
        s.innerHTML = "@keyframes spin { from { transform:rotate( 0deg ); } to { transform:rotate( 360deg ); } }";
        Browser.document.getElementsByTagName("head")[0].appendChild( s );
        (cast s).animation = "spin 1s linear infinite";
        loop( 60 );
    }
    // TODO: improve
    public function destroy(){
        Browser.document.getElementsByTagName("head")[0].removeChild( s );
        // onFrame = null;
        Browser.window.requestAnimationFrame( null );
        s.innerHTML = '';
        (cast s).animation = '';
        s = null;
    }
    function loop( tim: Float ): Bool {
        Browser.window.requestAnimationFrame( loop );
        if( onFrame != null ) onFrame();
        return true;
    }
}
