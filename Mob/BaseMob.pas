unit BaseMob;

interface

uses Windows, PlayerData, MiscData, Packets, Generics.Collections, SysUtils,
  DateUtils, Diagnostics;

type TPrediction = record
  ETA: Single;
  Timer: {TDateTime;}TStopwatch;
  Source: TPosition;
  Destination: TPosition;

  function CanPredict: Boolean;
  function Elapsed: Integer;
  function Delta: Single;
  function Interpolate(out d: Single): TPosition;

  procedure Create; overload;
  procedure CalcETA(speed: Byte);
end;

type PBaseMob = ^TBaseMob;
TBaseMob = record
  private
    _prediction: TPrediction;
    _cooldown: TDictionary<Byte, TTime>;
    _currentPosition: TPosition;

    procedure DeterminMoveDirection(const pos: TPosition);

    procedure AddToVisible(var mob : TBaseMob);
    procedure RemoveFromVisible(mob : TBaseMob);

    procedure SendSignal(pIndex, opCode: WORD);
    function  GetEquipDamage(LR : Integer): WORD;
    procedure ApplyDamage(attacker: TBaseMob; damage: Integer);

  public
    ClientId       : WORD;
    Character      : PCharacter;
    PlayerCharacter: TPlayerCharacter;
    AttackSpeed    : WORD;
    IsActive       : Boolean;
    IsDirty        : Boolean;
    Mobbaby        : WORD;
    PartyId        : WORD;
    PartyRequestId : WORD;
    VisibleMobs    : TList<WORD>;
    Target         : PBaseMob;


    procedure Create(characterPointer : PCharacter; index: WORD); overload;
    procedure Destroy();
    procedure SendPacket(packet : pointer; size : WORD);


    property LeftDamage  : WORD Index 7 read GetEquipDamage;
    property RightDamage : WORD Index 8 read GetEquipDamage;

    function IsPlayer : boolean;
    function IsDead : boolean;
    function IsMoving : boolean;
    function InBattle : boolean;
    function CurrentPosition: TPosition;

    procedure SetDestination(const destination: TPosition);

    procedure UpdateVisibleList();

    function CheckCooldown(skillId: Byte): Boolean;
    procedure UsedSkill(skillId: Byte);

    // Sends
    procedure SendMovement(destination : TPosition; calcDirection: Boolean = true); overload;
    procedure SendMovement(destX, destY : Single; calcDirection: Boolean = true); overload;
    procedure SendRemoveMob(delType: integer = 0; sendTo : WORD = 0);
    procedure SendChat(Name , str: AnsiString);

    procedure SendCurrentHPMP();
    Procedure SendStatus();
    procedure SendRefreshPoint();
    procedure SendRefreshLevel();

    procedure SendScore();
    procedure SendCreateMob(spawnType : WORD = 0; sendTo : WORD = 0);
    procedure SendEmotion(effType, effValue: smallint);
    procedure SendToVisible(packet : pointer; size : WORD; sendToSelf : Boolean = true);
    procedure SendParty(leader, member : WORD); overload;
    procedure SendParty; overload;
    procedure SendDamage(target: TBaseMob; skillId : Byte; damage: Integer = -1); overload;
    procedure SendDamage(targets: TList<WORD>; skillId : Byte; damage: Integer = -1); overload;
    procedure SendMobDead(killer: TBaseMob);
    procedure SendAffects();
    procedure SendEquipItems(sendSelf : Boolean = True);

    //Gets
    procedure GetCurrentScore();
    procedure GetAffectScore;
    function GetFirstSlot(itemId: WORD; invType: BYTE): Integer;
    function GetItemAmount(itemId: Integer; inv: array of TItem): TItemAmount;
    function GetCurrentHP(): Integer;
    function GetCurrentMP(): Integer;
    function GetEmptySlot(): Byte;
    procedure GetCreateMob(out packet : TSendCreateMobPacket);
    function GetMaxAbility(eff: integer): integer;
    function GetMobAbility(eff: integer):integer;
    function GetDamage(target: TBaseMob; master: Byte): smallint;


    function Teleport(x, y: Single) : Boolean; overload;
    function Teleport(position : TPosition) : Boolean; overload;

    procedure AddAffect(affect: TAffect);
    procedure SetAffect(affectId: Byte; affect: TAffect);
    procedure CleanAffect(affectId: Byte);

    procedure RemoveItem(slot, slotType: BYTE);
    procedure AddExp(exp : WORD);


    procedure GenerateBabyMob;
    procedure UngenerateBabyMob(ungenEffect: WORD);

    procedure ForEachInRange(range: Byte; proc: TProc<TPosition, TBaseMob, TBaseMob>); overload;
    procedure ForEachVisible(proc: TProc<TBaseMob>);


    class function GetMob(index: WORD; out mob: TBaseMob): boolean; overload; static;
    class function GetMob(index: WORD; out mob: PBaseMob): boolean; overload; static;
    class function GetMob(pos: TPosition; out mob: TBaseMob): boolean; overload; static;
    class procedure ForEachInRange(pos: TPosition; range: Byte; proc: TProc<TPosition, TBaseMob>); overload; static;
end;

const HPIncrementPerLevel: array[0..3] of integer = (
  3, // Transknight
  1, // Foema
  1, // BeastMaster
  2  // Hunter
);

const MPIncrementPerLevel: array[0..3] of integer = (
  1, // Transknight
  3, // Foema
  2, // BeastMaster
  1  // Hunter
);

implementation

uses GlobalDefs, Player, ItemFunctions, Functions, NPC, Log, Util, BuffsData;


function TBaseMob.CheckCooldown(skillId: Byte): Boolean;
begin
  Result := true;
  if not(_cooldown.ContainsKey(skillId)) then
    exit;

  if SecondsBetween(_cooldown[skillId], Now) < SkillsData[skillId].Delay then
  begin
    Result := false;
  end
  else
  begin
    _cooldown.Remove(skillId);
  end;
end;

procedure TBaseMob.CleanAffect(affectId: Byte);
var affect: TAffect;
begin
  ZeroMemory(@affect, sizeof(TAffect));
  SetAffect(affectId, affect);
end;

procedure TBaseMob.Create(characterPointer : PCharacter; index: WORD);
begin
  ZeroMemory(@self, sizeof(TBaseMob));
  VisibleMobs := TList<WORD>.Create;
  IsActive := true;
  IsDirty := false;
  Character := characterPointer;
  ClientId := index;

  _prediction.Create;
  _cooldown := TDictionary<Byte, TTime>.Create;
end;

procedure TBaseMob.Destroy();
var
  mob: TBaseMob;
begin
  self.IsActive := false;
  if(Character <> nil) then
   MobGrid[Round(CurrentPosition.Y)][Round(CurrentPosition.X)] := 0;
end;


function TBaseMob.GetEquipDamage(LR : Integer): WORD;
begin

end;

function TBaseMob.GetFirstSlot(itemId: WORD; invType: BYTE): Integer;
var inv: TList<TItem>;
  i: BYTE;
begin

end;

procedure TBaseMob.SendPacket(packet : pointer; size : WORD);
begin
  Server.SendPacketTo(clientId, packet, size);
end;

procedure TBaseMob.SendParty;
var party: PParty;
  i: WORD;
  member: TBaseMob;
begin
  if(PartyId = 0) then
    exit;

  party := @Parties[PartyId];

  for i in party.Members do
  begin
    if not(GetMob(i, member)) OR (i = ClientId) then
    begin
      party.Members.Remove(i);
      continue;
    end;

    if member.IsPlayer then
      member.SendParty(255 + party.Leader, ClientId);

    if self.IsPlayer then
      SendParty(255 + party.Leader, member.ClientId);
  end;
end;

procedure TBaseMob.SendParty(leader, member: WORD);
var packet: TSendPartyMember;
other : TBaseMob;
begin

end;

procedure TBaseMob.SendSignal(pIndex, opCode: WORD);
begin
  Server.SendSignalTo(ClientId, pIndex, opCode);
end;

procedure TBaseMob.SendToVisible(packet : pointer; size : WORD; sendToSelf : Boolean);
var i: WORD;
  player: TPlayer;
begin
  sendToSelf := IfThen(sendToSelf, IsPlayer, false);

  if(sendToSelf) then
    SendPacket(packet, size);

  for i in VisibleMobs do
  begin
    if(TPlayer.GetPlayer(i, player)) then
      player.SendPacket(packet, size, not sendToSelf);
  end;
end;

procedure TBaseMob.SendRemoveMob(delType: integer = DELETE_NORMAL; sendTo : WORD = 0);
var packet: TSignalData;
  mob: TBaseMob;
  i: WORD;
begin
  packet.Header.Size := sizeof(TSignalData);
  packet.Header.Code := $101;//aika
  packet.Header.Index := self.ClientId;

  packet.Data := delType;
  if(sendTo = 0) then
    SendToVisible(@packet, packet.Header.Size)
  else
    Server.SendPacketTo(sendTo, @packet, packet.Header.Size);

  for i in VisibleMobs do
  begin
    if(GetMob(i, mob)) then
      RemoveFromVisible(mob);
  end;

  VisibleMobs.Clear;
end;

procedure TBaseMob.SendMobDead(killer: TBaseMob);
var packet: TSendMobDeadPacket;
begin

end;

procedure TBaseMob.AddAffect(affect: TAffect);
var affectSlot: Byte;
  emptySlot: Int8;
begin

end;

procedure TBaseMob.AddExp(exp: WORD);
var levels : WORD;
begin

end;

procedure TBaseMob.AddToVisible(var mob: TBaseMob);
begin
  if(self.IsPlayer) then
  begin
    if not(VisibleMobs.Contains(mob.ClientId)) then
    begin
      VisibleMobs.Add(mob.ClientId);
      mob.AddToVisible(self);
      mob.SendCreateMob(SPAWN_NORMAL, self.ClientId);
    end;
  end
  else
    if(mob.IsPlayer) then
    begin
      VisibleMobs.Add(mob.ClientId);
      if not(mob.VisibleMobs.Contains(self.ClientId)) then
        mob.VisibleMobs.Add(self.ClientId);
    end;
end;

procedure TBaseMob.RemoveFromVisible(mob : TBaseMob);
begin
  VisibleMobs.Remove(mob.ClientId);
  if(self.IsPlayer) then
    mob.SendRemoveMob(0, self.ClientId);

  if(mob.VisibleMobs.Contains(self.ClientId)) then
    mob.RemoveFromVisible(self);

  if (Target <> NIL) AND (Target.ClientId = mob.ClientId) then
    Target := NIL;
end;

procedure TBaseMob.RemoveItem(slot, slotType: BYTE);
var item: PItem;
begin
  if(slot < 0) then exit;
  TItemFunctions.GetItem(item, self, slot, slotType);
  if(item <> nil) then
    ZeroMemory(item, sizeof(TItem));
end;

procedure TBaseMob.UpdateVisibleList;
var mob : TBaseMob;
  i: WORD;
begin
  IsDirty := false;
  if(VisibleMobs.Count > 0) then // Talvez possamos remover essa verificação
  begin
    for i in VisibleMobs do
    begin
      if(GetMob(i, mob) = false) then
      begin
        VisibleMobs.Remove(i);
        continue;
      end;

      if not(CurrentPosition.InRange(mob.CurrentPosition, DISTANCE_TO_FORGET)) then
        RemoveFromVisible(mob);
    end;
  end;

  self.ForEachInRange(DISTANCE_TO_WATCH, procedure(p: TPosition; self, m: TBaseMob)
  begin
    if self.VisibleMobs.Contains(m.ClientId) then
      exit;
    self.AddToVisible(m);
  end);
end;

procedure TBaseMob.UsedSkill(skillId: Byte);
begin
  if _cooldown.ContainsKey(skillId) then
    _cooldown[skillId] := Now
  else
    _cooldown.Add(skillId, Now);
end;

procedure TBaseMob.SendAffects;
var packet : TSendAffectsPacket;
  i : Integer;
begin

end;

procedure TBaseMob.SendChat(Name , str: AnsiString);
var
packet: TChatPacket;
begin
  ZeroMemory(@packet, sizeof(packet));
  packet.Header.Size := sizeof(packet);
  packet.Header.Code := $F86;//Aika
  packet.Header.Index := ClientId;


  SendToVisible(@packet, packet.Header.Size, true);
end;

procedure TBaseMob.SendEquipItems(sendSelf : Boolean = True);
var packet: TRefreshEquips; x: BYTE; sItem: TItem;
effValue : BYTE;
begin

end;


//PlayerSpam
procedure TBaseMob.SendCreateMob(spawnType : WORD = SPAWN_NORMAL; sendTo : WORD = 0);
var
    player : TPlayer;
    packet : TSendCreateMobPacket;
begin
  GetCreateMob(packet);
  packet.SpawnType := spawnType;
  if(sendTo > 0) then
    Server.SendPacketTo(sendTo, @packet, packet.Header.Size)
  else
    SendToVisible(@packet, packet.Header.Size);
end;

procedure TBaseMob.SendEmotion(effType, effValue: smallint);
var packet: TSendEmotionPacket;
begin
  packet.Header.Size := sizeof(TSendEmotionPacket);
  packet.Header.Code := $36A;
  packet.Header.Index := ClientId;

  packet.effType := effType;
  packet.effValue := effValue;
  packet.Unknown1 := 0;

  SendToVisible(@packet, packet.Header.Size);
end;

procedure TBaseMob.SendScore;
var packet : TSendScorePacket;
    i : Byte;
begin

end;

procedure TBaseMob.SendCurrentHPMP;
var
 packet: TSendCurrentHPMPPacket;
begin
  ZeroMemory(@packet, sizeof(TSendCurrentHPMPPacket));

	packet.Header.Size := sizeof(TSendCurrentHPMPPacket);
	packet.Header.Code := $103;//AIKA
	packet.Header.Index := ClientId;

  packet.CurHP := Character.CurrentScore.CurHP;
	packet.MaxHP := Character.CurrentScore.MaxHP;
	packet.CurMP := Character.CurrentScore.CurMP;
	packet.MaxMP := Character.CurrentScore.MaxMP;

  SendToVisible(@packet, packet.Header.Size);
end;

procedure TBaseMob.SendStatus;
var
 packet: TSendRefreshStatus;
begin
  ZeroMemory(@packet, $2C);
	packet.Header.Size := $2C;
	packet.Header.Code := $10A;//AIKA
	packet.Header.Index := ClientId;

  Packet.DNFis  := Character.CurrentScore.DNFis;
  Packet.DEFFis := Character.CurrentScore.DEFFis;
  Packet.DNMAG  := Character.CurrentScore.DNMAG;
  Packet.DEFMAG := Character.CurrentScore.DEFMAG;

  Packet.SpeedMove := 40;

  Packet.Critico := Character.CurrentScore.Critical;
  Packet.Esquiva := Character.CurrentScore.Esquiva;
  Packet.Acerto  := Character.CurrentScore.Acerto;
  Packet.Duplo   := 1;
  Packet.Resist  := 1;
  ////

  SendToVisible(@packet, packet.Header.Size);
end;

procedure TBaseMob.SendRefreshPoint;
var
 packet: TSendRefreshPoint;
begin
  ZeroMemory(@packet, sizeof(TSendRefreshPoint));
	packet.Header.Size := sizeof(TSendRefreshPoint);
	packet.Header.Code := $109;//AIKA
	packet.Header.Index := ClientId;

  Move(Character.CurrentScore,Packet.Pontos,Sizeof(Packet.Pontos));

  SendToVisible(@packet, packet.Header.Size);
end;

procedure TBaseMob.SendRefreshLevel;
var
 packet: TSendCurrentLevel;
begin
  ZeroMemory(@packet, sizeof(TSendCurrentLevel));
	packet.Header.Size := sizeof(TSendCurrentLevel);
	packet.Header.Code := $108;//AIKA
	packet.Header.Index := ClientId;

  Packet.Level:= Character.Level-1;
  Packet.Exp  := Character.Exp;

  SendToVisible(@packet, packet.Header.Size);
end;

procedure TBaseMob.ApplyDamage(attacker: TBaseMob; damage: Integer);
var i: Integer;
  sId: Byte;
  mana: Boolean;
  cur: Integer;
begin

end;

procedure TBaseMob.SendDamage(target: TBaseMob; skillId: Byte; damage: Integer = -1);
var packet: TProcessAttackOneMob;
  wRange: integer;
begin

end;

procedure TBaseMob.SendDamage(targets: TList<WORD>; skillId: Byte; damage: Integer);
var packet: TProcessAoEAttack;
  wRange: integer;
  target: TBaseMob;
  targetCount: Byte;
  targetId: WORD;
begin

end;

function TBaseMob.GetItemAmount(itemId: Integer; inv: array of TItem): TItemAmount;
var slot: Integer;
begin
  ZeroMemory(@Result, sizeof(TItemAmount));
  if(itemId < 0) OR (itemId > ItemList.Count) then
    exit;

  Result.ItemId := itemId;
  for slot := 0 to Length(inv) do
  begin
    if(inv[slot].Index = itemId) then
    begin
      Result.Slots[Result.SlotsCount] := slot;
      Inc(Result.SlotsCount);
      Inc(Result.Amount, TItemFunctions.GetItemAmount(inv[slot]));
    end;
  end;
end;

function TBaseMob.GetMaxAbility(eff: integer): integer;
var MaxAbility,i: integer;
ItemAbility: smallint;
begin

end;

class function TBaseMob.GetMob(index: WORD; out mob: TBaseMob): boolean;
begin
  if(index = 0) OR (index > MAX_SPAWN_ID) then
  begin
    result := false;
    exit;
  end;

  if(index <= MAX_CONNECTIONS) then
    mob := Players[index].Base
  else
    mob := NPCs[index].Base;

  if mob.Character = nil then
    exit;

  result := mob.IsActive;
end;

class function TBaseMob.GetMob(pos: TPosition; out mob: TBaseMob): boolean;
begin
  Result := GetMob(MobGrid[Round(pos.Y)][Round(pos.X)], mob);
end;

class function TBaseMob.GetMob(index: WORD; out mob: PBaseMob): boolean;
begin
  if(index = 0) then
  begin
    result := false;
    exit;
  end;

  if(index <= MAX_CONNECTIONS) then
    mob := @Players[index].Base
  else
    mob := @NPCs[index].Base;

  result := mob.IsActive;
end;

function TBaseMob.GetMobAbility(eff: integer) : integer;
begin

end;

function TBaseMob.InBattle: boolean;
begin
  Result := IfThen(Target <> nil);
end;

function TBaseMob.IsDead: boolean;
begin

end;

function TBaseMob.IsMoving: boolean;
begin
  if _prediction.Destination.IsValid then
    Result := IfThen(_prediction.Destination <> CurrentPosition)
  else Result := false;
end;

function TBaseMob.IsPlayer: boolean;
begin
  Result := IfThen(ClientId <= MAX_CONNECTIONS);
end;

procedure TBaseMob.GetCreateMob(out packet : TSendCreateMobPacket);
var
 i : Byte;
begin
  ZeroMemory(@packet, sizeof(TSendCreateMobPacket));

  packet.Header.Size := sizeof(TSendCreateMobPacket);
  packet.Header.Code := $349;
  packet.Header.Index := Clientid;

  Move(Character.Name, packet.Name[0], 16);

  for I := 0 to 8 do
  Packet.Equip[i] := Character.Equip[i].Index;

//   Packet.Position := CurrentPosition;

//   Packet.Position := PlayerCharacter.LastPos;
  packet.Position.X := 3450 ;
  packet.Position.Y :=  690;

  packet.CurHP := Character.CurrentScore.CurHP;
  packet.MAXHP := Character.CurrentScore.MAXHP;
  packet.CurMP := Character.CurrentScore.CurMP;
  packet.MAXMP := Character.CurrentScore.MAXMP;

  Packet.Altura:= Character.CurrentScore.Sizes.Altura;
  Packet.Tronco:= Character.CurrentScore.Sizes.Tronco;
  Packet.Corpo := Character.CurrentScore.Sizes.Corpo;
  Packet.Perna := Character.CurrentScore.Sizes.Perna;
end;

function TBaseMob.GetCurrentHP(): Integer;
var hp_inc,hp_perc: integer; //ainda no esquema do WYD
begin

  hp_inc := GetMobAbility(EF_HP);
  hp_perc := GetMobAbility(EF_HP_CHECK);

  inc(hp_inc, InitialCharacters[Character.ClassInfo].CurrentScore.MaxHP);
  inc(hp_inc, (HPIncrementPerLevel[Character.ClassInfo] * Character.Level));
  inc(hp_inc, (Character.CurrentScore.CONS shl 1));
  inc(hp_inc, Trunc(((hp_inc * hp_perc) / 100)));

  if(hp_inc > 64000) then //32
      hp_inc := 64000 //32
  else if(hp_inc <= 0) then
      hp_inc := 1;

  result:=hp_inc;

end;

function TBaseMob.GetCurrentMP(): Integer;
var mp_inc,mp_perc: integer;
begin
   mp_inc := GetMobAbility(EF_MP);
  mp_perc := GetMobAbility(EF_MP);

  inc(mp_inc, InitialCharacters[Character.ClassInfo].CurrentScore.MaxMP);
  inc(mp_inc, (HPIncrementPerLevel[Character.ClassInfo] * Character.Level));
  inc(mp_inc, (Character.CurrentScore.INT shl 1));
  inc(mp_inc, Trunc(((mp_inc * mp_perc) / 100)));

  if(mp_inc > 64000) then //32
      mp_inc := 64000 //32
  else if(mp_inc <= 0) then
      mp_inc := 1;

  result:=mp_inc;
end;


procedure TBaseMob.GetCurrentScore;
var special: array[0..3] of smallInt;
  special_all,resist,magic,atk_inc,def_inc,i,critical,body: integer;
  evasion: WORD;
  moveSpeed: Byte;
begin

end;

procedure TBaseMob.GetAffectScore;
begin
  BuffsData.GetAffectScore(Character);
end;

function TBaseMob.GetDamage(target: TBaseMob; master: Byte): smallint;
var resultDamage: Int16;
  masterFactory, randFactory: Integer;
begin

end;

function TBaseMob.GetEmptySlot: Byte;
var i: BYTE;
begin

end;

procedure TBaseMob.GenerateBabyMob;
//var pos: TPosition; i, j: BYTE; mIndex, id: WORD;
//    party : PParty;
var babyId, babyClientId: WORD;
  party : PParty;
  i, j: Byte;
  pos: TPosition;
begin

end;

procedure TBaseMob.UngenerateBabyMob(ungenEffect: WORD);//evok pode ser usado pra skill de att
//var pos: TPosition; i,j: BYTE; party : PParty; find: boolean;
begin

end;


procedure TBaseMob.ForEachInRange(range: Byte; proc: TProc<TPosition, TBaseMob, TBaseMob>);
var mobId, index: WORD;
  mob, this: TBaseMob;
  pos: TPosition;
begin
  if not(CurrentPosition.isValid) then
    exit;

  index := self.ClientId;
  this := self;

  CurrentPosition.ForEach(range, procedure(pos: TPosition)
  begin
   mobId := MobGrid[Round(pos.Y)][Round(pos.X)];//pode gerar erro
    if(mobId = 0) OR (mobId = index) then
      exit;

    if(mobId <= MAX_CONNECTIONS) then
      mob := Players[mobId].Base
    else
      mob := NPCs[mobId].Base;

    if not(mob.IsActive) then
      exit;

    proc(pos, this, mob);
  end);
end;

class procedure TBaseMob.ForEachInRange(pos: TPosition; range: Byte; proc: TProc<TPosition, TBaseMob>);
var mobId: WORD;
  mob: TBaseMob;
begin
  if not(pos.isValid) then
    exit;

  pos.ForEach(range, procedure(p: TPosition)
  begin
   mobId := MobGrid[Round(pos.Y)][Round(pos.X)];//pode gerar erro
    if(mobId = 0) then
      exit;

    if(mobId <= MAX_CONNECTIONS) then
      mob := Players[mobId].Base
    else
      mob := NPCs[mobId].Base;

    if not(mob.IsActive) then
      exit;

    proc(p, mob);
  end);
end;

procedure TBaseMob.ForEachVisible(proc: TProc<TBaseMob>);
var mobId: Integer;
  mob: TBaseMob;
begin
  for mobId in VisibleMobs do
  begin
    if TBaseMob.GetMob(mobId, mob) then
      proc(mob);
  end;
end;

procedure TBaseMob.SetAffect(affectId: Byte; affect: TAffect);
var i: Byte;
begin

end;

procedure TBaseMob.SetDestination(const destination: TPosition);
var dirVector: TPosition;
  speed: byte;
begin
  _prediction.Source := _currentPosition;
  if(_prediction.Source = destination) then
    exit;

  _prediction.Timer.Stop;
  _prediction.Timer.Reset;
  _prediction.Timer.Start; //:= Now;
  _prediction.Destination := destination;
// _prediction.CalcETA(Character.CurrentScore.MoveSpeed);
  _prediction.CalcETA(40);
end;

function TBaseMob.CurrentPosition: TPosition;
var
  delta: Single;
  id: WORD;
begin
  if not _currentPosition.IsValid then
    _currentPosition := PlayerCharacter.LastPos;

  if not(_prediction.CanPredict) then
  begin
    Result := _currentPosition;
    exit;
  end;
  Result := _prediction.Interpolate(delta);

//  if not TFunctions.UpdateWorld(ClientId, Result, WORLD_MOB) then
//  begin
//    Result := _currentPosition;
//    exit;
//  end;
//  if Character.Last.Distance(_currentPosition) > 4 then
//    IsDirty := true;

    _currentPosition := PlayerCharacter.LastPos;
  _currentPosition := Result;
end;


procedure TBaseMob.DeterminMoveDirection(const pos: TPosition);
var moveVector: TPosition;
  dir: BYTE;
begin

end;


procedure TBaseMob.SendMovement(destination: TPosition; calcDirection: Boolean = true);
begin
 SendMovement(destination.X, destination.Y, calcDirection);
end;

procedure TBaseMob.SendMovement(destX, destY : Single; calcDirection: Boolean = true);
var
  packet: TMovementPacket;
  distance, dir: BYTE;
begin
  packet.Destination.X := destX;
  packet.Destination.Y := destY;

  if not TFunctions.UpdateWorld(ClientId, packet.Destination, WORLD_MOB) then
  begin
    exit;
  end;

  PlayerCharacter.CurrentPos := CurrentPosition;
  SetDestination(packet.Destination);
  packet := TFunctions.GetAction(self, packet.Destination, MOVE_NORMAL);
  SendToVisible(@packet, packet.Header.Size, true);
end;

function TBaseMob.Teleport(x, y: Single) : Boolean;
var
  packet: TMovementPacket;
  src, dest: TPosition;
begin
	packet.Destination.X := x;
	packet.Destination.Y := y;

  Result := TFunctions.UpdateWorld(ClientId, packet.Destination, WORLD_MOB);
  if not Result then
    exit;

  packet := TFunctions.GetAction(self, packet.Destination, MOVE_TELEPORT);
//  src := packet.Source;
  dest := packet.Destination;
  SendToVisible(@packet, packet.Header.Size, true);
  //SendRemoveMob(SPAWN_TELEPORT);    manda o 0x101 pra deletar dos players

  PlayerCharacter.LastPos := src;
  _currentPosition := dest;

  UpdateVisibleList();
  SendCreateMob(SPAWN_TELEPORT);
end;


function TBaseMob.Teleport(position: TPosition) : Boolean;
begin
  Result := Teleport(position.X, position.Y);
end;

{ TPrediction }
procedure TPrediction.Create;
begin
  Timer := TStopwatch.Create;
end;

function TPrediction.Delta: Single;
begin
  if ETA > 0 then
    Result := Elapsed / ETA
  else
    Result := 1;
end;

function TPrediction.Elapsed: Integer;
begin
  Result := Timer.ElapsedTicks;
end;

function TPrediction.CanPredict: Boolean;
begin
  Result := ((ETA > 0) AND (Source.IsValid) AND (Destination.IsValid));
end;


function TPrediction.Interpolate(out d: Single): TPosition;
begin
  d := Delta;
  if(d >= 1) then
  begin
    ETA := 0;
    Result := Destination;
  end
  else Result := TPosition.Lerp(Source, Destination, d);
end;

procedure TPrediction.CalcETA(speed: Byte);
var dist: WORD;
begin
  dist := Source.Distance(Destination);
	speed := speed * 190;
	ETA := (AI_DELAY_MOVIMENTO + (dist * (1000 - speed)));
end;

end.
