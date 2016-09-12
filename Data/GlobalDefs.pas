unit GlobalDefs;

interface

uses System.Threading, Generics.Collections,

    PlayerData, MiscData, Load, Functions, NPC, NpcFunctions, ItemFunctions,
    ServerSocket, Threads, Player, Packets, Log, Util;

var
  CurrentServer: TCitizenship = TCitizenship.Server1;


  Neighbors: array[0..6] of TPosition;

  CurrentDir: string;
  MobGrid, ItemGrid: array[0..4096] of array[0..4096] of Word;
  g_pItemGrid : array[0..7] of array[0..7] of BYTE = (
    ( 01, 00, 00, 00, 00, 00, 00, 00 ), ( 01, 00, 01, 00, 00, 00, 00, 00 ),
    ( 01, 00, 01, 00, 01, 00, 00, 00 ), ( 01, 00, 01, 00, 01, 00, 01, 00 ),
    ( 01, 01, 00, 00, 00, 00, 00, 00 ), ( 01, 01, 01, 01, 00, 00, 00, 00 ),
    ( 01, 01, 01, 01, 01, 01, 00, 00 ), ( 01, 01, 01, 01, 01, 01, 01, 01 )
    );
  TimeTick: Cardinal;
  CityWeather: array[0..3] of TWeather;
  NpcFuncs: TNpcFunctions;
  ItemFuncs: TItemFunctions;

  Logger : TLog;
  Server : TServerSocket;
  HeightGrid : THeightMap;
  ItemList : TDictionary<integer, TItemList>;
  MobGener : TDictionary<integer, TMOBGener>;
  TeleportsList : TList<TTeleport>;
  SkillsData : TList<TSkillData>;
  MobBabyList : TList<TCharacter>;

  InstantiatedPlayers : Integer;
  Players : array[1..750] of TPlayer;

  NPCs : array[1001..30000] of TNpc;
  InstantiatedNPCs: WORD;

  InitialCharacters: array[0..5] of TCharacter;//AIka tem 6 tipo de personagens
  Parties : array[1..750] of TParty;
  Quests: TList<TQuest>;

const MAX_CONNECTIONS = 750;
  MAX_SPAWN_ID = 30000;
  MAX_INITITEM_LIST = 10000;

  AI_DELAY_MOVIMENTO = 2000;

  MAX_CARRY = 8;
  MAX_INVEN	= 48;
  Taxes = 5;
  CARRYGRIDX = 9;
  CARRYGRIDY = 7;
  MAX_GRIDX = 4096;
  MAX_GRIDY = 4096;

  EQUIP_TYPE    = 0;
  INV_TYPE      = 1;
  STORAGE_TYPE  = 2;

  DISTANCE_TO_WATCH = 14;
  DISTANCE_TO_FORGET = 16;

  WORLD_MOB = 0;
  WORLD_ITEM = 1;


  MOVE_NORMAL = 0;
  MOVE_TELEPORT = 1;
  MOVE_GENERATESUMON = 8; // Segundo o Guican

  DELETE_NORMAL = 0;      // Somente desaparece
  DELETE_DEAD = 1;        // Animacao da morte do spawn
  DELETE_DISCONNECT = 2;  // Efeito de quando o personagem sai do jogo
  DELETE_UNSPAWN = 3;     // Efeito quando os monstros ancts somem


  SPAWN_NORMAL = 0;    // Somente aparece
  SPAWN_TELEPORT = 2; // Efeito usado quando o personagem nasce ou eh teleportado
  SPAWN_BABYGEN = 3;  // Efeito de quando uma cria nasce

  //BUFS INDEX
  LENTIDAO              = 1;
  FM_VELOCIDADE         = 2;
  RESISTENCIA_N         = 3;
  EVASAO_N              = 5;
  POCAO_ATK             = 6;
  VELOCIDADE_N          = 7;
  ADD                   = 8;
  FM_BUFFATK            = 9;
  ATKMENOS              = 10;
  FM_ESCUDO_MAGICO      = 11;
  DEFESA_N              = 12;
  TK_ASSALTO            = 13;
  TK_POSSUIDO           = 14;
  FM_SKILLS             = 15;
  BM_MUTACAO            = 16;
  TK_AURAVIDA           = 17;
  FM_CONTROLE_MANA      = 18;
  HT_IMUNIDADE          = 19;
  VENENO                = 20;
  HT_MEDITACAO          = 21;
  FM_TROVAO             = 22;
  BM_AURA_BESTIAL       = 23;
  TK_SAMARITANO         = 24;
  BM_PROTELEMENT        = 25;
  HT_EVASAO_APRIMORADA  = 26;
  HT_GELO               = 27;
  HT_INIVISIBILIDADE    = 28;
  LIMITE_DA_ALMA        = 29;
  PvM                   = 30;
  HT_ESCUDO_DOURADO     = 31;
  CANCELAMENTO          = 32;
  MUTACAO2              = 33;
  COMIDA                = 34;
  BONUS_HP_MP           = 35;
  HT_VENENO             = 36;
  HT_LIGACAO_ESPCTRAL   = 37;
  HT_TROCAESP           = 38;
  BAU_EXP               = 39;

  //MUTAÇÂO MASTER
  LOBISOMEM              = 1;
  URSO                   = 2;
  ASTAROTH               = 3;
  TITAN                  = 4;
  EDEN                   = 5;

var InitItems : array[1..MAX_INITITEM_LIST] of TInitItem;

implementation

end.
