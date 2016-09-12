unit ClientConnection;

interface

uses SysUtils, Windows, WinSock2, EncDec, Packets;

type TClientConnection = record

  public
    Socket : TSocket;
    IpAddress : string;
    ReceivedPackets : Integer;
    RecvBuffer : array[0..32000] of Byte;//3000

    procedure Create(sock : TSocket);
    procedure Destroy();
    procedure SendPacket(packet : pointer; size : WORD; encrypt: Boolean);

  private
    SendBuffer : array[0..32000] of Byte;
end;

implementation

uses GlobalDefs, Player, Log;


procedure TClientConnection.Create(sock : TSocket);
var result: Integer;
  address : TSockAddrIn;
  addressLength : Integer;
  addressInternet: PSockAddrIn;
begin
  ZeroMemory(@self, sizeof(TClientConnection));
  self.Socket := sock;
  addressLength := SizeOf(TSockAddrIn);
  result := getpeername(sock, TSockAddr(address), addressLength);
  IpAddress := inet_ntoa(address.sin_addr);
end;

procedure TClientConnection.Destroy;
begin
  CloseSocket(self.Socket);
  self.Socket := INVALID_SOCKET;
  //FreeAndNil(self);
end;

procedure TClientConnection.SendPacket(packet : pointer; size : WORD; encrypt: Boolean);
var retVal : integer;
    header : TPacketHeader;
begin
  if encrypt then
  begin
    TEncDec.Encrypt(packet, size);
  end;

	retval := Send(Socket, packet^, size, 0);
  if (retval = SOCKET_ERROR) then
  begin
    Logger.Write('Send failed with error: ' + IntToStr(WSAGetLastError), TLogType.Warnings);
    CloseSocket(Socket);
    WSACleanup();
    exit;
  end;
end;

end.
