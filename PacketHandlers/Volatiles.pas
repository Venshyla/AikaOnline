unit Volatiles;

interface

uses Windows, Packets, Player, MiscData, ItemFunctions, Functions;

type TVolatiles = class(TObject)
  public
    class function UseItem(var player: TPlayer; var buffer: array of Byte): Boolean; static;

  private
    class function ReturnScroll(var player : TPlayer) : Boolean; static;
    class function Potion(var player : TPlayer; potionType : Byte): Boolean; static;
end;

implementation

class function TVolatiles.UseItem(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet : TUseItemPacket absolute buffer;
    srcItem, dstItem : TItem;
    ammount, volatile : Byte;
    used : Boolean;
begin

end;


class function TVolatiles.ReturnScroll(var player: TPlayer): Boolean;
var position : TPosition;
begin
  result:= true;
  position := TFunctions.GetStartXY(player.Character.CurrentCity);

  player.Base.Teleport(position);
  player.Base.SendEmotion(14, 3);
end;

class function TVolatiles.Potion(var player : TPlayer; potionType : Byte): Boolean;
begin
  result:= true;
  case potionType of
    1: // HP
    begin
      //Inc(player.Base.Character.bStatus, 100);
      //if(
    end; 
    2:  // MP
    begin
    end;
  end;
end;


end.                            
