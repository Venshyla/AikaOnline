unit PacketHandlers;

interface

uses Windows, ClientConnection, Packets, Player, Functions, PlayerData, SysUtils, MiscData,
    ItemFunctions, NPC;


type TPacketHandlers = class(TObject)
  public
    class function CheckLogin(var player : TPlayer; var buffer: array of Byte) : Boolean; static;
    class function NumericToken(var player : TPlayer; var buffer: array of Byte) : Boolean; static;
    class function CreateCharacter(var player: TPlayer; var buffer: array of Byte) : Boolean; static;
    class function DeleteCharacter(var player: TPlayer; var buffer: array of Byte) : Boolean; static;
    class function PlayerChat(var player: TPlayer; var buffer: array of Byte): Boolean; static;
    class function Gates(var player : TPlayer; var buffer: array of Byte) : Boolean; static;
    class function AddPoints(var player: TPlayer; var buffer: array of Byte): boolean;
    class function ChangeCity(var player : TPlayer; var buffer: array of Byte) : Boolean; static;
    class function MoveItem(var player : TPlayer; var buffer: array of Byte) : Boolean; static;
    class function DeleteItem(var player: TPlayer; var buffer: array of Byte) : Boolean;
    class function UngroupItem(var player: TPlayer; var buffer: array of Byte) : Boolean;
    class function SendNPCSellItens(var player: TPlayer; var buffer: array of Byte) : Boolean; static;
    class function BuyNpcItens(var player: TPlayer; var buffer: array of Byte): Boolean; static;
    class function SellItemsToNPC(var player: TPlayer; var buffer: array of Byte) : Boolean; static;
    class function RequestOpenStoreTrade(var player: TPlayer; var buffer: array of Byte): Boolean; static;
    class function BuyStoreTrade(var player : TPlayer; var buffer: array of Byte) : Boolean; static;
    class function RequestParty(var player: TPlayer; var buffer: array of Byte): Boolean; static;
    class function ExitParty(var player: TPlayer; var buffer: array of Byte): Boolean; static;
    class function AcceptParty(var player: TPlayer; var buffer: array of Byte): Boolean; static;

    class function SendClientSay(var player: TPlayer; var buffer: array of Byte): Boolean;
    class function CargoGoldToInventory(var player: TPlayer; var buffer: array of Byte): Boolean;
    class function InventoryGoldToCargo(var player: TPlayer; var buffer: array of Byte): Boolean;

    class function Trade(var player: TPlayer; var buffer: array of Byte): Boolean;

    class function CloseTrade(var player: TPlayer): Boolean;
    class function OpenStoreTrade(var player: TPlayer; var buffer: array of Byte): boolean;
    class function PKMode(var player: TPlayer; var buffer: array of Byte): boolean;
    class function ChangeSkillBar(var player: TPlayer; var buffer: array of Byte): boolean;
    class function DropItem(var player: TPlayer; var buffer: array of Byte): boolean;
    class function PickItem(var player: TPlayer; var buffer: array of Byte): boolean;

    class function MovementCommand(var player: TPlayer; var buffer: array of Byte): Boolean;
    class function RequestEmotion(var player: TPlayer; var buffer: array of Byte): Boolean;
end;

implementation
uses GlobalDefs, Log, Util;

class function TPacketHandlers.ChangeCity(var player: TPlayer; var buffer: array of Byte): Boolean;
begin
  Move(buffer[12], player.Character.CurrentCity, 4);
  if(player.Character.CurrentCity < TCity.Armia) or (player.Character.CurrentCity > TCity.Karden) then
  begin
    player.Character.CurrentCity := TCity.Armia;
    exit;
  end;
  Result := true;
end;

class function TPacketHandlers.RequestEmotion(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet : TRequestEmotion absolute buffer;
begin
  Result := false;
//  player.SendEmotion(packet.effType, packet.effValue);
  Result := true;
end;

class function TPacketHandlers.CheckLogin(var player : TPlayer; var buffer : array of Byte) : Boolean;
var
 packet : TRequestLoginPacket absolute buffer;
 userName, passWord : string;
begin
  Result := false;
  if(packet.Version <> $121) then
  begin
    player.SendClientMessage('Atualize o client!');
    exit;
  end;


  userName  :=  'admin';//TFunctions.CharArrayToString(packet.UserName);

  if not(player.LoadAccount(userName)) then
  begin
     player.SendClientMessage('Conta não encontrada!');
     exit;
  end;

  passWord :=  'admin';  //TFunctions.CharArrayToString(packet.PassWord);

  if(player.Account.Header.Password <> passWord) then
  begin
    player.SendClientMessage('Senha incorreta!');
    Server.Disconnect(player);
    exit;
  end;

  if(player.Account.Header.IsActive) then
  begin
    player.SendClientMessage('Conexão anterior finalizada!');
    Server.Disconnect(player.Account.Header.Username);
    exit;
  end;
  player.Account.Header.IsActive := true;
  player.SaveAccount;
  player.SendCharList;
  Result := true;
end;

class function TPacketHandlers.NumericToken(var player: TPlayer; var buffer: array of Byte): Boolean;
var
 packet : TNumericTokenPacket absolute buffer;
begin
  Result := true; //0 Ñ tem  // 1 tem numerica //2 trocar
  case packet.RequestChange of
0: if(player.Account.Header.NumericToken[packet.Slot] = '') then
   begin
   player.Account.Header.NumericToken[packet.Slot]:= packet.Numeric_1;
   player.SaveAccount;
   player.SendToWorld(packet.Slot);
   end;

1: if (AnsiCompareText(packet.Numeric_1, Trim(player.Account.Header.NumericToken[packet.Slot])) = 0) and (player.Account.Header.NumError[packet.Slot] < 5) then
   begin
   player.Account.Header.NumError[packet.Slot] := 0;
   player.SendToWorld(packet.Slot);
   end
   else
   begin
    Inc(player.Account.Header.NumError[packet.Slot],1);
    player.SubStatus := Waiting;
    player.SendPacket(@packet, packet.Header.Size);
    player.SaveAccount;
//    Player.SendCharList;
   end;

2: if (AnsiCompareText(packet.Numeric_2, Trim(player.Account.Header.NumericToken[packet.Slot])) = 0) and (player.Account.Header.NumError[packet.Slot] < 5) then
   begin
    player.Account.Header.NumericToken[packet.Slot] := packet.Numeric_1;
    player.SaveAccount;
    player.SendToWorld(packet.Slot);
   end
   else
   begin
    Inc(player.Account.Header.NumError[packet.Slot],1);
    player.SubStatus := Waiting;
    player.SendPacket(@packet, packet.Header.Size);
    player.SaveAccount;
   end;
end;
end;

class function TPacketHandlers.RequestOpenStoreTrade(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet: TRequestOpenPlayerStorePacket absolute buffer; i,z: BYTE;
begin

  result:=true;
end;

class function TPacketHandlers.CreateCharacter(var player: TPlayer; var buffer: array of Byte): Boolean;
var
packet : TCreateCharacterRequestPacket absolute buffer;
ClasseChar : Byte;
begin
  Result := true;
  //war
 if (packet.ClassIndex >= 10) and (packet.ClassIndex <=19) then ClasseChar:= 0;
//templar
 if (packet.ClassIndex >= 20) and (packet.ClassIndex <=29) then ClasseChar:= 1;
  //att
 if (packet.ClassIndex >= 30) and (packet.ClassIndex <=39) then ClasseChar:= 2;
 //dual
 if (packet.ClassIndex >= 40) and (packet.ClassIndex <=49) then ClasseChar:= 3;
 //mago
 if (packet.ClassIndex >= 50) and (packet.ClassIndex <=59) then ClasseChar:= 4;
 //cleriga
 if (packet.ClassIndex >= 60) and (packet.ClassIndex <=69) then ClasseChar:= 5;
 if packet.ClassIndex >= 70 then ClasseChar := 0;

 case Packet.Local of
 0: begin
    player.Account.Characters[packet.SlotIndex].LastPos.X := 3450;
    player.Account.Characters[packet.SlotIndex].LastPos.Y := 690;
    end;   //0 = 3450 690
 1:begin   //1 = 3470 935
    player.Account.Characters[packet.SlotIndex].LastPos.X := 3470;
    player.Account.Characters[packet.SlotIndex].LastPos.Y := 935;
    end;
 end;

 //Move os atributos iniciais para a database qndo cria o char
 Move(InitialCharacters[ClasseChar], player.Account.Characters[packet.SlotIndex].Base, sizeof(TCharacter));

 player.Account.Characters[packet.SlotIndex].Base.Equip[0].Index := packet.ClassIndex;
 player.Account.Characters[packet.SlotIndex].Base.Equip[1].Index := packet.Face;

 Move(packet.Name, player.Account.Characters[packet.SlotIndex].Base.Name[0], 16);

  TFunctions.SaveCharacterFile(player, packet.Name);
  player.SendCharList; //Ja salva
end;

class function TPacketHandlers.DeleteCharacter(var player: TPlayer; var buffer: array of Byte): Boolean;
var
  packet : TDeleteCharacterRequestPacket absolute buffer;
  local,Name : string;
begin

 if (AnsiCompareText(packet.Password, player.Account.Header.NumericToken[packet.SlotIndex]) = 0)  and  not Packet.Delete  then
begin
   Name:= player.Account.Characters[packet.SlotIndex].Base.Name;

  if(TFunctions.IsLetter(Name)) then
    local := CurrentDir + '\Chars\'+Trim(Name)[1]+ '\'+ Trim(Name)
  else
    local := CurrentDir + '\Chars\etc\'+ Trim(Name);
    DeleteFile(local);//deleta o arquivo

  ZeroMemory(@player.Account.Characters[packet.SlotIndex], sizeof(TCharacterDB));
  player.Account.Header.NumericToken[packet.SlotIndex] := '';
  player.Account.Header.NumError[packet.SlotIndex]     := 0;
  player.Account.Header.PlayerDelete[packet.SlotIndex] := False;
  player.SendCharList;
  player.SaveAccount;
end
else
  Inc(player.Account.Header.NumError[packet.SlotIndex],1);
 player.SendCharList;
end;

class function TPacketHandlers.Gates(var player: TPlayer; var buffer: array of Byte): Boolean;
var cX, cY : WORD;
    hour : TDateTime;
    teleport: TTeleport;
begin

	Result := true;
end;

class function TPacketHandlers.AddPoints(var player: TPlayer; var buffer: array of Byte): boolean;
var
  packet : TRequestAddPoints absolute buffer;
  onSuccess:boolean; max,reqclass,skillDiv,skillId,skillId2: integer;
  info: psmallint; master: pbyte; master2: pbyte; item: TItemList;
begin

end;

class function TPacketHandlers.MoveItem(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet : TMoveItemPacket absolute buffer;
    destItem, srcItem: pItem; aux: TItem; pos: BYTE;  error: integer;
begin
  if(packet.destSlot < 0) or (packet.srcSlot < 0)then
    exit;

  case(packet.DestType) of
    INV_TYPE:
    begin
      if(packet.destSlot < 64) then
        destItem := @player.Character.Base.Inventory[packet.destSlot]
      else exit;
    end;
    EQUIP_TYPE:
    begin
      if(packet.destSlot < 16) then
        destItem := @player.Character.Base.Equip[packet.destSlot]
      else exit;
    end;
    STORAGE_TYPE:
    begin
      if(packet.destSlot < 128) then
        destItem := @player.Account.Header.StorageItens[packet.destSlot]
      else exit;
    end;
  end;

  case(packet.srcType) of
    INV_TYPE:
    begin
      if(packet.srcSlot < 64) then
        srcItem := @player.Character.Base.Inventory[packet.srcSlot]
      else exit;
    end;
    EQUIP_TYPE:
    begin
      if(packet.srcSlot < 16) then
        srcItem := @player.Character.Base.Equip[packet.srcSlot]
      else exit;
    end;
    STORAGE_TYPE:
    begin
      if(packet.srcSlot < 128)then
        srcItem := @player.Account.Header.StorageItens[packet.srcSlot]
      else exit;
    end;
  end;

  error := 0;
  //if (packet.destType = INV_TYPE) then
  //begin
    //if not(TItemFunctions.CanCarry(player, srcItem^, packet.destSlot mod 9, packet.destSlot div 9, @error)) then
     // exit;
  //end;

  if (destItem.Index = 0) then
  begin
    Move(srcItem^, destItem^, 8);
  end
  else
  begin
    Move(destItem^, aux, 8);
    Move(srcItem^, destItem^, 8);
    Move(aux, srcItem^, 8);
  end;

  if (packet.destType = INV_TYPE) and (packet.srcSlot = 6) and not(player.Character.Base.Equip[7].Index = 0) then
  begin
  //  pos := TItemFunctions.GetEffectValue(player.Character.Base.Equip[7].Index, EF_POS);

		if(pos = 192) then
		begin
			Move(player.Character.Base.Equip[7], player.Character.Base.Equip[6], 8);
			ZeroMemory(@player.Character.Base.Equip[7], 8);
    end;
  end;

  if (packet.destType = EQUIP_TYPE) and (packet.destSlot = 14) then
    player.Base.GenerateBabyMob
  else
  begin
    if (packet.srcType = EQUIP_TYPE) and (packet.srcSlot = 14) then
      player.Base.UngenerateBabyMob(DELETE_UNSPAWN);
  end;

  ZeroMemory(srcItem,8);
  player.SendPacket(@packet, packet.Header.Size);


  player.Base.SendEquipItems(False);
  result := true;
end;

class function TPacketHandlers.DeleteItem(var player: TPlayer; var buffer: array of Byte) : Boolean;
var packet: TDeleteItem absolute buffer;
begin

end;

class function TPacketHandlers.UngroupItem(var player: TPlayer; var buffer: array of Byte) : Boolean;
begin

  result:=true;
end;

class function TPacketHandlers.SendNPCSellItens(var player: TPlayer; var buffer: array of Byte) : Boolean;
var packet: TSendNPCSellItensPacket absolute buffer;
    npc : TCharacter;
    npcId : WORD;
    i, j, k : Integer;
begin

end;

class function TPacketHandlers.Trade(var player: TPlayer; var buffer: array of Byte): Boolean;
begin

end;

class function TPacketHandlers.BuyNpcItens(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet: TBuyNpcItensPacket absolute buffer;
    item : TItem;
    price : Integer;
    slot: BYTE;
    adjustedPrice: integer;
begin

end;

class function TPacketHandlers.BuyStoreTrade(var player: TPlayer; var buffer: array of Byte): Boolean;
var
  packet: TBuyStoreItemPacket absolute buffer;
  seller : TPlayer;
  emptySlot : Byte;
  response : TSendItemBoughtPacket;
  i : BYTE;
  find : Boolean;
  branco : TItem;
begin

    result:= true;
end;

class function TPacketHandlers.SellItemsToNPC(var player: TPlayer; var buffer: array of Byte) : Boolean;
var packet : TSellItemsToNpcPacket absolute buffer;
    item : TItem;
    price, tax : integer;
begin

end;

class function TPacketHandlers.PlayerChat(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet : TChatPacket absolute buffer;
begin
  player.Base.SendToVisible(@packet, packet.Header.Size);
end;

class function TPacketHandlers.RequestParty(var player: TPlayer; var buffer: array of Byte): boolean;
var packet: TPartyRequestPacket absolute buffer;
    party : TParty;
begin

end;

class function TPacketHandlers.ExitParty(var player: TPlayer; var buffer: array of Byte): boolean;
var packet: TExitPartyPacket absolute buffer;
    //leader : TPlayer;
    i: BYTE;
    find: boolean;
    party : TParty;
    //id,liderid, exitid: Word; i: BYTE; find: boolean;
begin

end;

class function TPacketHandlers.AcceptParty(var player: TPlayer; var buffer: array of Byte): boolean;
var packet: TAcceptPartyPacket absolute buffer;
    party : PParty;
    //leader : TPlayer;
    i: BYTE; id: WORD; first: boolean;
    leader: TPlayer;
begin

end;

class function TPacketHandlers.SendClientSay(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet: TChatPacket;
begin
  ZeroMemory(@packet, sizeof(packet));
  packet.Header.Size := sizeof(packet);
  packet.Header.Code := $F86;//Aika
  packet.Header.Index := 1;

 //SetString(packet.Nick, PAnsiChar(Name), 15);
 //SetString(packet.fala, PAnsiChar(str), 95);

  Packet.Typechat[0]:= $FF;
  Packet.Typechat[1]:= $FF;
  Packet.Typechat[2]:= $FF;
  Packet.Typechat[3]:= $FF;

    player.Base.SendToVisible(@packet, packet.Header.Size, true);

    result:=true;
end;

class function TPacketHandlers.CargoGoldToInventory(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet : TRefreshMoneyPacket absolute buffer;
begin

end;

class function TPacketHandlers.InventoryGoldToCargo(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet : TRefreshMoneyPacket absolute buffer;
begin

end;

class function TPacketHandlers.CloseTrade(var player: TPlayer): Boolean;
begin

end;

class function TPacketHandlers.OpenStoreTrade(var player: TPlayer; var buffer: array of Byte): boolean;
var packet : TOpenTrade absolute buffer;
begin

end;

class function TPacketHandlers.PKMode(var player: TPlayer; var buffer: array of Byte): boolean;
var packet : TSignalData absolute buffer;
begin
  if packet.Data > 255 then
  begin
    result := false;
    exit;
  end;

  player.Character.PlayerKill := IFThen(packet.Data = 1);
  result := True;
end;

class function TPacketHandlers.ChangeSkillBar(var player: TPlayer; var buffer: array of Byte): boolean;
var packet : TSkillBarChange absolute buffer;
begin

end;

class function TPacketHandlers.DropItem(var player: TPlayer; var buffer: array of Byte): boolean;
var packet : TReqDropItem absolute buffer; item : PItem; initItem : TInitItem; Pos : TPosition;
    initId : WORD;
begin

end;

class function TPacketHandlers.PickItem(var player: TPlayer; var buffer: array of Byte): boolean;
var packet : TReqPickItem absolute buffer; item : PItem; initItem : TInitItem; Pos : TPosition;
    initId : WORD;
begin

  result := true;
end;

class function TPacketHandlers.MovementCommand(var player: TPlayer; var buffer: array of Byte): Boolean;
var packet : TMovementPacket absolute buffer;
  dir : AnsiChar;
  cmm: Boolean;
begin
  if not(packet.Destination.IsValid) OR (packet.MoveType <> MOVE_NORMAL) then
  begin
    result := false;
    exit;
  end;
  if(player.Base.CurrentPosition = packet.Destination) then
  begin
    result := true;
    exit;
  end;
   if packet.Destination.Distance(player.Base.CurrentPosition) > 30 then
  begin
    result := true;
    exit;
  end;

  if not TFunctions.UpdateWorld(player.Base.ClientId, packet.Destination, WORLD_MOB) then
  begin
    result := true;
    exit;
  end;

  player.Character.LastPos := player.Base.CurrentPosition;
  cmm := IfThen(packet.Header.Code = $301);
                                                                   //MOVE_NORMAL
  packet := TFunctions.GetAction(player.Base, packet.Destination, Packet.MoveType, nil);

  player.Base.IsDirty := true;
  player.base.SetDestination(packet.Destination);
  player.Base.SendToVisible(@packet, packet.Header.Size, false);
	if (cmm) then
		player.SendPacket(@packet, packet.Header.Size);//talvez não seja necessario
end;

end.
