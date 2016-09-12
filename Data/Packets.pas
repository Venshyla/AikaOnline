unit Packets;

interface

Uses PlayerData, MiscData, Util;


type TPacketHeader = Record
  Size  : Smallint;
  Key   : Byte;
  ChkSum: Byte;
  Index : Smallint;
  Code  : Smallint;
  Time  : LongWord;
end;

type TSignalData = Record
  Header : TPacketHeader;
  Data : integer;
end;

type TNpcPacket = Record
  Header : TPacketHeader;
  NpcIndex: WORD;
  //Unknow: array[0..5] of BYTE;
  Unknow: WORD;
  Confirm: WORD;
end;

type TMestreGriffo = Record
	Header   : TPacketHeader;
	WarpID   : integer;
	WarpType : integer;
end;

// Request Emotion  // $304
type TRequestEmotion = Record
  Header  : TPacketHeader;
  effType : DWORD;
  effValue: DWORD;
end;

type TDeleteItem = Record
  Header: TPacketHeader;
  slot,itemid: integer;
end;

type TGroupItem = Record
  Header: TPacketHeader;
  slot,itemid,quant: integer;
end;


{$REGION 'Login'}
Type TRequestLoginPacket = Record
  Header         : TPacketHeader;
  AcountSerial   : LongInt;
  UserName       : Array [0..31] of AnsiChar;
  Time           : LongInt;
  MacAddr        : Array [0..13] of byte;
  Version        : WORD;
  Null           : LongInt;
  PassWord       : Array [0..31] of AnsiChar;
  Nulls          : Array [0..991]of byte;//talvez desnecessario
End;
{$ENDREGION}

type TRefreshMoneyPacket = record
  Header: TPacketHeader;
  Unk   : DWORD;
  Gold  : Comp;
end;

type TRefreshEtcPacket = record
  Header: TPacketHeader;
  Hold: integer;
  Exp: integer;
  Learn: integer;
  StatusPoint: smallint;
  MasterPoint: smallint;
  SkillsPoint: smallint;
  MagicIncrement: smallint;
  Gold: integer;
end;

Type TClientMessagePacket = Record //size 0x90 [144]
  Header  : TPacketHeader;
  Null    : Byte;//valor 10+ msg amarela
  Type1   : Byte;//relacionado com tamanho
  Type2   : Byte;//tbm ou cor
  Null1   : Byte;
  Message : string[127];
End;

Type TChatPacket = Record
  Header    : TPacketHeader;
  NotUse    : Array [0..8] of byte;
  Typechat  : Array [0..3] of byte;
  Nick      : Array [0..15] of ansichar;//16 letras
  Fala      : Array [0..125] of ansichar;//126
End;

type TRefreshInventoryPacket = record
  Header    : TPacketHeader;
  Inventory : array[0..63] of TItem;
  Gold      : Comp;
end;

Type TSendCurrentHPMPPacket = Record  //0x20
  Header       : TPacketHeader;
  CurHP, MaxHP : DWORD;
  CurMP, MaxMP : DWORD;
  Null         : DWORD;
End;

Type TSendRefreshStatus = Record
  Header          : TPacketHeader;
  DNFis, DefFis   : Word;
  DNMag, DEFMag   : Word;
  Null            : Array [0..5]of byte;
  SpeedMove       : Word;
  Unk             : Word; // deve ser atk abilidade
  Null2           : Array [0..5]of byte;
  Critico         : Word;
  Esquiva,Acerto  : BYTE;
  Duplo,Resist    : WORD;
End;

Type TPoints = Record
  Forç, AGI ,
  INTE, CON ,
  SORT, STATUS: WORD;
End;

Type TSendRefreshPoint = Record
  Header  : TPacketHeader;
  Pontos  : TPoints;
  Null    : DWORD;
End;

Type TSendCurrentLevel = Record
  Header  : TPacketHeader;
  Level   : Word;
  Unk     : WORD;// CCCC
  Exp     : COMP;
End;

Type TSendCurrentGold = Record
  Header  : TPacketHeader;
  Unk      : DWORD;
  Gold     : Comp;
End;

type TSendScorePacket = record
  Header: TPacketHeader; //12
  Score : TStatus;       //40
  Critical: BYTE;
  SaveMana: BYTE;

  Affects: array[0..15] of TPacketAffect;

	GuildMemberType, GuildIndex : BYTE;

	RegenHP, RegenMP : BYTE;

  Resist : array[0..3] of shortint;

	CurHP, CurMP : WORD;

	MagicIncrement : BYTE;
	Unknown: array[0..4] of BYTE;
end;

// Request Command
type TCommandPacket = record
  Header : TPacketHeader;
  Command: array[0..15] of AnsiChar;
  Value  : array[0..99] of AnsiChar;
end;

type TMessageAction = Record
  PosX, PosY: WORD;
  Speed : Integer;
  Effect: SmallInt;		// 0:¾É±â  1:¼­±â  2:°È±â  3:¶Ù±â  4:³¯±â  5:ÅÚ·¹Æ÷Æ®,	6:¹Ð¸®±â(knock-back), 7:¹Ì²ô·¯Áö±â(ÀÌµ¿¾Ö´Ï¾øÀ½)  8:µµ¹ß, 9:ÀÎ»ç, 10:µ¹°Ý
  Direction: SmallInt;	//
  TargetX,TargetY: WORD;
end;

// Request Add Points
type TRequestAddPoints = Record
  Header: TPacketHeader;
  Mode,Info: smallint;
  Unk: integer;
end;

{$REGION 'CharList Packet 0x901 size: 336'}
Type TSizeChar = Record
  Altura  : Byte;  //TAMANHO
  Tronco  : Byte;  //TAMANHO
  Perna   : Byte;  //TAMANHO
  Corpo   : Byte;  //TAMANHO
End;

Type Item = Record
   Cabelo, Face ,
   Elmo  , Peito,
   Luva  , Calça,
   Arma  , Escudo : Word;
End;

Type TAtributos = Record
  Força, Agiliade,
  Int  , Saude   ,
  Mana , Status  : Word;
End;

Type TCharListCharactersData = Record
  Name            : Array [0..15] of ansichar;
  Unk             : Word;
  Classe          : Word;
  SizeofChar      : TSizeChar;
  Equip           : Array [0..07] of Word;
  Refi            : array [0..11] of byte; //
  Atributos       : TAtributos;
  Level           : Word;
  NotUse          : array[0..5] of byte;
  Exp             : Comp;
  Gold            : Comp;
  NotUse2         : array[0..3] of byte;
  Delete          : LongBool;
  NumericError    : Byte;
  NumRegister     : BOOLEAN;
  NotUse3         : array[0..5] of byte;
End;

Type TSendToCharListPacket = Record //Att CharList  Size: 336   recv
  Header          : TPacketHeader;
  AcountID        : LongInt;
  Unk             : LongInt;
  NotUse          : array [0..3] of byte;
  CharactersData  : Array [0..2] of TCharListCharactersData;
End;
{$ENDREGION}

type TNumericTokenPacket = Record
	Header        : TPacketHeader;
  Slot          : DWORD;
  RequestChange : DWORD;
  Numeric_1     :  Array [0..3] of Ansichar;
  Numeric_2     :  Array [0..3] of Ansichar;
End;

Type TCreateCharacterRequestPacket = Record
   Header          : TPacketHeader;
   AcountID        : LongInt;
   SlotIndex       : DWORD;
   Name            : Array [0..15] of ansiChar;
   ClassIndex      : Word; //cabelo
   Face            : Word;
   Null            : Array [0..11] of byte;
   Local           : DWORD;
End;

type TUpdateCharacterListPacket = Record
  Header          : TPacketHeader;
  AcountID        : LongInt;
  Unk             : LongInt;
  NotUse          : array [0..3] of byte;
  CharactersData  : Array [0..2] of TCharListCharactersData;
end;

type TDeleteCharacterRequestPacket = Record
  Header: TPacketHeader;
  AcountSerial    : LongInt;
  SlotIndex       : DWORD;
  Delete          : LongBool;//esse é longbool 4bytes
  Password        : Array [0..3] of Ansichar;//não é necessario
end;

type TSelectCharacterRequestPacket = Record
  Header : TPacketHeader;
  CharacterId : Byte;
End;

type TSendToWorldPacket = Record
  Header         : TPacketHeader;
  AcountSerial   : LongInt;
  Character      : TCharacter;
end;

type TMovementPacket = Record
  Header      : TPacketHeader;
  Destination : TPosition;
  Null        : Array [0..5] of byte;
  MoveType    : Byte;
  Speed       : Byte;
  Unk         : DWORD;
end;

type TAffectInPacket = Record
  Time: BYTE;
  Index: BYTE;
end;

type TSendNPCSellItensPacket = Record
  Header: TPacketHeader;
  Index   : Word;
  Merch   : word;//Tipo de loja
  Item    : Array [0..14] of WORD;
End;

type TSellItemsToNpcPacket = Record
  Header: TPacketHeader;
  NpcID,InvSlot : DWORD;
end;

type TBuyNpcItensPacket = Record
  Header: TPacketHeader;
  mobID,sellSlot: smallint;
  invSlot,Unknown1: smallint;
  Unknown2: integer;
end;

type p2E4 = Record
  Header: TPacketHeader;
  slot, itemid: integer;
end;

//Send Party Request
type TPartyRequestPacket = Record
  Header: TPacketHeader;
  LeaderId: WORD;
  Level: WORD;
  MaxHp, CurHp: WORD;
  SenderId: WORD;
  Nick: array[0..15] of AnsiChar;//string[15];
  unk2: BYTE;
  TargetId: WORD;
end;

type TAcceptPartyPacket = Record
  Header: TPacketHeader;
  LeaderId: WORD;
  Nick: array[0..15] of AnsiChar;
end;

type TExitPartyPacket = Record
  Header: TPacketHeader;
  ExitId: WORD;
  unk: Word;//$CCCC
end;

type TSendPartyMember = Record
  Header: TPacketHeader;
  LiderID: WORD;
  Level: WORD;
  MaxHp, CurHp: WORD;
  ClientId: WORD;
  Nick: string[15];
  unk2: WORD;
end;

type TUseItemPacket = Record
  Header: TPacketHeader;
  SrcType, SrcSlot: integer;
  DstType, DstSlot: integer;

  Position : TPosition;
  unk: integer;
end;

// Request Drop Item
type TReqDropItem = Record
  Header: TPacketHeader;
  invType,
  InvSlot,
  Unknown1 : Integer;
  Position : TPosition;
  Unknown2 : Integer;
end;

// Request Pick Item
type TReqPickItem = Record
  Header : TPacketHeader;
  invType,
  InvSlot : Integer;
  initId : WORD;
  Position : TPosition;
  Unknown1 : WORD;
end;

type TDropDelete = Record
  Header : TPacketHeader;
  initId : WORD;
  Unknown1 : WORD;
End;

// MOB DEAD
type
p_p338 = ^TSendMobDeadPacket;

TSendMobDeadPacket = Record
	Header: TPacketHeader;
	Hold: integer;
  killed, killer: smallint;
	Exp: integer;
end;

type mob_kill = Record
  Hold, Exp: Integer;
  EnemyList, EnemyIndex: pInteger;
  Dead: boolean;
  inBattle: pBoolean;
end;

type TSendCreateMobPacket = Record  //PlayerSpam
   Header        : TPacketHeader;
   Name          : ARRAY [0..15] OF Ansichar;
   Equip         : Array [0..07] of Word;
   ItemEff       : Array [0..11] of byte;
   Position      : TPosition;
   Unk_0         : DWORD;//Null
   CurHP,CurMP,
   MaxHP,MaxMP   : DWORD;
   Unk0          : WORD;
   SpawnType     : BYTE;
   Altura, Tronco, Perna, Corpo : BYTE;
   UnkType       : Byte;
   EffectType    : Word;
   Unk           : word;
   Buffs         : Array [0..59] OF WORD;
   UnkBytes      : Array [0..239] of byte;
   Title         : ARRAY [0..31] OF Ansichar;
   UnkBytes2     : Array [0..19] of byte;
End;

type TTradePacket = Record
	Header       : TPacketHeader;
	TradeItem    : Array [0..9] of TITEM;
	TradeItemSlot: Array [0..9] of byte;
  Null         : Word;
  Gold         : Comp;
  Confirm      : boolean;
	Waiting      : boolean;
  OtherClientid: WORD;
  Null0        : LongInt;
end;

// Request Open Trade - 39A

//Open Trade
type TOpenTrade = Record
  Header       : TPacketHeader;
  OtherClientId: integer;
end;

// Request Buy Item Trade
type TBuyStoreItemPacket = Record
  Header: TPacketHeader;
  Slot: integer;
  SellerId: integer;
  Gold: integer;
  Unknown: integer;
  Item: TItem;
end;

type TSendItemBoughtPacket = Record
  Header: TPacketHeader;
  SellerId: Integer;
  Slot: Integer;
end;

// Request Create Item
type TSendCreateItemPacket = record
  Header: TPacketHeader;
  Notice   : Boolean;
  invType  : Byte;
  invSlot  : Byte;
  itemData : TItem;
end;

// Send Delete Item
type TSendDeleteItemPacket = record
  Header: TPacketHeader;
  invType: integer;
  invSlot: integer;
  Unknown: integer;
  Pos : TPosition;
end;

type TSendCreateDropItem = Record
  Header: TPacketHeader;
  Pos : TPosition;
  initId : WORD;
  item: TItem;
  rotation,
  status : BYTE;
  Unknown: integer;
End;
// Request Refresh Inventory



// Request Refresh Etc


// Request Move Item
type TMoveItemPacket = record
  Header: TPacketHeader;
  SrcType,SrcSlot,
  DestType,DestSlot : WORD;
end;

// Request Refresh Itens
type TRefreshEquips = record
  private
    function GetBits(Index : BYTE; const aIndex: Integer): WORD;
    procedure SetBits(Index : BYTE; const aIndex: Integer; const aValue: WORD);

  public
    Header: TPacketHeader;

    itemIDEF: array[0..15] of WORD;
    {
        unsigned short ItemID : 12;
        unsigned short Sanc : 4;
    } //ItemEff[16];

    pAnctCode: array[0..15] of shortint;

    property Sanc[Index : BYTE] : WORD index $0C04 read GetBits write SetBits;
end;

type TRequestOpenPlayerStorePacket = Record
  Header: TPacketHeader;
  Trade: TTradeStore;
end;


type TTarget = Record
  Index, Damage: WORD;
end;

//Attack Sigle Mob
type TProcessAttackOneMob = Record
	Header: TPacketHeader;
	AttackerID, AttackCount: smallint; // Id de quem Realiza o ataque
	AttackerPos: TPosition; // Posicao X e Y de quem Ataca
	TargetPos: TPosition; // Posicao X e Y de quem Sofre o Ataque
	SkillIndex: smallint; // Id da skill usada
	CurrentMp: smallint; // Mp atual de quem Ataca
	Motion: shortint;   // (*)
	SkillParm: shortint; // (*)
	FlagLocal: shortint; // (*)
	DoubleCritical: shortint; // 0 para critico Simples, 1 para critico Duplo
	Hold ,CurrentExp: integer;
	ReqMp: smallint; // Mp necessario para usar a Skill
	Rsv: smallint;  // (*)
  Target: TTarget;
end;


//Ataque em area
type TProcessAoEAttack = Record
	Header: TPacketHeader;
	AttackerID,AttackCount: smallint; // Id de quem Realiza o ataque
	AttackerPos: TPosition; // Posicao X e Y de quem Ataca
	TargetPos: TPosition; // Posicao X e Y de quem Sofre o Ataque
	SkillIndex: smallint; // Id da skill usada
	CurrentMp: smallint; // Mp atual de quem Ataca
	Motion: shortint;
	SkillParm: shortint;
	FlagLocal: shortint;
	DoubleCritical: shortint; // 0 para critico Simples, 1 para critico Duplo
	Hold ,CurrentExp: integer;
	ReqMp: smallint; // Mp necessario para usar a Skill
	Rsv: smallint;
	Targets: array[0..12] of TTarget;
end;


//atack reto
type
p_p39E = ^p39E;
p39E = Record
	Header: TPacketHeader;
	AttackerID,AttackCount: smallint; // Id de quem Realiza o ataque
	AttackerPos: TPosition; // Posicao X e Y de quem Ataca
	TargetPos: TPosition; // Posicao X e Y de quem Sofre o Ataque
	SkillIndex: smallint; // Id da skill usada
	CurrentMp: smallint; // Mp atual de quem Ataca
	Motion: shortint;
	SkillParm: shortint;
	FlagLocal: shortint;
	DoubleCritical: shortint; // 0 para critico Simples, 1 para critico Duplo
	Hold ,CurrentExp: integer;
	ReqMp: smallint; // Mp necessario para usar a Skill
	Rsv: smallint;

  Target: array[0..1] of TTarget;
end;

// Request Emotion
type TSendEmotionPacket = Record
  Header : TPacketHeader;
  effType, effValue: smallint;
  Unknown1: integer;
end;

type TSendWeatherPacket = Record
  Header: TPacketHeader;
  WeatherId: Integer;
End;


{
 type TSkillBarChange = Record //altera o que ta no slot da skillbar
  Header  : TPacketHeader;
  Slot     : DWORD;
  TypeItem : DWORD;
  ItemID   : DWORD;
End;
}
type TSkillBarChange = Record
  Header  : TPacketHeader;
  SkillBar: array[0..19] of BYTE;
End;



type TCompoundersPacket = record
	  Header : TPacketHeader;
    Item: array[0..7] of TItem;
	  Slot: array[0..7] of BYTE;
end;

//SendAffect
type TSendAffectsPacket = record
	Header: TPacketHeader;
	Affects: array[0..15] of TAffect;
end;

// Effect Defines
Const
None                                                             = 00;

EF_BLANK01                                                       = 01;
EF_DAMAGE1                                                       = 02;
EF_DAMAGE2                                                       = 03;
EF_DAMAGE3                                                       = 04;
EF_DAMAGE4                                                       = 05;
EF_DAMAGE5                                                       = 06;
EF_DAMAGE6                                                       = 07;
EF_RESISTANCE1                                                   = 08;
EF_RESISTANCE2                                                   = 09;
EF_RESISTANCE3                                                   = 10;
EF_RESISTANCE4                                                   = 11;
EF_RESISTANCE5                                                   = 12;

EF_HP                                                            = 13;
EF_MP                                                            = 14;
EF_STR                                                           = 15;
EF_DEX                                                           = 16;
EF_INT                                                           = 17;
EF_CON                                                           = 18;
EF_SPI                                                           = 19;
EF_RESISTANCE6                                                   = 20;
EF_RESISTANCE7                                                   = 21;
EF_REITERATION                                                   = 22;
EF_DELAY_ATTACK1                                                 = 23;
EF_REFLECTION1                                                   = 24;
EF_ANTI_SKILL                                                    = 25;
EF_CHECK_SKILL                                                   = 26;
EF_ADD_DAMAGE1                                                   = 27;
EF_CAST_RATE                                                     = 28;
EF_AMP_PHYSICAL                                                  = 29;
EF_AMP_MAGIC                                                     = 30;
EF_CRITICAL_POWER                                                = 31;
EF_MOUNT_CONCENTRATION                                           = 32;
EF_SKILL_ATIME9                                                  = 33;
EF_AMP_SKILL_DAMAGE                                              = 34;
EF_POLLUTION_RESISTANCE                                          = 35;
EF_SIEGE_LEVEL                                                   = 36;
EF_DRAIN_MP                                                      = 37;
EF_DELAY_ATTACK2                                                 = 38;
EF_UNIDENTIFIED                                                  = 39;
EF_POLYMORPH1                                                    = 40;
EF_POLYMORPH2                                                    = 41;
EF_AWAKEN                                                        = 42;
EF_DOT_TIMER                                                     = 43;
EF_HP_CHECK_PC                                                   = 44;
EF_ATK_MONSTER                                                   = 45;
EF_RUNSPEED                                                      = 46;
EF_RANGE                                                         = 47;
EF_COOLTIME                                                      = 48;
EF_DOUBLE                                                        = 49;
EF_CRITICAL                                                      = 50;
EF_PARRY                                                         = 51;
EF_BLOCKING                                                      = 52;
EF_HIT                                                           = 53;
EF_PER_DAMAGE1                                                   = 54;
EF_PER_DAMAGE2                                                   = 55;
EF_PER_DAMAGE3                                                   = 56;
EF_PER_DAMAGE4                                                   = 57;
EF_PER_DAMAGE5                                                   = 58;
EF_PER_RESISTANCE1                                               = 59;
EF_PER_RESISTANCE2                                               = 60;
EF_PER_RESISTANCE3                                               = 61;
EF_PER_RESISTANCE4                                               = 62;
EF_PER_RESISTANCE5                                               = 63;
EF_REGENHP                                                       = 64;
EF_REGENMP                                                       = 65;
EF_SKILL_DAMAGE                                                  = 66;
EF_SKILL_HP_DAMAGE                                               = 67;
EF_ATK_NATION2                                                   = 68;
EF_DEF_NATION2                                                   = 69;
EF_RECALL                                                        = 70;
EF_SKILL_IMMOVABLE                                               = 71;
EF_SKILL_INVISIBILITY                                            = 72;
EF_SKILL_STUN                                                    = 73;
EF_SKILL_PROVOKE                                                 = 74;
EF_SKILL_DEATH                                                   = 75;
EF_SKILL_KNOCKBACK                                               = 76;
EF_SKILL_DISPEL1                                                 = 77;
EF_SKILL_DISPEL2                                                 = 78;
EF_SKILL_ABSORB1                                                 = 79;
EF_STATE_RESISTANCE                                              = 80;
EF_DASH                                                          = 81;
EF_SKILL_DIVISION                                                = 82;
EF_SKILL_DISPEL3                                                 = 83;
EF_SKILL_DISPEL4                                                 = 84;
EF_SKILL_DISPEL5                                                 = 85;
EF_PIERCING_RESISTANCE1                                          = 86;
EF_PIERCING_RESISTANCE2                                          = 87;
EF_SKILL_UNARMORED                                               = 88;
EF_CRITICAL_DEFENCE                                              = 89;
EF_ATK_ALIEN                                                     = 90;
EF_ATK_BEAST                                                     = 91;
EF_ATK_PLANT                                                     = 92;
EF_ATK_INSECT                                                    = 93;
EF_ATK_DEMON                                                     = 94;
EF_ATK_UNDEAD                                                    = 95;
EF_ATK_COMPLEX                                                   = 96;
EF_ATK_STRUCTURE                                                 = 97;
EF_DEF_ALIEN                                                     = 98;
EF_DEF_BEAST                                                     = 99;
EF_DEF_PLANT                                                     = 100;
EF_DEF_INSECT                                                    = 101;
EF_DEF_DEMON                                                     = 102;
EF_DEF_UNDEAD                                                    = 103;
EF_DEF_COMPLEX                                                   = 104;
EF_DEF_STRUCTURE                                                 = 105;
EF_AGGRO1                                                        = 106;
EF_AGGRO2                                                        = 107;
EF_AGGRO3                                                        = 108;
EF_AGGRO4                                                        = 109;
EF_SKILL_DOT_DAMAGE6                                             = 110;
EF_SKILL_DOT_MP                                                  = 111;
EF_REQUIRE_MP                                                    = 112;
EF_REQUIRE_MP0                                                   = 113;
EF_REQUIRE_MP1                                                   = 114;
EF_REQUIRE_MP2                                                   = 115;
EF_REQUIRE_MP3                                                   = 116;
EF_REQUIRE_MP4                                                   = 117;
EF_REQUIRE_MP5                                                   = 118;
EF_REQUIRE_MP6                                                   = 119;
EF_REQUIRE_MP7                                                   = 120;
EF_REQUIRE_MP8                                                   = 121;
EF_SKILL_ATIME6                                                  = 122;
EF_SKILL_RESURRECTION                                            = 123;
EF_DUR_RATE                                                      = 124;
EF_DURABILITY                                                    = 125;
EF_UNBREAKABLE                                                   = 126;
EF_RANDOM_MIN                                                    = 127;
EF_RANDOM_MAX                                                    = 128;
EF_STOP_REGEN_HP                                                 = 129;
EF_STOP_REGEN_MP                                                 = 130;
EF_CRITICAL_STUN                                                 = 131;
EF_ATK_DIVINE                                                    = 132;
EF_DRAIN_HP                                                      = 133;
EF_TARGET_FIX                                                    = 134;
EF_ANTI_MAGIC                                                    = 135;
EF_TRANSFER                                                      = 136;
EF_TRANSFER_LIMIT                                                = 137;
EF_REACTION                                                      = 138;
EF_CHANGE                                                        = 139;
EF_SILENCE1                                                      = 140;
EF_SILENCE2                                                      = 141;
EF_HP_CONVERSION                                                 = 142;
EF_MP_EFFICIENCY                                                 = 143;
EF_HP_CHECK                                                      = 144;
EF_REQUIRE_MPA                                                   = 145;
EF_RELIQUE_PER_HP                                                = 146;
EF_RELIQUE_PER_EXP                                               = 147;
EF_RELIQUE_PER_MP                                                = 148;
EF_RELIQUE_PER_DAMAGE1                                           = 149;
EF_RELIQUE_PER_DAMAGE2                                           = 150;
EF_SKILL_SHOCK                                                   = 151;
EF_SKILL_BLIND                                                   = 152;
EF_SKILL_SLEEP                                                   = 153;
EF_DECURE                                                        = 154;
EF_POINT_DEFENCE                                                 = 155;
EF_REFLECTION2                                                   = 156;
EF_MPCURE                                                        = 157;
EF_SPLASH                                                        = 158;
EF_UNARMOR                                                       = 159;
EF_HIDE_LIMIT                                                    = 160;
EF_HP_LIMIT                                                      = 161;
EF_SUMMON                                                        = 162;
EF_CAST_SPELL                                                    = 163;
EF_ANTICURE_COUNT                                                = 164;
EF_ANTICURE                                                      = 165;
EF_MASS_TELEPORT                                                 = 166;
EF_DELAY_DAMAGE6                                                 = 167;
EF_DISPEL_BUFF                                                   = 168;
EF_BREAK_BUFF                                                    = 169;
EF_DISPEL_ALL                                                    = 170;
EF_REFLECTION3                                                   = 171;
EF_REFLECTION4                                                   = 172;
EF_FAIRY_FORM                                                    = 173;
EF_RELIQUE_SKILL_PER_DAMAGE                                      = 174;
EF_RELIQUE_SKILL_ATIME0                                          = 175;
EF_RELIQUE_ATK_NATION                                            = 176;
EF_RELIQUE_DEF_NATION                                            = 177;
EF_RELIQUE_ALL_ABILITY                                           = 178;
EF_SELFHP_LIMIT                                                  = 179;
EF_CALLSKILL                                                     = 180;
EF_INITCOOLTIME                                                  = 181;

EF_PRAN_DAMAGE1                                                  = 182;
EF_PRAN_DAMAGE2                                                  = 183;
EF_PRAN_HP                                                       = 184;
EF_PRAN_MP                                                       = 185;
EF_PRAN_RESISTANCE1                                              = 186;
EF_PRAN_RESISTANCE2                                              = 187;
EF_PRAN_CRITICAL                                                 = 188;
EF_PRAN_SKILL_DAMAGE                                             = 189;
EF_PRAN_SKILL_ABSORB1                                            = 190;
EF_PRAN_REGENHP                                                  = 191;
EF_PRAN_REGENMP                                                  = 192;
EF_PRAN_PARRY                                                    = 193;
EF_PRAN_REQUIRE_MP                                               = 194;
EF_PRAN_STATE_RESISTANCE                                         = 195;

EF_CHAOS                                                         = 196;
EF_TYPE45                                                        = 197;

EF_RELIQUE_CRITICAL                                              = 198;
EF_RELIQUE_HIT                                                   = 199;
EF_RELIQUE_PARRY                                                 = 200;
EF_RELIQUE_DOUBLE                                                = 201;
EF_RELIQUE_STATE_RESISTANCE                                      = 202;
EF_RELIQUE_ATK_MONSTER                                           = 203;
EF_RELIQUE_DEF_MONSTER                                           = 204;
EF_RELIQUE_LEVEL_UPGRADE                                         = 205;
EF_BLANK03                                                       = 206;
EF_BLANK04                                                       = 207;
EF_DISPEL_RANDOM                                                 = 208;
EF_RELIQUE_PER_RESISTANCE1                                       = 209;
EF_RELIQUE_PER_RESISTANCE2                                       = 210;
EF_RELIQUE_DROP_RATE                                             = 211;
EF_RELIQUE_COOLTIME                                              = 212;
EF_RELIQUE_RUNSPEED                                              = 213;
EF_SKILL_DAMAGE6                                                 = 214;
EF_DAMAGE_SWARM                                                  = 215;
EF_ANTI_SWARM                                                    = 216;
EF_SKILL_CRITICAL                                                = 217;
EF_AFTEREFFECT                                                   = 218;
EF_PARALYSIS                                                     = 219;
EF_SUMMON_TARGET                                                 = 220;
EF_WEAPON_GUARD                                                  = 221;
EF_BATTLE_REGENHP                                                = 222;
EF_DAMAGE7                                                       = 223;
EF_BATTEL_RENEGADE                                               = 224;
EF_SUICIDE                                                       = 225;
EF_FEAR                                                          = 226;
EF_BATTLE_DAMAGE1                                                = 227;
EF_BATTLE_DAMAGE2                                                = 228;
EF_BATTLE_HP                                                     = 229;
EF_BATTLE_MP                                                     = 230;
EF_BATTLE_RESISTANCE1                                            = 231;
EF_BATTLE_RESISTANCE2                                            = 232;
EF_ABSOLUT_DAMAGE6                                               = 233;
EF_UPCURE                                                        = 234;
EF_FREEZE                                                        = 235;
EF_PULL_TARGET                                                   = 236;
EF_GUARD                                                         = 237;
EF_GUARD_RATE                                                    = 238;
EF_PROMESSA                                                      = 239;
EF_ULTIMATUM                                                     = 240;
EF_SNIPING_STANCE                                                = 241;
EF_IM_RUNSPEED                                                   = 242;
EF_IM_SKILL_IMMOVABLE                                            = 243;
EF_BLOODYROSE                                                    = 244;
EF_DEAD_LINK                                                     = 245;
EF_IM_SILENCE1                                                   = 246;
EF_IM_FEAR                                                       = 247;
EF_IM_SKILL_STUN                                                 = 248;
EF_IM_SKILL_SHOCK                                                = 249;
EF_IMMUNITY                                                      = 250;
EF_PROMESSA_LINK                                                 = 251;
EF_MARSHAL_PER_HP                                                = 252;
EF_MARSHAL_PER_MP                                                = 253;
EF_MARSHAL_ATK_NATION                                            = 254;
EF_MARSHAL_DEF_NATION                                            = 255;
EF_BREAK_ANTI_MAGIC                                              = 256;
EF_DAMAGE_TO_HP                                                  = 257;
EF_2SEC_RANDOM_COUNT                                             = 258;
EF_SKILL_CALLSKILL                                               = 259;
EF_DEATH_LIFE                                                    = 260;
EF_ABSOLUT_DAMAGE                                                = 261;
EF_SUMMON_MOUNT                                                  = 262;
EF_SUMMON_LOCK                                                   = 263;
EF_LIMIT_HP_UP                                                   = 264;
EF_INITSKILL                                                     = 265;
EF_BUFF_CONSERVATION                                             = 266;
EF_DOUBLE_HONOR_POINT                                            = 267;
EF_PER_HP                                                        = 268;
EF_PER_MP                                                        = 269;
EF_REDUCE_AOE                                                    = 270;
EF_BLANK15                                                       = 271;
EF_BLANK16                                                       = 272;
EF_SPEND_MANA                                                    = 273;
EF_COUNT_HIT                                                     = 274;
EF_AMP_PARALYSIS_ATTACK                                          = 275;
EF_SKILL_ABSORB2                                                 = 276;
EF_AMP_SKILL_DAMAGE6                                             = 277;
EF_PREMIUM_PER_EXP                                               = 278;
EF_HEADSCALE                                                     = 279;
EF_PC_PREMIUM_PER_EXP                                            = 280;
EF_SKILL_DOT_PER_HPCURE                                          = 281;
EF_NPC_ACCESS_DENIED                                             = 282;
EF_PARTY_PER_DROP_RATE                                           = 283;
EF_SPI_PER_MP                                                    = 284;
EF_ACCELERATION1                                                 = 285;
EF_ACCELERATION2                                                 = 286;
EF_ACCELERATION3                                                 = 287;
EF_IMPACT1                                                       = 288;
EF_IMPACT2                                                       = 289;
EF_IMPACT3                                                       = 290;
EF_LEGION_PER_EXP                                                = 291;
EF_LEGION_RATE_EXP                                               = 292;
EF_LEGION_BONUS_EXP                                              = 293;
EF_HONOR_PLUS                                                    = 294;
EF_RVR_EXP                                                       = 295;
EF_LEGION_DOT_PER_HPCURE                                         = 296;
EF_LEGION_DOT_PER_MPCURE                                         = 297;
EF_LEGION_DOT_TIMER                                              = 298;
EF_LEGION_MEMBER_HP                                              = 299;
EF_LEGION_MEMBER_LIMITEHP                                        = 300;
EF_LEGION_MEMBER_MP                                              = 301;
EF_LEGION_EXPLOITPOINT                                           = 302;
EF_LEGION_DECREASE                                               = 303;
EF_SWAP_AGGRO                                                    = 304;
EF_MANABURN                                                      = 305;
EF_REDUCE_CRITICAL_DAMAGE                                        = 306;
EF_PARTY_PER_DAMAGE6                                             = 307;
EF_LEGION_MEMBER_LIMITEMP                                        = 308;
EF_HP_BASE_DAMAGE                                                = 309;
EF_IMMUNITY_AFFECT                                               = 310;
EF_KILLING_RESTORE_HP                                            = 311;
EF_KILLING_RESTORE_MP                                            = 312;
EF_INSTANT_DEATH0                                                = 313;
EF_INSTANT_DEATH5                                                = 314;
EF_HP_MARK                                                       = 315;
EF_MP_MARK                                                       = 316;
EF_DECREASE_HP_DAMAGE                                            = 317;
EF_DECREASE_HP_DAMAGE_LIMIT                                      = 318;
EF_DECREASE_PER_DAMAGE1                                          = 319;
EF_DECREASE_PER_DAMAGE2                                          = 320;
EF_CREATE_ITEM                                                   = 321;
EF_DECREASE_PER_HP                                               = 322;
EF_DECREASE_PER_MP                                               = 323;
EF_DECREASE_PER_RESISTANCE1                                      = 324;
EF_DECREASE_PER_RESISTANCE2                                      = 325;
EF_DOUBLE_DAMAGE_PC                                              = 326;
EF_LEOPOLD_ATK_NATION                                            = 327;
EF_LEOPOLD_DEF_NATION                                            = 328;
EF_DEBUFF_ADD_DAMAGE                                             = 329;
EF_INITCOOLTIME_AGGRESSIVE                                       = 330;
EF_SILENCE_CURE                                                  = 331;
EF_SKILL_SELFSKILL                                               = 332;
EF_CLEAR_DAMAGE                                                  = 333;
EF_VISUAL_EFFECT_LINK                                            = 334;
EF_MONSTER_SUMMON                                                = 335;
EF_QUESTEXP_UP                                                   = 336;
EF_FISHING                                                       = 337;
EF_PRAN_EXP_UP                                                   = 338;
EF_IM_SLEEP                                                      = 339;
EF_ABSOLUTE_ZERO                                                 = 340;
EF_PRAN_DOUBLE                                                   = 341;
EF_CHECK_HP_DAMAGE                                               = 342;
EF_FILTER_HP_DAMAGE                                              = 343;
EF_ATK_BOSS                                                      = 344;
EF_DEF_BOSS                                                      = 345;
EF_SKILL_DOT_DAMAGE1                                             = 346;
EF_SKILL_DOTA_DAMAGE1                                            = 347;
EF_SKILL_DOTB_DAMAGE1                                            = 348;
EF_SKILL_DOTC_DAMAGE1                                            = 349;
EF_SKILL_DOTD_DAMAGE1                                            = 350;
EF_SKILL_DOT_DAMAGE2                                             = 351;
EF_SKILL_DOTA_DAMAGE2                                            = 352;
EF_SKILL_DOTB_DAMAGE2                                            = 353;
EF_SKILL_DOTC_DAMAGE2                                            = 354;
EF_SKILL_DOTD_DAMAGE2                                            = 355;
EF_BODYSCALE                                                     = 356;
EF_BLOOD_SPEND                                                   = 357;
EF_DECEIVE_ATK                                                   = 358;
EF_DECEIVE_DEF                                                   = 359;
EF_MP_BASE_DAMAGE                                                = 360;
EF_PER_CURE_PREPARE                                              = 361;
EF_PER_CURE_ACTIVATE                                             = 362;
EF_PREMIUM_PER_EXP2                                              = 363;
EF_ART_PER_HP                                                    = 364;
EF_ART_HP_PER_DAMAGE1                                            = 365;
EF_ART_SKILL_PER_REDUCE                                          = 366;
EF_ART_RES1_PER_DAMAGE1                                          = 367;
EF_ART_DD_SKILL_PER_HEAL                                         = 368;
EF_ART_AOE_PER_AMP                                               = 369;
EF_ART_CRITICAL_PER_DOUBLE                                       = 370;
EF_ART_DEX_TO_DAMAGE1                                            = 371;
EF_ART_PER_MP                                                    = 372;
EF_ART_MP_PER_DAMAGE2                                            = 373;
EF_ART_MP_PER_SDAMAGE6                                           = 374;
EF_ART_INT_TO_DAMAGE2                                            = 375;
EF_CONSERVATION_HONOR_POINT                                      = 376;
EF_PER_RESISTANCE11                                              = 377;
EF_PER_DAMAGE11                                                  = 378;
EF_PER_HP_MP                                                     = 379;
EF_STR_DEX_INT                                                   = 380;
EF_CRITICAL_DROP                                                 = 381;
EF_STANCE_LIMIT                                                  = 382;
EF_TARGETHP_PER_DAMAGE                                           = 383;
EF_REFLECTION5                                                   = 384;
EF_REFLECTION6                                                   = 385;
EF_DUNGEON_BOSS_PER_DROP_RATE                                    = 386;
EF_MULTIPLE_EXP4                                                 = 387;
EF_SUMMONGEN                                                     = 388;
EF_PER_HONOR_POINT                                               = 389;
EF_MENTOR_GUILD                                                  = 390;
EF_REVIVE                                                        = 391;
EF_REVIVEPLUS                                                    = 392;
EF_FEARPLUS                                                      = 393;
EF_DUNGEON_ON                                                    = 394;

type TMoveCommandPacket = Record // 52 -> 17
  Header: TPacketHeader;
  Destination: TPosition;
  Speed : Byte;
end;


implementation

uses System.Threading;

function TRefreshEquips.GetBits(Index : BYTE; const aIndex: Integer): WORD;
begin
  Result := GetBits(itemIDEF[Index], aIndex);
end;

procedure TRefreshEquips.SetBits(Index : BYTE; const aIndex: Integer; const aValue: WORD);
begin
  SetWordBits(itemIDEF[Index], aIndex, aValue);
end;

end.
