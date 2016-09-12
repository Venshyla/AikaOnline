unit Functions;

interface

uses Classes, StrUtils, SysUtils, Windows, MiscData, PlayerData, BaseMob, Player, Math,
    Packets;

type TFunctions = class
  private
  public
    class function FreeClientId() : WORD; static;

    class function IsNumeric(str : string; out Value: Integer) : Boolean; overload; static;
    class function IsNumeric(str : string; out Value: short) : Boolean; overload; static;
    class function IsNumeric(str: string): Boolean; overload; static;

    class function IsLetter(text: string): Boolean; static;
    class function Clock() : Cardinal; static;
    class function CharArrayToString(chars : array of AnsiChar) : string; static;
    class function FindCharacter(characterName : string) : Boolean; static;
    class procedure SaveCharacterFile(const player : TPlayer; characterName : string); static;
    class function CompareCharOwner(const player : TPlayer; characterName : string) : Boolean; static;

    class function GetStartXY(var player : TPlayer; charId : Byte) : TPosition; overload; static;
    class function GetStartXY(var player : TPlayer) : TPosition; overload; static;
    class function GetStartXY(cityId : TCity) : TPosition; overload; static;

    class function GetEmptyMobGrid(index: WORD; var pos : TPosition; radius: WORD = 6): Boolean; overload; static;
    class function GetEmptyMobGrid(index: WORD; var posX: SmallInt; var posY: SmallInt; radius: WORD = 6) : Boolean; overload; static;

    class function GetEmptyItemGrid(index: WORD; var pos : TPosition): Boolean; overload; static;
    class function GetEmptyItemGrid(index: WORD; var posX: SmallInt; var posY: SmallInt) : Boolean; overload; static;

    class function GetRandomEmptyMobGrid(index: WORD; var pos : TPosition; radius: WORD = 6) : Boolean; overload; static;
    class function GetRandomEmptyMobGrid(index: WORD; var posX: SmallInt; var posY: SmallInt; radius: WORD = 6) : Boolean; overload; static;

    class function GetFreeMob() : WORD; static;
    class function FindInParty(partyId, findid: WORD): BYTE; static;

    class function Rand(num: integer = 0) : integer; overload; static;
    class function Rand(num, num2: integer) : integer; overload; static;

    class procedure ClearArea(pos1, pos2: TPosition); static;

    class function UpdateWorld(index: Integer; var pos: TPosition; flag: Byte): Boolean;
    class function GetAction(mob: TBaseMob; pos: TPosition; actionType: Byte; cmm: PAnsiChar = NIL): TMovementPacket;
    //class procedure SetMobGrid(mob : TBaseMob); static;
end;

implementation
{ TFunctions }

uses GlobalDefs, Log;

class function TFunctions.FindCharacter(characterName: string): Boolean;
var local : string;
begin
  if(IsLetter(characterName)) then
    local := CurrentDir+'\Chars\' + characterName[1] + '\'+Trim(characterName)
  else
    local := CurrentDir+'\Chars\etc\' + Trim(characterName);

  if(FileExists(local)) then
    result := true
  else
    result := false;
end;

class function TFunctions.FindInParty(partyId, findid: WORD): BYTE;
var i: BYTE;
    party : TParty;
begin
  result := 11;
  party := Parties[partyId];
  if(party.Leader = 0) then exit;

  for i := 0 to 10 do
  begin
    if(party.Members[i] = findid) then
    begin
      result:=i;
      exit;
    end;
  end;
end;

class function TFunctions.FreeClientId: WORD;
var i: WORD;
begin
  result := 0;
  if(InstantiatedPlayers + 1 > MAX_CONNECTIONS) then exit;
  for i := 1 to (MAX_CONNECTIONS - 1) do
  begin
    if not(Players[i].Base.IsActive) then
    begin
      result := i;
      exit;
    end;
  end;
end;

class function TFunctions.IsNumeric(str: string; out Value: short): Boolean;
var
  E: Integer;
begin
  Val(str, Value, E);
  Result := E = 0;
end;

class function TFunctions.IsNumeric(str: string; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(str, Value, E);
  Result := E = 0;
end;

class function TFunctions.IsNumeric(str: string): Boolean;
var
  E: Integer;
  Value: Integer;
begin
  Val(str, Value, E);
  Result := E = 0;
end;

class function TFunctions.Rand(num, num2: integer): integer;
begin
  Result := RandomRange(num, num2);
  Randomize;
end;

class function TFunctions.Rand(num: integer = 0): integer;
var i : integer;
begin
  Randomize;
  if(num = 0) then
  begin
    result := Trunc(Random);
    exit;
  end;
  result := Random(num);
end;

class procedure TFunctions.SaveCharacterFile(const player: TPlayer; characterName: string);
var
  f:textfile;
  local : string;
begin
  if(IsLetter(characterName)) then
  begin
    if not DirectoryExists(CurrentDir + '\Chars\' + Trim(characterName[1])) then forceDirectories(CurrentDir + '\Chars\' + Trim(characterName[1]));
    local := CurrentDir + '\Chars\' + Trim(characterName[1]) + '\'+Trim(characterName);
  end
  else
  local := CurrentDir + '\Chars\etc\' + Trim(characterName);
  AssignFile(f, local);
  ReWrite(f);
  Writeln(f, player.Account.Header.Username);
  CloseFile(f);
end;

class function TFunctions.UpdateWorld(index: Integer; var pos: TPosition; flag: Byte): Boolean;
var mob: TBaseMob;
begin
  Result := false;
	if flag = WORLD_MOB then
	begin
    if not TBaseMob.GetMob(index, mob) then exit;
		Result := GetEmptyMobGrid(index, pos);
		if Result then
		begin
			MobGrid[Round(mob.CurrentPosition.Y)][Round(mob.CurrentPosition.X)] := 0;
			MobGrid[Round(pos.Y)][Round(pos.X)] := index;
    end;
    exit;
  end
	else if flag = WORLD_ITEM then
  begin
		if (Index >= MAX_INITITEM_LIST) OR (Index < 0) then
    begin
      exit;
    end;
		Result := GetEmptyItemGrid(Index, pos);
		if Result then
		begin
			ItemGrid[Round(pos.Y)][Round(pos.X)] := Index;
    end;
	  exit;
  end;
end;

{
class procedure TFunctions.SetMobGrid(mob : TBaseMob);
begin
  MobGrid[mob.Character.Last.Y][mob.Character.Last.X] := mob.ClientId;
end;
}
class function TFunctions.IsLetter(text: string): boolean;
const ALPHA_CHARS = ['a'..'z', 'A'..'Z'];
begin
  if(Length(text) > 0) AND (text[1] in ALPHA_CHARS) then begin
    Result := true;
    exit;
  end;
  result := false;
end;

class function TFunctions.CharArrayToString(chars: array of AnsiChar): string;
begin
  if (Length(chars) > 0) then
    SetString(Result, PAnsiChar(@chars[0]), Length(chars))
  else
    Result := '';
  Result := Trim(Result);
end;

class procedure TFunctions.ClearArea(pos1, pos2: TPosition);
var
  x: Integer;
  y: Integer;
  mob: TBaseMob;
  p: TPosition;
begin
  for x := Round(pos1.X) to Round(pos2.X) do
    for y := Round(pos1.Y) to Round(pos2.Y) do
  begin
    p.Create(x, y);
    if not(TBaseMob.GetMob(p, mob)) then continue;
    if(mob.IsPlayer) then
      p := GetStartXY(Players[mob.ClientId])
    else
      p := NPCs[mob.ClientId].GenerData.SpawnSegment.Position;
    mob.Teleport(p);
  end;
end;

class function TFunctions.Clock() : Cardinal;
begin
  result := GetTickCount() - TimeTick;
end;

class function TFunctions.CompareCharOwner(const player: TPlayer; characterName: string): Boolean;
var f: textfile;
    local: string;
    into: string;
begin
  if(IsLetter(characterName)) then
    local := CurrentDir + '\Chars\' + characterName[1] + '\' + Trim(characterName)
  else
    local := CurrentDir + '\Chars\etc\' + Trim(characterName);

  AssignFile(f, local);
  Reset(f);
  Readln(f, into);
  CloseFile(f);
  if(AnsiCompareStr(Trim(into), Trim(player.Account.Header.Username)) <> 0) then
    result := false
  else
    result := true;
end;

class function TFunctions.GetFreeMob():WORD;
var i:WORD;
begin
  result := 0;
  for i := 1001 to 30000 do
    if not(NPCs[i].Base.IsActive) then
    begin
      result := i;
      break;
    end;
end;

class function TFunctions.GetRandomEmptyMobGrid(index: WORD; var pos: TPosition;
  radius: WORD): Boolean;
begin
//  Result := GetRandomEmptyMobGrid(index,  pos.X ,  pos.Y , radius);
end;

class function TFunctions.GetRandomEmptyMobGrid(index: WORD; var posX,
  posY: SmallInt; radius: WORD): Boolean;
var nY, nX: integer;
  r: Byte;
  w,t,x,y: Integer;
  neighbor: TPosition;
begin
  if(posX < 0) or (posX >= 4096) or (posY < 0) or (posY >= 4096) then
  begin
    Logger.Write('GetEmptyMobGrid: Posição fora do limite permitido X:' + IntToStr(posX) + '-Y:' + IntToStr(posY), TLogType.Warnings);
    result := false;
    exit;
  end;

  if(MobGrid[posY][posX] = Index) OR (MobGrid[posY][posX] = 0) then
  begin
    if(HeightGrid.p[posY][posX] <> 127)then
    begin
      result := true;
      exit;
    end;
  end;

  for r := 1 to radius do
  begin
    w := r * Round(Sqrt(Random));
    t := 2 * Round(Pi * Random);
    x := w * Round(Cos(t));
    y := w * Round(Sin(t));

    nX := posX + x;
    nY := posY + y;

    if(MobGrid[nY][nX] = 0) then
    begin
      if(HeightGrid.p[nY][nX] <> 127) then
      begin
        posX := nX;
        posY := nY;
        result := true;
        exit;
      end;
    end;
  end;
  result := false;
  Logger.Write('MobAction: Sem nenhum espaço livre para movimento.', TLogType.Warnings);
end;

class function TFunctions.GetEmptyMobGrid(index: WORD; var pos: TPosition; radius: WORD = 6): Boolean;
begin
 // Result := GetEmptyMobGrid(index, pos.X, pos.Y, radius);
end;

class function TFunctions.GetAction(mob: TBaseMob; pos: TPosition; actionType: Byte; cmm: PAnsiChar): TMovementPacket;
begin
  ZeroMemory(@Result, SizeOf(TMovementPacket));

  Result.Header.Size := sizeof(TMovementPacket);
  Result.Header.Code := $366;
  Result.Header.Index := mob.Clientid;
 //	Result.Speed := mob.Character.CurrentScore.MoveSpeed;   ainda não tem
  Result.Speed := $FF;
	Result.Destination := pos;
	Result.MoveType := actionType;
end;

class function TFunctions.GetEmptyItemGrid(index: WORD; var pos: TPosition): Boolean;
begin
 // Result := GetEmptyItemGrid(index, pos.X, pos.Y);
end;

class function TFunctions.GetEmptyItemGrid(index: WORD; var posX, posY: SmallInt): Boolean;
var nY, nX: integer;
begin
  if(posX < 0) or (posX >= 4096) or (posY < 0) or (posY >= 4096) then
  begin
    Logger.Write('GetEmptyItemGrid: Posição fora do limite permitido X:' + IntToStr(posX) + '-Y:' + IntToStr(posY), TLogType.Warnings);
    result := false;
    exit;
  end;

  if(ItemGrid[posY][posX] = Index) then
  begin
    result := true;
    exit;
  end;

  if (ItemGrid[posY][posX] = 0) then
  begin
    if(HeightGrid.p[posY][posX] <> 127)then
    begin
      result := true;
      exit;
    end;
  end;

  for nY := posY - 1 to posY + 1 do
  begin
    for nX := posX - 1 to posX + 1 do
    begin
      if(ItemGrid[nY][nX] = 0)then
      begin
        if(HeightGrid.p[nY][nX] <> 127)then
        begin
          posX := nX;
          posY := nY;
          result := true;
          exit;
        end;
      end;
    end;
  end;
  result := false;
//  Logger.Write('MobAction: Sem nenhum espaço livre para movimento.', TLogType.Warnings);
end;

class function TFunctions.GetEmptyMobGrid(index: WORD; var posX: SmallInt; var posY: SmallInt; radius: WORD = 6) : Boolean;
var nY, nX: integer;
  r: Byte;
  w,t,x,y: Integer;
  neighbor: TPosition;
begin
  if(posX < 0) or (posX >= 4096) or (posY < 0) or (posY >= 4096) then
  begin
    Logger.Write('GetEmptyMobGrid: Posição fora do limite permitido X:' + IntToStr(posX) + '-Y:' + IntToStr(posY), TLogType.Warnings);
    result := false;
    exit;
  end;

  if(MobGrid[posY][posX] = Index) OR (MobGrid[posY][posX] = 0) then
  begin
    if(HeightGrid.p[posY][posX] <> 127)then
    begin
      result := true;
      exit;
    end;
  end;

  for r := 1 to radius do
  begin
    for neighbor in Neighbors do
    begin
//      nX := posX + (neighbor.X * r);
//      nY := posY + (neighbor.Y * r);

      if(MobGrid[nY][nX] = 0)then
      begin
        if(HeightGrid.p[nY][nX] <> 127)then
        begin
          posX := nX;
          posY := nY;
          result := true;
          exit;
        end;
      end;
    end;
  end;
  result := false;
  Logger.Write('MobAction: Sem nenhum espaço livre para movimento.', TLogType.Warnings);
end;

class function TFunctions.GetStartXY(cityId: TCity): TPosition;
begin
  case(cityId) of
    TCity.Armia: //armia
    begin
      Result.X := 2100;
      Result.Y := 2100;
      end;
    TCity.Azram:
    begin
      Result.X := 2507;
      Result.Y := 1715;
      end;
    TCity.Erion:
    begin
      Result.X := 2461;
      Result.Y := 1997;
      end;
    TCity.Karden:
    begin
      Result.X := 3645;
      Result.Y := 3130;
    end;
	end;
end;

class function TFunctions.GetStartXY(var player : TPlayer; charId : Byte) : TPosition;
begin

end;

class function TFunctions.GetStartXY(var player : TPlayer) : TPosition;
begin

end;

end.

