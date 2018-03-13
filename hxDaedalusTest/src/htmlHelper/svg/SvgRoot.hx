package htmlHelper.svg;
import js.Browser;
import js.html.svg.SVGElement;
import js.html.Element;
import js.html.CSSStyleDeclaration;
import js.html.Node;
@:forward( appendChild, removeChild )
abstract SvgRoot( SVGElement ) from SVGElement to SVGElement {
    inline public static var svgNameSpace: String = "http://www.w3.org/2000/svg" ;
    inline public function new( ?e: SVGElement ){
        if( e == null ){
            this = create();
        } else {
            this = e;
        }
    }
    inline static public function create(): SvgRoot {
        var svgElement: SVGElement = cast Browser.document.createElementNS( svgNameSpace, 'svg' );
        var element: Element = cast svgElement;
        var style: CSSStyleDeclaration = element.style;
        style.paddingLeft = "0px";
        style.paddingTop = "0px";
        style.left = Std.string( 0 + 'px' );
        style.top = Std.string( 0 + 'px' );
        style.position = "absolute";
        Browser.document.body.appendChild( element );
        var svgRoot: SvgRoot = svgElement;
        return svgRoot;
    }
    public var width( get, set ): Int;
    inline public function set_width( width_: Int ):Int {
        this.setAttribute( "width", Std.string( width_ ) );
        return( width_ );
    }
    inline public function get_width(): Int {
        return Std.parseInt( this.getAttribute( "width" ) );
    }
    public var height( get, set ): Int;
    inline public function set_height( height_: Int ):Int {
        this.setAttribute( "height", Std.string( height_ ) );
        return( height_ );
    }
    inline public function get_height(): Int {
        return Std.parseInt( this.getAttribute( "height" ) );
    }
}
