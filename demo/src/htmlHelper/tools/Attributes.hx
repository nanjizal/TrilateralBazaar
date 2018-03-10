package htmlHepler.tools;
import js.html.DivElement;
import js.html.Attr;
abstract AnAttribute( Attr ) from Attr  {
    inline function new( att: Attr ){
        this = att;
    }
    @:to
    inline function attFloat(): Float {
        return Std.parseFloat( this.value );
    }
    @:to
    public function attInt(): Int {
        return Std.parseInt( this.value );
    }
    @:to
    inline function attString(): String {
        return this.value;
    }
    inline function parseBool( str: String ): Bool {
        str = str.toLowerCase();
        var bool: Bool = false;
        if( str == 'true' ) bool = true;
        return bool;
    }
    @:to
    inline function attBool(): Bool {
        return parseBool( this.value );
    }
    @:to
    inline function attArrayString(): Array<String> {
        var arrStr = this.value.split(',');
        var first = arrStr[ 0 ];
        if( first.charAt(0) == '[' ){
          arrStr[ 0 ] = first.substr( 1 );
        }
        var len = arrStr.length;
        if( len > 1 ){
            var len_1 = len - 1;
            var last = arrStr[ len_1 ];
            var last_last = last.length - 1;
            if( last.charAt( last_last ) == ']' ){
                arrStr[ len_1 ] = last.substr( 0, last_last );
            }
        } else {
            var last = arrStr[ 0 ];
            var last_last = last.length - 1;
            if( last.charAt( last_last ) == ']' ){
                arrStr[ 0 ] = last.substr( 0, last_last );
            }
        }
        return arrStr;
    }
    @:to
    inline function attArrayFloat(): Array<Float> {
        var AnAt: AnAttribute = this;
        var arrStr: Array<String> = AnAt;
        var arr = new Array<Float>();
        for( i in arrStr ){
            arr.push( Std.parseFloat( i ) );
        }
        arrStr = null;
        return arr;
    }
    @:to
    inline function attArrayInt(): Array<Int> {
        var AnAt: AnAttribute = this;
        var arrStr: Array<String> = AnAt;
        var arr = new Array<Int>();
        for( i in arrStr ){
            arr.push( Std.parseInt( i ) );
        }
        arrStr = null;
        return arr;
    }
    @:to
    inline function attArrayBool(): Array<Bool> {
        var AnAt: AnAttribute = this;
        var arrStr: Array<String> = AnAt;
        var arr = new Array<Bool>();
        for( i in arrStr ){
            arr.push( parseBool( i ) );
        }
        arrStr = null;
        return arr;
    }
    public static inline function get_Attribute( element: DivElement, name: String ): AnAttribute {
        var atts = element.attributes;
        var atr = atts.getNamedItem( name );
        var at: AnAttribute = atr;
        return at;
    }
}
// Ideally suited for using
class Attributes {
    public static var _element: DivElement;
    public static var _atts: NamedNodeMap;
    // don't inline as makes code verbose.
    public static function parseAttribute( element_: DivElement, name_: String ): AnAttribute {
        if( _element == element_ ){} else {
            _element = element_;
            _atts = element_.attributes;
        }
        return _atts.getNamedItem( name_ );
        //return element_.attributes.getNamedItem( name_ );
    }
}
