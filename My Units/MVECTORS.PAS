unit MVectors;
{This unit provides 3-vectors in matrix form.  Since they are a structured
 data type they cannot be returned as the results of functions, as was done
 previously in VECTORS.PAS.                                        8/31/97}

interface

uses
  Classes,
  CRT_Ops,
  Trig_Fns;  {Note: this is used only by the sample procedure "Rotate"}


{PREDEFINED TYPE}

type
  Vector = record
    x,y,z : extended;  {components on three axes}
    end;

  Ray = record  {the name "Line" is already in GRAPH unit}
      Origin,
      Direction : vector
    end;

  Plane = record
      Point,
      Normal : vector
    end;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{PREDEFINED VECTORS}

var
  Ux, Uy, Uz : vector;  {unit vectors for the three Cartesian axes}
  ZeroVector : vector;

procedure AssignToVector(var V : vector; const x, y, z : extended);
{creates vector V and sets its Cartesian components equal to x, y, and z}

procedure UpdateVector(var V : vector;  const NumDecPlaces : integer;
  const VectorName : string);
{provides screen dialog for updating xyz-vector components}

procedure PromptToRotateVector(var V : vector; const Name : string; const NumDec : integer);
{prompts user to modify an existing vector by rotation about a specified axis}

{ELEMENTARY VECTOR OPERATIONS}

procedure Sum(const V1, V2 : vector; var V3 : vector);
{returns sum of vectors V1 and V2 in V3}

procedure CrossProduct(const V1, V2 : vector; var V3 : vector);
{returns vector product V1xV2 in V3}

function DotProduct(const V1, V2 : vector) : extended;
{returns scalar product V1.V2}

function EqualVectors(const V1, V2 : vector) : boolean;
{tests for equality of two vectors and returns result}

{SAMPLE TOOLS DERIVED FROM ELEMENTARY OPERATIONS}

procedure Difference(const V1, V2 : vector; var V3 : vector);
{returns difference of vectors V1 and V2 in V3}

function ModSqr(const V : vector): extended;
{returns square of length of vector V}

function Magnitude(const V : vector): extended;
{returns length of vector V}

function VectorString(const V : vector; const D : integer) : string;
{writes vector in form '(x:0:D, y:0:D, z:0:D)' where D = number of decimal
 places desired in display;  disposes of V if it was an intermediate result}

function FixedWidthVectorString(const V : vector; const W, D : integer) : string;
{writes vector in form '(x:W:D, y:W:D, z:W:D)' where D = number of decimal
 places desired in display and W is the width;  disposes of V if it was an intermediate result}

procedure Multiply(const A : extended; var V : vector);
{transforms vector V --> A*V}

procedure Divide(var V : vector; const A : extended);
{transforms vector V --> V/A}

procedure Normalize(var V : vector);
{transforms vector V into a unit vector in the original direction}

procedure Rotate(var V : vector; const Angle : radians; const Axis : vector);
{rotates vector V ccw by Angle radians about Axis.}

procedure TransverseVector(const RayDirection, Axis : vector; var Result : vector);
{given unit vectors RayDirection and Axis, produces as Result a unit vector
 which is in the plane of the first two and perpendicular to RayDirection.
 If the first two vectors are parallel, this operation is not defined and
 the ZeroVector is returned}

procedure CrossVector(const RayDirection, Axis : vector; var Result : vector);
{same as, but orthogonal to, "TransverseVector" -- i.e., returns unit vector
 TransverseVector cross RayDirection (parallel to Axis cross RayDirection)
 unless the given unit vectors are parallel in which case, this operation is
 not defined and the ZeroVector is returned}

procedure CreateRay(var RayToCreate : ray; const Origin, Direction : vector);
{initializes the components of a "ray"}

procedure CreatePlane(var PlaneToCreate : plane; const Point, Normal : vector);
{initializes the components of a "plane"}

procedure IntersectLineWithPlane(const LineDescription : ray;
  const PlaneDescription : plane; var InterceptPoint : vector;
  var InterceptValid : boolean);
{if InterceptValid, then InterceptPoint describes the point of intersection
 of the referenced line and plane;  otherwise, the line does not intersect
 the plane}

procedure IntersectTwoPlanes(const Plane1, Plane2 : plane;
  var InterceptLine : ray; var InterceptValid : boolean);
{if InterceptValid, then InterceptLine describes the intersection of the two
 referenced planes;  otherwise, the planes do not intersect}

procedure PointOfClosestApproach(const R1, R2 : ray; var P : vector);
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

implementation

procedure AssignToVector(var V : vector; const x, y, z : extended);
{creates vector V and sets its Cartesian components equal to x, y, and z}
  begin
    V.x := x;
    V.y := y;
    V.z := z;
  end;

procedure UpdateVector(var V : vector;  const NumDecPlaces : integer;
  const VectorName : string);
{provides screen dialog for updating xyz-vector components}
  begin
    writeln('Current value of '+VectorName+' is:  '+VectorString(V,NumDecPlaces));
    with V do
      begin
        UpdateExtendedVariable(x,NumDecPlaces,'  New x-component');
        UpdateExtendedVariable(y,NumDecPlaces,'  New y-component');
        UpdateExtendedVariable(z,NumDecPlaces,'  New z-component');
      end;
  end;

procedure Sum(const V1, V2 : vector; var V3 : vector);
{returns sum of vectors V1 and V2 in V3}
  begin
{    AssignToVector(V3, V1.x + V2.x, V1.y + V2.y, V1.z + V2.z);}
    with V3 do
      begin
        x := V1.x + V2.x;
        y := V1.y + V2.y;
        z := V1.z + V2.z;
      end;
  end;


procedure Difference(const V1, V2 : vector; var V3 : vector);
{returns difference of vectors V1 and V2 in V3}
  begin
{    AssignToVector(V3, V1.x - V2.x, V1.y - V2.y, V1.z - V2.z);}
    with V3 do
      begin
        x := V1.x - V2.x;
        y := V1.y - V2.y;
        z := V1.z - V2.z;
      end;
  end;


procedure CrossProduct(const V1, V2 : vector; var V3 : vector);
{returns vector product V1xV2 in V3}
  begin
{    AssignToVector(V3, V1.y*V2.z - V1.z*V2.y,
      V1.z*V2.x - V1.x*V2.z, V1.x*V2.y - V1.y*V2.x);}
    with V3 do
      begin
        x := V1.y*V2.z - V1.z*V2.y;
        y := V1.z*V2.x - V1.x*V2.z;
        z := V1.x*V2.y - V1.y*V2.x;
      end;
  end;


function DotProduct(const V1, V2 : vector) : extended;
{returns scalar product V1.V2}
  begin
    DotProduct := V1.x*V2.x + V1.y*V2.y + V1.z*V2.z;
  end;


function EqualVectors(const V1, V2 : vector) : boolean;
{tests for equality of two vectors and returns result}
  begin
    EqualVectors := (V1.x=V2.x) and (V1.y=V2.y) and (V1.z=V2.z)
  end;

function ModSqr(const V : vector): extended;
{returns square of length of vector V}
  begin
{    ModSqr := DotProduct(V,V);}
    with V do ModSqr := sqr(x) + sqr(y) + sqr(z);
  end;

function Magnitude(const V : vector): extended;
{returns length of vector V}
  begin
{    Magnitude := sqrt(ModSqr(V));}
    with V do Magnitude := sqrt(sqr(x) + sqr(y) + sqr(z));
  end;

function VectorString(const V : vector; const D : integer) : string;
{writes vector in form '(x:0:D, y:0:D, z:0:D)' where D = number of decimal
 places desired in display;  disposes of V if it was an intermediate result}
  var
    Xcomp, Ycomp, Zcomp : string;
  begin
    with V do
      begin
        str(x:0:D,Xcomp);  {Note: x = DotProduct(Ux,V)}
        str(y:0:D,Ycomp);
        str(z:0:D,Zcomp)
      end;
    VectorString := '(' + Xcomp + ', ' + Ycomp + ', ' + Zcomp + ')';
  end;

function FixedWidthVectorString(const V : vector; const W, D : integer) : string;
{writes vector in form '(x:W:D, y:W:D, z:W:D)' where D = number of decimal
 places desired in display and W is the width;  disposes of V if it was an intermediate result}
  var
    Xcomp, Ycomp, Zcomp : string;
  begin
    with V do
      begin
        str(x:W:D,Xcomp);  {Note: x = DotProduct(Ux,V)}
        str(y:W:D,Ycomp);
        str(z:W:D,Zcomp)
      end;
    FixedWidthVectorString := '(' + Xcomp + ', ' + Ycomp + ', ' + Zcomp + ')';
  end;


procedure Multiply(const A : extended; var V : vector);
{transforms vector V --> A*V}
  begin
    with V do
      begin
        x := A*x;
        y := A*y;
        z := A*z;
      end;
  end;


procedure Divide(var V : vector; const A : extended);
{transforms vector V --> V/A}
  begin
    if A=0 then
      begin
        writeln('Error: trying to divide vector by 0 in Divide');
        Halt
      end
    else
      Multiply(1/A,V)
  end;


procedure Normalize(var V : vector);
{transforms vector V into a unit vector in the original direction}
  var
    Length : extended;
  begin
    Length := Magnitude(V);
    if Length=0 then
      HaltForError('Error: unable to normalize vector of length 0','MVectors')
    else
      Divide(V,Length)
  end;


procedure Rotate(var V : vector; const Angle : radians; const Axis : vector);
{rotates vector V ccw by Angle radians about Axis, disposes of Axis if
 it was an intermediate result.  See LN003:102 for explanation}
  var
    R, I1, I2, I3 : vector;
    Cosine : extended;
  begin
    R := Axis;  {releases Axis}
    Normalize(R);
    Cosine := cos(Angle);

    I1 := V;
    Multiply(Cosine,I1);

    CrossProduct(R,V,I2);
    Multiply(sin(Angle),I2);

    I3 := R;
    Multiply( (1 - Cosine)*DotProduct(R,V), I3);

    Sum(I1,I2,V);
    Sum(V,I3,V);
  end;

procedure PromptToRotateVector(var V : vector; const Name : string; const NumDec : integer);
{prompts user to modify an existing vector by rotation about a specified axis}
  var
    WantToChange : boolean;
    RotationAxis : vector;
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
        Rotate(V,DtoR(Angle),RotationAxis);
        writeln('New value of '+Name+' = '+VectorString(V,NumDec));
        writeln;
      end;
  end;

procedure IntersectLineWithPlane(const LineDescription : ray;
  const PlaneDescription : plane; var InterceptPoint : vector;
  var InterceptValid : boolean);
{if InterceptValid, then InterceptPoint describes the point of intersection
 of the referenced line and plane;  otherwise, the line does not intersect
 the plane}
  var
    V : vector;
    d, da : extended;

  begin
    with LineDescription do with PlaneDescription do
      begin
        Difference(Point,Origin,V);
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
                Multiply(d/da,V);
                Sum(Origin,V,InterceptPoint);
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
    V1, V2 : vector;
  begin
    with InterceptLine do
      begin
        CrossProduct(Plane1.Normal,Plane2.Normal,Direction);
        Mag := Magnitude(Direction);
        if Mag<1.0e-20 then
          begin {planes are parallel so there is no unique intersection line}
            InterceptValid := false;
          end
        else
          begin
            InterceptValid := true;
            Divide(Direction,Mag);  {necessary iff unit-vector result is desired}
            CrossProduct(Plane1.Normal,Direction,V1);
            Difference(Plane2.Point,Plane1.Point,V2);
            Multiply(DotProduct(V2,Plane2.Normal)/DotProduct(V1,Plane2.Normal),
              V1);
            Sum(Plane1.Point,V1,Origin);
          end;
      end;
  end;

procedure TransverseVector(const RayDirection, Axis : vector; var Result : vector);
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
        Multiply(DotProd,Result);
        Difference(Axis,Result,Result);
        Divide(Result,sqrt(1.0 - sqr(DotProd)));
      end;
  end;

procedure CrossVector(const RayDirection, Axis : vector; var Result : vector);
{same as, but orthogonal to, "TransverseVector" -- i.e., returns unit vector
 TransverseVector cross RayDirection (parallel to Axis cross RayDirection)
 unless the given unit vectors are parallel in which case, this operation is
 not defined and the ZeroVector is returned}
  begin
    CrossProduct(Axis,RayDirection,Result);
    if not EqualVectors(Result,ZeroVector) then Normalize(Result);
  end;

procedure CreateRay(var RayToCreate : ray; const Origin, Direction : vector);
  begin
    RayToCreate.Origin := Origin;
    RayToCreate.Direction := Direction;
  end;

procedure CreatePlane(var PlaneToCreate : plane; const Point, Normal : vector);
  begin
    PlaneToCreate.Point:= Point;
    PlaneToCreate.Normal := Normal;
  end;

procedure PointOfClosestApproach(const R1, R2 : ray; var P : vector);
{determines the point P on R1 which is closest to R1.  It is assumed that
 the Direction vectors of R1 and R2 are unit vectors.  Halts with an error
 message if the two rays are parallel.  See LN003-106}
  var
    DeltaR12 : vector;
    DotProd12, Num, Denom : extended;
  begin
    DotProd12 := DotProduct(R1.Direction,R2.Direction);
    if abs(DotProd12)<1.0 then
      begin
        Difference(R1.Origin,R2.Origin,DeltaR12);
        Num := DotProduct(DeltaR12,R2.Direction)*DotProd12 -
               DotProduct(DeltaR12,R1.Direction);
        Denom := 1.0 - sqr(DotProd12);
        P := R1.Direction;
        Multiply(Num/Denom,P);
        Sum(R1.Origin,P,P);
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

      DistanceSqrd := ModSqr(DeltaR12)
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
    V : vector;
    d, da : extended;

  begin
    with RayToMove do with PlaneToMoveTo do
      begin
        Difference(Point,Origin,V);
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
                Multiply(DistanceMoved,V);
                Sum(Origin,V,Origin);
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

begin
  AssignToVector(Ux,1,0,0);
  AssignToVector(Uy,0,1,0);
  AssignToVector(Uz,0,0,1);
  AssignToVector(ZeroVector,0,0,0);
end.