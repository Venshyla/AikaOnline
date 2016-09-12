unit Util;

interface

uses System.Threading, Diagnostics;

type DWORD = Longword;
  TLoopState = TParallel.TLoopState;

  TVarProc<T1,T2> = reference to procedure (var Arg1: T1; var Arg2: T2);
  TVarFunc<T1,T2,T3,TResult> = reference to function (var Arg1: T1; var Arg2: T2; var Arg3: T3): TResult;


function IFThen(cond: boolean; aTrue: variant; aFalse:  variant): variant; overload;
function IFThen(cond: boolean): Boolean; overload;


function GetBits(const Bits: DWORD; const aIndex: Integer): Integer;
procedure SetByteBits(var Bits: Byte; const aIndex, aValue: Integer); overload;
procedure SetWordBits(var Bits: WORD; const aIndex: Integer; const aValue: Integer); overload;
function Last(const list: array of AnsiChar) : AnsiChar;

implementation

uses Math;

function IFThen(cond: boolean; aTrue: variant; aFalse:  variant): variant;
begin
if cond then
  Result := aTrue
else
  Result :=  aFalse;
end;

function IFThen(cond: boolean): Boolean;
begin
  Result := IFThen(cond, true, false);
end;

function GetBits(const Bits: DWORD; const aIndex: Integer): Integer;
begin
  Result := (Bits shr (aIndex shr 8))       // offset
            and ((1 shl Byte(aIndex)) - 1); // mask
end;

procedure SetByteBits(var Bits: Byte; const aIndex, aValue: Integer);
var
  Offset: Byte;
  Mask: Integer;
  r: integer;
begin
  Mask := ((1 shl Byte(aIndex)) - 1);
  Assert(aValue <= Mask);

  Offset := aIndex shr 8;
  Bits := (Bits and (not (Mask shl Offset))) or DWORD(aValue shl Offset);
end;

procedure SetWordBits(var Bits: WORD; const aIndex: Integer; const aValue: Integer);
var
  Offset: Byte;
  Mask: Integer;
begin
  Mask := ((1 shl Byte(aIndex)) - 1);
  Assert(aValue <= Mask);

  Offset := aIndex shr 8;
  Bits := (Bits and (not (Mask shl Offset)))
          or DWORD(aValue shl Offset);
end;

function Last(const list: array of AnsiChar) : AnsiChar;
var i: Integer;
begin
  for i := 0 to Length(list) {downto 0}  do
  begin
    if(list[i] <> #0) then
    begin
      Result := list[i];
      exit;
    end;
  end;
  Result := #0;
end;

end.
