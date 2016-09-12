unit Commands;

interface

  Uses MiscData, Player, BaseMob,
   Windows, Messages, SysUtils, Variants, Classes, DateUtils,
   Packets, StdCtrls, MMSystem,
   ItemFunctions;

  type
    TCommands = class(TObject)
    public
      class function Received(var player : TPlayer; var buffer: array of BYTE) : Boolean;

    private
      class procedure Dir(var player : TPlayer; command : TCommandPacket); static;
      class procedure Item(var player : TPlayer; packet : TCommandPacket); static;
      class procedure Tab(var player : TPlayer; command : TCommandPacket); static;
      class procedure Teleport(var player : TPlayer; command : TCommandPacket); static;
      class procedure UpdateArea(var player : TPlayer; command : TCommandPacket); static;
  end;

implementation

uses GlobalDefs, Functions;

class procedure TCommands.Dir(var player : TPlayer; command: TCommandPacket);
{var year, month, day : Word;
    str : string;}
begin

end;

class function TCommands.Received(var player : TPlayer; var buffer: array of BYTE) : Boolean;
var packet : TCommandPacket absolute buffer;
begin

end;

class procedure TCommands.Tab(var player: TPlayer; command: TCommandPacket);
var packet : TSendCreateMobPacket;
begin
  player.Base.SendCreateMob(SPAWN_NORMAL);
end;

class procedure TCommands.Teleport(var player: TPlayer; command: TCommandPacket);
var Strings : TStringList; line: string; pos: TPosition;
begin
  line := command.Value;
  Strings := TStringList.Create;
  ExtractStrings([' '], [#0], pChar(line), Strings);

  pos := TPosition.Create(StrToInt(Strings[0]), StrToInt(Strings[1]));
  if not(TFunctions.GetEmptyMobGrid(player.Base.ClientId, pos)) then
  begin

  end;
  player.Base.Teleport(pos);
end;

class procedure TCommands.UpdateArea(var player: TPlayer;
  command: TCommandPacket);
begin
  player.Base.ForEachVisible(procedure(mob: TBaseMob)
  begin
    mob.SendCreateMob(SPAWN_NORMAL, 1);
  end);
end;

class procedure TCommands.Item(var player : TPlayer; packet: TCommandPacket);
begin

end;

end.
