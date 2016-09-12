program GameServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Generics.Collections,
  ClientConnection in 'Connection\ClientConnection.pas',
  EncDec in 'Connection\EncDec.pas',
  ServerSocket in 'Connection\ServerSocket.pas',
  GlobalDefs in 'Data\GlobalDefs.pas',
  MiscData in 'Data\MiscData.pas',
  Packets in 'Data\Packets.pas',
  PlayerData in 'Data\PlayerData.pas',
  Functions in 'Functions\Functions.pas',
  ItemFunctions in 'Functions\ItemFunctions.pas',
  Load in 'Functions\Load.pas',
  Log in 'Functions\Log.pas',
  Threads in 'Functions\Threads.pas',
  BaseMob in 'Mob\BaseMob.pas',
  NPC in 'Mob\NPC.pas',
  Player in 'Mob\Player.pas',
  Aylin in 'PacketHandlers\NPCs\Aylin.pas',
  NpcFunctions in 'PacketHandlers\NPCs\NpcFunctions.pas',
  NPCHandlers in 'PacketHandlers\NPCs\NPCHandlers.pas',
  Tiny in 'PacketHandlers\NPCs\Tiny.pas',
  Commands in 'PacketHandlers\Commands.pas',
  PacketHandlers in 'PacketHandlers\PacketHandlers.pas',
  Volatiles in 'PacketHandlers\Volatiles.pas',
  MestreGriffo in 'PacketHandlers\NPCs\MestreGriffo.pas',
  Util in 'Functions\Util.pas',
  BuffsData in 'Data\BuffsData.pas',
  Structs in 'Structs.pas';

var
  stay: string;

begin
  try
    Logger := TLog.Create;

    Server := TServerSocket.Create;
    Server.Port := 8822;

    Server.UpTime := now;

    CurrentDir := GetCurrentDir;

    TLoad.InitCharacters;

   {
    Neighbors[0] := TPosition.Create(0, 1);
    Neighbors[1] := TPosition.Create(0,-1);
    Neighbors[2] := TPosition.Create(1, 0);
    Neighbors[3] := TPosition.Create(-1,0);
    Neighbors[4] := TPosition.Create(1, 1);
    Neighbors[5] := TPosition.Create(-1,-1);

    NpcFuncs  := TNpcFunctions.Create;
    ItemFuncs := TItemFunctions.Create;

    ItemList      := TDictionary<integer, TItemList>.Create;
    TeleportsList := TList<TTeleport>.Create;
    SkillsData    := TList<TSkillData>.Create;
    MobBabyList   := TList<TCharacter>.Create;
    MobGener      := TDictionary<integer,TMOBGener>.Create;

    TLoad.ItemsList;
    TLoad.HeightMap;
    TLoad.MobBaby;
    TLoad.TeleportList;
    TLoad.SkillData;
    TLoad.MobList;
}

    Server.StartServer;
    Server.DisconnectAll;
    while(Server.IsActive) do
	  begin

    end;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
       LogTxt(stay);

      Readln(stay);
    end;
  end;
end.
