unit Matrices;
{Provides basic operations for real matrices of any order.  Assumes that the
 data is stored in an array of extended numbers with NxM components.
                                                                    8/29/95}

interface

uses CRT_Ops, SysUtils;

type
  LinearArray = array[1..6400] of extended;

const
  RespondToKeyPress : boolean = false;  {long operations, such as solving
   simultaneous equations will display current status if KeyPress is detected}

procedure DisplayMatrix(const Matrix; const N, M, W, D : integer);
{displays elements of matrix of order NxM in fields of width W with D decimals
 (upper left corner starts at current cursor position and cursor ends one space
 beyond lower right corner)}

procedure ClearMatrix(var Matrix ; const N,M : integer);
{fills NxM matrix of extended data with zeroes}

procedure CopyMatrix(const Original; var Copy; const N,M : integer);
{copies Original NxM matrix to Copy}

procedure TransposeMatrix(const A; var B; const N,M : integer);
{matrix A of order NxM is transposed into matrix B of order MxN}

procedure AddMatrices(const A, B; var C; const N,M : integer);
{adds matrix A to matrix B yielding matrix C, all of order NxM}

procedure SubtractMatrices(const A, B; var C; const N,M : integer);
{subtracts matrix B from matrix A yielding matrix C, all of order NxM}

procedure MultiplyMatrices(const A, B; var C; const M, N, P, Q : integer);
{multiplies matrix A of order MxN times matrix B of order PxQ yielding result
 of order MxQ in C.  (Must have N = P to multiply)

 Example:

 To multiply a 3x1 vector by a 3x3 rotation matrix:

   MultiplyMatrices(RotationMatrix,OldVector,NewVector,3,3,3,1);

 where OldVector and NewVector must be stored at different locations, since
 the values of the elements are effectively passed as pointers to the storage
 locations -- that if "B" and "C" are the same, "B" will become corrupted as
 "C" is modified.}

function Determinant(var Matrix; const N : integer): extended;
{returns the determinant of an NxN (square) matrix, destroying elements
 in process}

procedure SolveSimultan(var CoeffMatrix, Vector; const N : integer);
{solves M*X = B where B is a known N-vector and M a known NXN matrix.
 Before calling the routine, the values of M are placed in CoeffMatrix
 and the values of B in Vector.  On return, CoeffMatrix contains the
 LU decomposition and Vector the solution.  If the original data are
 needed again, they should first be copied and the copies passed to
 this routine}

implementation

function LIndex(const i,j,M : integer): integer;
{Returns index of matrix element i,j in a linear array starting at the same
 address using the fact that an NxM matrix is stored in memory in the sequence
      M[1,1], M[1,2], .. M[1,M],  M[2,1], M[2,2], .. M[2,M], .. M[N,M]
 (note: this routine always works, but in the interest of effiency other
    methods are used when the index to the next desired element of the linear
    array can be obtained by more direct means)     }
  begin
    LIndex := (i-1)*M + j
  end;

procedure DisplayMatrix(const Matrix; const N, M, W, D : integer);
 {displays elements of matrix of order NxM in fields of width W with
  D decimals -- see above for effect on cursor}
  var
    LA : LinearArray absolute Matrix;
    i,j, LAIndex  : integer;
    FormattedString : string;
  begin
    LAIndex := 0;
    for i := 1 to N do
      begin
        for j := 1 to M do
          begin
            inc(LAIndex);  {points to (i,j) element of array}
            Str(LA[LAIndex]:W:D,FormattedString);
            write(FormattedString);
          end;
        writeln;
      end;
  end;

procedure ClearMatrix(var Matrix ; const N,M : integer);
  begin
    FillChar(Matrix,longint(N)*longint(M)*SizeOf(extended),0)
  end;

procedure CopyMatrix(const Original; var Copy; const N,M : integer);
{copies Original NxM matrix to Copy}
  begin
    Move(Original,Copy,longint(N)*longint(M)*SizeOf(extended))
  end;

procedure TransposeMatrix(const A; var B; const N,M : integer);
  var
    LA1 : LinearArray absolute A;
    LA2 : LinearArray absolute B;
    i,j,LA1Index : integer;
  begin
    LA1Index := 0;
    for i := 1 to N do
      for j := 1 to M do
        begin
          inc(LA1Index);  {= LIndex(i,j,M) -- points to (i,j) element of B}
          LA2[LIndex(j,i,N)] := LA1[LA1Index];
        end;
  end;

procedure AddMatrices(const A, B; var C; const N,M : integer);
  var
    LA1 : LinearArray absolute A;
    LA2 : LinearArray absolute B;
    LA3 : LinearArray absolute C;
    i,j, LAIndex : integer;

  begin
    LAIndex := 0;
    for i := 1 to N do
      for j := 1 to M do
        begin
          inc(LAIndex);  {points to (i,j) element of array}
          LA3[LAIndex] := LA1[LAIndex] + LA2[LAIndex];
        end;
  end;

procedure SubtractMatrices(const A, B; var C; const N,M : integer);
  var
    LA1 : LinearArray absolute A;
    LA2 : LinearArray absolute B;
    LA3 : LinearArray absolute C;
    i,j,LAIndex : integer;

  begin
    LAIndex := 0;
    for i := 1 to N do
      for j := 1 to M do
        begin
          inc(LAIndex);   {points to (i,j) element of array}
          LA3[LAIndex] := LA1[LAIndex] - LA2[LAIndex];
        end;
  end;

procedure MultiplyMatrices(const A, B; var C; const M, N, P, Q : integer);
  var
    LA1 : LinearArray absolute A;
    LA2 : LinearArray absolute B;
    LA3 : LinearArray absolute C;
    i,j,k : integer;

  begin {MultiplyMatrices}
    if N<>P then
      begin
        writeln;
        writeln('***Unable to multiply matrix of order '+IntToStr(M)+'x'+IntToStr(N)+
                ' by order '+IntToStr(P)+'x'+IntToStr(Q)+'***');
        writeln;
        Halt
      end
    else
      begin
        ClearMatrix(C,P,Q);
        for i := 1 to M do
          for j := 1 to Q do
            for k := 1 to N do
              LA3[LIndex(i,j,Q)] :=
                LA3[LIndex(i,j,Q)] + LA1[LIndex(i,k,N)]*LA2[LIndex(k,j,Q)]
      end;
  end;  {MultiplyMatrices}

function Determinant(var Matrix; const N : integer): extended;
{Returns the determinant of an NxN (square) matrix, destroying elements
 in process.  This algorithm uses the lower-upper decomposition method as
 explained on p. 13 of the TI58/59 Master Library handbook, which in turn
 is supposed to be based on Dahlquist and Bjork, Numerical Methods (Prentice
 Hall, 1974).  Since the the separate matrices are not required here, and
 since the decomposition proceeds in such a way as to permit this, memory is
 conserved by writing the elements of the decomposition on top of the original
 matrix, the diagonal elements representing  U[k,k], since  L[k,k]=1  need not
 be recorded.  The TI book says that pivoting can be used to improve accuracy,
 but does not explain how.  It also does not explain what to do when U[k,k]=0.
 In the following it is assumed this means the determinant is 0, but
 calculation of L[i,k] cannot be completed.

 Note that Turbo Pascal "for i := j to k do" loops are executed exactly once
 if j=k, and not at all if j>k.}

  var
    LA : LinearArray absolute Matrix;
    i,j,k,p : integer;
    Product : extended;

   begin {Determinant}

     Product := 1;  {determinant = product of diagonal elements of U}

     for k := 1 to N do
       begin
         if RespondToKeyPress and KeyPressed then
           begin
             writeln;
             writeln('Unit MATRICES working on row '+IntToStr(k)+' of LU-decomposition');
             writeln;
             ClearKey;
           end;
         for j := k to N do for p := 1 to k-1 do
           LA[LIndex(k,j,N)] := LA[LIndex(k,j,N)] - LA[LIndex(k,p,N)]*LA[LIndex(p,j,N)];
         { M[k,j] = U[k,j] for j = k..N is now the kth row of U
           completed by U[k,j] = 0 for j = 1..(k-1) }

         Product := Product*LA[LIndex(k,k,N)];

         for i := k+1 to N do if LA[LIndex(k,k,N)]<>0 then
           begin
             for p := 1 to k-1 do
               LA[LIndex(i,k,N)] := LA[LIndex(i,k,N)] - LA[LIndex(i,p,N)]*LA[LIndex(p,k,N)];
             LA[LIndex(i,k,N)] := LA[LIndex(i,k,N)]/LA[LIndex(k,k,N)]
             { M[i,k] = L[i,k] for i = (k+1)..N is now the kth column of L
               completed by L[i,k] = 0 for i = 1..(k-1) and L[k,k] = 1 }
           end

       end;  {kth row and column completed}

     Determinant := Product;

   end;  {Determinant}

procedure SolveSimultan(var CoeffMatrix, Vector; const N : integer);
{Uses the method in the TI book}

  var
    LA : LinearArray absolute CoeffMatrix;
    X  : LinearArray absolute Vector;
    i, k  : integer;

  begin {SolveSimultan}
    if Determinant(CoeffMatrix,N)=0 then
      HaltForError('Unable to solve simultaneous eqns. (Determinant = 0)','Matrices')
    else {L/U decomposition successful with no diagonal elements = 0}
      begin
        {X[i] is initially the "B" vector in the TI book, and LA the LU decomposition}
        for i := 1 to N do
          begin
            for k := 1 to i-1 do X[i] := X[i] - LA[LIndex(i,k,N)]*X[k]
          end;
        {X[i] is now the "Y" vector in the TI book}
        for i := N downto 1 do
          begin
            for k := i+1 to n do X[i] := X[i] - LA[LIndex(i,k,N)]*X[k];
            X[i] := X[i]/LA[LIndex(i,i,N)]
          end;
        {X[i] is now the "X" vector in the TI book}
      end
  end;  {SolveSimultan}

end.