package htmlHelper.canvas;
import js.html.CanvasElement;
import js.Browser;
@:forward( width, height, getContext2d )
abstract CanvasWrapper( CanvasElement ) to CanvasElement from CanvasElement {
    public inline function new( ?e: CanvasElement ){
        if( e == null ){
            this = create();
        } else {
            this = e;
        }
    }
    inline static public function create(): CanvasElement {
        var canvas = Browser.document.createCanvasElement();
        var dom = cast canvas;
        var style = dom.style;
        style.paddingLeft = "0px";
        style.paddingTop = "0px";
        style.left = '0px';
        style.top = '0px';
        style.position = "absolute";
        return canvas;
    }
    public var x( get, set ): Int;
    inline public function set_x( x_: Int ):Int {
        ( cast this ).style.left = Std.string( x_ ) + 'px';
        return( x_ );
    }
    inline public function get_x(): Int {
        var style = ( cast this ).style;
        var len = style.left.length;
        return Std.parseInt( style.left.substr( 0, len - 2 ) );
    }
    public var y( get, set ): Int;
    inline public function set_y( y_: Int ):Int {
        ( cast this ).style.left = Std.string( y_ ) + 'px';
        return( y_ );
    }
    inline public function get_y(): Int {
        var style = ( cast this ).style;
        var len = style.top.length;
        return Std.parseInt( style.top.substr( 0, len - 2 ) );
    }
}
