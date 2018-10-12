unit DE405d_EphemerisFile;
{this is the same as DE405_EphemerisFile.pas, but has been restructured to reflect
the contents of such files after conversion to native Pascal/Delphi data}

interface

const
  NCOEFF = 1018;  {number of entries in a data block: StartJD, EndJD + (NCOEFF-2) Chebychev coefficients}
type
  TJPL_Word = Double;
  TJPL_Integer = Integer;
{note: the following are defined as arrays of characters in the Unix files.  The
  Pascal strings add one extra byte per item to code the length.  This causes the
  blocks of type 1 (below) to contain slightly more bytes than in Unix, but these
  blocks are padded anyway to match the size of type 3 blocks}
  TJPL_TitleLine = String[84];
  TJPL_Name = String[6];

  TJPL_DataBlock = record
  {see note under TEphemerisOutput :  since TPL_Word = 8 bytes, this definition produces
   a structure of size 8*NCOEFF bytes, which is "even" with no padding required and matches
   the actual size of the blocks in the JPL unix files = 8144 bytes per record in the present case.}
    case Integer of
    1:(
        TTL    : array[1..3] of TJPL_TitleLine;  {title lines}
        CNAM   : array[1..400] of TJPL_Name;     {names of constants}
        SS     : array[1..3] of TJPL_Word;       {start JD, end JD, block length (days)}
        NCON   : TJPL_Integer;                   {number of constants}
        AU     : TJPL_Word;                      {Astronomical unit}
        EMRAT  : TJPL_Word;                      {Earth-Moon mass ratio}
        IPT    : array[1..12,1..3] of TJPL_Integer;    {pointer for planet and nutation coefficents}
        NUMDE  : TJPL_Integer;                   {ephemeris number (XXX of DEXXX)}
        LPT    : array[1..3] of TJPL_Integer;       {pointer for libration coefficents}
      );
    2: (CVAL : array[1..400] of TJPL_Word);      {values of named constants}
    3: (DB : array[1..NCOEFF] of TJPL_Word);     {DB[1] = StartJD of data block
                                                  DB[2] = EndJD
                                                  DB[3..NCOEFF] = Chebychev coefficents per IPT and LPT}
    end;

{the following three translation functions are provided in DE405_EphemerisFile.pas
 to permit access to the data.  The data in the DE405d format files can be read
 directly, however the same three functions (which do essentially nothing) are provided
 so code can be written to use the two units interchangeably.}

function CharArrayToString(const CharArray : string): string;

function JPLIntegerToInteger(const JPL_Integer : TJPL_Integer) : integer;

function JPLWordToDouble(const JPL_Word : TJPL_Word) : Double;

implementation

function CharArrayToString(const CharArray : string): string;
begin
  Result := CharArray;
end;

function JPLIntegerToInteger(const JPL_Integer : TJPL_Integer) : integer;
begin
  Result := JPL_Integer;
end;

function JPLWordToDouble(const JPL_Word : TJPL_Word) : Double;
begin
  Result := JPL_Word;
end;


end.
