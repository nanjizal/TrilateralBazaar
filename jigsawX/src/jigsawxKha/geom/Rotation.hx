package jigsawxKha.geom;
import kha.math.FastMatrix3;
class Rotation {
    public static inline
    function offsetRotation( angle: Float, centreX: Float, centreY: Float ){
        return FastMatrix3.translation( centreX, centreY ).multmat( FastMatrix3.rotation( angle ) ).multmat( FastMatrix3.translation( -centreX, -centreY ) );
    }
}