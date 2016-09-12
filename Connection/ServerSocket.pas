unit ServerSocket;

interface

uses PlayerData, Functions, PacketHandlers, ClientConnection, Threads, Log, Commands,
    Volatiles, NpcFunctions, Player, Packets, EncDec, Util,

    WinSock2, Windows, SysUtils, Variants, Diagnostics,
    DateUtils, ShareMem, Classes, Generics.Collections;


type TServerLoopThread = class(TThread)
  public
    procedure Execute; override;
  private
    procedure FillFDS(var fds : TFDSet);
    procedure HandleClients(fds : TFDSet);
end;

type TServerSocket = class(TObject)
  UpTime           : TDateTime;
  Sock             : TSocket;
  ServerAddr       : TSockAddrIn;
  Port             : Integer;
  IsActive         : Boolean;
  ServerLoopThread : TServerLoopThread;

  public
    function StartServer() : Boolean;
    procedure CloseServer();
    procedure AddPlayer(sock : TSocket; clientInfo : PSockAddr);

    procedure Disconnect(var player : TPlayer); overload;
    procedure Disconnect(clientId : WORD); overload;
    procedure Disconnect(userName : string); overload;
    procedure DisconnectAll();

    function OnReceivePacket(var player : TPlayer; var buffer : array of Byte; size : Integer) : Boolean;

    procedure SendPacketTo(clientId : Integer; packet : pointer; size : WORD; encrypt: Boolean = true);
    procedure SendSignalTo(clientId : Integer; pIndex, opCode: WORD);
    procedure SendToAll(packet : pointer; size : WORD);

  private
    procedure StartThreads();
    function  PacketControl(var player : TPlayer; size : integer; var buffer : array of Byte; initialOffset : integer) : Boolean;
end;

implementation

uses GlobalDefs, NPCHandlers;

{ TServer }
function TServerSocket.StartServer() : Boolean;
var
 wsa      : TWsaData;
 timeinit : integer;
begin
  Result := false;
  ZeroMemory(@Players, sizeof(Players));
  if(WSAStartup(MAKEWORD(2, 2), wsa) <> 0) then
  begin
    Logger.Write('Ocorreu um erro ao inicializar o Winsock 2', TLogType.ServerStatus);
    exit;
  end;
  self.Sock := socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
  self.ServerAddr.sin_family := AF_INET;
  self.ServerAddr.sin_port := htons(self.Port);
  self.ServerAddr.sin_addr.S_addr := INADDR_ANY;

  if (bind(Sock, TSockAddr(ServerAddr), sizeof(ServerAddr)) = -1) then
  begin
    Logger.Write('Ocorreu um erro ao configurar o socket.', TLogType.ServerStatus);
		closesocket(sock);
		sock := INVALID_SOCKET;
    exit;
	end;

	if (listen(sock, MAX_CONNECTIONS) = -1) then
  begin
    Logger.Write('Ocorreu um erro ao colocar o socket em modo de escuta.', TLogType.ServerStatus);
		closesocket(sock);
		sock := INVALID_SOCKET;
		exit;
  end;

  IsActive := true;
  StartThreads;
  timeinit := MilliSecondsBetween(Now, UpTime);
  Logger.Write('Servidor levou ' + inttostr(timeinit) + ' milisegundos para carregar(aprox: ' + floattostr(timeinit/1000) +' segundos).', TLogType.ServerStatus);
  Result := true;
end;

procedure TServerSocket.CloseServer;
begin
  if(Sock = -1) or not(IsActive) then exit;
  IsActive := false;
  DisconnectAll();
  ZeroMemory(@Parties, sizeof(TParty) * Length(Parties));
  CloseSocket(sock);
  Sock := INVALID_SOCKET;
end;

procedure TServerSocket.StartThreads;
begin
  ServerLoopThread := TServerLoopThread.Create(false);
  ServerLoopThread.FreeOnTerminate := true;

  LoginDisconnectThread := TLoginDisconnectThread.Create(false);
  LoginDisconnectThread.FreeOnTerminate := true;

  SaveAccountsThread := TSaveAccountsThread.Create(false);
  SaveAccountsThread.FreeOnTerminate := true;

  UpdateHpMpThread := TUpdateHpMpThread.Create(false);
  UpdateHpMpThread.FreeOnTerminate := true;

  VisibleListThread := TVisibleListThread.Create(false);
  VisibleListThread.FreeOnTerminate := true;

{  NpcAIThread := TNpcAIThread.Create(false);
  NpcAIThread.FreeOnTerminate := true;

  VisibleDropListThread := TVisibleDropListThread.Create(false);
  VisibleDropListThread.FreeOnTerminate := true;

  WeatherChangeThread := TWeatherChangeThread.Create(false);
  WeatherChangeThread.FreeOnTerminate := true;         }
end;

procedure TServerSocket.AddPlayer(sock : TSocket; clientInfo : PSockAddr);
var clientId : WORD;
  clientConnection: TClientConnection;
  packet: TClientMessagePacket;
  errorStr: string;
  ipsCount : Byte;
  i: Integer;
begin
  errorStr := '';
  clientId := TFunctions.FreeClientId;
  clientConnection.Create(sock);
  if(clientId = 0) then
  begin
    errorStr := 'Limite de conexões atingida.';
    //exit;
  end
  else
  begin
    // Infelizmente se precisar dar exit, não da pra dar break, não da pra usar TPlayer.ForEach
    for i := 1 to InstantiatedPlayers do
    begin
      if(ipsCount >= 5) then
      begin
        errorStr := 'Limite de conexões por IP atingido.';
        break;
      end;

      if not(Players[i].Base.IsActive) then continue;

      if(clientConnection.IpAddress = Players[i].Connection.IpAddress) then
      begin
        Inc(ipsCount);
      end;
    end;
  end;

  if(errorStr <> '') then
  begin
    ZeroMemory(@packet, sizeof(TClientMessagePacket));
    packet.Header.Size := sizeof(TClientMessagePacket);
    packet.Header.Code := $984;
    SetString(packet.Message, PAnsiChar(errorStr), 95);

    clientConnection.SendPacket(@packet, packet.Header.Size, true);
    Logger.Write(errorStr,TLogType.Packets);
    Disconnect(clientId);
  end;

  // Aqui verificamos se o proximo clientId disponivel é maior que o numero de players
  // Se for, nós definimos InstantiatedPlayers, como esse clientId
  // O valor de InstantiatedPlayers, continuara a subir com o loguin de novos players
  // mas cada vez que a TLoginDisconnectThread for executada esse número é recalculado
  // Isso evita que o loop por todos os players, seja MAXCONNECTIONS
  // sendo sempre um número igual ou próximo ao valor real de players logados
  if(clientId > InstantiatedPlayers) then
    InstantiatedPlayers := clientId;

  Players[clientId].Create(clientId, clientConnection);
end;

procedure TServerSocket.DisconnectAll;
var i : WORD;
  cnt: WORD;
begin
  TPlayer.ForEach(procedure(player: PPlayer)
  begin
    Disconnect(player.Base.ClientId);
    Inc(cnt);
  end);
  ZeroMemory(@Players, SizeOf(Players));
  if(cnt > 0) then
    Logger.Write('[' + IntToStr(cnt) + '] players foram desconectados.', TLogType.ConnectionsTraffic);
end;

procedure TServerSocket.Disconnect(clientId : WORD);
begin
  if(clientId = 0) then
    exit;

  if not(Players[clientId].Base.IsActive) then
    exit;
  Disconnect(Players[clientId]);

  Logger.Write('Desconect',TLogType.Packets);
end;

procedure TServerSocket.Disconnect(var player : TPlayer);
begin
  if not(player.Base.IsActive) then
    exit;

   if(player.Status > WaitingLogin) then
   begin
     Logger.Write('O Jogador [' + player.Account.Header.Username + '] de Clientid: ' + IntToStr(player.Base.ClientId) + ' se desconectou.', TLogType.ConnectionsTraffic);
   end;
  player.Destroy;
end;

procedure TServerSocket.Disconnect(userName: string);
var i : Integer;
begin
  for i := 1 to (MAX_CONNECTIONS - 1) do
  begin
    if not(Players[i].Base.IsActive) then continue;

    if (AnsiCompareText(Players[i].Account.Header.Username, userName) = 0) then
    begin
      Server.Disconnect(Players[i]);
      Logger.Write('Desconect',TLogType.Packets);
      exit;
    end;
  end;
end;

function TServerSocket.OnReceivePacket(var player : TPlayer; var buffer : array of Byte; size : Integer) : Boolean;
var initialOffset : Integer;
    //correctBuffer : array of Byte;
begin
  result := true;
  if (size < sizeof(TPacketHeader)) then
  begin
    exit;
  end;

  initialOffset := 0;
  if(player.Connection.ReceivedPackets = 0) and (size > 116) then
  begin
    initialOffset := 4;
  end;
  Inc(player.Connection.ReceivedPackets);

  Dec(size, initialOffset);
  TEncDec.Decrypt(buffer[initialOffset], size);

  PacketControl(player, size, buffer, initialOffset);
end;

procedure TServerSocket.SendPacketTo(clientId: Integer; packet : pointer; size : WORD; encrypt: Boolean);
var player: TPlayer;
begin
  if TPlayer.GetPlayer(clientId, player) then
    player.SendPacket(packet, size, encrypt);
end;

procedure TServerSocket.SendSignalTo(clientId: Integer; pIndex, opCode: WORD);
var signal : TPacketHeader;
begin
  if(clientId > MAX_CONNECTIONS) or not(Players[clientId].Base.IsActive) then exit;

  ZeroMemory(@signal, sizeof(TPacketHeader));
  signal.Size := 12;
  signal.Index := pIndex;
  signal.Code := opCode;

  Players[clientId].SendPacket(@signal, sizeof(TPacketHeader), true);
end;

procedure TServerSocket.SendToAll(packet : pointer; size : WORD);
var player : TPlayer;
begin
  for player in Players do
  begin
    player.SendPacket(packet, size, true);
  end;
end;


function TServerSocket.PacketControl(var player : TPlayer; size : integer; var buffer : array of Byte; initialOffset : integer) : Boolean;
var
  header : TPacketHeader;
  i      : Integer;
begin
  Result := false;
  try
    ZeroMemory(@header, sizeof(TPacketHeader));
    if(initialOffset <> 0) then
      Move(buffer[initialOffset], buffer, size);
    Move(buffer, header, sizeof(TPacketHeader));
    if(header.Size <> size) then
      exit;
  finally
    Logger.Write('Recv - Code: ' + Format('0x%x', [header.Code]) + ' / Size : ' + IntToStr(header.Size) +
    ' / ClientId : ' + IntToStr(header.Index), TLogType.Packets);

    case header.Code of
      $685: Result := TPacketHandlers.CheckLogin(player, buffer);

      $F02:   Result := TPacketHandlers.NumericToken(player, buffer);
      $3E04:  Result := TPacketHandlers.CreateCharacter(player, buffer);
      $668:   Result := player.BackToCharList;
      $301:   Result := TPacketHandlers.MovementCommand(player, buffer);
      $603:   Result := TPacketHandlers.DeleteCharacter(player, buffer);
      $F86:   Result := TPacketHandlers.SendClientSay(player, buffer);//não funfa ainda
      $70F:   Result := TPacketHandlers.MoveItem(player, buffer);


     {  $213: Result := TPacketHandlers.SelectCharacter(player, buffer);

      $270: Result := TPacketHandlers.PickItem(player, buffer);
      $272: Result := TPacketHandlers.DropItem(player, buffer);
      $277: Result := TPacketHandlers.AddPoints(player, buffer);
      $28B, $28E: Result := TNPCHandlers.Handle(player, buffer);
      $AD9: Result := NpcFuncs.NpcMestreGriffo.MestreGriffoProc(player, buffer);
      $290: Result := TPacketHandlers.Gates(player, buffer);
      $291: Result := TPacketHandlers.ChangeCity(player, buffer);
      $36A: Result := TPacketHandlers.RequestEmotion(player, buffer);
      $373: Result := TVolatiles.UseItem(player, buffer);
      $376: Result := TPacketHandlers.MoveItem(player, buffer);
      $27B: Result := TPacketHandlers.SendNPCSellItens(player, buffer);
      $2E4: Result := TPacketHandlers.DeleteItem(player, buffer);
      $2E5: Result := TPacketHandlers.UngroupItem(player, buffer);

      $334: Result := TCommands.Received(player, buffer);

      $378: Result := TPacketHandlers.ChangeSkillBar(player, buffer);
      $379: Result := TPacketHandlers.BuyNpcItens(player, buffer);
      $37A: Result := TPacketHandlers.SellItemsToNPC(player, buffer);
      $383: Result := TPacketHandlers.Trade(player, buffer);
      $384: Result := TPacketHandlers.CloseTrade(player);
      $387: Result := TPacketHandlers.CargoGoldToInventory(player, buffer);
      $388: Result := TPacketHandlers.InventoryGoldToCargo(player, buffer);
     }
    end;
  end;
end;


{ TServerLoopThread }
procedure TServerLoopThread.Execute;
var
    newSocket : TSocket;
	  ClientInfo: PSockAddr;
    clientinfolen : Integer;

    fds: TFdSet;
    activity: Integer;
    timeout : TTimeVal;
begin
  Priority := tpHighest;
  timeout.tv_sec := 0;
  timeout.tv_usec := 2000;
  while(Server.IsActive) do
	begin
    try
      FD_ZERO(fds);
      FillFDS(fds);
		  _FD_SET(Server.Sock, fds);

		  activity := Select(0, @fds, nil, nil, @timeout);
		  if (activity = 0) then continue;

		  if (activity < 0) { and (errno != EINTR)} then
      begin
		  	Logger.Write('Select command failed. Error #' + IntToStr(WSAGetLastError), TLogType.Warnings);
		  	Server.IsActive := false;
      end;
		  if (FD_ISSET(Server.Sock, fds)) then
      begin
		  	newSocket := accept(Server.Sock, ClientInfo, nil);
        if (NewSocket <> INVALID_SOCKET) then
          Server.AddPlayer(newSocket, ClientInfo)
		  	else
          Logger.Write('Error accepting socket. Error #' + IntToStr(WSAGetLastError), TLogType.Warnings);
		  end;
      HandleClients(fds);
    except
      continue;
    end;
  end;
  inherited;
end;

procedure TServerLoopThread.FillFDS(var fds : TFDSet);
var i : WORD;
    player : TPlayer;
begin
  for i := 1 to MAX_CONNECTIONS do
  begin
    player := Players[i];
    if(player.Base.IsActive) then
      _FD_SET(player.Connection.Socket, fds)
    else Server.Disconnect(player);
	end;
end;

procedure TServerLoopThread.HandleClients(fds: TFDSet);
var i : WORD;
begin
  for i := 1 to (MAX_CONNECTIONS - 1) do
  begin
    if not(Players[i].Base.IsActive) then
      continue;

    if(FD_ISSET(Players[i].Connection.Socket, fds)) then
    begin
      if not(Players[i].ReceiveData) then
        Server.Disconnect(Players[i]);
    end;
  end;
end;

begin


end.
