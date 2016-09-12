unit MestreGriffo;

interface

Uses MiscData, PlayerData, ItemFunctions, Functions,
   Windows, Messages, SysUtils, Variants, Classes, Graphics,
   Controls, Forms, Dialogs, ScktComp, Packets, StdCtrls, Player, MMSystem;


  type
    MestreGriffoClass = class(TObject)
    public
      class function MestreGriffoProc(var player : TPlayer; var buffer: array of Byte): Boolean;
  end;

implementation

class function MestreGriffoClass.MestreGriffoProc(var player : TPlayer; var buffer: array of Byte): Boolean;
var packet : TMestreGriffo absolute buffer; dest: MiscData.TPosition;
begin
  result := False;
  
  if(packet.WarpType = 1)then
	begin
		result := true;
    exit;
	end;
  
	case packet.WarpID of
		0:
    begin
			player.SendClientMessage('Chegou no destino [Campo_de_Treino].');
      dest.X := 2112;
      dest.Y := 2051;
      TFunctions.GetEmptyMobGrid(player.Base.ClientId, dest);
			player.Base.Teleport(dest);
    end;

		1:
    begin
			player.SendClientMessage('Chegou no destino [Defensor da alma].');
      dest.X := 2372;
      dest.Y := 2099;
      TFunctions.GetEmptyMobGrid(player.Base.ClientId, dest);
			player.Base.Teleport(dest);
    end;

		2:
    begin
			player.SendClientMessage('Chegou no destino [Jardin de deus].');
      dest.X := 2220;
      dest.Y := 1714;
      TFunctions.GetEmptyMobGrid(player.Base.ClientId, dest);
			player.Base.Teleport(dest);
    end;

		3:
    begin
			player.SendClientMessage('Chegou no destino [Dungeon].');
      dest.X := 2365;
      dest.Y := 2279;
      TFunctions.GetEmptyMobGrid(player.Base.ClientId, dest);
			player.Base.Teleport(dest);
    end;

		4:
    begin
			player.SendClientMessage('Chegou no destino [SubMundo].');
      dest.X := 1826;
      dest.Y := 1771;
      TFunctions.GetEmptyMobGrid(player.Base.ClientId, dest);
			player.Base.Teleport(dest);
    end;

	end;

	result := true;
end;

end.
