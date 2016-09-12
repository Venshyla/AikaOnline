unit MiscData;

interface

uses SysUtils, Generics.Collections, Types;

type TEquipSlot =
(
  Face,     // 00
  hair ,    // 01
  Helmet,   // 02
  Chest,    // 03
  Gloves,   // 04
  Boots,    // 05
  LWeapon,  // 06
  Unk_7,    // 07
  Unk_8,    // 08
  Mount,    // 09
  Pran ,    // 10
  Ring,     // 11
  Earring,  // 12
  Bracelet, // 13
  Necklace, // 14
  RWeapon   // 15
);
type TDirection = (Forward, Backward, Rigth, Left);

type TItemAmount = Record
  ItemId: Integer;
  Slots: array[0..127] of BYTE;
  Amount: WORD;
  SlotsCount: BYTE;
End;

type TPosition = Record
  public
    X: Single; //tudo em single
    Y: Single;

    constructor Create(x, y: Single);

    function  Distance(const pos : TPosition) : WORD;
    function  InRange (const pos : TPosition; range : WORD) : Boolean;
    procedure ForEach (range: Byte; proc: TProc<TPosition>);

    function magnitude   : WORD;
    function normalized  : TPosition;
    function IsValid     : boolean;
    function PvPAreaType : Integer;

    class function Forward: TPosition; static;
    class function Rigth: TPosition; static;

    class function Lerp(const start, dest: TPosition; time: Single): TPosition; static;
    class function Qerp(const start, dest: TPosition; time: Single; inverse: Boolean = false): TPosition; static;

    class operator Equal(pos1, pos2 : TPosition): Boolean;
    class operator NotEqual(pos1, pos2 : TPosition): Boolean;
    class operator Add(pos1, pos2 : TPosition) : TPosition;
    class operator Subtract(pos1, pos2 : TPosition) : TPosition;
    class operator Multiply(pos1 : TPosition; val: WORD): TPosition;
    class operator Multiply(pos1 : TPosition; val: Single): TPosition;
end;

type TRect = record
  BottomLeft, TopRigth: TPosition;
end;

type PQuest = ^TQuest;
  TQuest = record
  ID : Word;
  Unk: Array [0..9] of byte;
end;

type TTeleport = Record
  Scr1, Scr2, Dest1, Dest2 : TPosition;
  Price, Time: Integer;
End;

type TItemEffect = Record
Index : Array [0..2]of Byte;
Value : Array [0..2]of Byte;
End;

type PItem = ^TItem;
  TITEM = record
  Index,APP : Word;
  Identific : LongInt;
  Effects   : TItemEffect;
  MIN, MAX  : BYTE;
  Refi      : BYTE; //REFI[1Byte]/LVL[1Byte]/(QNT[2 bytes])
  Unk       : BYTE; //BOOL Aumentar durabilidade ou ñ
  Time      : WORD; // Licença/TEMPO PRA EXPIRAR
end;

type THeightMap = Record
  p: array[0..4095] of array[0..4095] of BYTE;
End;

type TTradeStore = Record
  Name: string[23];
  Item: array[0..11] of TItem;

  Slot: array[0..11] of BYTE;

  Gold: array[0..11] of integer;
  Unknown,index: smallint;
end;

type TPacketAffect = Record
  Time, Index : Byte;
End;

type TSkillData = Record
  Index : smallint;
  SkillPoint, TargetType, AffectTime : integer;
  ManaSpent : WORD;
  Delay: WORD;
  Range,
  InstanceType, InstanceValue, TickType, TickValue,
  AffectType, AffectValue, Act123, Act123_2,
  InstanceAttribute, TickAttribute, Aggressive,
  Maxtarget, PartyCheck, AffectResist, PassiveCheck, Name : String;
End;

type TAISegment = Record
  Position: TPosition;
  Say     : string[80];
  WaitTime: WORD; // Em segundos
End;

type PMOBGener = ^TMOBGener;
TMOBGener = Record
  Id,
	Mode, // 0 - 3
	MinuteGenerate,// 4 - 7

	MaxNumMob, // 8 - 11

	MobCount, // 12 - 15

	MinGroup, // 16 - 19
	MaxGroup: integer;// 20 - 23

  SpawnSegment: TAISegment;     // Só vai ser usado pra definir o Spawn
  Segments : TList<TAISegment>;
//  Destination: TAISegment;

	FightAction, // 504 - 823
	FleeAction, // 824 - 1143
	DieAction: array[0..3] of string[79]; // 1144 - 1463

  Follower,
  Leader: string;

	Formation, // 1464 - 1467
	RouteType: integer; // 1468 - 1471

  procedure AddSegmentData(segmentId: Byte); overload;
  procedure AddSegmentData(segmentId : Byte; x, y: Integer); overload;
  procedure AddSegmentData(segmentId : Byte; waitTime: Integer); overload;
  procedure AddSegmentData(segmentId : Byte; say: string); overload;
end;

type TItemListOld = Record
  Index : smallint;
  Name: String[63];

  Mesh: Smallint;
  Submesh: Smallint;

  unknow: Smallint;

  Level: Smallint;
  STR: Smallint;
  INT: Smallint;
  DEX: Smallint;
  CON: Smallint;

  Effects: array[0..11] of TItemEffect;

  Price: Integer;
  Unique: Smallint;
  Pos: Word;

  Extreme: Smallint;
  Grade: Smallint;
end;

type TEffectsBinary = Record    // Effeito ItemList bin não no client
    index: Smallint;
    value: Smallint;
end;

type TItemList = Record
    Name: array[0..63] of AnsiChar;

    Mesh: Smallint;
	  Submesh: Smallint;

	  unknow: Smallint;

    Level: Smallint;
    STR: Smallint;
    INT: Smallint;
    DEX: Smallint;
    CON: Smallint;

    Effects: array[0..11] of TEffectsBinary;

    Price: Integer;
    Unique: Smallint;
    Pos: Word;

    Extreme: Smallint;
    Grade: Smallint;
end;

{$REGION 'ItemList'}
type T_ItemList = Record                //||Cada Item tem 464 bytes
Name        : Array [0..63]  of Byte;   //||Nome Portugues
NameEnglish : Array [0..63]  of Byte;   //||Nome original
Descrition  : Array [0..127] of Byte; //Descrição
//Unk   : Array [0..207]of byte;  //

Unknown            : WORD; //itens como bala fica 1
ItemType           : WORD; //itens como bala se o valor for 0 fica sem durabilidade
UnkValues          : Array [0..16]of byte;
DelayUse           : WORD;//delay ao usar item consumivel
Null1              : Array [0..5]of byte;
PriceHonor         : DWORD; //valor
PriceMedal         : DWORD; //valor
PriceGold          : DWORD; //valor
SellPrince         : DWORD; //Eu acho que é
Classe             : WORD;//dword
Null2              : Array [0..7]of byte;

Expires            : Boolean;//se  expira ou não aqui não é a data
BonusEquip         : LongBool;//4bytes
Null00             : Word;

//Até a classe são 29Bytes
Level              : WORD;

//do atkFis ATé o lvl são 27Bytes

ATKFis             : WORD;
DefFis             : WORD;
MagATK             : WORD;
DefMag             : WORD;
Null0              : Array [0..05]of byte;
HP,MP              : WORD;//
Null001            : Array [0..13]of byte;
TypeItem           : Byte;//Se é raro...normal....  [0~~7]
Null01             : WORD;
TypeTrade          : Byte;//[0~~2] 1 N Trocavel, 2 Negociação revertida
Null02             : Array [0..11]of byte;
Durabilidade       : Byte;
Null03             : LongInt;
EF                 : Array [0..2]of WORD;
EFV                : Array [0..2]of WORD;
change             : Boolean; //Mudança de aparencia
reduction          : Boolean; // se ja foi reduzido
fortification      : Boolean;//
Rank               : Byte;
Null               : LongInt;//Tem um valor loco
MaxLvl             : DWORD; // do lvl min ao max
Null3              : LongInt;
TypePriceItem      : WORD; //se for cash por exemplo
TypePriceItemValue : WORD;
Null4              : Array [0..19]of byte;
end;

{
[Total Structure Size: 464 bytes]

000-063: LocalizedName [64 bytes]
064-127: KoreanName [?] [64 bytes]
128-255: Description [128 bytes]

256-257: unknown [2 bytes]

258-259: ItemType [2 bytes]
260-263: CaeliumOreFlag [4 bytes]
264-283: unknown [20 bytes]

284-287: HonorCost [4 bytes]
288-291: MedalCost [4 bytes]
292-295: BuyPrice [4 bytes]
296-299: SellPrice [4 bytes]
300-301: Profession [2 bytes]

302-319: unknown [18 bytes]
320-321: ImageIndex [2 bytes]
322-329: unknown [8 bytes]
330-331: CharacterMinLevel [2 bytes]
332-335: unknown [4 bytes]
336-339: TimeLimit [4 bytes]
340-343: unknown [4 bytes]
344-351: unused [8 bytes]
352-353: unknown [2 bytes]
354-357: unused [4 bytes]
358-359: PATK [2 bytes]
360-361: PDEF [2 bytes]
362-363: MATK [2 bytes]
364-365: MDEF [2 bytes]
366-367: unused [2 bytes]
368-369: unknown [2 bytes]
370-375: unused [6 bytes]
376-377: unknown [2 bytes]
378-379: unknown [2 bytes]
380-381: unused [2 bytes]
382-383: unknown [2 bytes]
384-389: unused [6 bytes]
390-391: CountryFlag [2 bytes]
392-393: unknown [2 bytes]
384-405: unused [22 bytes]
406-407: unknown [2 bytes]
408-411: unused [4 bytes]
412-413: Effect1 [2 bytes]
414-415: Effect2 [2 bytes]
416-417: Effect3 [2 bytes]
418-419: Effect1Value [2 bytes]
420-421: Effect2Value [2 bytes]
422-423: Effect3Value [2 bytes]
424-427: unknown [4 bytes]
428-429: unknown [2 bytes]
430-431: unknown [2 bytes]
432-433: CharacterMaxLevel [2 bytes]
434-435: unused [2 bytes]
436-437: unknown [2 bytes]
438-439: unused [2 bytes]
440-441: unknown [2 bytes]
442-443: unknown [2 bytes]
444-445: unknown [2 bytes]
446-447: unknown [2 bytes]
448-449: unknown [2 bytes]
450-451: unknown [2 bytes]
452-453: unknown [2 bytes]
454-455: unknown [2 bytes]
456-457: unknown [2 bytes]
458-459: unknown [2 bytes]
460-461: unknown [2 bytes]
462-463: unused [2 bytes]
}

//Type TItemList = ARRAY[0..20480] OF T_ItemList;
{$ENDREGION}

implementation

uses Util;

{ TPosition }
constructor TPosition.Create(x, y: Single);
begin
  self.X := x;
  self.Y := Y;
end;

function TPosition.Distance(const pos: TPosition): WORD;
var dif: TPosition;
begin
  dif := self - pos;
  Result := Round(Sqrt(dif.X * dif.X + dif.Y * dif.Y));
end;

function TPosition.InRange(const pos : TPosition; range: WORD): Boolean;
var dist : WORD;
begin
  dist   := Distance(pos);
  Result := IfThen(dist <= range);
end;

procedure TPosition.ForEach(range: Byte; proc: TProc<TPosition>);
var x, y: WORD;
begin
  for x := Round(self.X) - range to Round(self.X) + range do
  begin
    for y := Round(self.y) - range to Round(self.y) + range do
    begin
      if (x > 4096) or (x <= 0) or (y > 4096) or (y <= 0) then
      continue;
      proc(TPosition.Create(x,y));
    end;
  end;
end;

class function TPosition.Forward: TPosition;
begin
  Result.X := 0;
  Result.Y := -1;
end;
class function TPosition.Rigth: TPosition;
begin
  Result.X := -1;
  Result.Y := 0;
end;

function TPosition.IsValid: boolean;
begin
  Result := true;
  if(self.X > 4096) or (self.Y > 4096) or (self.X <= 0) or (self.Y <= 0) then
    Result := false;
end;

class function TPosition.Lerp(const start, dest: TPosition; time: Single): TPosition;
begin
  Result := start + (dest - start) * time;
end;

class function TPosition.Qerp(const start, dest: TPosition; time: Single; inverse: Boolean = false): TPosition;
var quad: Single;
begin
  quad := IfThen(inverse, (2 - time), time);
  Result := start + (dest - start) * time * quad;
end;

function TPosition.magnitude: WORD;
begin
  Result := Round(Sqrt(self.X * self.X + self.Y * self.Y));
end;

function TPosition.normalized: TPosition;
var mag : WORD;
begin
  mag := self.magnitude;

  Result.X := Round(self.X) div mag;
  Result.Y := Round(self.y) div mag;
end;

class operator TPosition.Equal(pos1, pos2: TPosition): Boolean;
begin
  Result := false;
  if (pos1.X = pos2.X) AND (pos1.Y = pos2.Y) then
    Result := true;
end;
class operator TPosition.NotEqual(pos1, pos2: TPosition): Boolean;
begin
  Result := not(pos1 = pos2);
end;

function TPosition.PvPAreaType: Integer;
begin
	////MENOS CP / COM FRAG
	if (X >= 3330) AND (Y >= 1026) AND (X <= 3600) AND (Y <= 1660) then Result := 2 //Area das Pistas de Runas
	else if (X >= 2176) AND (Y >= 1150) AND (X <= 2304) AND (Y <= 1534) then Result := 2 //Area Campo Azran Quest Imp
	else if (X >= 2446) AND (Y >= 1850) AND (X <= 2546) AND (Y <= 1920) then Result := 2 //Area Torre Erion 02
	else if (X >= 1678) AND (Y >= 1550) AND (X <= 1776) AND (Y <= 1906) then Result := 2 //Area de Reinos
	else if (X >= 1150) AND (Y >= 1676) AND (X <= 1678) AND (Y <= 1920) then Result := 2 //Area caça Noatun
	else if (X >= 3456) AND (Y >= 2688) AND (X <= 3966) AND (Y <= 3083) then Result := 2 //Area caça Gelo
	else if (X >= 3582) AND (Y >= 3456) AND (X <= 3968) AND (Y <= 3710) then Result := 2 //Area Lan House

	////SEM CP / SEM FRAG
	else if (X >= 2602) AND (Y >= 1702) AND (X <= 2652) AND (Y <= 1750) then Result := 1 //Area Coliseu Azran
	else if (X >= 2560) AND (Y >= 1682) AND (X <= 2584) AND (Y <= 1716) then Result := 1 //Area PVP Azran
	else if (X >= 2122) AND (Y >= 2140) AND (X <= 2148) AND (Y <= 2156) then Result := 1 //Area PVP Armia
	else if (X >= 136) AND (Y >= 4002) AND (X <= 200) AND (Y <= 4088) then Result := 1 //Area Duelo

	////SEM CP / COM FRAG
	else if (X >= 2174) AND (Y >= 3838) AND (X <= 2560) AND (Y <= 4096) then Result := 3 //Area Kefra
	else if (X >= 1076) AND (Y >= 1678) AND (X <= 1150) AND (Y <= 1778) then Result := 3 //Area Castelo Noatun
	else if (X >= 1038) AND (Y >= 1678) AND (X <= 1076) AND (Y <= 1702) then Result := 3 //Area Castelo Noatun Altar
	else if (X >= 2498) AND (Y >= 1868) AND (X <= 2516) AND (Y <= 1896) then Result := 3 //Area Torre Erion 01
	else if (X >= 130) AND (Y >= 140) AND (X <= 248) AND (Y <= 240) then Result := 3 //Area Guerra entre Guildas
	else Result := 0;
end;

class operator TPosition.Add(pos1, pos2: TPosition): TPosition;
begin
  Result.X := pos1.X + pos2.X;
  Result.Y := pos1.Y + pos2.Y;
end;

class operator TPosition.Subtract(pos1, pos2: TPosition): TPosition;
begin
  Result.X := pos1.X - pos2.X;
  Result.Y := pos1.Y - pos2.Y;
end;

class operator TPosition.Multiply(pos1 : TPosition; val: WORD): TPosition;
begin
  Result.X := pos1.X * val;
  Result.Y := pos1.Y * val;
end;

class operator TPosition.Multiply(pos1: TPosition; val: Single): TPosition;
begin
  Result.X := Round(pos1.X * val);
  Result.Y := Round(pos1.Y * val);
end;

{ TMOBGener }

procedure TMOBGener.AddSegmentData(segmentId: Byte; x, y: Integer);
var segment: TAISegment;
begin
  AddSegmentData(segmentId);
  Dec(segmentId);

  segment := Segments[segmentId];
  if x <> -1 then
    segment.Position.X := x;
  if y <> -1 then
    segment.Position.Y := y;

  Segments[segmentId] := segment;
end;

procedure TMOBGener.AddSegmentData(segmentId: Byte; waitTime: Integer);
var segment: TAISegment;
begin
  AddSegmentData(segmentId);
  Dec(segmentId);

  segment := Segments[segmentId];
  segment.WaitTime := waitTime;
  Segments[segmentId] := segment;
end;

procedure TMOBGener.AddSegmentData(segmentId: Byte; say: string);
var segment: TAISegment;
begin
  AddSegmentData(segmentId);
  Dec(segmentId);

  segment := Segments[segmentId];
  segment.Say := say;
  Segments[segmentId] := segment;
end;

procedure TMOBGener.AddSegmentData(segmentId: Byte);
var segment: TAISegment;
begin
  if Segments = NIL then
    Segments := TList<TAISegment>.Create;

  while segmentId > Segments.Count do
  begin
    Segments.Add(segment);
  end;
end;

end.
