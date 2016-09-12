unit ItemFunctions;

interface

Uses MiscData, DateUtils,
   Windows, Messages, SysUtils, Variants, Classes,Graphics,
   Controls, Packets, Player, BaseMob;

type TItemFunctions = class(TObject)
  public
    class function GetAnctCode(item: TItem) : integer;
    class function GetEffectValue(itemid: integer; eff:shortint) : smallint;
    class function GetItemAbility(const item : TItem; eff: integer) : smallint;
    class function GetSanc(item : TItem) : smallint; static;
    class procedure IncreaseSanc(var item : TItem; value: Byte); static;
    class function GetItem(var item : TItem; mob: TBaseMob; slot, slotType: BYTE): Boolean; overload; static;
    class function GetItem(out item : PItem; mob: TBaseMob; slot, slotType: BYTE): Boolean; overload; static;
    class function GetItemAmount(item: TItem) : BYTE; static;
    class procedure SetItemAmount(var item: TItem; quant: BYTE); static;
    class function GetEmptySlot(const player : TPlayer) : BYTE; static;
    class function CanCarry(const player: TPlayer; Dest: TItem; DestX, DestY: integer; error: pInteger): Boolean; //00409360 - ok
    class function PutItem(var player: TPlayer; item : TItem): Integer;
    class function CanTrade(const player: TPlayer): Boolean;
    class procedure DeleteItem(var player : TPlayer; itemId : integer; quant : WORD);
    class function FreeInitItem(): WORD;
    class function GetEmptyItemGrid(var Position: MiscData.TPosition): Boolean;
    class procedure DeleteVisibleDropList(initId : WORD);
    class procedure DecreaseAmount(var item: TItem; quant: BYTE = 1); static;
  private
end;


var Power : array[0..4] of integer = (220, 250, 280, 320, 370);


implementation


Uses GlobalDefs, PlayerData, Util;

class procedure TItemFunctions.DecreaseAmount(var item: TItem; quant: BYTE = 1);
var
  i: Byte;
  amount: Byte;
begin

end;

class procedure TItemFunctions.DeleteItem(var player : TPlayer; itemId : integer; quant : WORD);
var i,j,lastslot : BYTE;
begin


end;

class function TItemFunctions.CanCarry(const player: TPlayer; Dest : TItem; DestX, DestY: integer; error: pInteger): Boolean; //00409360 - ok
var ItemGrid, i, x, y, pInvX, pInvY: integer; pGridDest, pGridInv: array[0..7] of BYTE; invSlots : array[0..MAX_INVEN] of BYTE;
begin

end;

class function TItemFunctions.PutItem(var player: TPlayer; item : TItem): Integer;
var pos: integer; DestX,DestY,error : integer;
begin

end;


class function TItemFunctions.CanTrade(const player: TPlayer): Boolean;
var i: Byte;
  item: TItem;
  pos: Byte;
  DestX, DestY, error: Integer;
begin
  for i := 0 to 11 do
  begin
    for pos := 0 to (MAX_CARRY - 1) do
    begin
      DestX := pos mod CARRYGRIDX;
      DestY := pos div CARRYGRIDX;
      error := 0;
      if not(CanCarry(player, item, DestX, DestY, @error)) then
      begin
        result := false;
        exit;
      end;
    end;
  end;
  result := true;
end;

class function TItemFunctions.GetAnctCode(item: TItem) : integer;
var value: integer;
begin

end;

class function TItemFunctions.GetEffectValue(itemid: integer; eff:shortint) : smallint;
var i: BYTE;
begin
  for i := 0 to 11 do begin
    if(ItemList[itemid].Effects[i].Index = eff) then
    begin
      result := ItemList[itemid].Effects[i].Value;
      exit;
    end;
  end;
  result:= 0;
end;


class function TItemFunctions.GetItemAbility(const item : TItem; eff: integer) : smallint;
begin

end;

class function TItemFunctions.GetItem(var item : TItem; mob: TBaseMob; slot, slotType: BYTE): Boolean;
begin

end;

class function TItemFunctions.GetItem(out item: PItem; mob: TBaseMob; slot,
  slotType: BYTE): Boolean;
begin

end;
{
class function TItemFunctions.GetItemPointer(out item : PItem; player : TPlayer; slot, slotType: BYTE): Boolean;
begin
  result := false;
  if(slot < 0) then exit;

  case(slotType) of
    INV_TYPE:
    begin
      if(slot < 64) then
        item := @player.Character.Base.Inventory[slot]
      else exit;
    end;

    EQUIP_TYPE:
    begin
      if(slot < 16) then
        item := @player.Character.Base.Equip[slot]
      else exit;
    end;

    STORAGE_TYPE:
    begin
      if(slot < 128)then
        item := @player.Account.Header.StorageItens[slot]
      else exit;
    end;
  end;
  result := true;
end;
}
class function TItemFunctions.GetItemAmount(item: TItem): BYTE;
begin

end;

class function TItemFunctions.GetSanc(item : TItem): smallint;
var value: integer;
begin

end;

class procedure TItemFunctions.IncreaseSanc(var item: TItem; value: Byte);
var
  i: Integer;
begin

end;

class procedure TItemFunctions.SetItemAmount(var item : TItem; quant: BYTE);
begin

end;

class function TItemFunctions.GetEmptySlot(const player : TPlayer) : BYTE;
var i: BYTE;
begin

end;

class function TItemFunctions.FreeInitItem(): WORD;
var i: WORD;
begin
  for i := 1 to MAX_INITITEM_LIST do
  begin
    if(InitItems[i].Item.Index = 0)then
    begin
      result := i;
      exit;
    end;
  end;
  result := 0;
end;

class function TItemFunctions.GetEmptyItemGrid(var Position: MiscData.TPosition): Boolean;
var nY, nX : WORD;
begin
    if(ItemGrid[Round(Position.Y)][Round(Position.X)] = 0)then
    begin
    //    if(HeightGrid.p[Position.Y][Position.X] <> 127)then
        begin
            result := true;
            exit;
        end;
    end;

//    for nY := Position.Y - 1 to Position.Y + 1 do
    begin
     //   for nX := Position.X - 1 to Position.X + 1 do
        begin
            if(nX < 0) or (nY < 0) or (nX >= 4096) or (nY >= 4096)then
    //            continue;

            if(ItemGrid[nY][nX] = 0)then
            begin
                if(ItemGrid[nY][nX] <> 127)then
                begin
                    Position.X := nX;
                    Position.Y := nY;
                    result := true;
                    exit;
                end;
            end;
        end;
    end;

    result := false;
end;

class procedure TItemFunctions.DeleteVisibleDropList(initId : WORD);
var x, y : Integer;
    player : TPlayer;
    initItem : TInitItem;
    mobId : WORD;
begin
  try
    initItem := InitItems[initId];
  except
    exit;
  end;

  if(MinutesBetween(Now, initItem.TimeDrop) < 1) then
  begin
    exit;
  end;

  initItem.Pos.ForEach(17, procedure(pos: TPosition)
  begin
  //  mobId := MobGrid[pos.Y][pos.X];
    if(mobId = 0) OR (mobId > MAX_CONNECTIONS)  then
      exit;

    player := Players[mobId];

    if not(player.Base.IsActive) then
      exit;

 //   player.SendDeleteDropItem(initId + 10000, True);
  end);
  {
  for x := initItem.Pos.X - 17 to initItem.Pos.X + 17 do
  begin
    for y := initItem.Pos.Y - 17 to initItem.Pos.Y + 17 do
    begin
      if (x > 4096) or (x < 0) or (y > 4096) or (y < 0) then
        continue;

      mobId := MobGrid[y][x];
      if(mobId = 0) then
        continue;

      if(mobId <= MAXCONNECTIONS) then
        player := Players[mobId]
      else
        exit;

      if not(player.Base.IsActive) then
        continue;

      player.SendDeleteDropItem(initId + 10000, True);
    end;
  end;
  }
end;


end.
