unit NPC;

interface

uses MiscData, PlayerData, BaseMob, SysUtils, DateUtils, Threading, Diagnostics,
    Generics.Collections;

// Definido por adicional na face
type TNpcBehaviour = (Passive, SelfDefence, Aggressive, PlayerService);
type TState = (Idle, Moving, Attacking);

type PNpc =  ^TNpc;
TNpc = record
  public
    base          : TBaseMob;
    Character     : TCharacter;
    MobLeaderId   : smallint;
    GenerId       : WORD;
    Behaviour     : TNpcBehaviour;
    LearnedSkills : TList<Byte>;
    TimeKill      : TDateTime;

    procedure Create(npc: TCharacter; gId, clientId, leaderId: Integer);
    procedure PerformAI;

    function GenerData: TMOBGener;

    class procedure ForEach(parallel: Boolean; proc : TProc<PNPC>); static;

  private
    _currentState: TState;
    _previusState: TState;
//    _target: PBaseMob;
    _lastAction: TTime;
    _idleTime: Single;
    _currentSegment: TAISegment;


    procedure SetState(state : TState);

    procedure Revive;
    procedure SearchForTarget;

    function IdleState: Boolean;
    function MovingState: Boolean;
    function AttackingState: Boolean;

    function ChooseAttack: Integer;
end;



implementation

uses GlobalDefs, Windows, Functions , Log, Util;

{ TNpc }
procedure TNpc.Create(npc: TCharacter; gId, clientId, leaderId: Integer);
var skill: TSkillData;
begin
  ZeroMemory(@self, sizeof(TNpc));
  base.Create(@Character, clientId);


  Character := npc;
  MobLeaderId := leaderId;
  GenerId := gId;



  _currentState := Moving;
  if(GenerData.Segments <> nil) then
    _currentSegment := GenerData.Segments.First;

  if(MobLeaderId < MAX_CONNECTIONS) then
    Behaviour := PlayerService
{  else if (npc.Merchant = 31) OR (npc.Merchant = 32) then
    Behaviour := SelfDefence
  else if npc.Merchant = 16 then
    Behaviour := Aggressive
   else
    Behaviour := Passive;
    }
end;

function TNpc.GenerData: TMOBGener;
begin
  if MobGener.ContainsKey(GenerId) then
    Result := MobGener[GenerId];
end;


procedure TNpc.PerformAI;
var act: Boolean;
begin
  if not(base.IsActive) OR (GenerId = 0) OR (base.Character = nil) OR
      (Character.Equip[0].Index = 0) then
  exit;

  if(base.IsDead) then
  begin
    Revive;
    exit;
  end;

  if base.VisibleMobs.Count = 0 then
    exit;

  if Behaviour >= Aggressive then
    SearchForTarget;

  case _currentState of
    Idle: act := IdleState;
    Moving: act := MovingState;
    Attacking: act := AttackingState;
  end;

  if act then
    _lastAction := Now;
end;

function TNpc.IdleState: Boolean;
begin
  if (SecondsBetween(Now, _lastAction) >= _idleTime) then
  begin
    SetState(_previusState);
    exit;
  end
end;

function TNpc.MovingState: Boolean;
var nextSegmentId : integer;
begin
  Result := false;
  if(GenerData.Segments = NIL) OR (GenerData.Segments.Count = 0) then
  begin
    SetState(Idle);
    _idleTime := 100;
    exit;
  end;

  if (base.Target = nil) then
  begin
    if(base.IsMoving) then // Se ainda estiver indo para o destino, retorna
      exit;

    nextSegmentId := GenerData.Segments.IndexOf(_currentSegment) + 1;
    nextSegmentId := IfThen(nextSegmentId = GenerData.Segments.Count, 0, nextSegmentId);
    _currentSegment := GenerData.Segments[nextSegmentId];

//    Inc( _currentSegment.Position.X , TFunctions.Rand(-2, 2));
//    Inc(_currentSegment.Position.Y, TFunctions.Rand(-2, 2));
    base.SendMovement(_currentSegment.Position);

    SetState(Idle);
    if _currentSegment.Say <> '' then
    begin
      base.SendChat('',_currentSegment.Say);
    end;
    _idleTime := _currentSegment.WaitTime;
    Result := true;
  end
  else
  begin
    base.SendMovement(base.Target.CurrentPosition);
    SetState(Attacking);
    Result := true;
  end;
end;

function TNpc.AttackingState: Boolean;
var dist: WORD;
begin
 { Result := false;

  if (base.Target = NIL) OR not(base.Target.IsActive) then
  begin
    SetState(Idle);
    exit;
  end;

  dist := base.Target.CurrentPosition.Distance(base.CurrentPosition);
  if dist > 10 then // Desiste de atacar e volta a fazer o de antes
  begin
    base.Target := NIL;
    SetState(Idle);
    exit;
  end
  else if dist > 3 then // Tenta se aproximar
  begin
    SetState(Moving);
    exit;
  end;
  Result := TCombatHandlers.HandleAttack(base, base.Target.ClientId, ChooseAttack);
  SetState(Idle);
  _idleTime := base.AttackSpeed;  }
end;

procedure TNpc.SearchForTarget;
var curTarget: TBaseMob;
  i: Integer;
  targetId: Integer;
begin
  // Crias e evocações
  if (Behaviour = TNpcBehaviour.PlayerService) AND
    (MobLeaderId > 0) AND (MobLeaderId < MAX_CONNECTIONS) then
  begin
    base.Target := Players[MobLeaderId].base.Target;
    SetState(Attacking);
    exit;
  end;

  // Máximo de inimigos que ele pode ter
  if (base.VisibleMobs.Count = 0) then
    exit;

  base.ForEachInRange(5, procedure(pos: TPosition; self, mob: TBaseMob)
  begin
    if (mob.IsDead) OR not(mob.IsPlayer) then
      exit;

    if not curTarget.IsActive then
    begin
      curTarget := mob;
      exit;
    end;

    if mob.Character.CurrentScore.CurHP < curTarget.Character.CurrentScore.CurHP then
    begin // Encontramos um alvo mais fraco
      curTarget := mob;
    end;
  end);

  if curTarget.IsActive then
  begin
    if TBaseMob.GetMob(curTarget.ClientId, base.Target) then
      _currentState := Attacking;
  end;
end;

procedure TNpc.Revive;
var time: TDateTime;
  minute: Int8;
begin
  minute := GenerData.MinuteGenerate;
  if(minute = 0) then // 0 só da spawn "On Demand"
    exit;

  if(minute = -1) then
    minute := 0;

  if (MinutesBetween(Now, TimeKill) >= minute) then
  begin
  //  Character.Last := GenerData.SpawnSegment.Position;
  //  if(TFunctions.GetEmptyMobGrid(base.ClientId, Character.Last, 8)) then
    begin
  //    MobGrid[Character.Last.Y][Character.Last.X] := base.ClientId;
      Character.CurrentScore.CurHP := Character.CurrentScore.MaxHP;
      base.UpdateVisibleList;
      base.SendCreateMob(SPAWN_TELEPORT);
    end;
  end;
end;

procedure TNpc.SetState(state: TState);
begin
  _previusState := _currentState;
  _currentState := state;
end;

function TNpc.ChooseAttack: Integer;
begin
  Result := TFunctions.Rand(LearnedSkills.Count + 5);
  Result := IfThen(Result > LearnedSkills.Count, -1, Result);
end;

class procedure TNpc.ForEach(parallel: Boolean; proc: TProc<PNPC>);
var i: Integer;
  npc: PNPC;
begin
  try
    if(parallel) then
    begin
      TParallel.For(1001, InstantiatedNpcs - 1, procedure(i : Integer)
      begin
        npc := @NPCs[i];
        if(npc = nil) OR not(npc.base.IsActive) then
          exit;
        proc(npc);
      end);
    end
    else
    begin
      for i := 1001 to InstantiatedNpcs - 1 do
      begin
        npc := @NPCs[i];
        if(npc = nil) OR not(npc.base.IsActive) then
          continue;
        proc(npc);
      end;
    end;
  except on e : Exception do
    Logger.Write(e.Message, TLogType.Warnings);
  end;
end;

end.
