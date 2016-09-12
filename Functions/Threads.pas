unit Threads;

interface

uses Windows, SysUtils, Classes, DateUtils, System.TimeSpan, System.Diagnostics,
      BaseMob, PlayerData, Player, NPC, ItemFunctions, System.SyncObjs;

type TBackgroundThread = class(TThread)
  public
    constructor Create(Suspend:Boolean);

  protected
    // Essas propriedades vão ser definidas em 'Setup'
    CycleTime: Single; // Tempo entre um ciclo e o outro
    SleepTime: Single; // Tempo de sleep caso não tenha nenhum player
    Lock: TCriticalSection; // Vamos usar em threads que precisem ser Thread-Safe

    procedure Setup; virtual;
    procedure Execute; override;
    procedure OnTerminate(Sender: TObject);
    procedure Update(elapsed: TTimeSpan); virtual; abstract;
end;

type TVisibleListThread = class(TBackgroundThread)
  protected
    procedure Setup; override;
    procedure Update(elapsed: TTimeSpan); override;
end;

type TQuestsThread = class(TBackgroundThread)
  protected
    procedure Setup; override;
    procedure Update(elapsed: TTimeSpan); override;
end;

type TNpcAIThread = class(TBackgroundThread)
  protected
    procedure Setup; override;
    procedure Update(elapsed: TTimeSpan); override;
end;

type TVisibleDropListThread = class(TBackgroundThread)
  protected
    procedure Setup; override;
    procedure Update(elapsed: TTimeSpan); override;
end;

type TLoginDisconnectThread = class(TBackgroundThread)
  protected
    procedure Setup; override;
    procedure Update(elapsed: TTimeSpan); override;
end;

type TSaveAccountsThread = class(TBackgroundThread)
  protected
    procedure Setup; override;
    procedure Update(elapsed: TTimeSpan); override;
end;

type TUpdateHpMpThread = class(TBackgroundThread)
  protected
    procedure Setup; override;
    procedure Update(elapsed: TTimeSpan); override;
end;


var LoginDisconnectThread : TLoginDisconnectThread;
    NpcAIThread : TNpcAIThread;
    SaveAccountsThread : TSaveAccountsThread;
    UpdateHpMpThread : TUpdateHpMpThread;

    VisibleListThread : TVisibleListThread;
    VisibleDropListThread : TVisibleDropListThread;

implementation

uses GlobalDefs, Log, Packets, Util, MiscData, Functions;

{ TBackgroundThread }
constructor TBackgroundThread.Create(Suspend:Boolean);
begin
  inherited;
  self.Setup;
end;

procedure TBackgroundThread.Setup;
begin
  Priority := tpNormal;
  CycleTime := 2;
  SleepTime := 5;
end;

procedure TBackgroundThread.Execute;
var timer: TStopwatch;
  updateTime: TTimeSpan;
begin
  try
//    Logger.Write(self.ClassName + ': ' + IntToStr(self.ThreadID), TLogType.ServerStatus);
//    timer := TStopwatch.Create;
//    timer.Start;
    timer := TStopwatch.StartNew;
    while (Server.IsActive) do
    begin
      if (InstantiatedPlayers <= 0) AND (SleepTime > 0) then
      begin
        TThread.Sleep(Round(SleepTime * 1000));
        timer.Reset;
        timer.Start;
        continue;
      end;

      if (timer.ElapsedMilliseconds < CycleTime * 1000) then
      begin
        if ((CycleTime * 1000) - timer.ElapsedMilliSeconds > 0) THEN
        begin
          TThread.Sleep(Round((CycleTime * 1000) - timer.ElapsedMilliSeconds));
        end;
        continue;
      end;
      updateTime := timer.Elapsed;
      timer.Reset;
      timer.Start;
      Update(updateTime);
      inherited;
    end;
  except on e : Exception do
    Logger.Write(e.Message, TLogType.Warnings);
  end;
end;

procedure TBackgroundThread.OnTerminate(Sender: TObject);
begin
  Logger.Write('A BackgroundThread: ' + IntToStr(self.ThreadId) + ' foi finalizada', TLogType.Warnings);
  //inherited;
end;

{ TLoginDisconnectThread }
procedure TLoginDisconnectThread.Setup;
begin
  Priority := tpNormal;
  CycleTime := 2;
  SleepTime := 10;
end;

procedure TLoginDisconnectThread.Update(elapsed: TTimeSpan);
var time: TDateTime;
  lastId: WORD;
begin
  TPlayer.ForEach(procedure(player : PPlayer)
  begin
    if not(player.Base.IsActive) then
      exit;

    if ((IncMinute(player.CountTime, 1) < Now)
      and (player.Status = TPlayerStatus.WaitingLogin)) then
    begin
      Server.Disconnect(player.Base.ClientId);
      exit;
    end;
    lastId := IFThen(player.Base.ClientId > lastId, player.Base.ClientId, lastId);
  end);
  InstantiatedPlayers := lastId;
end;


{ TSaveAccountsThread }
procedure TSaveAccountsThread.Setup;
begin
  Priority := tpHigher;
  CycleTime := 5;
  SleepTime := 10;
end;

procedure TSaveAccountsThread.Update(elapsed: TTimeSpan);
var cnt: WORD;
begin
  TPlayer.ForEach(procedure(player : PPlayer)
  begin
    if not(player.Account.Header.IsActive) OR (player.Status < PLAYING) then
      exit;
    // A conta só será salva por essa thread caso o player esteja no mundo
    // Quando ele voltar a tela de personagens ela é salva automaticamente.
    // O mesmo vale para o Disconnect
    player.SaveAccount;
    Inc(cnt);
  end);
  //Logger.Write('[' + IntToStr(cnt) + '] contas foram salvas...', TLogType.ConnectionsTraffic);
end;

{ TVisibleListThread }
procedure TVisibleListThread.Setup;
begin
  Priority := tpHigher;
  CycleTime := 1;
  SleepTime := 6;
end;

procedure TVisibleListThread.Update(elapsed: TTimeSpan);
var i: Integer;
begin
  TPlayer.ForEach(procedure(player : PPlayer; state : TLoopState)
  begin
    if not(player.Base.IsDirty) OR (player.Status < Playing) then
      exit;

    player.Base.UpdateVisibleList;

    //state.Break;
  end);
end;


{ TNpcAIThread }
procedure TNpcAIThread.Setup;
begin
  Priority := tpHigher;
  CycleTime := 1;
  SleepTime := 10;
  Lock := TCriticalSection.Create;
end;

procedure TNpcAIThread.Update(elapsed: TTimeSpan);
begin
  TNpc.ForEach(false, procedure(npc: PNpc)
  begin
    npc.PerformAI;
  end);
end;


{ TVisibleDropListThread }
procedure TVisibleDropListThread.Setup;
begin
  Priority := tpLower;
  CycleTime := 8; // Essa é uma thread que pode ser realmente lenta
  SleepTime := 10;
end;

procedure TVisibleDropListThread.Update(elapsed: TTimeSpan);
var i: Integer;
begin
  for i := 1 to Length(InitItems) do
  begin
    TItemFunctions.DeleteVisibleDropList(i);
    sleep(1);
  end;
end;


{ TUpdateHpMpThread }
procedure TUpdateHpMpThread.Setup;
begin
  Priority := tpNormal;
  CycleTime := 8;
  SleepTime := 10;
end;

procedure TUpdateHpMpThread.Update(elapsed: TTimeSpan);
var hpMp: WORD;
    dirtyAffects: Boolean;
    dirtyHpMp: Boolean;
    aura: Boolean;
begin

end;

{ TQuestsThread }
procedure TQuestsThread.Setup;
begin
  Priority := tpNormal;
  CycleTime := 60;
  SleepTime := 10;
end;

procedure TQuestsThread.Update(elapsed: TTimeSpan);
var quest: TQuest;
  index: WORD;
  player: TPlayer;
  pos: TPosition;
begin

end;

end.
