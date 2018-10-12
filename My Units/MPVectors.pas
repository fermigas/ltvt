unit MPVectors;
{This is a re-write of DVectors, adopting the style of MP's MATLIB, in which
 the vector components are referred to by V[X] rather than V.x , etc.
 This allows type compatibility with references to the same quantities as an
 array of three values, which not only allows indexing operations (for i := X..Z do ...)
 but should also be more consistent with the Matrices unit.
                                                                    3/10/04}

interface

uses
  Classes,
  CRT_Ops,
  Trig_Fns;  {Note: this is used only by the sample procedure "RotateVector"}


{PREDEFINED TYPE}

type
   TVectorIndex  = (X,Y,Z);

   TVector = array[TVectorIndex] of extended;

   TVectorValue = array[1..3] of extended;
  {this is a type-cast compatible reference to the same values, but indexed by 1..3}

   Ray = record  {the name "Line" is already in GRAPH unit}
      Origin,
      Direction : TVector
    end;

   Plane = record
      Point,
      Normal : TVector
    end;

   TCoordinateSystem = record
  {expressed by axes in ICRF system}
      UnitX,
      UnitY,
      UnitZ : TVector
    end;

  TPolarCoordinates = record
      Longitude, {[rad]}
      Latitude,  {[rad]}
      Radius
        : extended;
    end;


{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{PREDEFINED VECTORS}

var
  Ux, Uy, Uz : TVector;  {unit vectors for the three Cartesian axes}
  ZeroVector : TVector;

procedure AssignToVector(var V : TVector; const X_value, Y_value, Z_value : extended);
{creates vector V and sets its Cartesian components equal to x, y, and z}

procedure UpdateVector(var V : TVector;  const NumDecPlaces : integer;
  const VectorName : string);
{provides screen dialog for updating xyz-vector components}

procedure PromptToRotateVector(var V : TVector; const Name : string; const NumDec : integer);
{prompts user to modify an existing vector by rotation about a specified axis}

{ELEMENTARY VECTOR OPERATIONS}

procedure VectorSum(const V1, V2 : TVector; var V3 : TVector);
{returns sum of vectors V1 and V2 in V3}

procedure CrossProduct(const V1, V2 : TVector; var V3 : TVector);
{returns vector product V1xV2 in V3}

function DotProduct(const V1, V2 : TVector) : extended;
{returns scalar product V1.V2}

function EqualVectors(const V1, V2 : TVector) : boolean;
{tests for equality of two vectors and returns result}

{SAMPLE TOOLS DERIVED FROM ELEMENTARY OPERATIONS}

procedure RotateCoordinateSystem(var CS : TCoordinateSystem; const Euler1, Euler2, Euler3 : extended);
{transforms a coordinate system by rotating by Euler1 about z-axis; then Euler2
 about new x-axis; and finally Euler3 about new z-axis.  The three angles are
 in radians and CCW.}

procedure ProjectVector(const InitialVector : TVector; const CS : TCoordinateSystem;  var CS_Vector : TVector);
{computes components of InitialVector in CS, assumes both are specified in same system}

procedure UnProjectVector(const CS_Vector : TVector; const CS : TCoordinateSystem;  var InitialVector : TVector);
{determines InitialVector which has the specified components when projected into CS}

procedure VectorDifference(const V1, V2 : TVector; var V3 : TVector);
{returns difference vector V1 minus vector V2 in V3}

function VectorModSqr(const V : TVector): extended;
{returns square of length of vector V}

function VectorMagnitude(const V : TVector): extended;
{returns length of vector V}

function VectorString(const V : TVector; const D : integer) : string;
{writes vector in form '(V[x]:0:D, V[y]:0:D, V[z]:0:D)' where D = number of decimal
 places desired in display;  disposes of V if it was an intermediate result}

function FixedWidthVectorString(const V : TVector; const W, D : integer) : string;
{writes vector in form '(V[x]:W:D, V[y]:W:D, V[z]:W:D)' where D = number of decimal
 places desired in display and W is the width;  disposes of V if it was an intermediate result}

procedure MultiplyVector(const A : extended; var V : TVector);
{transforms vector V --> A*V}

procedure DivideVector(var V : TVector; const A : extended);
{transforms vector V --> V/A}

procedure NormalizeVector(var V : TVector);
{transforms vector V into a unit vector in the original direction}

procedure RotateVector(var V : TVector; const Angle : radians; const Axis : TVector);
{rotates vector V ccw by Angle radians about Axis.}

procedure TransverseVector(const RayDirection, Axis : TVector; var Result : TVector);
{given unit vectors RayDirection and Axis, produces as Result a unit vector
 which is in the plane of the first two and perpendicular to RayDirection.
 If the first two vectors are parallel, this operation is not defined and
 the ZeroVector is returned}

procedure CrossVector(const RayDirection, Axis : TVector; var Result : TVector);
{same as, but orthogonal to, "TransverseVector" -- i.e., returns unit vector
 TransverseVector cross RayDirection (parallel to Axis cross RayDirection)
 unless the given unit vectors are parallel in which case, this operation is
 not defined and the ZeroVector is returned}

procedure CreateRay(var RayToCreate : ray; const Origin, Direction : TVector);
{initializes the components of a "ray"}

procedure CreatePlane(var PlaneToCreate : plane; const Point, Normal : TVector);
{initializes the components of a "plane"}

procedure IntersectLineWithPlane(const LineDescription : ray;
  const PlaneDescription : plane; var InterceptPoint : TVector;
  var InterceptValid : boolean);
{if InterceptValid, then InterceptPoint describes the point of intersection
 of the referenced line and plane;  otherwise, the line does not intersect
 the plane}

procedure IntersectTwoPlanes(const Plane1, Plane2 : plane;
  var InterceptLine : ray; var InterceptValid : boolean);
{if InterceptValid, then InterceptLine describes the intersection of the two
 referenced planes;  otherwise, the planes do not intersect}

procedure PointOfClosestApproach(const R1, R2 : ray; var P : TVector);
{determines the point P on R1 which is closest to R1.  It is assumed that
 the Direction vectors of R1 and R2 are unit vectors.  Halts with an error
 message if the two rays are parallel.  See LN003-106}

procedure MoveRayToPlane(var RayToMove : ray; const PlaneToMoveTo : plane;
                         var DistanceMoved : extended);
{if possible, moves Origin of RayToMove to lie on PlaneToMoveTo.
 DistanceMoved is the number of repetitions of the vector RayToMove.Direction
 which have to be added to the old Origin to get to the new one.  If Direction
 is a unit vector, then this will be the distance in the current unit system.
 Halts with error message if the ray is parallel to the plane}

procedure DescribeRay(const RayToDescribe: Ray; const RayID: string);
{prints 3-line description giving ID, Origin, and Direction}

function RayDescription(const RayToDescribe: Ray; const RayID: string): TStringList;
{same except result returned as TStringList}

procedure DescribePlane(const PlaneToDescribe: Plane; const PlaneID: string);
{prints 3-line description giving ID, Point, and Normal}

function PlaneDescription(const PlaneToDescribe: Plane; const PlaneID: string): TStringList;
{same except result returned as TStringList}

// functions useful for spherical trigonometry operations

procedure PolarToVector(const Lon_radians, Lat_radians, Radius : extended;  var VectorResult : TVector);
{returns vector in system with y-axis = north, z-axis = origin of longitude and latitude}

function VectorToPolar(const InputVector : TVector): TPolarCoordinates;
{InputVector is in system with y = north pole, z-axis = origin of longitude and latitude}

procedure ComputeDistanceAndBearing(const Lon1, Lat1, Lon2, Lat2 : extended; var AngleBetween, Bearing : extended);
{all arguments in radians}

implementation

procedure AssignToVector(var V : TVector; const X_value, Y_value, Z_value : extended);
{sets Cartesian components equal to X_value, Y_value, and Z_value}
  begin
    V[X] := X_value;
    V[Y] := Y_value;
    V[Z] := Z_value;
  end;

procedure UpdateVector(var V : TVector;  const NumDecPlaces : integer;
  const VectorName : string);
{provides screen dialog for updating xyz-vector components}
  begin
    writeln('Current value of '+VectorName+' is:  '+VectorString(V,NumDecPlaces));
      begin
        UpdateExtendedVariable(V[x],NumDecPlaces,'  New x-component');
        UpdateExtendedVariable(V[y],NumDecPlaces,'  New y-component');
        UpdateExtendedVariable(V[z],NumDecPlaces,'  New z-component');
      end;
  end;

procedure VectorSum(const V1, V2 : TVector; var V3 : TVector);
{returns sum of vectors V1 and V2 in V3}
  begin
{    AssignToVector(V3, V1[X] + V2[X], V1[Y] + V2[Y], V1[Z] + V2[Z]);}
      begin
        V3[x] := V1[X] + V2[X];
        V3[y] := V1[Y] + V2[Y];
        V3[z] := V1[Z] + V2[Z];
      end;
  end;


procedure RotateCoordinateSystem(var CS : TCoordinateSystem; const Euler1, Euler2, Euler3 : extended);
{transforms a coordinate system by rotating by Euler1 about z-axis; then Euler2
 about new x-axis; and finally Euler3 about new z-axis.  The three angles are
 in radians and CCW.}
  begin
    with CS do
      begin
      {rotate by Euler1 about ICRF z-axis}
        RotateVector(UnitX,Euler1,UnitZ);
        RotateVector(UnitY,Euler1,UnitZ);

      {rotate by Euler2 about new x-axis}
        RotateVector(UnitY,Euler2,UnitX);
        RotateVector(UnitZ,Euler2,UnitX);

      {rotate by Euler3 about new z-axis}
        RotateVector(UnitX,Euler3,UnitZ);
        RotateVector(UnitY,Euler3,UnitZ);
      end;
  end;

procedure ProjectVector(const InitialVector : TVector; const CS : TCoordinateSystem;  var CS_Vector : TVector);
{computes components of InitialVector in CS, assumes both are specified in same system}
  begin
    with CS do
      begin
        CS_Vector[X] := DotProduct(InitialVector,UnitX);
        CS_Vector[Y] := DotProduct(InitialVector,UnitY);
        CS_Vector[Z] := DotProduct(InitialVector,UnitZ);
      end;
  end;

procedure UnProjectVector(const CS_Vector : TVector; const CS : TCoordinateSystem;  var InitialVector : TVector);
{determines InitialVector which has the specified components when projected into CS}
  var
    Vx, Vy, Vz : TVector;
  begin
    with CS do
      begin
        Vx := UnitX;
        MultiplyVector(CS_Vector[X],Vx);
        Vy := UnitY;
        MultiplyVector(CS_Vector[Y],Vy);
        Vz := UnitZ;
        MultiplyVector(CS_Vector[Z],Vz);
        VectorSum(Vx,Vy,InitialVector);
        VectorSum(InitialVector,Vz,InitialVector);
      end;
  end;

procedure VectorDifference(const V1, V2 : TVector; var V3 : TVector);
{returns difference vector V1 minus vector V2 in V3}
  begin
{    AssignToVector(V3, V1[X] - V2[X], V1[Y] - V2[Y], V1[Z] - V2[Z]);}
      begin
        V3[x] := V1[X] - V2[X];
        V3[y] := V1[Y] - V2[Y];
        V3[z] := V1[Z] - V2[Z];
      end;
  end;


procedure CrossProduct(const V1, V2 : TVector; var V3 : TVector);
{returns vector product V1xV2 in V3}
  begin
{    AssignToVector(V3, V1[Y]*V2[Z] - V1[Z]*V2[Y],
      V1[Z]*V2[X] - V1[X]*V2[Z], V1[X]*V2[Y] - V1[Y]*V2[X]);}
      begin
        V3[x] := V1[Y]*V2[Z] - V1[Z]*V2[Y];
        V3[y] := V1[Z]*V2[X] - V1[X]*V2[Z];
        V3[z] := V1[X]*V2[Y] - V1[Y]*V2[X];
      end;
  end;


function DotProduct(const V1, V2 : TVector) : extended;
{returns scalar product V1.V2}
  begin
    DotProduct := V1[X]*V2[X] + V1[Y]*V2[Y] + V1[Z]*V2[Z];
  end;


function EqualVectors(const V1, V2 : TVector) : boolean;
{tests for equality of two vectors and returns result}
  begin
    EqualVectors := (V1[X]=V2[X]) and (V1[Y]=V2[Y]) and (V1[Z]=V2[Z])
  end;

function VectorModSqr(const V : TVector): extended;
{returns square of length of vector V}
  begin
{    VectorModSqr := DotProduct(V,V);}
    VectorModSqr := sqr(V[x]) + sqr(V[y]) + sqr(V[z]);
  end;

function VectorMagnitude(const V : TVector): extended;
{returns length of vector V}
  begin
{    VectorMagnitude := sqrt(VectorModSqr(V));}
    VectorMagnitude := sqrt(sqr(V[x]) + sqr(V[y]) + sqr(V[z]));
  end;

function VectorString(const V : TVector; const D : integer) : string;
{writes vector in form '(V[x]:0:D, V[y]:0:D, V[z]:0:D)' where D = number of decimal
 places desired in display;  disposes of V if it was an intermediate result}
  var
    Xcomp, Ycomp, Zcomp : string;
  begin
      begin
        str(V[x]:0:D,Xcomp);  {Note: V[x] = DotProduct(Ux,V)}
        str(V[y]:0:D,Ycomp);
        str(V[z]:0:D,Zcomp)
      end;
    VectorString := '(' + Xcomp + ', ' + Ycomp + ', ' + Zcomp + ')';
  end;

function FixedWidthVectorString(const V : TVector; const W, D : integer) : string;
{writes vector in form '(V[x]:W:D, V[y]:W:D, V[z]:W:D)' where D = number of decimal
 places desired in display and W is the width;  disposes of V if it was an intermediate result}
  var
    Xcomp, Ycomp, Zcomp : string;
  begin
      begin
        str(V[x]:W:D,Xcomp);  {Note: V[x] = DotProduct(Ux,V)}
        str(V[y]:W:D,Ycomp);
        str(V[z]:W:D,Zcomp)
      end;
    FixedWidthVectorString := '(' + Xcomp + ', ' + Ycomp + ', ' + Zcomp + ')';
  end;


procedure MultiplyVector(const A : extended; var V : TVector);
{transforms vector V --> A*V}
  begin
      begin
        V[x] := A*V[x];
        V[y] := A*V[y];
        V[z] := A*V[z];
      end;
  end;


procedure DivideVector(var V : TVector; const A : extended);
{transforms vector V --> V/A}
  begin
    if A=0 then
      begin
        writeln('Error: trying to divide vector by 0 in DivideVector');
        Halt
      end
    else
      MultiplyVector(1/A,V)
  end;


procedure NormalizeVector(var V : TVector);
{transforms vector V into a unit vector in the original direction}
  var
    Length : extended;
  begin
    Length := VectorMagnitude(V);
    if Length=0 then
      HaltForError('Error: unable to normalize vector of length 0','MVectors')
    else
      DivideVector(V,Length)
  end;


procedure RotateVector(var V : TVector; const Angle : radians; const Axis : TVector);
{rotates vector V ccw by Angle radians about Axis, disposes of Axis if
 it was an intermediate result.  See LN003:102 for explanation}
  var
    R, I1, I2, I3 : TVector;
    Cosine : extended;
  begin
    R := Axis;  {releases Axis}
    NormalizeVector(R);
    Cosine := cos(Angle);

    I1 := V;
    MultiplyVector(Cosine,I1);

    CrossProduct(R,V,I2);
    MultiplyVector(sin(Angle),I2);

    I3 := R;
    MultiplyVector( (1 - Cosine)*DotProduct(R,V), I3);

    VectorSum(I1,I2,V);
    VectorSum(V,I3,V);
  end;

procedure PromptToRotateVector(var V : TVector; const Name : string; const NumDec : integer);
{prompts user to modify an existing vector by rotation about a specified axis}
  var
    WantToChange : boolean;
    RotationAxis : TVector;
    Angle : extended;
  begin
    WantToChange := false;
    UpdateBooleanVariable(WantToChange,'Modify '+Name+' by rotation');
    if WantToChange then
      begin
        writeln('Present value of '+Name+' = '+VectorString(V,NumDec));
        RotationAxis := Uy;
        Angle := 0;
        UpdateVector(RotationAxis,NumDec,'rotation axis');
        UpdateExtendedVariable(Angle,NumDec,'CCW rotation angle [deg]');
        RotateVector(V,DtoR(Angle),RotationAxis);
        writeln('New value of '+Name+' = '+VectorString(V,NumDec));
        writeln;
      end;
  end;

procedure IntersectLineWithPlane(const LineDescription : ray;
  const PlaneDescription : plane; var InterceptPoint : TVector;
  var InterceptValid : boolean);
{if InterceptValid, then InterceptPoint describes the point of intersection
 of the referenced line and plane;  otherwise, the line does not intersect
 the plane}
  var
    V : TVector;
    d, da : extended;

  begin
    with LineDescription do with PlaneDescription do
      begin
        VectorDifference(Point,Origin,V);
        d := DotProduct(V,Normal);
        if d=0 then {Origin already in plane}
          begin
            InterceptValid := true;
            InterceptPoint := Origin;
          end
        else
          begin
            da := DotProduct(Direction,Normal);
            if da<>0 then
              begin
                InterceptValid := true;
                V := Direction;
                MultiplyVector(d/da,V);
                VectorSum(Origin,V,InterceptPoint);
              end
            else
              InterceptValid := false;
          end;
      end;
  end;


procedure IntersectTwoPlanes(const Plane1, Plane2 : plane;
  var InterceptLine : ray; var InterceptValid : boolean);
{if InterceptValid, then InterceptLine describes the intersection of the two
 referenced planes;  otherwise, the planes do not intersect. See LN003-107}
  var
    Mag : extended;
    V1, V2 : TVector;
  begin
    with InterceptLine do
      begin
        CrossProduct(Plane1.Normal,Plane2.Normal,Direction);
        Mag := VectorMagnitude(Direction);
        if Mag<1.0e-20 then
          begin {planes are parallel so there is no unique intersection line}
            InterceptValid := false;
          end
        else
          begin
            InterceptValid := true;
            DivideVector(Direction,Mag);  {necessary iff unit-vector result is desired}
            CrossProduct(Plane1.Normal,Direction,V1);
            VectorDifference(Plane2.Point,Plane1.Point,V2);
            MultiplyVector(DotProduct(V2,Plane2.Normal)/DotProduct(V1,Plane2.Normal),
              V1);
            VectorSum(Plane1.Point,V1,Origin);
          end;
      end;
  end;

procedure TransverseVector(const RayDirection, Axis : TVector; var Result : TVector);
{given unit vectors RayDirection and Axis, produces as Result a unit vector
 which is in the plane of the first two and perpendicular to RayDirection.
 If the first two vectors are parallel, this operation is not defined and
 the ZeroVector is returned}
  var
    DotProd : extended;
  begin
    DotProd := DotProduct(RayDirection,Axis);
    if abs(DotProd)>=1 then
      Result := ZeroVector
    else
      begin
        Result := RayDirection;
        MultiplyVector(DotProd,Result);
        VectorDifference(Axis,Result,Result);
        DivideVector(Result,sqrt(1.0 - sqr(DotProd)));
      end;
  end;

procedure CrossVector(const RayDirection, Axis : TVector; var Result : TVector);
{same as, but orthogonal to, "TransverseVector" -- i.e., returns unit vector
 TransverseVector cross RayDirection (parallel to Axis cross RayDirection)
 unless the given unit vectors are parallel in which case, this operation is
 not defined and the ZeroVector is returned}
  begin
    CrossProduct(Axis,RayDirection,Result);
    if not EqualVectors(Result,ZeroVector) then NormalizeVector(Result);
  end;

procedure CreateRay(var RayToCreate : ray; const Origin, Direction : TVector);
  begin
    RayToCreate.Origin := Origin;
    RayToCreate.Direction := Direction;
  end;

procedure CreatePlane(var PlaneToCreate : plane; const Point, Normal : TVector);
  begin
    PlaneToCreate.Point:= Point;
    PlaneToCreate.Normal := Normal;
  end;

procedure PointOfClosestApproach(const R1, R2 : ray; var P : TVector);
{determines the point P on R1 which is closest to R1.  It is assumed that
 the Direction vectors of R1 and R2 are unit vectors.  Halts with an error
 message if the two rays are parallel.  See LN003-106}
  var
    DeltaR12 : TVector;
    DotProd12, Num, Denom : extended;
  begin
    DotProd12 := DotProduct(R1.Direction,R2.Direction);
    if abs(DotProd12)<1.0 then
      begin
        VectorDifference(R1.Origin,R2.Origin,DeltaR12);
        Num := DotProduct(DeltaR12,R2.Direction)*DotProd12 -
               DotProduct(DeltaR12,R1.Direction);
        Denom := 1.0 - sqr(DotProd12);
        P := R1.Direction;
        MultiplyVector(Num/Denom,P);
        VectorSum(R1.Origin,P,P);
      end
    else
    {rays parallel -- alternatively could return Origin of R1}
      begin
        PrepareToHalt;
        writeln;
        writeln('   Ray 1 :   Origin = '+VectorString(R1.Origin,4)+
          ' and Direction = '+VectorString(R1.Direction,4));
        writeln('   Ray 2 :   Origin = '+VectorString(R2.Origin,4)+
          ' and Direction = '+VectorString(R2.Direction,4));
        writeln('            *** These two rays are parallel ***');
        writeln;
        HaltForError('It is impossible to find a unique point of closest approach','MVectors');
      end;
{Note:
    at closest approach --

      DistanceSqrd := VectorModSqr(DeltaR12)
          - sqr(DotProduct(DeltaR12,R2.Direction)) - sqr(Num)/Denom;

    where the last term is omitted if the rays are parallel. }

  end;

procedure MoveRayToPlane(var RayToMove : ray; const PlaneToMoveTo : plane;
                         var DistanceMoved : extended);
{if possible, moves Origin of RayToMove to lie on PlaneToMoveTo.
 DistanceMoved is the number of repetitions of the vector RayToMove.Direction
 which have to be added to the old Origin to get to the new one.  If Direction
 is a unit vector, then this will be the distance in the current unit system.}
  var
    V : TVector;
    d, da : extended;

  begin
    with RayToMove do with PlaneToMoveTo do
      begin
        VectorDifference(Point,Origin,V);
        d := DotProduct(V,Normal);
        if d=0 then {Origin is already in plane}
          DistanceMoved := 0
        else
          begin
            da := DotProduct(Direction,Normal);
            if da<>0 then
              begin
                DistanceMoved := d/da;
                V := Direction;
                MultiplyVector(DistanceMoved,V);
                VectorSum(Origin,V,Origin);
              end
            else
              begin
                PrepareToHalt;
                writeln('*** Ray starting at  '+VectorString(Origin,4));
                writeln('  and travelling in direction  '+VectorString(Direction,4));
                writeln('is PARALLEL to plane defined by');
                writeln('  Point : '+VectorString(Point,4)+'   Normal : '+
                   VectorString(Normal,4));
                writeln('so it is impossible to find an intercept');
                writeln;
                HaltForError('','XTL_Ops');
              end;
          end;
      end;
  end;

procedure DescribeRay(const RayToDescribe: Ray; const RayID: string);
  begin
    writeln(RayID+':');
    writeln('   Origin    = '+VectorString(RayToDescribe.Origin,6));
    writeln('   Direction = '+VectorString(RayToDescribe.Direction,6));
  end;

function RayDescription(const RayToDescribe: Ray; const RayID: string): TStringList;
  begin
    Result := TStringList.Create;
    Result.Add(RayID+':');
    Result.Add('   Origin    = '+VectorString(RayToDescribe.Origin,6));
    Result.Add('   Direction = '+VectorString(RayToDescribe.Direction,6));
  end;

procedure DescribePlane(const PlaneToDescribe: Plane; const PlaneID: string);
  begin
    writeln(PlaneID+':');
    writeln('   Center = '+VectorString(PlaneToDescribe.Point,6));
    writeln('   Normal = '+VectorString(PlaneToDescribe.Normal,6));
  end;

function PlaneDescription(const PlaneToDescribe: Plane; const PlaneID: string): TStringList;
  begin
    Result := TStringList.Create;
    Result.Add(PlaneID+':');
    Result.Add('   Center = '+VectorString(PlaneToDescribe.Point,6));
    Result.Add('   Normal = '+VectorString(PlaneToDescribe.Normal,6));
  end;

procedure PolarToVector(const Lon_radians, Lat_radians, Radius : extended;  var VectorResult : TVector);
{determines vector components of a point in polar form taking
  y-axis = polar direction
  z-axis = origin of Longitude (which is measured CCW about y-axis)
  x-axis = y cross z
 Lat, Lon are in radians }
  begin
    VectorResult[x] := Radius*Sin(Lon_radians)*Cos(Lat_radians);
    VectorResult[y] := Radius*Sin(Lat_radians);
    VectorResult[z] := Radius*Cos(Lon_radians)*Cos(Lat_radians);
  end;

function VectorToPolar(const InputVector : TVector): TPolarCoordinates;
{InputVector is in system with y = north pole, z-axis = origin of longitude and latitude}
begin
  Result.Radius := VectorMagnitude(InputVector);
  Result.Latitude := Asin(InputVector[y]/Result.Radius);       // formerly used routines in Math unit
  Result.Longitude := Atan2(InputVector[x],InputVector[z]);
end;

procedure ComputeDistanceAndBearing(const Lon1, Lat1, Lon2, Lat2 : extended; var AngleBetween, Bearing : extended);
var
  SinLat1, CosLat1, SinLat2, CosLat2, CosTheta, SinTheta,
  CosThetaSqrd, Denom, PolarAngle, CosAz, SinAz : extended;
begin
    PolarAngle := Lon2 - Lon1;
    SinLat1 := Sin(Lat1);
    CosLat1 := Cos(Lat1);
    SinLat2 := Sin(Lat2);
    CosLat2 := Cos(Lat2);
    CosTheta := SinLat1*SinLat2 + CosLat1*CosLat2*Cos(PolarAngle);
    CosThetaSqrd := Sqr(CosTheta);
    if CosThetaSqrd>=1 then // note: can only be >1 due to round-off error
      begin
        AngleBetween := 0;
        Bearing := 0;
      end
    else
      begin
        AngleBetween := ACos(CosTheta);

        SinTheta := Sqrt(1-CosThetaSqrd);
        Denom := CosLat1*SinTheta;
        if Denom=0 then
          Bearing := 0
        else
          begin
            CosAz := (SinLat1*CosTheta - SinLat2)/Denom;
            SinAz := Sin(PolarAngle)*CosLat2/SinTheta;
            Bearing := Pi - ATan2(SinAz,CosAz);
          end;
      end;
end;

begin
  AssignToVector(Ux,1,0,0);
  AssignToVector(Uy,0,1,0);
  AssignToVector(Uz,0,0,1);
  AssignToVector(ZeroVector,0,0,0);
end.