package;

import hxDaedalus.ai.EntityAI;
import hxDaedalus.ai.PathFinder;
import hxDaedalus.ai.trajectory.LinearPathSampler;
import hxDaedalus.data.math.RandGenerator;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.data.math.Point2D;
import hxDaedalus.data.Edge;
import hxDaedalus.data.Face;
import hxDaedalus.data.Object;

import khaMath.Matrix4;
import trilateral.tri.Triangle;
import trilateral.tri.Trilateral;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Contour;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrilateralPair;
import trilateral.geom.Algebra;
import trilateral.path.Crude;         // just overlap nothing between very dirty
import trilateral.path.RoundEnd;      // create isolated rounded lines not ideal as end of each line overlap but very robust.
import trilateral.path.MediumOverlap; // when the lines overlap slightly
import trilateral.path.Medium;        // this is for triangles between angles
import trilateral.path.FineOverlap;   // when the lines overlap slightly
import trilateral.path.Fine;          // this is triangles with curved corners
import trilateral.path.FillOnly;      // no drawing this is just useful if you want the shape without drawing the contour.
import trilateral.helper.Shapes;
import trilateral.helper.AppColors;
import trilateral.justPath.SvgPath;
import trilateral.justPath.PathContextTrace;
import trilateral.angle.Angles;
import trilateral.polys.Poly;
import trilateral.geom.Point;

#if trilateral_includeSegments
import trilateral.segment.SixteenSeg;
import trilateral.segment.SevenSeg;
#end

// change name to include hxDaedalus
class TrilateralTest {
    
    public var appColors:       Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                                   , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                                   , BlueAlpha, GreenAlpha, RedAlpha ];
    public var triangles:       TriangleArray;
    var setMatrix:              Matrix4->Void;
    var modelViewProjection:    Matrix4;
    var theta:                  Float = 0;
    var stageRadius:            Float; // Int ?
    
    var _mesh : Mesh;
// NO VIEW    var _view : KSimpleView;
    var _objects: Array<Object> = new Array<Object>();
    var _object: Object;
    var _entityAI : EntityAI;
    var _pathfinder : PathFinder;
    var _path : Array<Float>;
    var _pathSampler : LinearPathSampler;
    var _newPath:Bool = false;
    var x: Float = 0;
    var y: Float = 0;
    var shapes: Shapes;
    public
    function new( stageRadius_: Float, setMatrix_: Matrix4->Void, setAnimate_: Void->Void ){
        stageRadius         = stageRadius_;
        modelViewProjection = Matrix4.identity();
        setMatrix = setMatrix_;
        setAnimate_(); // if you want it to draw every frame, or update triangles
    }
    public
    function setup(){
        triangles = new TriangleArray();
        shapes = new Shapes( triangles, appColors );
        
        // build a rectangular 2 polygons mesh 
        _mesh = RectMesh.buildRectangle(1024, 1024);
        
        // pseudo random generator
        /*
        var randGen : RandGenerator;
        randGen = new RandGenerator();
        randGen.seed = 7259;  // put a 4 digits number here
        // populate mesh with many square objects
        
        var shapeCoords : Array<Float>;
        for (i in 0...50){
            object = new Object();
            shapeCoords = new Array<Float>();
            shapeCoords = [ -1, -1, 1, -1,
                             1, -1, 1, 1,
                            1, 1, -1, 1,
                            -1, 1, -1, -1];
            object.coordinates = shapeCoords;
            randGen.rangeMin = 10;
            randGen.rangeMax = 40;
            object.scaleX = randGen.next();
            object.scaleY = randGen.next();
            randGen.rangeMin = 0;
            randGen.rangeMax = 1000;
            object.rotation = (randGen.next() / 1000) * Math.PI / 2;
            randGen.rangeMin = 50;
            randGen.rangeMax = 550;
            object.x = randGen.next();
            object.y = randGen.next();
            _objects.push( object );
            _mesh.insertObject(object);
        }
        object = new Object();
        */
        _object = new Object();
        var shape = [ 93., 195., 129., 92., 280., 81., 402., 134., 477., 70., 619., 61.,759., 97., 758., 247., 662., 347., 665., 230., 721., 140., 607., 117., 472., 171., 580., 178., 603., 257., 605., 377., 690., 404., 787., 328., 786., 480., 617., 510., 611., 439., 544., 400., 529., 291., 509., 218., 400., 358., 489., 402., 425., 479., 268., 464., 341., 338., 393., 427., 373., 284., 429., 197., 301., 150., 296., 245., 252., 384., 118., 360., 190., 272., 244., 165., 81., 259., 40., 216.];
        shape = [55,55,145,55,235,100,325,55,415,55,415,145,370,235,415,320,415,410,325,410,235,365,145,410,55,410,55,320,105,235,55,145];
        var shape2: Array<Float> = [115,235,235,355,360,235,235,110];
        _object.multiPoints = [shape,shape2];
        _object.scaleX = 1.;
        _object.scaleY = 1.;
        _objects.push( _object );
        var object2 = new Object();
        object2.multiPoints = [shape,shape2];
        object2.scaleX = 1.;
        object2.scaleY = 1.;
        _objects.push( object2 );
        _mesh.insertObject(object2);
        var object3 = new Object();
        object3.multiPoints = [shape,shape2];
        object3.scaleX = 1.;
        object3.scaleY = 1.;
        object3.x = 500;
        object3.y = 500;
        _objects.push( object3 );
        _mesh.insertObject(object3);
        
        _mesh.insertObject(_object);
        // we need an entity
        _entityAI = new EntityAI();
        // set radius as size for your entity
        _entityAI.radius = 4;
        // set a position
        _entityAI.x = 20;
        _entityAI.y = 20;
        // now configure the pathfinder
        _pathfinder = new PathFinder();
        _pathfinder.entity = _entityAI;  // set the entity
        _pathfinder.mesh = _mesh;  // set the mesh
        // we need a vector to store the path
        _path = new Array<Float>();
        // then configure the path sampler
        _pathSampler = new LinearPathSampler();
        _pathSampler.entity = _entityAI;
        _pathSampler.samplingDistance = 10;
        _pathSampler.path = _path;
    }
    var alpha = 0.;
    public 
    function render(){
        clear();
        _object.x = 200 + 100 * Math.sin( alpha );
        alpha += 0.08;
        _object.y = 200 + 100 * Math.cos( alpha );
        _mesh.updateObjects();  // don't forget to update
        _pathfinder.mesh = _mesh;  // set the mesh
        
        // show result mesh on screen
        drawMesh();
        if( _newPath ){
            // find path !
            _pathfinder.findPath( x, y, _path );
            
            // show path on screen
            drawPath();
             // show entity position on screen
            drawEntity(); 
            // reset the path sampler to manage new generated path
            _pathSampler.reset();
        }
        // animate !
        if ( _pathSampler.hasNext ) {
            // move entity
            _pathSampler.next();
        }
        // show entity position on screen
        drawEntity();
        shapes.rectangle( 0, 0, 1024, 1025, NearlyBlack );
    }
    inline
    function drawEntity(){
        shapes.circle( _entityAI.x, _entityAI.y, 5, Green );
    }
    inline
    function drawPath(){
        var pathBlue = new Fine( null, null, both );
        pathBlue.width = 2;
        pathBlue.plotCoord( _path );
        triangles.addArray( 8
                        ,   pathBlue.trilateralArray
                        ,   findColorID( Red ) );
    }
    inline
    function clear(){
        triangles = new TriangleArray();
        shapes = new Shapes( triangles, appColors );
    }
    inline
    function drawMesh(){
        var all = _mesh.getVerticesAndEdges();
        var p0: Point2D;
        var p1: Point2D;
        var constrainPath = new Fine();
        constrainPath.width = 0.5;
        var edgePath = new Fine();
        edgePath.width = 0.5;
        for (e in all.edges) {   
            p0 = e.originVertex.pos;
            p1 = e.destinationVertex.pos;
            if( e.isConstrained ){
                constrainPath.moveTo( p0.x, p0.y );
                constrainPath.lineTo( p1.x, p1.y );
            } else {
                edgePath.moveTo( p0.x, p0.y );
                edgePath.lineTo( p1.x, p1.y );
            }
        }
        triangles.addArray( 6
                        ,   edgePath.trilateralArray
                        ,   findColorID( LightGrey ) );
        triangles.addArray( 7
                        ,   constrainPath.trilateralArray
                        ,   findColorID( MidGrey ) );
        var triArr: TrilateralArray = new TrilateralArray();
        for( o in _objects ) extractObjectTrilateralArray( o, triArr );
        triangles.addArray( 7
                        ,   triArr
                        ,   findColorID( Yellow ) );
        for (v in all.vertices) shapes.circle( v.pos.x, v.pos.y, 2, Orange );
    }
    public inline
    function mouseDown( x_: Float, y_: Float ){
        x = x_;
        y = y_;
        _newPath = true;
    }
    public inline
    function mouseUp( x_: Float, y_: Float ){
        x = x_;
        y = y_;
        _newPath = false;
    }
    public inline
    function mouseMove( x_: Float, y_: Float ){
        if( _newPath ){
            x = x_;
            y = y_;
        }
    }
    function findColorID( col: AppColors ){
        return appColors.indexOf( col );
    }
    function createBird(){
        var path = new Fine( null, null, both );
        path.width = 1;
        var p = new SvgPath( path );
        p.parse( bird_d, 0, 0, 1.5, 1.5 );
        triangles.addArray( 6
                        ,   path.trilateralArray
                        ,   8 );
        
    }
    static public function extractObjectTrilateralArray( object: Object, triArr: TrilateralArray ){
        var facesDone = new Map<Face,Bool>();
        var openFacesList = new Array<Face>();
        for( i in 0...object.edges.length ) openFacesList.push( object.edges[ i ].rightFace );
        var currFace:Face;
        while( openFacesList.length > 0 ){
            currFace = openFacesList.pop();
            if( facesDone[ currFace ] ) continue;
            if( currFace.isReal ) {
                var currEdge = currFace.edge;
                var a = currEdge.originVertex.pos;
                var b = currEdge.nextLeftEdge.originVertex.pos;
                var c = currEdge.nextLeftEdge.destinationVertex.pos;
                //var isSolid = ( (a.x * b.y - b.x * a.y) + (b.x * c.y - c.x * b.y) + (c.x * a.y - a.x * c.y) )<0;
                //if( isSolid ) 
                triArr.add( new Trilateral( a.x, a.y, b.x, b.y, c.x, c.y ) );
            }
            if( !currFace.edge.isConstrained) openFacesList.push(currFace.edge.rightFace);
            if( !currFace.edge.nextLeftEdge.isConstrained ) openFacesList.push(currFace.edge.nextLeftEdge.rightFace);
            if( !currFace.edge.prevLeftEdge.isConstrained ) openFacesList.push(currFace.edge.prevLeftEdge.rightFace);
            facesDone[ currFace ] = true;
        }
    }
    var bird_d = "M210.333,65.331C104.367,66.105-12.349,150.637,1.056,276.449c4.303,40.393,18.533,63.704,52.171,79.03c36.307,16.544,57.022,54.556,50.406,112.954c-9.935,4.88-17.405,11.031-19.132,20.015c7.531-0.17,14.943-0.312,22.59,4.341c20.333,12.375,31.296,27.363,42.979,51.72c1.714,3.572,8.192,2.849,8.312-3.078c0.17-8.467-1.856-17.454-5.226-26.933c-2.955-8.313,3.059-7.985,6.917-6.106c6.399,3.115,16.334,9.43,30.39,13.098c5.392,1.407,5.995-3.877,5.224-6.991c-1.864-7.522-11.009-10.862-24.519-19.229c-4.82-2.984-0.927-9.736,5.168-8.351l20.234,2.415c3.359,0.763,4.555-6.114,0.882-7.875c-14.198-6.804-28.897-10.098-53.864-7.799c-11.617-29.265-29.811-61.617-15.674-81.681c12.639-17.938,31.216-20.74,39.147,43.489c-5.002,3.107-11.215,5.031-11.332,13.024c7.201-2.845,11.207-1.399,14.791,0c17.912,6.998,35.462,21.826,52.982,37.309c3.739,3.303,8.413-1.718,6.991-6.034c-2.138-6.494-8.053-10.659-14.791-20.016c-3.239-4.495,5.03-7.045,10.886-6.876c13.849,0.396,22.886,8.268,35.177,11.218c4.483,1.076,9.741-1.964,6.917-6.917c-3.472-6.085-13.015-9.124-19.18-13.413c-4.357-3.029-3.025-7.132,2.697-6.602c3.905,0.361,8.478,2.271,13.908,1.767c9.946-0.925,7.717-7.169-0.883-9.566c-19.036-5.304-39.891-6.311-61.665-5.225c-43.837-8.358-31.554-84.887,0-90.363c29.571-5.132,62.966-13.339,99.928-32.156c32.668-5.429,64.835-12.446,92.939-33.85c48.106-14.469,111.903,16.113,204.241,149.695c3.926,5.681,15.819,9.94,9.524-6.351c-15.893-41.125-68.176-93.328-92.13-132.085c-24.581-39.774-14.34-61.243-39.957-91.247c-21.326-24.978-47.502-25.803-77.339-17.365c-23.461,6.634-39.234-7.117-52.98-31.273C318.42,87.525,265.838,64.927,210.333,65.331zM445.731,203.01c6.12,0,11.112,4.919,11.112,11.038c0,6.119-4.994,11.111-11.112,11.111s-11.038-4.994-11.038-11.111C434.693,207.929,439.613,203.01,445.731,203.01z";
    
}