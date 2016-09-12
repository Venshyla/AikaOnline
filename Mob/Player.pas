unit Player ;

interface

uses
 Windows, ClientConnection, WinSock2, PlayerData, MiscData, BaseMob,
 SysUtils, Generics.Collections, Packets, Log, System.Threading;


type PPlayer = ^TPlayer;
  TPlayer = record
  procedure Create(clientId : WORD; conn: TClientConnection);
  procedure Destroy;

  private
    SelectedCharacterIndex : integer;

  public
    Base      : TBaseMob;
    Status    : TPlayerStatus;
    SubStatus : TPlayerStatus;
    Character : TPlayerCharacter;

    Account      : TAccountFile;
    CountTime    : TDateTime;
    Connection   : TClientConnection;
    KnowInitItems: TList<integer>;

    procedure SaveAccount();
    function  LoadAccount(userName : string) : Boolean;

    procedure SendPacket(packet : pointer; size : WORD; encrypt: Boolean = true);
    procedure SendSignal(headerClientId, packetCode: WORD); overload;
    procedure SendSignal(headerClientId, packetCode: WORD; optional: array of Integer); overload;
    function  ReceiveData() : Boolean;
    ////// Sends/////
    procedure SendCharList;
    Function  BackToCharList : Boolean;
    function  SendToWorld(charId : Byte) : Boolean;

    procedure RefreshMoney();
    procedure SendEmotion(effType, effValue: integer);
    procedure SendClientMessage(str: AnsiString);
    procedure SendCreateItem(invType : smallint; invSlot : smallint; item: TItem);

    //Spam

    class function GetPlayer(index: WORD; out player: TPlayer): boolean; static;
    class procedure ForEach(proc: TProc<PPlayer>); overload; static;
    class procedure ForEach(proc: TProc<PPlayer, TParallel.TLoopState>); overload; static;
end;


implementation

uses GlobalDefs, Functions, ItemFunctions;

{$REGION 'TPlayer'}
procedure TPlayer.Create(clientId : WORD; conn: TClientConnection);
begin
  ZeroMemory(@self, sizeof(TPlayer));
  Base.Create(@self.Character.Base, clientId);
  self.Connection := conn;
  KnowInitItems   := TList<integer>.Create;
end;

procedure TPlayer.Destroy;
begin
  Account.Header.IsActive := false;
  SaveAccount;
  Connection.Destroy;
  Base.Destroy;
end;

procedure TPlayer.SaveAccount;
var
  f : file of TAccountFile;
  local : string;
begin
  if(TFunctions.IsLetter(Account.Header.Username)) then
  begin
    local := CurrentDir + '\ACCS\' + Trim(Account.Header.Username[1]) + '\' + Trim(Account.Header.Username) + '.acc'
  end
  else
    local := CurrentDir + '\ACCS\etc\' + Trim(Account.Header.Username)+ '.acc';
  if(Status = TPlayerStatus.Playing) then
  begin
    Move(Character, Account.Characters[SelectedCharacterIndex], sizeof(TCharacterDB));
  end;
  AssignFile(f, local);
  ReWrite(f);
  Write(f, Account);
  CloseFile(f);
end;

function TPlayer.LoadAccount(userName: string): Boolean;
var f : file of TAccountFile;
    local : string;
begin
  ZeroMemory(@Account, sizeof(TAccountFile));
  if(TFunctions.IsLetter(userName) = true) then
    local := CurrentDir + '\ACCS\' + userName[1] + '\' + Trim(userName) + '.acc'
  else
    local := CurrentDir + '\ACCS\etc\' + Trim(userName) + '.acc';
  if not(FileExists(local)) then
    exit;
  try
    AssignFile(f, local);
    Reset(f);
    Read(f, Account);
    CloseFile(f);
    Result := true;
  except
    CloseFile(f);
  end;
end;

procedure TPlayer.SendPacket(packet : pointer; size : WORD; encrypt: Boolean);
begin
  if(Connection.Socket = -1) then exit;
  Connection.SendPacket(packet, size, encrypt);
end;

procedure TPlayer.SendSignal(headerClientId, packetCode: WORD);
var signal : TPacketHeader;
begin
  ZeroMemory(@signal, sizeof(TPacketHeader));

  signal.Size  := 12;
  signal.Index := headerClientId;
  signal.Code  := packetCode;

  SendPacket(@signal, signal.Size)
end;

procedure TPlayer.SendSignal(headerClientId, packetCode: WORD; optional: array of Integer);
var signal : TPacketHeader;
  signalBuffer: array of BYTE;
  i: Integer;
  a: Integer;
begin
  ZeroMemory(@signal, sizeof(TPacketHeader));
  signal.Size  := 12 + Length(optional) * SizeOf(Integer);
  signal.Index := headerClientId;
  signal.Code  := packetCode;

  SetLength(signalBuffer, signal.Size);
  Move(signal, signalBuffer[0], sizeof(TPacketHeader));
  Move(optional[0], signalBuffer[12], Length(optional) * 4);
  SendPacket(@signalBuffer, signal.Size);
end;

function TPlayer.ReceiveData(): Boolean;
var ReceivedBytes : integer;
begin
  Result := false;
	ZeroMemory(@Connection.RecvBuffer, 32000);
	ReceivedBytes := Recv(Connection.Socket, Connection.RecvBuffer, 32000, 0);
	if(ReceivedBytes <= 0) then
  begin
    exit;
  end;
  Result := Server.OnReceivePacket(self, Connection.RecvBuffer, ReceivedBytes);
end;
{$ENDREGION}

{$REGION 'Sends'}
procedure TPlayer.SendCharList;
var
 packet: TSendToCharListPacket;
 i,z   : BYTE;
begin
  ZeroMemory(@packet, sizeof(TSendToCharListPacket));
  packet.Header.Size  := sizeof(TSendToCharListPacket);
  packet.Header.Index := 00; //aqui ja vai a index real
  packet.Header.Code  := $901;
  Packet.AcountID     := Account.Header.AccountId;
  for i := 0 to 2 do // 3 personagens
  begin
  Move(Account.Characters[i].Base.Name, packet.CharactersData[i].Name, 16);

  for z := 0 to 7 do
  packet.CharactersData[i].Equip[z] := Account.Characters[i].Base.Equip[z].Index;
  Move(Account.Characters[i].Base.CurrentScore,Packet.CharactersData[i].Atributos,sizeof(Packet.CharactersData[i].Atributos));

  if Account.Header.NumericToken[i] <> '' then Packet.CharactersData[i].NumRegister := True;
     Packet.CharactersData[i].NumericError := Account.Header.NumError[i];

  Move(Account.Characters[i].Base.CurrentScore.Sizes,Packet.CharactersData[i].SizeofChar,sizeof(Packet.CharactersData[i].SizeofChar));
  packet.CharactersData[i].Gold   := Account.Characters[i].Base.Gold;
  packet.CharactersData[i].Exp    := Account.Characters[i].Base.Exp;
  Packet.CharactersData[i].Classe := Account.Characters[i].Base.ClassInfo;
  end;

  if(Status = CharList) then
  begin
    packet.Header.Size := sizeof(TUpdateCharacterListPacket);
    SendPacket(@packet, packet.Header.Size);
    exit;
  end;

  Status    := CharList;
  SubStatus := Senha2;

  SaveAccount;
  SendPacket(@packet, packet.Header.Size);
end;

function TPlayer.BackToCharList : Boolean;
begin
  MobGrid[Round(Character.CurrentPos.Y)][Round(Character.CurrentPos.Y)] := 0; //deleta o char do grid
  ZeroMemory(@Character, sizeof(TPlayerCharacter));
  Status := CharList;
  SelectedCharacterIndex := -1;
  SendSignal(self.Base.ClientId, $318);//aika
  SendCharList;
  Result := true;
end;

function TPlayer.SendToWorld(charId : Byte) : Boolean;
var
    packet : TSendToWorldPacket;
    spawnPosition : TPosition;
    direction: BYTE;
begin
  Result := false;
  ZeroMemory(@Character, sizeof(TPlayerCharacter));
  ZeroMemory(@packet, sizeof(TSendToWorldPacket));

  SelectedCharacterIndex := charId;

  packet.Header.Size  := sizeof(TSendToWorldPacket);
  packet.Header.Code  := $925;
  packet.Header.Index := $7535;

  Move(Account.Characters[charId], Character, sizeof(TCharacterDB));
  Move(Account.Characters[charId],packet.Character,Sizeof(sizeof(TSendToWorldPacket)));

  if(Base.IsDead) then
  begin
    Character.Base.CurrentScore.CurHP := Character.Base.CurrentScore.MaxHP;
  end;

  Character.Base.ClientId := Base.ClientId;

  MobGrid[Round(Character.LastPos.Y)][Round(Character.LastPos.X)] := Base.Clientid;
  Move(Character.Base, packet.Character, sizeof(TCharacter));

  SendPacket(@packet, packet.Header.Size);

  Base.UpdateVisibleList;
  //Seguindo a ordem do serv//
//  Base.SendStatus;
  Base.SendRefreshPoint;
  Base.SendRefreshLevel;
  Base.SendCreateMob(SPAWN_TELEPORT);
  Base.SendCurrentHPMP;
  Base.SendStatus;
  //skills  vai no packet 0x106

 //...
  Status := Playing;
  SendSignal(Base.ClientId, $186);
  Result := true;
end;
{
Packets Inclusos:
4x $186
Sentoword
$16F  Unk
$103  Atualiza HP MP...
$109 Atualiza pontos
$103 Atualiza HP MP...de novo
$10A Atualiza status de atack
$14F Unk
$138 Unk
$357 Unk
$166 Unk


}



procedure TPlayer.RefreshMoney;
var
 packet : TRefreshMoneyPacket;
begin
  ZeroMemory(@packet, sizeof(TRefreshMoneyPacket));
  packet.Header.Size  := sizeof(TRefreshMoneyPacket);
	packet.Header.Code  := $312;//AIKA
	packet.Header.Index := Base.Clientid;
 	packet.Gold         := Character.Base.Gold;
  SendPacket(@packet, packet.Header.Size);
end;

procedure TPlayer.SendEmotion(effType, effValue: integer);
var packet: TRequestEmotion;
begin
    packet.Header.Size  := sizeof(TRequestEmotion);
    packet.Header.Code  := $304;//AIKA
    packet.Header.Index := Base.ClientId;

    packet.effType  := effType;
    packet.effValue := effValue;

    Base.SendToVisible(@packet, packet.Header.Size, true);//False
end;

procedure TPlayer.SendCreateItem(invType : smallint; invSlot : smallint; item: TItem);
var
 packet: TSendCreateItemPacket;
begin
  ZeroMemory(@packet, sizeof(TSendCreateItemPacket));
  packet.Header.Size := sizeof(TSendCreateItemPacket);
  packet.Header.Code := $F0E; //AIKA
  packet.Header.Index := Base.ClientId;
  Packet.Notice  := True;
  packet.invType := invType;
  packet.invSlot := invSlot;
  if(@item = NIL) then fillchar(packet.itemData, 0, sizeof(Item))
  else Move(item, packet.itemData, sizeof(item));
  SendPacket(@packet, packet.Header.Size);
end;

procedure TPlayer.SendClientMessage(str: AnsiString);
var packet: TClientMessagePacket;
begin
  ZeroMemory(@packet, sizeof(TClientMessagePacket));

  packet.Header.Size  := 144;
  packet.Header.Code  := $984;
  packet.Header.Index := 0;
  Packet.Type1:= $10;
  //Packet.Type1:= $01;

  SetString(packet.Message, PAnsiChar(str), 127);

  SendPacket(@packet, packet.Header.Size);
end;

{$ENDREGION}

{$REGION 'Classes'}
class procedure TPlayer.ForEach(proc: TProc<PPlayer, TParallel.TLoopState>);
begin
  TParallel.For(1, InstantiatedPlayers, procedure(i : Integer; state : TParallel.TLoopState)
  var player: PPlayer;
  begin
    player := @Players[i];
    if(player = nil) OR not(player.Base.IsActive) then
      exit;
    proc(player, state);
  end);
end;

class procedure TPlayer.ForEach(proc: TProc<PPlayer>);
var
  i     : Integer;
  player: PPlayer;
begin
  for i := 1 to InstantiatedPlayers do
  begin
    player := @Players[i];
    if(player = nil) OR not(player.Base.IsActive) then
      continue;
    proc(player);
  end;
end;

class function TPlayer.GetPlayer(index: WORD; out player: TPlayer): boolean;
begin
  Result := false;
  if(index = 0) OR (index > MAX_CONNECTIONS) then
    exit;

  player := Players[index];
  Result := player.Base.IsActive;
end;
{$ENDREGION}

end.

