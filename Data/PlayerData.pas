unit PlayerData;

interface

uses MiscData, Types, Generics.Collections;


type TCity             = (Armia, Azram, Erion, Karden);
type TWeatherCondition = (Normal, Rain, Snow, HeavySnow);
type TCitizenship      = (None = -1, Server1, Server2, Server3);
type TClassLevel       = (Mortal, Arch, Celestial, SubCelestial, Hardcore);
type TPlayerStatus     = (WaitingLogin, CharList, Senha2,Waiting, Playing);

type TInitItem = Record
  Item     : TItem;
  ClientId : WORD;
  TimeDrop : TDateTime;
  Pos      : TPosition;
End;

type TTrade = Record
  Itens        : Array [0..9] of TITEM;
  Slots        : Array [0..9] of byte;
  Null         : Word;
  Gold         : Comp;
  Confirm      : boolean;
	Waiting      : boolean;
  OtherClientid: WORD;
  Null0        : LongInt;
end;

{$REGION 'Complemento'}
//Pode facilitar quando for copiar os valores.
Type TSizes = Record
  Altura, Tronco,
  Perna , Corpo  : BYTE;//07 77 77 Padrao
End;

Type TPoints = Record
  Str, agility,
  Int , Cons,
  luck, Status   : WORD;
End;

Type TLife = Record
  CurHP, MaxHP   : DWORD;
  CurMP, MaxMP   : DWORD;
End;

Type TDamage = Record
  DNFis,DefFis   : Word;
  DNMag,DefMag   : Word;
  BonusDMG       : Word;
End;
{$ENDREGION}

type TStatus = Record
  Str, agility,
  Int , Cons,
  luck, Status   : WORD;

  Sizes          : TSizes;

  CurHP, MaxHP   : DWORD;
  CurMP, MaxMP   : DWORD;

  Unk_1          : LongInt;

  Honor          : DWORD;
  Kills          : DWORD;

  Null_2         : Array [0..5] of byte;

  pSkill          : Word;

  Unk0           : Word;
  Null_3         : Array [0..59] of byte;
  Unk1           : WORD;

  DNFis,DefFis   : Word;
  DNMag,DefMag   : Word;
  BonusDMG       : Word;

  null_4         : Array [0..9] of byte;

  Critical       : word;
  Esquiva        : Byte;
  Acerto         : Byte;

  Null_6         : LongInt;
end;

type TCharacterListData = Record

end;

type TAffect = Record
	Index: BYTE;
	Master: BYTE;
	Value: smallint;
	Time: integer;
end;

type TAffectInfo = record
  private
    function GetBits(const Index: Integer): Byte;
    procedure SetBits(const Index: Integer; const Value: Byte);
  (*
  struct
  {
      BYTE SlowMov : 1;
      BYTE DrainHP : 1;
      BYTE VisionDrop : 1;
      BYTE Evasion : 1;
      BYTE Snoop : 1;
      BYTE SpeedMov : 1;
      BYTE SkillDelay : 1;
      BYTE Resist : 1;
  } AffectInfo;
  *)
  public
    _Info: Byte;

    property SlowMov    : Byte index 0001 read GetBits write SetBits;
    property DrainHP    : Byte index 0101 read GetBits write SetBits;
    property VisionDrop : Byte index 0201 read GetBits write SetBits;
    property Evasion    : Byte index 0301 read GetBits write SetBits;
    property Snoop      : Byte index 0401 read GetBits write SetBits;
    property SpeedMov   : Byte index 0501 read GetBits write SetBits;
    property SkillDelay : Byte index 0601 read GetBits write SetBits;
    property Resist     : Byte index 0701 read GetBits write SetBits;
end;

type PCharacter = ^TCharacter;// aqui ja é o sendtoword
  TCharacter = record            //Todas infos basicas do char
  ClientId       : DWORD;
  Null_0         : DWORD;
  UnkNK          : DWORD; //talvez ID unico do char
  Name           : Array [0..15]of AnsiChar;
  Unk_0          : Byte; // valor 5 talvez nação
  ClassInfo      : Byte; //é a classe mesmo
  Null_1         : Word;
  CurrentScore   : TStatus;

  Exp            : Comp;
  Level          : Word; //Level-1
  Null_7         : Array [0..153]of byte;

  Equip          : Array [0..15] of TITEM; //16 Itens
  Null           : LongInt;
  Inventory      : Array [0..63] of TITEM; //60 Itens  4 bolsas

  Gold           : Comp; //8 Bytes
  UnkBytes0      : Array [0..383] of byte;  //Tem valores desconhecidos
  Quests         : Array [0..15]  of TQuest; //Max 16 Quests
  UnkBytes1      : Array [0..595] of byte;  //Tem valores desconhecidos
  Senha2         : Array [0..3]   of AnsiChar;
  UnkBytes2      : Array [0..331] of byte;   /////////////////
  BarraSkill     : Array [0..24]  of DWORD;//Estranho valor e qtd [4bytes]
  UnkBytes3      : Array [0..619] of byte;  /////////////////
  PranName       : Array [0..01]  of Array [0..15] of AnsiChar;
  Unknow         : LongInt;
End;

type PPran = ^TPran;//sendtoword  Pran
  TPran    = record
  Name          : Array [0..15] of Ansichar;
  UNK1,UNK2     : DWORD;
  CurHP,MaxHp   : DWORD;
  CurMp,MaxMP   : DWORD;
  Exp           : DWORD;
  DefFis,DefMag : Word;
  UnkBytes      : Array [0..11] of byte;
  Equip         : Array [0..15] of TITEM; //16 itens
  Inventory     : Array [0..41] of TITEM; //2 bolsas
  Unk           : DWORD;
  NullBytes     : Array [0..39]of byte;
End;


type TAccountHeader = Record//toda conta tem
  AccountId   : Integer;
  Username    : String[15];
  Password    : String[11];
  IsActive    : Boolean;

  BasePran     : TPran;
  StorageGold  : Comp;
  StorageItens : Array [0..85] of TITEM;
  NumError     : Array [0..2]  of Byte;
  NumericToken : Array [0..2]  of String[4];
  PlayerDelete : Array [0..2]  of Boolean;
end;

type TCharacterDB = record //todo personagem tem/ Tudo que tem que salvar
  Index      : DWORD;     // Id único do personagem
  Base       : TCharacter;
  //SpeedMove: WORD; //Não vai no sendtoword;
  //DuploAtk : WORD;
  LastAction : TTime;
  PlayerKill : Boolean;   //PK
  LastPos    : TPosition; //Ultima coordenada
  CurrentPos : TPosition; //Atual
end;
//TPlayerCharacter-> Move -> TCharacterDB      Salvar
//TCharacterDB   ->  Move -> TPlayerCharacter  Carregar

type TPlayerCharacter = record
  Index      : DWORD;  // Id único do personagem
  Base       : TCharacter;
  //SpeedMove: WORD; //Não vai no sendtoword;
  //DuploAtk : WORD;
  LastAction : TTime;
  PlayerKill : Boolean;
  LastPos    : TPosition; //Ultima coordenada
  CurrentPos : TPosition; //Atual


  ////Não vai ser copiado para DB
  Citizenship     : TCitizenship;
  CurrentCity     : TCity;
  TradeStore      : TTradeStore;
  IsStoreOpened   : Boolean;
  Trade           : TTrade;
end;

type TAccountFile = Record
  Header: TAccountHeader;
  Characters: array[0..2] of TCharacterDB;
end;

type PParty = ^TParty;
TParty = Record
  Leader: WORD;
  Members: TList<WORD>;
  RequestId: WORD;

  function AddMember(memberClientId: WORD): Boolean;
End;

type TTradeStore = Record
  Name: string[23];
  Item: array[0..11] of TItem;
  Slot: array[0..11] of BYTE;
  Gold: array[0..11] of integer;
  Unknown, Index: smallint;
end;



type TWeather = Record
  Condition : TWeatherCondition;
  Time      : TDateTime;
  Next      : TDateTime;
End;

type TCharacterFile = Record
  Name: String[15];
end;

type TItemEffect = Record
  Index: Smallint;
  Value: Smallint;
end;

type PNpcGenerator = ^TNpcGenerator;
TNpcGenerator = record
  MinuteGenerate : smallint;
  LeaderName     : string[15];
  FollowerName   : string[15];
  LeaderCount    : BYTE;
  FollowerCount  : BYTE;
  RouteType      : BYTE;
  SpawnPosition  : TPosition;
  SpawnWait      : shortint;
  SpawnSay       : string[95];
  Destination    : TPosition;
  DestSay        : string[95];
  DestWait       : shortint;
  ReviveTime     : Cardinal;
  AttackDelay    : Cardinal;
End;

const MAX_MOB_BABY = 38;

const MobBabyNames: array[0..MAX_MOB_BABY - 1] of string =
('Condor', 'Javali', 'Lobo', 'Urso', 'Tigre',
'Gorila', 'Dragao_Negro', 'Succubus', 'Porco',
'Javali_', 'Lobo_', 'Dragao_Menor', 'Urso_',
'Dente_de_Sabre', 'Sem_Sela', 'Fantasma', 'Leve',
'Equipado', 'Andaluz', 'Sem_Sela_', 'Fantasma_',
'Leve_', 'Equipado_', 'Andaluz_', 'Fenrir', 'Dragao',
'Grande_Fenrir', 'Tigre_de_Fogo', 'Dragao_Vermelho',
'Unicornio', 'Pegasus', 'Unisus', 'Grifo', 'Hippo_Grifo',
'Grifo_Sangrento', 'Svadilfari', 'Sleipnir', '');


ExpList : Array [0..150] of Comp =  //AIKA
(1,
200,
538,
1171,
2294,
4142,
6992,
11164,
17025,
24988,
35514,
49114,
66350,
87839,
114252,
146316,
184816,
230596,
284563,
347686,
420998,
505598,
602652,
713397,
839140,
981260,
1141210,
1320518,
1520791,
1743714,
1991052,
2264652,
2566444,
2898445,
3262758,
3661574,
4097174,
4571930,
5088309,
5648872,
6256276,
6913276,
7622726,
8387583,
9210906,
10095858,
11045708,
12063832,
13153717,
14318960,
19427014,
22772422,
26441542,
30726982,
35642566,
41202118,
47419462,
54607942,
62788294,
71674822,
87169222,
93096262,
99704710,
107010694,
115647238,
125646598,
138053868,
152927110,
170064723,
189649760,
214930400,
267008518,
330462924,
407568876,
504140921,
644954086,
754105971,
875837696,
1010149261,
1157040666,
1347961511,
1679989393,
2045220063,
2446973800,
2888902911,
3375024933,
4128514067,
4889538092,
5658172357,
6434492964,
7218576777,
8010501428,
8810345325,
9618187660,
10434108418,
11258188383,
12090509147,
12931153118,
13780203528,
13780203528,
412240337041,
858993459200,
2718714298706,
7937099564131,
17918603561762,
34200824583909,
58411555236126,
92294552240980,
137713831405357,
196623602849380,
271111220679375,
363354233314912,
475646153292574,
610400752233263,
770121996071118,
957446994726481,
117510305243294E15,
142593343754109E15,
171290167748585E15,
203906149401538E15,
240759975286403E15,
28217935140794E15,
328503580182612E15,
380083989935312E15,
437280928422255E15,
500468057798281E15,
143684179568848E16,
184058246526394E16,
23878094025327E16,
308742865141674E16,
381673471431686E16,
254564429775782E16,
313789623517077E16,
429469241895671E16,
638800879879009E16,
841170934230876E16,
22367381367251E17,
3311675422304E17,
604787938617824E17,
522833777869817E17,
630893780672802E17,
142604889474107E18,
172551916182602E18,
208787818679732E18,
326857329959878E18,
33342716190445E18,
34012904777253E18,
346965640994912E18,
353939649977975E18,
361053836385689E18,
849050410);

implementation

uses Util;

{ TAffectInfo }
function TAffectInfo.GetBits(const Index: Integer): Byte;
begin
  Result := Util.GetBits(_Info, Index);
end;

procedure TAffectInfo.SetBits(const Index: Integer; const Value: Byte);
begin
  SetByteBits(_Info, Index, Value);
end;

{ TParty }

function TParty.AddMember(memberClientId: WORD): Boolean;
begin

end;

end.


