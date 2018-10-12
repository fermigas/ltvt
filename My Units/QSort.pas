unit QSort;

interface

procedure SortExtendedArray(var a: array of extended);

procedure SortIntegerArray(var a: array of integer);

function MedianOfExtendedArray(var a: array of extended) : extended;
{Sorts the array and returns the median value -- either the exact middle value
if the number of elements is odd, or the value midway between the two central
values of the number of elements is even}

implementation

procedure SortExtendedArray(var a: array of extended {; var SI:  array of integer});
{on call: "a" is an open array of data;  SI is an externally intialized array
  of integer indicies, such as [1,2,3,...]
 on return:  the values in "a" are rearranged in sequence of increasing
  value;  the values in SI are rearranged in the same way:  e.g. SI = [3,1,2,...]
  indicates that the first "a" value was number 3 in the original list, etc.}

{following adapted from \sw\lang\pascal\tp7\examples\QSORT.PAS}
  procedure Sort(l, r: Integer);
  var
    i, j{, k}: integer;
    x, y: extended;
  begin {Sort}
    i := l; j := r; x := a[(l+r) DIV 2];
    repeat
      while a[i] < x do i := i + 1;
      while x < a[j] do j := j - 1;
      if i <= j then
      begin
        y := a[i]; {k := SI[i];}
        a[i] := a[j]; {SI[i] := SI[j];}
        a[j] := y;  {SI[j] := k;}
        i := i + 1; j := j - 1;
      end;
    until i > j;
    if l < j then Sort(l, j);
    if i < r then Sort(i, r);
  end; {Sort}

begin {SortExtendedArray}
  Sort(Low(a),High(a));
end;  {SortExtendedArray}

procedure SortIntegerArray(var a: array of integer);
  procedure Sort(l, r: Integer);
  var
    i, j{, k}: integer;
    x, y: integer;
  begin {Sort}
    i := l; j := r; x := a[(l+r) DIV 2];
    repeat
      while a[i] < x do i := i + 1;
      while x < a[j] do j := j - 1;
      if i <= j then
      begin
        y := a[i]; {k := SI[i];}
        a[i] := a[j]; {SI[i] := SI[j];}
        a[j] := y;  {SI[j] := k;}
        i := i + 1; j := j - 1;
      end;
    until i > j;
    if l < j then Sort(l, j);
    if i < r then Sort(i, r);
  end; {Sort}

begin {SortIntegerArray}
  Sort(Low(a),High(a));
end;  {SortIntegerArray}

function MedianOfExtendedArray(var a: array of extended) : extended;
var
  Quotient, Remainder : integer;
begin
  SortExtendedArray(a);
  Quotient := Length(a) div 2;
  Remainder := Length(a) mod 2;
  if Remainder=1 then
    Result := a[Quotient]
  else{even number of elements -- interpolate}
    Result := (a[Quotient] + a[Quotient-1])/2;
end;
end.
