unit Funcoes;

interface

{
Uses WinSock,
   Windows, Messages, SysUtils, Variants, Classes, Graphics, StrUtils, DateUtils,
   Math, Controls, Forms, Dialogs, ScktComp, Packets, StdCtrls, Players, MMSystem,
   Guilds, Generics.Collections, MiscData, PlayerData;

type
  Functions = class(TObject)
  public
    Bufferr: array[0..32000] of Byte;
    function CheckItensTrade(index: WORD; Mode: BYTE): boolean;
    function GetFreeMob():WORD;
    function clock():Cardinal;
    function GetQuantTradeItem(clientid: WORD): BYTE;
    function GetFreeSlotS(clientid: WORD): BYTE;
    function DeleteItem(index: Word; p: pByte): boolean; overload;
    function RequestParty(index: Word; p: pByte): boolean;
    function AcceptParty(index: Word; p: pByte): boolean;
    function ExitParty(index: Word; p: pByte): boolean;
    function IsNumber(text: string): boolean;
    function IsLetter(text: string): boolean;
    function IsLetter2(text: array of AnsiChar): boolean;
    function GetClientIdBySocket(sock: TSocket): integer;
    function CloseTrade(Index: WORD; Buffer: pByte):boolean; overload;
    function FreeClientId(): integer;
    function ConexoesIP(IP: string):integer;
    function FindAcc(Name: string): boolean;
    function FindChar(Name: string): boolean;
    function LoadAcc(Name: string): TAccountFile;
    //function ServerIdByeHandle(handlef: integer): integer;
    function GetUserByAccName(Name: string): integer;
    function GetGuilty(Clientid: WORD): BYTE;
    function GetCurKill(Clientid: WORD):BYTE;
    function GetTotKill(Clientid:WORD):WORD;
    function GetItemSanc(sitem: TItem):smallint;
    function GetAnctCode(sitem: TItem):integer;
    function GetEffectValue(itemid: integer; eff:shortint):smallint;
    function GetItemAbility(sitem: TItem; eff: integer): smallint;
    function GetMaxAbility(Clientid: WORD; eff: integer; Char : PCharacter): integer;
    function GetMobAbility(Clientid: WORD; eff: integer; Char : PCharacter):integer;
    function GetCurrentHP(Clientid: WORD; Char : PCharacter): integer;
    function GetCurrentMP(Clientid: WORD; Char : PCharacter): integer;
    function LoadAndCompareCharOwner(Name: string; AccName: string): boolean;
    function GetItemIDEF(sItem: TItem; mnt: boolean):WORD;
    function PlayerAction(Index:integer; BufferAux: pBYTE): boolean;
    function SendClientSay(Index: WORD; pak: pBYTE): boolean;
    function GetItemPointer(index: WORD; typee: integer; slot: integer): TItem;
    function CanEquip(pItem: TItem; pScore: TStatus; pSlot: integer; pClass:integer; pEquip: array of TItem): boolean;
    function MoveItem(Index: WORD; pak: pBYTE):boolean;
    function GetEmptySlot(Index: WORD): BYTE;
    function Teleport(x,y,clientid: WORD): boolean;
    function Gates(clientid: WORD): boolean;
    function FindNewXYPos(x,y,id: integer): TPosition;
    function RefreshMoney(Clientid: WORD): boolean;
    function RefreshInventory(Clientid: WORD): boolean;
    function AddPoints(Index: WORD; p: pByte): boolean;
    function GetEmptyCargoSlot(Index: WORD): BYTE;
    function OpenStoreTrade(Index: WORD; Buffer: pByte):boolean;
    function ReadHeightMap():boolean;
    function GetEmptyMobGrid(index: WORD; posX, posY: pword): boolean;
    function Distance(posX1, posY1: smallint; posX2, posY2: psmallint): Double;
    function rand(num:integer):integer;
    function BuyItemTrade(Index: WORD; pak: pByte): boolean;
    function OpenTrade(Index: WORD; pak: pByte): boolean;
    function GetStartXY(index: WORD): boolean;
    function FindInParty(index, findid: WORD): BYTE;
    function GetExpApply(exp, index, mobindex: integer): integer;
    procedure DeleteItem(activeChar : PActiveCharacter; slot : BYTE); overload;
    procedure DeleteItem(activeChar : PActiveCharacter; itemId : integer; quant : WORD); overload;
    procedure Trade(index: WORD; pak: pByte);
    procedure SendLevelUP(index, mobid: WORD);
    procedure Weather();
    procedure SendWeather(index, cityid: Word); overload;
    procedure SendWeather(); overload;
    //procedure CreateGuildFile(struct: ArqGuild);
    procedure SendParty(leader, member, toclient: WORD);
    procedure SendExitParty(leader, exitid: integer; force: boolean);
    procedure SendAutoTrade(sendIndexID, tradeIndexID: integer);
    procedure AIMove(mobindex :WORD);
    procedure AICreateMob(mobindex :WORD);
    procedure SkillData();
    procedure LoadTeleportList();
    procedure LoadMobList();
    procedure GetAction(Index: integer; posX:Smallint; posY: smallint; p: p_p366);
    procedure GridMulticast(Index: integer; posX:smallint; posY:smallint; buf2: pBYTE; size: WORD);
    procedure GridMulticast2(posX: smallint; posY: smallint; sendPak2: pBYTE; size: WORD; Index: WORD);
    procedure SendChat(Index: WORD; str: string);
    procedure CreateItem(Index: WORD; invType: smallint; invSlot:smallint; pitem: TItem);
    procedure SendScore(index: WORD);
    procedure SendRemoveMob(Index: WORD; pakClient: WORD; delType: integer);
    procedure SendRemoveMob2(Index: WORD; pakClient: WORD; delType: integer);//no self
    procedure SendEtc(index: WORD);
    procedure SendEquipItems(Index: WORD; noSendPakClientID: WORD);
    procedure GetCreateMob(Clientid: WORD);
    procedure GetCurrentScore(Clientid: WORD);
    procedure LoadItemList();
    procedure SendMobDead(Killer,Killed: WORD; posX, posY: integer);
    procedure SendSignal(Clientid: WORD; pIndex: WORD; opCode: WORD);
    procedure CreateChar(Clientid: integer; ClassIndex: BYTE; X: BYTE; Name: array of AnsiChar);
    procedure DeleteChar(Clientid: integer; X: BYTE; Name: string);
    procedure SendSocketPacket(Buffer: array of Byte; Size: WORD; Socket: TCustomWinSocket);
    procedure SendClientPacket(BufferAux: pByte; Size:WORD; Clientid: WORD);
    procedure SendClientMsg(Clientid: integer; Msg: string);
    procedure DeleteClientId(Id: integer);
    procedure Log(listbox: TListBox; recsend: string; pHeader: TPacketHeader; Clientid: WORD);
    procedure SendSocketMsg(Socket: TCustomWinSocket; Msg: string);
    procedure SendToCharList(Clientid: WORD; Player: TAccountFile);
    procedure SaveAcc(Acc: TAccountFile; index: WORD);
    procedure SaveCharFile(Name: array of AnsiChar; AccName: string; local: string);
    procedure SendSignalParm(Clientid: WORD; pIndex: WORD; opCode: WORD; dat1: integer);
    procedure Signal(Clientid: WORD; pIndex: WORD; opCode: WORD);
    procedure SendToWorld(CharId: BYTE; Clientid: WORD; Socket: TCustomWinSocket); inline;
    procedure Disconnect(Clientid: WORD);
    procedure DisconnectALL();
    procedure SendGridMob(Index, spawn: WORD);
    procedure SendCreateMob(sendClientID,createClientID,spawn: WORD);
    procedure GetCreateNPC(Clientid: WORD; spawnType: BYTE = 0);
    procedure SendCurrentHPMP(Index: WORD);
    procedure SendNPCSellItens(Clientid: WORD; Buf: pByte);
    procedure BuyNpcItens(Clientid: WORD; Buf: pByte);
    procedure SellItemsToNPC(Clientid: WORD; Buf: pByte);
    procedure GetCreateMobTrade(Index: Word);
    procedure Movement(spw: psMob2; index, newPosX, newPosY: smallint);
    procedure SendEmotion(Index: WORD; effType, effValue: smallint);
    procedure LoadMobBaby();
    procedure GenerateBabyMob(Index, mIndex, mobNum: WORD);
    procedure UngenerateBabyMob(mIndex, ungenEffect: WORD); overload;
    procedure CloseTrade(index: WORD); overload;
    //    procedure SendAffects(Index: WORD);


    procedure ReadBlah();
    procedure WriteBlah();

    function ReadGuilds(guildId : integer; fileType : Byte) : Boolean;
    procedure WriteGuilds(guildId : integer; fileType : Byte);
  end;

type ftext = Record
  Name: string[15];
end;

var p364: p_364h;
Power: array[0..4] of integer = (220,250,280,320,370);

const HPIncrementPerLevel: array[0..3] of integer = (
        3, // Transknight
        1, // Foema
        1, // BeastMaster
        2  // Hunter
);

const MPIncrementPerLevel: array[0..3] of integer = (
        1, // Transknight
        3, // Foema
        2, // BeastMaster
        1  // Hunter
);

const Imposto = 5;
}
implementation
 {
Uses
  Unit1;

Const
  Letras: String[26] = ('abcdefghijlmnopqrstuvxywzk');

 function Functions.rand(num:integer):integer;
 //var i: integer;
 begin
    {i := 1;

    i := ((i * 214013) + 2531011);
    result:= ((i shr 16) and $7FFF);

    Randomize;
    result:= Random(num);
end;
{
function Functions.RefreshMoney(Clientid: WORD): boolean; // [GS] -> [Game]
var p: p3AF;
begin
  p.Header.Size := sizeof(p3AF);
	p.Header.Code := $3AF;
	p.Header.Index := Clientid;

	p.Gold := Player[Clientid].Char.Gold;

	SendClientPacket(@p,p.Header.Size,clientid);
	result:=true;
end;
}

{
procedure Functions.SellItemsToNPC(Clientid: WORD; Buf: pByte);
var p: p37A; g,price: integer;
begin
  Move(Buf^,p,sizeof(p37A));

  if(p.invType <> INV_TYPE)then
  begin
    SendClientMsg(clientid,'Passe o item para o inventário.');
    exit;
  end;

  if(p.invSlot > 63)then
    exit;

  if(Player[Clientid].Char.Gold+ItemList[Player[clientid].Char.Inventory[p.invSlot].Index].Price <= 2000000000)then
  begin
    if(ItemList[Player[clientid].Char.Inventory[p.invSlot].Index].Price mod 20000 = 0)then
      price:=Trunc((ItemList[Player[clientid].Char.Inventory[p.invSlot].Index].Price/(4+(Trunc((ItemList[Player[clientid].Char.Inventory[p.invSlot].Index].Price/20000)-1)*2))))
    else
      price:=Trunc((ItemList[Player[clientid].Char.Inventory[p.invSlot].Index].Price/(4+(Trunc(ItemList[Player[clientid].Char.Inventory[p.invSlot].Index].Price/20000)*2))));
    g:=Trunc((price*Imposto)/100);
    inc(Player[Clientid].Char.Gold,price);
    dec(Player[Clientid].Char.Gold,g);
    ZeroMemory(@Player[clientid].Char.Inventory[p.invSlot].Index,8);
    SaveAcc(Jogador[clientid],clientid);
    RefreshInventory(clientid);
  end
  else
  begin
    SendClientMsg(Clientid,'Limite de 2 Bilhões de gold.');
  end;
end;

procedure Functions.BuyNpcItens(Clientid: WORD; Buf: pByte);
var p: p379; slot: BYTE; g: integer;
begin
  Move(Buf^,p,sizeof(p379));
  if(Player[Clientid].Char.Gold>=ItemList[NPCMob[p.mobID].NPC.Inventory[p.sellSlot].Index].Price)then
  begin
    slot:=GetEmptySlot(Clientid);
    if(slot <> 254) then
    begin
      g:=Trunc((ItemList[NPCMob[p.mobID].NPC.Inventory[p.sellSlot].Index].Price*Imposto)/100);
      inc(g,ItemList[NPCMob[p.mobID].NPC.Inventory[p.sellSlot].Index].Price);
      dec(Player[Clientid].Char.Gold,g);
      CreateItem(Clientid,INV_TYPE,slot,NPCMob[p.mobID].NPC.Inventory[p.sellSlot]);
      Move(NPCMob[p.mobID].NPC.Inventory[p.sellSlot],Player[Clientid].Char.Inventory[slot],8);
      SaveAcc(Jogador[clientid],clientid);
      RefreshMoney(clientid);
    end
    else
    begin
      SendClientMsg(Clientid,'Inventário cheio. Impossível Negociar.');
    end;
  end
  else
    SendClientMsg(Clientid,'Gold insuficiente.');
end;


procedure Functions.SendNPCSellItens(Clientid: WORD; Buf: pByte);
var p: p17C;
i,j,k: Integer;
c: word;
range: double;
begin
  Move(Buf^,Bufferr[0],16);
  Move(Bufferr[12],c,2);
  range := Distance(Player[clientid].current.current.x, Player[clientid].current.current.Y
  , @NPCMob[c].NPC.Last.x, @NPCMob[c].NPC.Last.y);
  if(range > 6)then
    exit;
  p.Header.Size:=236;
  p.Header.Code:=$17C;
  p.Header.Index:=30000;
  case NPCMob[c].NPC.Merchant of
    1://itens
    begin
      p.Merch:=1;
      j:=0;
      for i := 0 to 64 do
      begin
        if(NPCMob[c].NPC.Inventory[i].Index = 0) and (j <= 26)then
        begin
          for k := i+1 to 64 do
            if(NPCMob[c].NPC.Inventory[k].Index <> 0)then
            begin
              Move(NPCMob[c].NPC.Inventory[k].Index,NPCMob[c].NPC.Inventory[i].Index,8);
              inc(j);
              break;
            end;
        end;
      end;
      j:=0;
      for i := 0 to 64 do
      begin
        if(NPCMob[c].NPC.Inventory[i].Index <> 0) and (j <= 26)then begin
          Move(NPCMob[c].NPC.Inventory[i],p.Itens[j],8);
          inc(j);
        end;
      end;
      p.Imposto:=Imposto;
    end;
    19:
    begin
      p.Merch:=3;
      j:=0;
      for i := 0 to 64 do
      begin
        if(NPCMob[c].NPC.Inventory[i].Index <> 0) and (j <= 26)then begin
          Move(NPCMob[c].NPC.Inventory[i],p.Itens[j],8);
          inc(j);
          if(j = 8) or (j = 17)then
            inc(j);
        end;
      end;
      p.Imposto:=0;
    end;
  end;
  SendClientPacket(@p,236,Clientid);
end;

procedure Functions.SendGridMob(Index, spawn: WORD);
var posX, posY,mobID: smallint;
nY,nX,VisX,VisY,minPosX,minPosY,maxPosX,maxPosY: integer;
begin
    if(Index <= 0) or (Index >= 8192) then
        exit;

    posX := Trunc(Player[Index].Current.Current.X);
    posY := Trunc(Player[Index].Current.Current.Y);

    VisX := 23; VisY := 23;
    minPosX := (posX - 11);
    minPosY := (posY - 11);

	if((minPosX + VisX) >= 4096)then
		VisX := (VisX - (VisX + minPosX - 4096));

	if((minPosY + VisY) >= 4096)then
		VisY := (VisY - (VisY + minPosY - 4096));

    if(minPosX < 0)then
	  begin
		  minPosX := 0;
		  VisX := (VisX + minPosX);
	  end;

	if(minPosY < 0)then
	begin
		minPosY := 0;
		VisY := (VisY + minPosY);
	end;

  maxPosX := (minPosX + VisX);
  maxPosY := (minPosY + VisY);

  for nY := minPosY to maxPosY do
  begin
    for nX := minPosX to maxPosX do
    begin
      mobID := MobGrid[nY][nX];
      if(mobID <= 0) or (Index = mobID) then
        continue;

      if(mobID < 1000)then
        SendCreateMob(mobID, Index,spawn);

      if(Index < 1000)then
        SendCreateMob(Index, mobID,0);
    end;
  end;

end;

procedure Functions.SendCreateMob(sendClientID, createClientID, spawn: WORD);
begin
    if(createClientID < 1000) and (Player[createClientID].Trading) then
    begin // Envia a venda do player
        GetCreateMobTrade(createClientID);
        SendClientPacket(@Bufferr,sizeof(p_363h),sendClientID);
    end
    else
    begin // Envia o spawn normal
        if(createClientID > 1000)then
        begin
          if(NpcMob[createClientID].NPC.Status.HP > 0)then
          begin
            GetCreateNPC(createClientID);
          end;
        end
        else GetCreateMob(createClientID);

        p364.spawnType:=spawn;
        SendClientPacket(@p364,sizeof(p_364h),sendClientID);
    end;
end;

function Functions.CloseTrade(Index: WORD; Buffer: pByte):boolean;
var Header: sHeader;
begin
  Move(Buffer^,Header,12);

  if(index <> Header.Index)then
  begin
    result:=false;
    exit;
  end;

  if(Player[Index].Trading)then
  begin
    Player[Index].Trading:=false;

    SendCreateMob(index,index,SPAWN_NORMAL);
    GridMulticast2(Trunc(Player[index].current.current.x),Trunc(Player[index].current.current.y),@p364,sizeof(p_364h),0);
  end;

  if(Player[index].Trade.isTrading)then
  begin
    CloseTrade(Player[index].Trade.otherClientid);
    CloseTrade(index);
  end;

  result:=true;
end;

function Functions.BuyItemTrade(Index: WORD; pak: pByte): boolean;
var x: byte; pServer: p398; SlotIndex,gold: integer; Header: p39B; sItem: TItem;
begin
    Move(pak^,pServer,sizeof(p398));
    if(pServer.Slot > 11)then
    begin
        result:= false;
        exit;
    end;

    if(pServer.index = Index)then
    begin
        result:= false;
        exit;
    end;

    if(not Player[pServer.index].Trading)then
    begin
        result:= true;
        exit;
    end;

    SlotIndex := pServer.Slot;

    gold := pServer.Gold;
    if(gold <> Player[pServer.Index].TradeLoja.Gold[SlotIndex])then
    begin
        SendClientMsg(Index, 'Item Price changed error.');
        result:= true;
        exit;
    end;

    if(CompareMem(@Player[pServer.Index].TradeLoja.Item[SlotIndex], @pServer.Item, 8) = false)then
    begin
        SendClientMsg(Index, 'Item changed error.');
        result:= true;
        exit;
    end;

    if(Player[Index].Char.Gold < Player[pServer.Index].TradeLoja.Gold[SlotIndex])then
    begin
        SendClientMsg(Index, 'Não pussui essa quantia.');
        result:= true;
        exit;
    end;

    if((Player[pServer.Index].TradeLoja.Gold[SlotIndex] + Player[pServer.Index].Char.Gold) > 2000000000)then
    begin
        SendClientMsg(Index, 'Limite de 2.000.000.000 de gold.');
        result:= true;
        exit;
    end;

    x:= GetEmptySlot(Index);

    if(x = 254)then
    begin
        SendClientMsg(Index, 'Sem espaço no inventário.');
        result:= true;
        exit;
    end;

    move(Player[index].Char.Inventory[x], pServer.Item, 8);
    CreateItem(Index, INV_TYPE, x, pServer.Item);

    dec(Player[index].Char.Gold,gold);
    RefreshMoney(index);

    Header.Header.Size:=20;
    Header.Header.Code:=$39B;
    Header.Header.Index:=$7530;
    Header.index:=pServer.index;
    Header.slot:=pServer.Slot;
    // Apaga o item na auto-venda para todos os clients visiveis
    GridMulticast2(Trunc(Player[pServer.Index].current.current.x), Trunc(Player[pServer.Index].current.current.y), @Header, 20, 0);

    ZeroMemory(@Jogador[pServer.index].Header.StorageItens[Player[pServer.Index].TradeLoja.Slot[SlotIndex]], 8);
    CreateItem(index, STORAGE_TYPE, Player[pServer.Index].TradeLoja.Slot[SlotIndex], sItem);

    inc(Jogador[pServer.index].Header.StorageGold,Player[pServer.Index].TradeLoja.Gold[SlotIndex]);
    SendSignalParm(pServer.index, $7530, $339, Jogador[pServer.index].Header.StorageGold);

    Player[pServer.Index].TradeLoja.Gold[SlotIndex] := 0;
    Player[pServer.Index].TradeLoja.Slot[SlotIndex] := 0;
    Player[pServer.Index].TradeLoja.Item[SlotIndex].Index := 0;
    SendClientMsg(pServer.index, 'Um produto foi vendido.');
    result:= true;
end;

function Functions.OpenStoreTrade(Index: WORD; Buffer: pByte):boolean;
var p: p397; i,z: BYTE;
begin
  Move(Buffer^,p,sizeof(p397));

  if(Player[Index].Trading = true)then
  begin
    result:=true;
    exit;
  end;

  //if(index <> p.Header.Index)then
  //begin
    //result:=false;
    //exit;
  //end;

  for i := 0 to 11 do
  begin
    if(p.Trade.Gold[i] = 0)then
      continue;

    if(p.Trade.Slot[i] >= 128)then
    begin
      result:=false;
      exit;
    end;

    z:=0;
    while z < 12 do begin
      if(z <> i) and (p.Trade.Slot[i] = p.Trade.Slot[z])then
        break;
      inc(z);
    end;

    if(z <> 12)then
    begin
      result:=false;
      exit;
    end;

    if(p.Trade.Gold[i] > 999999999)then
    begin
      result:=false;
      exit;
    end;

    if(Jogador[index].Header.StorageItens[p.Trade.Slot[i]].Index > 6500)then
    begin
      result:=false;
      exit;
    end;

    if(CompareMem(@Jogador[index].Header.StorageItens[p.Trade.Slot[i]],@p.Trade.Item[i],8) = false)then
    begin
      result:=false;
      exit;
    end;

  end;

  Player[index].Trading:=true;
  Move(p.Trade,Player[index].TradeLoja,sizeof(sTradeLoja));
  SendClientPacket(@p,sizeof(p397),Index);

  GetCreateMobTrade(Index);
  GridMulticast2(Trunc(Player[index].current.current.x),Trunc(Player[index].current.current.y),@Bufferr,sizeof(p_363h),0);
  result:=true;
end;

procedure Functions.Signal(Clientid: WORD; pIndex: WORD; opCode: WORD);
var Header: sHeader;
begin
  Header.Size:=12;
  Header.Index:=pIndex;
  Header.Code:=opCode;

  SendClientPacket(@Header,12,Clientid);
end;

procedure Functions.SendSignalParm(Clientid: WORD; pIndex: WORD; opCode: WORD; dat1: integer);
var Header: sHeader2;
begin
  Header.Size:=16;
  Header.Index:=pIndex;
  Header.Code:=opCode;
  Header.data:=dat1;

  SendClientPacket(@Header,16,Clientid);
end;

function Functions.GetMaxAbility(Clientid: WORD; eff: integer; Char : PCharacter): integer;
var MaxAbility,i: integer;
ItemAbility: smallint;
begin
  MaxAbility:=0;
  for i := 0 to 15 do begin
    if(Char^.Equip[i].Index = 0)then
      continue;

    ItemAbility:=GetItemAbility(Char^.Equip[i],eff);
    if(MaxAbility < ItemAbility)then
      MaxAbility := ItemAbility;
  end;
  result:=MaxAbility;
end;

function Functions.GetItemIDEF(sItem: TItem; mnt: boolean):WORD;
var value: BYTE; colored: boolean;
begin

	if (mnt)then
	begin// montaria
		value := Trunc(sItem.EF2 / 10);
	end
	else
	begin
		if (sitem.EF1 >=  116) and (sitem.EF1 <=  125)then
		begin
			value := sitem.EFV1;
			colored := true;
		end
		else if (sitem.EF2 >=  116) and (sitem.EF2 <=  125)then
		begin
			value := sitem.EFV2;
			colored := true;
		end
		else if (sitem.EF3 >=  116) and (sitem.EF3 <=  125)then
		begin
			value := sitem.EFV3;
			colored := true;
		end
		else if (sitem.EF1 = 43)then
		begin
			value := sitem.EFV1;
		end
		else if (sitem.EF2 = 43)then
		begin
			value := sitem.EFV2;
		end
		else if (sitem.EF3 = 43)then
		begin
			value := sitem.EFV3;
		end
		else// item sem refinacao
    begin
			result:=sitem.Index;
      exit;
    end;
	end;


	if(value > 9) and not(mnt) and not(colored)then
  begin
		if (value < 234)then
			value := 10
		else if (value < 238)then
			value := 11
		else if (value < 242)then
			value := 12
		else if (value < 246)then
			value := 13
		else if (value < 250)then
			value := 14
		else if (value < 254)then
			value := 15
		else// value < 256
			value := 16;
	end
  else if(colored)then
		if(value >= 9)then value := 9;
	result:= sitem.Index or (value * $1000);
end;

procedure Functions.SendSignal(Clientid: WORD; pIndex: WORD; opCode: WORD);
var Header: sHeader;
begin
  Header.Size:=12;
  Header.Index:=pIndex;
  Header.Code:=opCode;

  SendClientPacket(@Header,12,Clientid);
end;

procedure Functions.LoadItemList();
var DataFile : TextFile;
lineFile : String;
fileStrings : TStringList;
ID,i,y:integer;
begin
  AssignFile(DataFile, 'Itemlist.csv');

  Reset(DataFile);

  fileStrings := TStringList.Create;

  while not EOF (DataFile) do
  begin
    Readln(DataFile, lineFile);
    ExtractStrings([';'],[' '],PChar(Linefile),fileStrings);
    // verifica qual id será colocado
    ID := strtoint(fileStrings.Strings[0]);
    //Adiciona na estrutura;
    ItemList[ID].Name := fileStrings.Strings[1];//nome
    ItemList[ID].Mesh := strtoint(fileStrings.Strings[2]);//Mesh
    ItemList[ID].Submesh := strtoint(fileStrings.Strings[3]);//Submesh
    ItemList[ID].Level := strtoint(fileStrings.Strings[4]);//
    ItemList[ID].STR := strtoint(fileStrings.Strings[5]);//
    ItemList[ID].INT := strtoint(fileStrings.Strings[6]);//
    ItemList[ID].DEX := strtoint(fileStrings.Strings[7]);//
    ItemList[ID].CON := strtoint(fileStrings.Strings[8]);//
    ItemList[ID].Unique := strtoint(fileStrings.Strings[9]);//
    ItemList[ID].Price := strtoint(fileStrings.Strings[10]);//
    ItemList[ID].Pos := strtoint(fileStrings.Strings[11]);//
    ItemList[ID].Extreme := strtoint(fileStrings.Strings[12]);//
    ItemList[ID].Grade := strtoint(fileStrings.Strings[13]);//
    y:= (fileStrings.Count-14) div 2;//define quantos Ef_ tem na linha
    for I := 0 to y-1 do //considera a contagem do 0, logo tem que reduzir 1 no Y
    begin
     ItemList[ID].Effect[i].index := strtoint(fileStrings[14+(i*2)]);// Loop de 2 linhas
     ItemList[ID].Effect[i].value := strtoint(fileStrings[15+(i*2)]);//
    end;
    filestrings.Clear;
  end;
  fileStrings.Free;
  Form1.ListBox4.Items.Add('ItemList carregado com sucesso!');
  CloseFile(DataFile);
end;

procedure Functions.SkillData();
var DataFile : TextFile;
lineFile : String;
fileStrings : TStringList;
ID:integer;
ProcName: string;
begin
  AssignFile(DataFile, 'Skilldata.csv');

  Reset(DataFile);

  fileStrings := TStringList.Create;

  while not EOF(DataFile) do
  begin
    Readln(DataFile, lineFile);
    ExtractStrings([','],[' '],PChar(Linefile),fileStrings);
    if(IsNumber(fileStrings.strings[0]) = false)then begin
      filestrings.Clear;
      continue;
    end;
    // verifica qual id será colocado
    ID := strtoint(fileStrings.Strings[0]);
    //Adiciona na estrutura;
    SkillsData[ID].SkillPoint    := strtoint(fileStrings.Strings[1]);
    SkillsData[ID].InstanceType  := fileStrings.Strings[6];
    SkillsData[ID].InstanceValue := fileStrings.Strings[7];
    SkillsData[ID].AffectValue   := fileStrings.Strings[11];
    SkillsData[ID].AffectValue   := fileStrings.Strings[12];
    SkillsData[ID].SkillName     := fileStrings.Strings[22];
    ProcName := StringReplace(fileStrings.Strings[22], 'ç', 'c', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'é', 'e', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ú', 'u', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'á', 'a', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'í', 'i', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ã', 'a', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ê', 'e', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, '_', '' , [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'â', 'a', [rfReplaceAll, rfIgnoreCase]);
    Skills.SkillsDict.Add(ID,ProcName);
    filestrings.Clear;
  end;
  fileStrings.Free;
  Form1.ListBox4.Items.Add('Skilldata carregado com sucesso!');
  CloseFile(DataFile);
end;

function Functions.GetEmptySlot(Index: WORD): BYTE;
var i: BYTE;
begin
  for i := 0 to 59 do
  begin
    if(Player[Index].Char.Inventory[i].Index = 0)then
    begin
      result:=i;
      exit;
    end;
  end;
  result:=254;
end;

function Functions.GetEmptyCargoSlot(Index: WORD): BYTE;
var i: BYTE;
begin
  for i := 0 to 127 do
  begin
    if(Jogador[Index].Header.StorageItens[i].Index = 0)then
    begin
      result:=i;
      exit;
    end;
  end;
  result:=254;
end;

function Functions.FindNewXYPos(x,y,id:integer): TPosition;
var i,j:integer;
begin
  for i := 1 to 10 do begin
    for j := 1 to 10 do begin
      if(MobGrid[y+i][x+j] <> 0) then
        continue
      else
      begin
        MobGrid[y+i][x+j]:=id;
        result.x:=x+j;
        result.y:=y+i;
        exit;
      end;
    end;
  end;
  result.x:=0;
  result.y:=0;
end;

procedure Functions.GetCreateMobTrade(Index: Word);
var p: p_363h;
begin
    GetCreateMob(Index);

    p364.Header.Code:=$363;
    p364.Header.Size:=sizeof(p_363h);
    p364.Header.Index:=$7530;
    p364.spawnType := $CC;
    p364.MemberType := $CC;
    Move(p364,p,132);
    Move(Player[index].TradeLoja.Name,p.StoreName[0],24);
    //Player[index].TradeLoja.Name
    p.x2 := p.X;
    p.y2 := p.Y;
    p.Clientid:= p.Index;
    p.clock:= clock;
    FillChar(p.unk[0],13,$CC);
    FillChar(p.unk3[0],8,$CC);
    FillChar(p.unk4[0],4,$CC);
    FillChar(Bufferr[0],200,$CC);
    Move(p,Bufferr[0],sizeof(p_363h));
end;

procedure Functions.LoadMobList();
var DataFile : TextFile;
lineFile : String;
pos: TPosition;
local123:string;
fileStrings : TStringList;
f2: file of sMob3;
aux: sMob3;
ID,ID2,j,i,px,py:integer;
error: boolean;
IdLeader: integer;
begin
  error:=false;
  AssignFile(DataFile, 'npc.csv');

  Reset(DataFile);

  fileStrings := TStringList.Create;
  ID:=1;
  ID2:=1001;
  j:=0;
  while not EOF (DataFile) do
  begin
    Readln(DataFile, lineFile);
    ExtractStrings([','],[' '],pChar(Linefile),fileStrings);

    if(IsNumber(fileStrings.strings[0]) = false)then begin
      filestrings.Clear;
      continue;
    end;

    //Adiciona na estrutura;
    Npcs[ID].MinuteGenerate := strtoint(fileStrings.Strings[0]);
    Npcs[ID].Leader_Name := fileStrings.Strings[1];//nome
    Npcs[ID].Follower_Name := fileStrings.Strings[2];
    Npcs[ID].Leader_Count := strtoint(fileStrings.Strings[3]);
    Npcs[ID].Follower_Count := strtoint(fileStrings.Strings[4]);//
    Npcs[ID].RouteType := strtoint(fileStrings.Strings[5]);//
    Npcs[ID].SpawnPosx := strtoint(fileStrings.Strings[6]);//
    Npcs[ID].SpawnPosY := strtoint(fileStrings.Strings[7]);//
    Npcs[ID].SpawnWait := strtoint(fileStrings.Strings[8]);//
    Npcs[ID].SpawnSay := fileStrings.Strings[9];//
    Npcs[ID].Destx := strtoint(fileStrings.Strings[10]);//
    Npcs[ID].Desty := strtoint(fileStrings.Strings[11]);//
    Npcs[ID].DestSay := fileStrings.Strings[12];//
    Npcs[ID].DestWait := strtoint(fileStrings.Strings[13]);//
    Npcs[ID].ReviveTime:=strtoint(fileStrings.Strings[14]);
    Npcs[ID].AttackDelay:=strtoint(fileStrings.Strings[15]);
    filestrings.Clear;
    local123:=diretorio+'\npc\'+Npcs[ID].Leader_Name;
    if(fileexists(local123) = false) then begin
      Showmessage('Npc: '+Npcs[ID].Leader_Name+' não encontrado.');
      error:=true;
      inc(j);
      continue;
    end;
    AssignFile(f2, local123);
    Reset(f2);
    Read(f2, aux);
    CloseFile(f2);
    for i := 1 to Npcs[ID].Leader_Count do
    begin
      Move(aux,NpcMob[ID2].NPC,sizeof(sMob3));
      NpcMob[ID2].NPC.Last.x:=Npcs[ID].SpawnPosX;
      NpcMob[ID2].NPC.Last.y:=Npcs[ID].SpawnPosY;
      NpcMob[ID2].Dead:=false;
      NpcMob[ID2].LastAttack:=time;
      if (Npcs[ID].MinuteGenerate = 0) then begin
        if(MobGrid[Npcs[ID].SpawnPosY][Npcs[ID].SpawnPosX] = 0)then
        begin
          MobGrid[Npcs[ID].SpawnPosY][Npcs[ID].SpawnPosX]:=ID2;
          NpcMob[ID2].MobLeaderId:=ID2;
          IdLeader := ID2;
        end
        else
        begin
          if(GetEmptyMobGrid(ID2,@NpcMob[ID2].NPC.Last.x,@NpcMob[ID2].NPC.Last.y) = false)then
          begin
            dec(ID2);
            continue;
          end;
          MobGrid[NpcMob[ID2].NPC.Last.y][NpcMob[ID2].NPC.Last.x]:=ID2;
          NpcMob[ID2].MobLeaderId:=ID2;
        end;
        NpcMob[ID2].GenerId:=ID;
      end
      else
      begin
        NpcMob[ID2].MobLeaderId:=ID2;
        NpcMob[ID2].GenerId:=ID;
        NpcMob[ID2].NPC.Status.HP:=0;
        NpcMob[ID2].Dead:=true;
        NpcMob[ID2].TimeKill:=ServerUPTime;
        IdLeader := ID2;
      end;
      for j := 1 to Npcs[ID].Follower_Count do
      begin
        inc(ID2);
        Move(aux,NpcMob[ID2].NPC,sizeof(sMob3));
        NpcMob[ID2].NPC.Last.x:=Npcs[ID].SpawnPosX;
        NpcMob[ID2].NPC.Last.y:=Npcs[ID].SpawnPosY;
        NpcMob[ID2].Dead:=false;
        if(Npcs[ID].MinuteGenerate = 0)then
        begin
          if(MobGrid[Npcs[ID].SpawnPosY][Npcs[ID].SpawnPosX] = 0)then
          begin
            MobGrid[Npcs[ID].SpawnPosY][Npcs[ID].SpawnPosX]:=ID2;
            NpcMob[ID2].MobLeaderId:=IdLeader;
          end
          else
          begin
            if(GetEmptyMobGrid(ID2,@NpcMob[ID2].NPC.Last.x,@NpcMob[ID2].NPC.Last.y) = false)then
            begin
              dec(ID2);
              continue;
            end;
            MobGrid[NpcMob[ID2].NPC.Last.y][NpcMob[ID2].NPC.Last.x]:=ID2;
            NpcMob[ID2].MobLeaderId:=IdLeader;
          end;
          NpcMob[ID2].GenerId:=ID;
        end
        else
        begin
          NpcMob[ID2].MobLeaderId:=IdLeader;
          NpcMob[ID2].GenerId:=ID;
          NpcMob[ID2].NPC.Status.HP:=0;
          NpcMob[ID2].Dead:=true;
          NpcMob[ID2].TimeKill:=Now;
        end;
      end;
      GetCurrentScore(ID2);
      inc(ID2);
    end;
    inc(ID);
  end;
  fileStrings.Free;
  if(error = false) then
    Form1.ListBox4.Items.Add('Moblist carregado com sucesso!')
  else
    Form1.ListBox4.Items.Add('Moblist carregado com '+inttostr(j)+' erro(s)!');
  CloseFile(DataFile);
end;

procedure Functions.LoadTeleportList();
var DataFile : TextFile;
lineFile : String;
fileStrings : TStringList;
ID:integer;
begin
  AssignFile(DataFile, 'teleports.csv');

  Reset(DataFile);

  fileStrings := TStringList.Create;
  ID:=0;

  while not EOF (DataFile) do
  begin
    Readln(DataFile, lineFile);
    ExtractStrings([','],[' '],pChar(Linefile),fileStrings);
    if(IsNumber(fileStrings.strings[0]) = false)then begin
      filestrings.Clear;
      continue;
    end;
    //Adiciona na estrutura;
    Teleportes[ID].Localx1 := strtoint(fileStrings.Strings[0]);
    Teleportes[ID].Localy1 := strtoint(fileStrings.Strings[1]);//nome
    //Teleportes[ID].Localx2 := strtoint(fileStrings.Strings[2]);
    //Teleportes[ID].Localy2 := strtoint(fileStrings.Strings[3]);
    Teleportes[ID].Destx1 := strtoint(fileStrings.Strings[2]);//
    Teleportes[ID].Desty1 := strtoint(fileStrings.Strings[3]);//
    //Teleportes[ID].Destx2 := strtoint(fileStrings.Strings[6]);//
    //Teleportes[ID].Desty2 := strtoint(fileStrings.Strings[7]);//
    Teleportes[ID].Custo := strtoint(fileStrings.Strings[4]);//
    Teleportes[ID].Hora := strtoint(fileStrings.Strings[5]);//
    filestrings.Clear;
    inc(ID);
  end;
  fileStrings.Free;
  Form1.ListBox4.Items.Add('Teleportes carregados com sucesso!');
  Form1.ListBox3.Clear;
  CloseFile(DataFile);
end;

function Functions.Teleport(x,y,clientid: WORD): boolean;
var p: p366;
begin
  if(not GetEmptyMobGrid(clientid,@x,@y))then
  begin
    result:=false;
    exit;
  end;
	p.Header.Size := sizeof(p366);
	p.Header.Code := $366;
	p.Header.Index := clientid;

	p.mType := 1;
	p.mSpeed := 2;
	p.xSrc := Trunc(Player[clientid].current.current.x);
	p.ySrc := Trunc(Player[clientid].current.current.y);
	p.xDst := x;
	p.yDst := y;

	Player[clientid].current.source.x := Player[clientid].current.current.x;
	Player[clientid].current.source.y := Player[clientid].current.current.y;
  GridMulticast2(Trunc(Player[clientid].current.source.x),Trunc(Player[clientid].current.source.y),@p,p.Header.Size, clientid);
  SendRemoveMob2(clientid,clientid,SPAWN_TELEPORT);

	Player[clientid].current.current.x := x;
	Player[clientid].current.current.y := y;

  //SendToVisible(encdec, thisclient, packet, sizeof(p366), true);
  GridMulticast2(Trunc(Player[clientid].current.Current.X),Trunc(Player[clientid].current.Current.Y),@p,p.Header.Size, clientid);
  GetCreateMob(clientid);
  SendGridMob(clientid,0);
  SendClientPacket(@p,p.Header.Size,clientid);

  //MobGrid[p.ySrc][p.xSrc]:=0;
  //MobGrid[p.yDst][p.xDst]:=clientid;
  GridMulticast(Clientid, p.xDst, p.yDst, @p, sizeof(p366));

  result:=true;
end;

function Functions.Gates(clientid: WORD): boolean;
var cX,cY,i: WORD; gold: integer; hour: TDateTime;
begin
	cX := ((Trunc(Player[clientid].current.current.x)) and $FFC);
	cY := ((Trunc(Player[clientid].current.current.y)) and $FFC);


	for i:=0 to 36 do
	begin

		if(Teleportes[i].Localx1 = cX) and (Teleportes[i].Localy1 = cY)then
		begin
			gold := Player[clientid].Char.Gold - Teleportes[i].Custo;

			if(gold >= 0)then
			begin
				if(hour = Teleportes[i].Hora) or (Teleportes[i].Hora = -1)then
				begin
					if(not Teleport(Teleportes[i].Destx1,Teleportes[i].Desty1,clientid))then
          begin
            SendClientMsg(clientid,'Não é possível teleportar.');
            break;
          end;
					Player[clientid].Char.Gold := gold;
					RefreshMoney(clientid);
				end else SendClientMsg(clientid,'Hora incorreta para uso do Teleport');
			end else SendClientMsg(clientid,'Gold Insuficiente');
      break;
		end;

	end;

	result := true;
end;

procedure Functions.SendCurrentHPMP(Index: WORD);
var  refresh: pCL_181h; nBuffer: array[0..50] of byte;
begin
	//Header
	refresh.Header.Size := sizeof(pCL_181h);
	refresh.Header.Code := $181;
	refresh.Header.Index := Index;


	refresh.hp1 := Player[Index].Char.Status.HP;
	refresh.hp2 := Player[Index].Char.Status.maxHP;
	refresh.mp1 := Player[Index].Char.Status.MP;
	refresh.mp2 := Player[Index].Char.Status.maxMP;

	SendClientPacket(@refresh,refresh.Header.Size,Index);
end;

procedure Functions.GetCreateNPC(Clientid: WORD; spawnType : BYTE = 0);
var i: BYTE; effvalue: integer; pitem: TItem;
begin
  ZeroMemory(@p364,sizeof(p_364h));
  p364.Header.Size:=sizeof(p_364h);
  p364.Header.Code:=$364;
  p364.Header.Index:=30002;

  Move(NpcMob[Clientid].NPC.Name[0],p364.Name[0],12);

  Move(NpcMob[Clientid].NPC.Status,p364.Status,sizeof(TStatus));

  p364.Index:=Clientid;

  p364.X:=NpcMob[Clientid].NPC.Last.x;
  p364.Y:=NpcMob[Clientid].NPC.Last.y;

  p364.ChaosPoint:=0;
  p364.CurrentKill:=0;
  p364.TotalKill:=0;

  p364.GuildIndex:=0;

  for i := 0 to 15 do begin
    p364.Affect[i].Time:=0;
    p364.Affect[i].Index:=0;
  end;

  for i := 0 to 15 do begin
    //effvalue:=0;
    Move(NpcMob[Clientid].NPC.Equip[i],pitem,8);
    if(i = 14) then
    begin
      if(pitem.Index >= 2360) and (pitem.Index <= 2389) then
      begin
        if(pitem.EF1 = 0) then
          pitem.Index:=0;
      end;
    end;
    //effvalue:=GetItemSanc(pitem);
    p364.ItemEff[i]:=pitem.Index;
    p364.AnctCode[i]:=GetAnctCode(pitem);
  end;

  p364.spawnType:=spawnType;
  p364.Tab:='Delphi Test Server';
  for i := 1 to 25 do
    p364.Tab[i-1]:=p364.Tab[i];
end;

function Functions.IsLetter(text: string): boolean;
var i: BYTE;
begin
  for i := 1 to 26 do
  begin
    if(AnsiCompareText(text[1],Letras[i]) = 0) then begin
      result:=false;
      exit;
    end;
  end;
  result:=true;
end;

function Functions.IsLetter2(text: array of AnsiChar): boolean;
var i: BYTE;
begin
  for i := 1 to 26 do
  begin
    if(AnsiCompareText(text[0],Letras[i]) = 0) then begin
      result:=false;
      exit;
    end;
  end;
  result:=true;
end;

procedure Functions.Log(listbox: TListBox; recsend: string; pHeader: sHeader; Clientid: WORD);
begin
  listbox.Items.Add(recsend+Format('%x',[pHeader.Code])+
    '  Size: '+inttostr(pHeader.Size)+'  Clientid: '+inttostr(Clientid));
  listBox.ItemIndex := listbox.Items.Count-1;
end;

function Functions.IsNumber(text: string): boolean;
begin
  try
    strtoint(text);
  except on EConvertError do
    begin
      result:=false;
      exit;
    end;
  end;
  result:=true;
end;

procedure Functions.SaveCharFile(Name: array of AnsiChar; AccName: string; local: string);
var
  f:textfile;
  Struct: ftext;
  i: BYTE;
begin
  //Struct.Name:=Copy(AccName,0,length(AccName));
  //Move(AccName,Struct.Name[0],15);
  //for i := 0 to length(AccName) do
    //Struct.Name[i]:=Struct.Name[i+1];
  //Struct.Name[i]
  AssignFile(f, local);
  ReWrite(f);
  Writeln(f,AccName);
  CloseFile(f);
end;

procedure Functions.DeleteChar(Clientid: integer; X: BYTE; Name: string);
var senddelete: DELETECHARR; i,j: BYTE;
begin
  senddelete.Header.Size:=756;
  senddelete.Header.Code:=$112;
  senddelete.Header.Index:=Clientid;
  ZeroMemory(@Jogador[Clientid].charInfos[x],sizeof(charInfoss));
  for i:=0 to 3 do begin
    Move(Jogador[Clientid].charInfos[i].Char.status,senddelete.SelList.Status[i],sizeof(TStatus));
    for j:=0 to 15 do
      Move(Jogador[Clientid].charInfos[i].Char.Equip[0],senddelete.SelList.Equip[i][0],(sizeof(Item)*16));
    for j:=1 to 15 do
      senddelete.SelList.Name[i][j-1]:=Jogador[Clientid].charInfos[i].Char.Name[j-1];
    senddelete.SelList.GuildIndex[i]:=Jogador[Clientid].charInfos[i].Char.GuildIndex;
    senddelete.SelList.Gold[i]:=Jogador[Clientid].charInfos[i].Char.Gold;
    senddelete.SelList.Exp[i]:=Jogador[Clientid].charInfos[i].Char.Exp;
    senddelete.SelList.PosX[i]:=2100;
    senddelete.SelList.PosY[i]:=2100;
  end;
  Move(senddelete,Buffer,756);
  SendClientPacket(@Buffer,756,Clientid);
  Form1.Listbox4.Items.Add('Conta: '+Jogador[Clientid].Header.Name+' Excluiu personagem: '+
  Name+'.');
  if(IsLetter(Name) = false) then
    deletefile(Diretorio+'\Chars\'+Name[1]+'\'+Trim(Name))
  else
    deletefile(Diretorio+'\Chars\etc\'+Trim(Name));
  SaveAcc(Jogador[Clientid],Clientid);
end;

procedure Functions.CreateChar(Clientid: integer; ClassIndex: BYTE; X: BYTE; Name: array of AnsiChar);
var NewChar: CREATCHAR; i,j: BYTE;
lastCharId : LONG64;
begin
  Move(InitChar[ClassIndex].Char, Jogador[Clientid].charInfos[x].Char,sizeof(cInfo));
  Move(InitChar[ClassIndex].Char. Equip,Jogador[Clientid].charInfos[x].Char.Equip,sizeof(InitChar[0].Char.Equip));
  Move(InitChar[ClassIndex].Char. Status,Jogador[Clientid].charInfos[x].Char.Status,sizeof(TStatus));
  Move(InitChar[ClassIndex].Char. Status,Jogador[Clientid].charInfos[x].Char.bStatus,sizeof(TStatus));
  Jogador[Clientid].charInfos[x].pkstatus:=InitChar[ClassIndex].pkstatus;
  for i:=1 to 15 do
    Jogador[Clientid].charInfos[x].Char.Name[i-1] := Name[i-1];
  Jogador[Clientid].charInfos[x].Char.Status.Merchant:=0;
  Jogador[Clientid].charInfos[x].Char.Hold:=0;
  Jogador[Clientid].charInfos[x].Char.Status.Speed:=2;
  Jogador[Clientid].charInfos[x].current.current.x:=2100;
  Jogador[Clientid].charInfos[x].current.current.y:=2100;
  NewChar.Header.Size:=756;
  NewChar.Header.Code:=$110;
  NewChar.Header.Index:=Clientid;
  for i:=1 to 15 do
    NewChar.SelList.Name[x][i-1]:=Jogador[Clientid].charInfos[x].Char.Name[i-1];
  for i:=0 to 3 do begin
    Move(Jogador[Clientid].charInfos[i].Char.Status,NewChar.SelList.Status[i],sizeof(TStatus));
    //for j:=0 to 15 do begin
     Move(Jogador[Clientid].charInfos[i].Char.Equip[0],NewChar.SelList.Equip[i][0],(sizeof(Item)*16));
    //end;
    if i <> x then begin
      for j:=1 to 15 do
        NewChar.SelList.Name[i][j-1]:=Jogador[Clientid].charInfos[i].Char.Name[j-1];
    end;
    NewChar.SelList.GuildIndex[i]:=Jogador[Clientid].charInfos[i].Char.GuildIndex;
    NewChar.SelList.Gold[i]:=Jogador[Clientid].charInfos[i].Char.Gold;
    NewChar.SelList.Exp[i]:=Jogador[Clientid].charInfos[i].Char.Exp;
    NewChar.SelList.PosX[i]:=2100;
    NewChar.SelList.PosY[i]:=2100;
  end;
  SendClientPacket(@NewChar,756,Clientid);
  Form1.Listbox4.Items.Add('Conta: '+Jogador[Clientid].Header.Name+' Criou personagem: '+
  Name+'.');
  Form1.Listbox4.ItemIndex :=Form1.Listbox4.Items.Count-1;
  if(IsLetter2(Name) = false) then
    SaveCharFile(Name,Jogador[Clientid].Header.Name,Diretorio+'\Chars\'+Name[0]+'\'+Trim(Name))
  else
    SaveCharFile(Name,Jogador[Clientid].Header.Name,Diretorio+'\Chars\etc\'+Trim(Name));
  SaveAcc(Jogador[Clientid],Clientid);

  if BlahList.Count > 0 then
    lastCharId := BlahList.Last.CharacterIndex
  else
    lastCharId := 0;
  BlahList.Add(TBlah.Create(lastCharId + 1, Jogador[Clientid].Header.Name)); // Adiciona o personagem a lista
  WriteBlah();
end;

procedure Functions.ReadBlah();
var f:textfile;
local: string;
line : string;
charId : LONG64;
fileStrings : TStringList;
begin
  fileStrings := TStringList.Create;
  local := Diretorio + '\Blah.list';
  AssignFile(f, local);
  Reset(f);
  while not EOF (f) do
  begin
    Readln(f, line);
    ExtractStrings([','],[' '], pChar(line), fileStrings);
    BlahList.Add(TBlah.Create(StrToInt64Def(fileStrings.Strings[0], 0), fileStrings.Strings[1]))
  end;
  CloseFile(f);
  fileStrings.Destroy;
end;

procedure Functions.WriteBlah();
var f:textfile;
local: string;
i : integer;
begin
  local := Diretorio + '\Blah.list';
  AssignFile(f, local);
  ReWrite(f);
  for i := 0 to BlahList.Count - 1 do
  begin
     Writeln(f, IntToStr(BlahList[i].CharacterIndex) + ',' + BlahList[i].AccountName);
  end;
  CloseFile(f);
end;

function Functions.ReadGuilds(guildId : integer; fileType : Byte) : Boolean;
var textf:textfile;
f : file of TBasicGuildInfo;
local: string;
basicInfo : TBasicGuildInfo;
line : string;
fileStrings : TStringList;
i : Integer;
list : ^TList<integer>;
begin
  Result := false;
  case fileType of
    0:
    begin
      local := Diretorio + '\Guilds\' + IntToStr(guildId) + '\BasicInfo.guild';
      if(not FileExists(local)) then
      begin
        exit;
      end;
      //GuildList.Add(guildId, TGuild.Create);
      AssignFile(f, local);
      Reset(f);
      Read(f, basicInfo);

      if(not GuildList.ContainsKey(guildId)) then
        GuildList.Add(guildId, TGuild.CreateBasic(basicInfo))
      else
        GuildList[guildId].BasicInfo := basicInfo;

      CloseFile(f);
      Result := true;
      exit;
    end;

    1:
    begin
      list := @GuildList[guildId].LeaderMembersList;
      local := Diretorio + '\Guilds\' + IntToStr(guildId) + '\LeaderMembers.guild';
    end;

    2,
    3,
    4:
    begin
      list := @GuildList[guildId].SubLeadersMemberList[fileType - 2];
      local := Diretorio + '\Guilds\' + IntToStr(guildId) + '\SubGuild' + IntToStr(fileType - 1) + '.guild';
    end;
  end;

  list^.Clear;
  if(not FileExists(local)) then
    exit;

  fileStrings := TStringList.Create;
  AssignFile(textf, local);
  Reset(textf);
  while not EOF (textf) do
  begin
    Readln(textf, line);
    ExtractStrings([','],[' '], pChar(line), fileStrings);
    for i := 0 to fileStrings.Count do
    begin
      if(not GuildList.ContainsKey(guildId)) then
        ReadGuilds(guildId, 0);

      list^.Add(StrToInt(fileStrings.Strings[i]));
    end;
  end;
  CloseFile(textf);
  fileStrings.Destroy;
  Result := true;
end;

procedure Functions.WriteGuilds(guildId : integer; fileType : Byte);
var textf:textfile;
f : file of TBasicGuildInfo;
local: string;
i : Integer;
list : TList<integer>;

begin
  if(not GuildList.ContainsKey(guildId)) then
    exit;

  case fileType of
    0:
    begin
      local := Diretorio + '\Guilds\' + IntToStr(guildId) + '\BasicInfo.guild';


      if(not DirectoryExists(Diretorio + '\\Guilds\\' + IntToStr(guildId))) then
        CreateDir(Diretorio + '\\Guilds\\' + IntToStr(guildId));

      AssignFile(f, local);
      ReWrite(f);
      Write(f, GuildList[guildId].BasicInfo);
      CloseFile(f);
      exit;
    end;

    1:
    begin
      list := GuildList[guildId].LeaderMembersList;
      local := Diretorio + '\Guilds\' + IntToStr(guildId) + '\LeaderMembers.guild';
    end;

    2,
    3,
    4:
    begin
      list := GuildList[guildId].SubLeadersMemberList[fileType - 2];
      local := Diretorio + '\Guilds\' + IntToStr(guildId) + '\SubGuild' + IntToStr(fileType - 1) + '.guild';
    end;
  end;

  if(not FileExists(local)) then
    WriteGuilds(guildId, 0);

  AssignFile(textf, local);
  Reset(textf);
  for i := 0 to list.Count do
  begin
     Write(textf, IntToStr(list[i]) + ',');
  end;
end;


function Functions.GetGuilty(Clientid: WORD): BYTE;
var guilty: BYTE;
begin
  guilty:=Player[Clientid].pkstatus;
  if(guilty > 255)then
    guilty:=255;

  result:=guilty;
end;

function Functions.GetCurKill(Clientid: WORD):BYTE;
begin
  result:=Player[Clientid].currentkill;
end;

function Functions.GetTotKill(Clientid:WORD):WORD;
begin
  result:=Player[Clientid].totkill;
end;

function Functions.GetItemSanc(sitem: TItem):smallint;
var value: integer;
begin
  value:=0;

  if(sitem.Index >= 2360) and (sitem.Index <= 2389) then
  begin
    //Montarias.
    value := Trunc((sitem.EF3 / 10));

    if(value > 9) then
        value := 9;

    result := value;
    exit;
  end;

 if(sitem.Index >= 2330) and (sitem.Index <= 2359) then
 begin
      //Crias.
      result:= 0;
      exit;
 end;

 if(sitem.EF1 = 43)then
      value := sitem.EFV1
  else if(sitem.EF2 = 43)then
      value := sitem.EFV2
  else if(sitem.EF3 = 43)then
      value := sitem.EFV3;

  if(value >= 230)then
  begin
      value := Trunc(10 + ((value - 230) / 4));
      if(value > 15)then
          value := 15;
  end
  else
      value := (value mod 10);

  result:=value;
end;

function Functions.GetAnctCode(sitem: TItem):integer;
var value: integer;
begin
  value:=0;

  if(sitem.EF1 = 43)then
      value := sitem.EFV1
  else if(sitem.EF2 = 43)then
      value := sitem.EFV2
  else if(sitem.EF3 = 43)then
      value := sitem.EFV3;

  if(value = 0)then
  begin
      result:= 0;
      exit;
  end;

	if(value < 230)then
  begin
		result:= 43;
    exit;
  end;

  case (value mod 4) of
    0:begin  result:=$30; exit; end;
    1:begin  result:=$40; exit; end;
    2:begin  result:=$10; exit; end;
    else begin result:=$20; exit; end;
  end;
end;

function Functions.GetEffectValue(itemid: integer; eff:shortint):smallint;
var i: BYTE;
begin
  for i := 0 to 11 do begin
    if(ItemList[itemid].Effect[i].Index = eff)then begin
      result:= ItemList[itemid].Effect[i].Value;
      exit;
    end;
  end;
  result:= 0;
end;

function Functions.GetMobAbility(Clientid: WORD; eff: integer; Char : PCharacter):integer;
var LOCAL_1,LOCAL_2,LOCAL_19,LOCAL_20,dam1,dam2,arm1,arm2,unique1:integer;
porc,unique2,LOCAL_28: integer;
LOCAL_18: array[0..15] of integer;
begin
  LOCAL_1:=0;
  if(eff = EF_RANGE)then
  begin
    LOCAL_1 := GetMaxAbility(Clientid, eff, Char);

    LOCAL_2 := Trunc((Char^.Equip[0].Index / 10));
    if(LOCAL_1 < 2) and (LOCAL_2 = 3)then
        if((Char^.Learn and $100000) <> 0)then
            LOCAL_1 := 2;

    result:=LOCAL_1;
    exit;
  end;

  for LOCAL_19 := 0 to 15 do
  begin
      LOCAL_18[LOCAL_19] := 0;

      LOCAL_20 := Char^.Equip[LOCAL_19].Index;
      if(LOCAL_20 = 0) and (LOCAL_19 <> 7)then
          continue;

      if(LOCAL_19 >= 1) and (LOCAL_19 <= 5)then
          LOCAL_18[LOCAL_19] := ItemList[LOCAL_20].Unique;

      if(eff = EF_DAMAGE) and (LOCAL_19 = 6)then
          continue;

      if(eff = EF_MAGIC) and (LOCAL_19 = 7)then
          continue;

      if(LOCAL_19 = 7) and (eff = EF_DAMAGE)then
      begin
        dam1 := (GetItemAbility(Char^.Equip[6], EF_DAMAGE) +
                    GetItemAbility(Char^.Equip[6], EF_DAMAGE2));
        dam2 := (GetItemAbility(Char^.Equip[7], EF_DAMAGE) +
                    GetItemAbility(Char^.Equip[7], EF_DAMAGE2));

        arm1 := Char^.Equip[6].Index;
        arm2 := Char^.Equip[7].Index;

        unique1 := 0;
        if(arm1 > 0) and (arm1 < 6500)then
            unique1 := ItemList[arm1].Unique;

        unique2 := 0;
        if(arm2 > 0) and (arm2 < 6500)then
            unique2 := ItemList[arm2].Unique;

        if(unique1 <> 0) and (unique2 <> 0)then
        begin
          porc := 0;
          if(unique1 = unique2)then
              porc := 30
          else
              porc := 20;

          if(dam1 > dam2)then
              LOCAL_1 := Trunc(((LOCAL_1 + dam1) + ((dam2 * porc) / 100)))
          else
              LOCAL_1 := Trunc(((LOCAL_1 + dam2) + ((dam1 * porc) / 100)));

          continue;
        end;

        if(dam1 > dam2)then
            inc(LOCAL_1,dam1)
        else
            inc(LOCAL_1,dam2);

        continue;
      end;

      LOCAL_28 := GetItemAbility(Char^.Equip[LOCAL_19], eff);
      if(eff = EF_ATTSPEED) and (LOCAL_28 = 1)then
          LOCAL_28 := 10;

      inc(LOCAL_1,LOCAL_28);
    end;

    if(eff = EF_AC) and (LOCAL_18[1] <> 0)then
        if(LOCAL_18[1] = LOCAL_18[2]) and (LOCAL_18[2] = LOCAL_18[3]) and
           (LOCAL_18[3] = LOCAL_18[4]) and (LOCAL_18[4] = LOCAL_18[5])then
            LOCAL_1 := Trunc(((LOCAL_1 * 105) / 100));

    result := LOCAL_1;
end;

function Functions.GetItemAbility(sitem: TItem; eff: integer): smallint;
var resultt,itemid,unique,pos,i,val,ef2,sanc,x: integer;
begin
  resultt:=0;
  itemid:=sitem.Index;

  if(itemid <= 0) or (itemid >= 6500) then
  begin
    result:=0;
    exit;
  end;

  unique:=ItemList[itemid].Unique;
  pos:=ItemList[itemid].Pos;

  if(eff = EF_DAMAGEADD) or (eff = EF_MAGICADD)then
      if(unique < 41) or (unique > 50)then begin
          result:= 0;
          exit;
      end;

  if(eff = EF_CRITICAL)then
      if(sitem.EF2 = EF_CRITICAL2) or (sitem.EF3 = EF_CRITICAL2)then
          eff := EF_CRITICAL2;

  if(eff = EF_DAMAGE) and (pos = 32)then
      if(sitem.EF2 = EF_DAMAGE2) or (sitem.EF3 = EF_DAMAGE2)then
          eff := EF_DAMAGE2;

  if(eff = EF_MPADD)then
      if(sitem.EF2 = EF_MPADD2) or (sitem.EF3 = EF_MPADD2)then
          eff := EF_MPADD2;

  if(eff = EF_ACADD)then
      if(sitem.EF2 = EF_ACADD2) or (sitem.EF3 = EF_ACADD2)then
          eff := EF_ACADD2;

  if(eff = EF_LEVEL) and (itemID >= 2330) and (itemID < 2360) then
      resultt := (sitem.EF2 - 1)
  else if(eff = EF_LEVEL)then
      inc(resultt,ItemList[itemID].Level);

  if(eff = EF_REQ_STR)then
      inc(resultt,ItemList[itemID].Str);
  if(eff = EF_REQ_INT)then
      inc(resultt,ItemList[itemID].Int);
  if(eff = EF_REQ_DEX)then
      inc(resultt,ItemList[itemID].Dex);
  if(eff = EF_REQ_CON)then
      inc(resultt,ItemList[itemID].Con);

  if(eff = EF_POS)then
      inc(resultt,ItemList[itemID].Pos);

  if(eff <> EF_INCUBATE)then
  begin
      for i := 0 to 11 do begin
          if(ItemList[itemID].Effect[i].Index <> eff)then
              continue;

          val := ItemList[itemID].Effect[i].Value;
          if(eff = EF_ATTSPEED) and (val = 1)then
              val := 10;

          inc(resultt,val);
          break;
      end;
  end;

    if(sitem.Index >= 2330) and (sitem.Index < 2390)then
    begin
      if(eff = EF_MOUNTHP)then begin
          result:=sitem.EF1;
          exit;
      end;

      if(eff = EF_MOUNTSANC)then begin
          result:=sitem.EF2;
          exit;
      end;

      if(eff = EF_MOUNTLIFE)then begin
          result:=sitem.EFV2;
          exit;
      end;

      if(eff = EF_MOUNTFEED)then begin
          result:=sitem.EF3;
          exit;
      end;

      if(eff = EF_MOUNTKILL)then begin
          result:=sitem.EFV3;
          exit;
      end;

      if(sitem.Index >= 2362) and (sitem.Index < 2390) and (sitem.EF1 > 0)then
      begin
          ef2 := sitem.EF2;

          if(eff = EF_DAMAGE)then begin
              result:=Trunc(((GetEffectValue(sitem.Index, EF_DAMAGE) * (ef2 + 20)) / 100));
          end;exit;
          end;

          if(eff = EF_MAGIC)then begin
              result:=Trunc(((GetEffectValue(sitem.Index, EF_MAGIC) * (ef2 + 15)) / 100));
              exit;
          end;

          if(eff = EF_PARRY)then begin
              result:=GetEffectValue(sitem.Index, EF_PARRY);
              exit;
          end;

          if(eff = EF_RUNSPEED)then begin
              result:=GetEffectValue(sitem.Index, EF_RUNSPEED);
              exit;
          end;

          if(eff = EF_RESIST1) or (eff = EF_RESIST2) or
             (eff = EF_RESIST3) or (eff = EF_RESIST4) then begin
              result:=GetEffectValue(sitem.Index, EF_RESISTALL);
              exit;
          end;

      result:=resultt;
      exit;
    end;

    if(sitem.EF1 = eff)then begin

      val := sitem.EFV1;
      if(eff = EF_ATTSPEED) and  (val = 1)then
          val := 10;

      inc(resultt,val);
    end
    else
    begin
       if(sitem.EF2 = eff)then begin

        val := sitem.EFV2;
        if(eff = EF_ATTSPEED) and  (val = 1)then
            val := 10;

        inc(resultt,val);
      end
      else
      begin
         if(sitem.EF3 = eff)then begin

          val := sitem.EFV3;
          if(eff = EF_ATTSPEED) and  (val = 1)then
              val := 10;

          inc(resultt,val);
        end;
      end;
    end;

    if(eff = EF_RESIST1) or (eff = EF_RESIST2) or
       (eff = EF_RESIST3) or (eff = EF_RESIST4) then
    begin
      for i := 0 to 11 do begin
        if(ItemList[itemID].Effect[i].Index <> EF_RESISTALL)then
            continue;

        inc(resultt,ItemList[itemID].Effect[i].Value);
        break;
      end;

      if(sitem.EF1 = EF_RESISTALL)then
        inc(resultt,sitem.EFV1)
      else
      if(sitem.EF2 = EF_RESISTALL)then
        inc(resultt,sitem.EFV2)
      else
      if(sitem.EF3 = EF_RESISTALL)then
        inc(resultt,sitem.EFV3);
    end;

    sanc := GetItemSanc(sitem);
    if(sitem.Index <= 40)then
        sanc := 0;

    if(sanc >= 9) and ((pos and $F00) <> 0) then
        inc(sanc,1);

    if(sanc <> 0) and (eff <> EF_GRID) and (eff <> EF_CLASS) and
       (eff <> EF_POS) and (eff <> EF_WTYPE) and (eff <> EF_RANGE) and
       (eff <> EF_LEVEL) and (eff <> EF_REQ_STR) and (eff <> EF_REQ_INT) and
       (eff <> EF_REQ_DEX) and (eff <> EF_REQ_CON) and (eff <> EF_VOLATILE) and
       (eff <> EF_INCUBATE) and (eff <> EF_INCUDELAY)then
    begin
        if(sanc <= 10)then
            resultt := Trunc((((sanc + 10) * result) / 10))
        else
        begin
          val := Power[sanc - 11];
          resultt := Trunc(((((result * 10) * val) / 100) / 10));
        end;
    end;

    if(eff = EF_RUNSPEED)then
    begin
        if(resultt >= 3)then
            resultt := 2;

        if(resultt > 0) and (sanc >= 9)then
            inc(resultt,1);
    end;

    if(eff = EF_HWORDGUILD) or (eff = EF_LWORDGUILD)then
    begin
        x := resultt;
        resultt := x;
    end;

    if(eff = EF_GRID)then
        if(resultt < 0) or (resultt > 7)then
            resultt := 0;

    result:=resultt;
end;

function Functions.clock():Cardinal;
begin
  result := GetTickCount() - TimeTick;
end;

function Functions.GetCurrentHP(Clientid: WORD; Char : PCharacter): integer;
var hp_inc,hp_perc: integer;
begin
    hp_inc := GetMobAbility(Clientid, EF_HP, Char);
    hp_perc := GetMobAbility(Clientid, EF_HPADD, Char);

    inc(hp_inc,InitChar[Char^.ClassInfo].Char.bStatus.MaxHP);
    inc(hp_inc,(HPIncrementPerLevel[Char^.ClassInfo] * Char^.bStatus.Level));
    inc(hp_inc,(Char^.Status.CON shl 1));
    inc(hp_inc,Trunc(((hp_inc * hp_perc) / 100)));

    if(hp_inc > 64000)then //32
        hp_inc := 64000 //32
    else if(hp_inc <= 0)then
        hp_inc := 1;

    result:=hp_inc;
end;

function Functions.GetCurrentMP(Clientid: WORD; Char : PCharacter): integer;
var mp_inc,mp_perc: integer;
begin
    mp_inc := GetMobAbility(Clientid, EF_MP, Char);
    mp_perc := GetMobAbility(Clientid, EF_MPADD, Char);

    inc(mp_inc,InitChar[Char^.ClassInfo].Char.bStatus.MaxMP);
    inc(mp_inc,(HPIncrementPerLevel[Char^.ClassInfo] * Char^.bStatus.Level));
    inc(mp_inc,(Char^.Status.INT shl 1));
    inc(mp_inc,Trunc(((mp_inc * mp_perc) / 100)));

    if(mp_inc > 64000)then //32
        mp_inc := 64000 //32
    else if(mp_inc <= 0)then
        mp_inc := 1;

    result:=mp_inc;
end;

procedure Functions.GetCurrentScore(Clientid: WORD);
var special: array[0..3] of integer;
special_all,resist,magic,chaos,mov,atk_inc,def_inc,i,critical,body: integer;  Char : PCharacter;
begin
  if(Clientid <= 1000) then
  begin
    //Move(Player[Clientid].Char, Char,sizeof(TStatus));
    Char := @Player[Clientid].Char;
    Player[Clientid].AttackSpeed:=GetMobAbility(Clientid,EF_ATTSPEED, Char)+100+(Char.bStatus.Dex div 5);
    Player[Clientid].Evasion:=GetMobAbility(Clientid,EF_PARRY, Char) div 10;
  end
  else
  begin
    //Move(NpcMob[Clientid].NPC, Char,sizeof(TStatus));
    Char := @NpcMob[Clientid].NPC;
    NpcMob[Clientid].AttackSpeed:=GetMobAbility(Clientid,EF_ATTSPEED, Char)+100+(Char.bStatus.Dex div 5);
    NpcMob[Clientid].Evasion:=GetMobAbility(Clientid,EF_PARRY, Char) div 10;
  end;


  special[0] := Char^.bStatus.wMaster;
  special[1] := Char^.bStatus.fMaster;
  special[2] := Char^.bStatus.sMaster;
  special[3] := Char^.bStatus.tMaster;
  special_all := GetMobAbility(Clientid, EF_SPECIALALL, Char);
  inc(special[0],GetMobAbility(Clientid, EF_SPECIAL1, Char));
  inc(special[1],(GetMobAbility(Clientid, EF_SPECIAL2, Char) + special_all));
  inc(special[2],(GetMobAbility(Clientid, EF_SPECIAL3, Char) + special_all));
  inc(special[3],(GetMobAbility(Clientid, EF_SPECIAL4, Char) + special_all));

  for i := 0 to 3 do
      if(special[i] > 255)then
          special[i] := 255;

  Char^.Status.wMaster := special[0];
  Char^.Status.fMaster := special[1];
  Char^.Status.sMaster := special[2];
  Char^.Status.tMaster := special[3];

  //resist := 0;
  //if(GetItemSanc(Equip[1]) >= 9)then
      //resist := 30;

  Char^.Resist[0] := GetMobAbility(Clientid, EF_RESIST1, Char) + resist;
  Char^.Resist[1] := GetMobAbility(Clientid, EF_RESIST2, Char) + resist;
  Char^.Resist[2] := GetMobAbility(Clientid, EF_RESIST3, Char) + resist;
  Char^.Resist[3] := GetMobAbility(Clientid, EF_RESIST4, Char) + resist;

  if(Char^.Resist[0] > 100)then
      Char^.Resist[0] := 100;

  if(Char^.Resist[1] > 100)then
      Char^.Resist[1] := 100;

  if(Char^.Resist[2] > 100)then
      Char^.Resist[2] := 100;

  if(Char^.Resist[3] > 100)then
      Char^.Resist[3] := 100;

  magic := (GetMobAbility(Clientid, EF_MAGIC, Char) shr 1); //>>
  if(magic > 255)then
      magic := 255;

  Char^.MagicIncrement := magic;

  critical := Trunc(((GetMobAbility(Clientid, EF_CRITICAL, Char) / 10) * 5));
  if(critical > 255)then
      critical := 255;

  Char^.Critical := critical;

  Char^.RegenHP := GetMobAbility(Clientid, EF_REGENHP, Char);
  Char^.RegenMP := GetMobAbility(Clientid, EF_REGENMP, Char);
  Char^.SaveMana := GetMobAbility(Clientid, EF_SAVEMANA, Char);

  Char^.Status.STR := Char^.bStatus.STR;
  Char^.Status.INT := Char^.bStatus.INT;
  Char^.Status.DEX := Char^.bStatus.DEX;
  Char^.Status.CON := Char^.bStatus.CON;
  inc(Char^.Status.STR,GetMobAbility(Clientid, EF_STR, Char));
  inc(Char^.Status.INT,GetMobAbility(Clientid, EF_INT, Char));
  inc(Char^.Status.DEX,GetMobAbility(Clientid, EF_DEX, Char));
  inc(Char^.Status.CON,GetMobAbility(Clientid, EF_CON, Char));

  Char^.Status.Speed := Char^.bStatus.Speed;
  Char^.Status.Level := Char^.bStatus.Level;
  Char^.Status.Merchant := Char^.bStatus.Merchant;

  chaos := Char^.Inventory[63].EF1;
  //Char^.bStatus.Move.ChaosRate = chaos / 10;
  //Char^.Status.Move.ChaosRate = chaos / 10;

  mov := GetMaxAbility(Clientid, EF_RUNSPEED, Char);
  Char^.Status.Speed := mov + 3;
  if (Char^.Status.Speed > 6) then
    Char^.Status.Speed := 6;


  Char^.Status.maxHP := GetCurrentHP(Clientid, Char);
  Char^.Status.maxMP := GetCurrentMP(Clientid, Char);

  if(Char^.Status.maxHP < Char^.Status.HP)then
      Char^.Status.HP := Char^.Status.maxHP;

  if(Char^.Status.maxMP < Char^.Status.MP)then
      Char^.Status.MP := Char^.Status.maxMP;

  atk_inc := Char^.bStatus.Attack;
  inc(atk_inc,GetMobAbility(Clientid, EF_DAMAGE, Char));
  inc(atk_inc,GetMobAbility(Clientid, EF_DAMAGEADD, Char));
  inc(atk_inc,Trunc(((Char^.Status.STR / 5) * 2)));
  inc(atk_inc,Char^.Status.wMaster);
  inc(atk_inc,Char^.Status.Level);
  Char^.Status.Attack := atk_inc;

  def_inc := Char^.bStatus.Defence;
  inc(def_inc,GetMobAbility(Clientid, EF_AC, Char));
  inc(def_inc,GetMobAbility(Clientid, EF_ACADD, Char));
  inc(def_inc,Trunc((Char^.Status.Level * 2)));
  Char^.Status.Defence := def_inc;

  body := Char^.Equip[0].Index;
  Char^.ClassInfo := Trunc(body / 10);

  // Not Implemented
  Char^.CapeInfo := 0;
  Char^.GuildIndex := 0;
  Char^.SkillProp := 0;
  Char^.GuildMemberType := 0;
end;

procedure Functions.GetCreateMob(Clientid: WORD);
var i: BYTE; effvalue: integer; pitem: TItem;
begin

  ZeroMemory(@p364,sizeof(p_364h));
  p364.Header.Size:=sizeof(p_364h);
  p364.Header.Code:=$364;
  p364.Header.Index:=30002;

  Move(Player[Clientid].Char.Name,p364.Name[0],12);
  Move(Player[Clientid].Char.Status,p364.Status,sizeof(TStatus));

  p364.Index:=Clientid;

  p364.X:=Trunc(Player[Clientid].current.current.x);
  p364.Y:=Trunc(Player[Clientid].current.current.y);

  p364.ChaosPoint:=75;//GetGuilty(Clientid);
  p364.CurrentKill:=0;//GetCurKill(Clientid);
  p364.TotalKill:=0;//GetTotKill(Clientid);

  p364.GuildIndex:=Player[Clientid].Char.GuildIndex;

  for i := 0 to 15 do begin
    p364.Affect[i].Time:=(Player[Clientid].Char.affects[i].Time) shr 3;
    p364.Affect[i].Index:=Player[Clientid].Char.affects[i].Index;
  end;

  for i := 0 to 15 do begin
    //effvalue:=0;
    pitem:=Player[Clientid].Char.Equip[i];
    if(i = 14) then
    begin
      if(pitem.Index >= 2360) and (pitem.Index <= 2389) then
      begin
        if(pitem.EF1 = 0) then
          pitem.Index:=0;
      end;
    end;
    //effvalue:=GetItemSanc(pitem);
    p364.ItemEff[i]:=pitem.Index;
    p364.AnctCode[i]:=GetAnctCode(pitem);
  end;

  p364.spawnType:=0;
  p364.Tab:='Delphi Test Server';
  for i := 1 to 25 do
    p364.Tab[i-1]:=p364.Tab[i];
end;

procedure Functions.SendToWorld(CharId: BYTE; Clientid: WORD; Socket: TCustomWinSocket);
var sWorld: TOWORLD; i: BYTE;
f:file of TOWORLD;
//movement: p366;
begin
  ZeroMemory(@Player[Clientid], sizeof(ActiveChar));
  Move(Jogador[Clientid].charInfos[CharId],Player[Clientid],sizeof(charInfoss));
  STATUS[vn]:=PLAYING;
  Player[Clientid].Charid:=CharId;
  Player[Clientid].Dead:=false;
  Player[Clientid].Char.ClientIndex := Clientid;
  GetCurrentScore(Clientid);
  ZeroMemory(@sWorld,sizeof(TOWORLD));
  sWorld.Header.Size:= sizeof(TOWORLD);
  sWorld.Header.Code:=$114;
  sWorld.Header.Index:=30002;
  sWorld.Character.Evasion:=0;
  sworld.Character.Merchant:=player[clientid].Char.bStatus.Merchant;
 //sworld.Character.
  if(Jogador[Clientid].charInfos[CharId].Char.Status.Level < 35) then
  begin
    sWorld.Point.x:=2112;
    sWorld.Point.y:=2041;
    Player[Clientid].current.cityID := 0;
    GetEmptyMobGrid(clientid,@sWorld.Point.x,@sWorld.Point.y);
    Player[Clientid].current.current.x:=sWorld.Point.x;
    Player[Clientid].current.current.y:=sWorld.Point.y;
  end
  else
  begin
    if(GetStartXY(clientid)= false)then
    begin
      SendClientMsg(clientid,'Falta espaço no mapa.');
      exit;
    end;
    sWorld.Point.x:=Trunc(Player[Clientid].current.current.x);
    sWorld.Point.y:=Trunc(Player[Clientid].current.current.y);
  end;
  sWorld.Character.Last.x:=sWorld.Point.x;
  sWorld.Character.Last.y:=sWorld.Point.y;
  sWorld.Character.Hold:=Jogador[Clientid].charInfos[CharId].Char.Hold;
  sWorld.Character.CapeInfo:=Player[Clientid].Char.CapeInfo;
  MobGrid[sWorld.Point.y][sWorld.Point.x]:=Clientid;
  ZeroMemory(@sWorld.Character.Name[0],12);
  Move(Jogador[Clientid].charInfos[CharId].Char.Name,sWorld.Character.Name[0],12);
  sWorld.Character.QuestInfo:=0;
  sWorld.Character.Merchant:=0;
  sWorld.Character.GuildIndex:=Jogador[Clientid].charInfos[CharId].Char.GuildIndex;
  sWorld.Character.ClassInfo:=Jogador[Clientid].charInfos[CharId].Char.ClassInfo;
  sWorld.Character.SkillProp:=0;//Jogador[Clientid].charInfos[CharId].pkstatus;//pkstatus
  sWorld.Character.Gold:=Jogador[Clientid].charInfos[CharId].Char.Gold;
  sWorld.Character.Exp:=Jogador[Clientid].charInfos[CharId].Char.Exp;
  Move(Player[Clientid].Char.Status,sWorld.Character.Status,sizeof(TStatus));
  Move(Player[Clientid].Char.bStatus,sWorld.Character.bStatus,sizeof(TStatus));
  sWorld.Character.pSkill:=Jogador[Clientid].charInfos[CharId].Char.pSkill;
  sWorld.Character.pStatus:=Jogador[Clientid].charInfos[CharId].Char.pStatus;
  sWorld.Character.Learn:=Jogador[Clientid].charInfos[CharId].Char.Learn;
  sWorld.Character.pMaster:=Jogador[Clientid].charInfos[CharId].Char.pMaster;
  sWorld.Character.Critical:=Trunc((Player[Clientid].Char.Critical/10)*5);
  sWorld.Character.SaveMana:=Player[Clientid].Char.SaveMana;
  Move(Jogador[Clientid].charInfos[CharId].Char.Equip[0],sWorld.Character.Equip[0],(sizeof(Item)*16));
  Move(Jogador[Clientid].charInfos[CharId].Char.Inventory[0],sWorld.Character.Inventory[0],(sizeof(Item)*64));
  for i:=0 to 15 do begin
    sWorld.Character.affects[i].Index:=Jogador[Clientid].charInfos[CharId].Char.affects[i].Index;
    sWorld.Character.affects[i].Master:=Jogador[Clientid].charInfos[CharId].Char.affects[i].Master;
    sWorld.Character.affects[i].Value:=Jogador[Clientid].charInfos[CharId].Char.affects[i].Value;
    sWorld.Character.affects[i].Time:=Jogador[Clientid].charInfos[CharId].Char.affects[i].Time;
  end;
  for i := 0 to 3 do
    sWorld.Character.SkillBar1[i]:=-1;
  for i := 0 to 15 do
    sWorld.Character.SkillBar2[i]:=-1;
  sWorld.Character.ClientIndex:=Clientid;
  sWorld.Character.SlotIndex:=CharId;
  sWorld.Character.unk1:=0;
  sWorld.Character.MagicIncrement:=Player[Clientid].Char.MagicIncrement;
  sWorld.Character.RegenHP:=Player[Clientid].Char.RegenHP;
  sWorld.Character.RegenMP:=Player[Clientid].Char.RegenHP;
  sWorld.Character.Resist[0]:=Player[Clientid].Char.Resist[0];
  sWorld.Character.Resist[1]:=Player[Clientid].Char.Resist[1];
  sWorld.Character.Resist[2]:=Player[Clientid].Char.Resist[2];
  sWorld.Character.Resist[3]:=Player[Clientid].Char.Resist[3];
  sWorld.Character.Tab:='';
  //EncDec.Encrypt(@sWorld, 1244);
  Socket.SendBuf(BufferDest, 1244);
  Skills.SendAffects(Clientid);
  SendScore(Clientid);
  SendWeather(Clientid, Player[Clientid].current.cityID);
  GetCreateMob(Clientid);
  p364.spawnType:=2;
  //EncDec.Encrypt(@p364, sizeof(p_364h));
  Socket.SendBuf(BufferDest, sizeof(p_364h));
  SendGridMob(Clientid,2);
  if(Player[clientid].Char.Equip[14].index>= 2330) and (Player[clientid].Char.Equip[14].index <= 2359)then
    GenerateBabyMob(clientid, Player[clientid].Char.Equip[14].index - 2330 + 8,0);
  STATUS[vn]:=PLAYING;
  SendSignal(clientid, 0, $3A0);
end;


function Functions.GetClientIdByHandle(handlef: TIdTCPConnection): integer;
var i:WORD;
begin
  for i := 1 to MAXCONNECTIONS do
  begin

    if(Server.Connections[i] = handlef) then
    begin
      result:=i;
      exit;
    end;

  end;
  result:=0;
end;


function Functions.ServerIdByeHandle(handlef: integer): integer;
var i:WORD;
begin
  for i := 0 to MAXCONNECTIONS-1 do
  begin
    if(Form1.ServerSocket1.Socket.Connections[i].SocketHandle = handlef) then
    begin
      result:=i;
      exit;
    end;
  end;
  result:=0;
end;


function Functions.FreeClientId(): integer;
var i:WORD;
begin
  for i := 0 to MAXCONNECTIONS-1 do
  begin
    if(Server.Connections[i] = nil) then
    begin
      result:=i;
      exit;
    end
  end;
end;

function Functions.GetUserByAccName(Name: string): integer;
var i:WORD;
begin
  Name := Trim(Name);
  for i := 1 to MAXCONNECTIONS do
  begin
    if(Jogador[i].Header.Name = Name) then
    begin
      result:=i;
      exit;
    end
  end;
  result:= -1;
end;

procedure Functions.DeleteClientId(Id: integer);
begin
  if(Server.Connections.ContainsKey(Id)) then
  begin
    Server.Connections.Remove(Id);
    // TODO - Fechar a conexão?
  end;
  //SHandle[id] := 0;
end;

function Functions.ConexoesIP(IP: string):integer;
var j,i:WORD;
begin
  j := 0;
  for i := 1 to MAXCONNECTIONS do
  begin
    if(IPs[i] = IP) then
    begin
      inc(j,1);
    end;
  end;
  result:=j;
end;

function Functions.FindAcc(Name: string): boolean;
begin
  if(IsLetter(Name) = false) then begin
    if(fileexists(Diretorio+'\ACCS\'+Name[1]+'\'+Trim(Name)+'.acc') = true) then
      result := true
    else
      result := false;
  end
  else
  begin
    if(fileexists(Diretorio+'\ACCS\etc\'+Trim(Name)+'.acc') = true) then
      result := true
    else
      result := false;
  end;
end;

function Functions.FindChar(Name: string): boolean;
begin
  if(IsLetter(Name) = false) then begin
    if(fileexists(Diretorio+'\Chars\'+Name[1]+'\'+Trim(Name)) = true) then
      result := true
    else
      result := false;
  end
  else
  begin
    if(fileexists(Diretorio+'\Chars\etc\'+Trim(Name)) = true) then
      result := true
    else
      result := false;
  end;
end;

function Functions.LoadAcc(Name: string): TAccountFile;
var f:file of TAccountFile;
local: string;
Acc: TAccountFile;
begin
  if(IsLetter(Name) = false) then
    local:=Diretorio+'\ACCS\'+Name[1]+'\'+Trim(Name)+'.acc'
  else
    local:=Diretorio+'\ACCS\etc\'+Trim(Name)+'.acc';
  ZeroMemory(@Acc,sizeof(TAccountFile));
  AssignFile(f, local);
  Reset(f);
  Read(f, Acc);
  CloseFile(f);
  result:=Acc;
end;

procedure Functions.SendAutoTrade(sendIndexID, tradeIndexID: integer);
var p: p397;
begin
  if(Player[tradeIndexID].Trading=false)then
      exit;

  p.Header.Size := sizeof(p397);
  p.Header.Code := $397;
  p.Header.Index := tradeIndexID;

  Move(Player[tradeIndexID].TradeLoja,p.Trade,sizeof(sTradeLoja));

  SendClientPacket(@p, p.Header.Size, sendIndexID);
end;

function Functions.OpenTrade(Index: WORD; pak: pByte): boolean;
var p: p39A;
begin
    move(pak^,p,sizeof(p39A));
    if(Player[p.Index].Trading = false)then
    begin
      result:= true;
      exit;
    end;

    SendAutoTrade(Index, p.Index);
    result:=true;
end;

function Functions.LoadAndCompareCharOwner(Name: string; AccName: string): boolean;
var f: textfile;
local: string;
into: string;
begin
  if(IsLetter(Name) = false) then
    local:=Diretorio+'\Chars\'+Name[1]+'\'+Trim(Name)
  else
    local:=Diretorio+'\Chars\etc\'+Trim(Name);
  AssignFile(f, local);
  Reset(f);
  Readln(f, into);
  CloseFile(f);
  if(AnsiCompareStr(Trim(into),Trim(AccName)) <> 0) then
    result:=false
  else
    result:=true;
end;

procedure Functions.SendToCharList(Clientid: WORD; Player: TAccountFile);
var SendACC: SELCHARLIST; i,j,a: BYTE;
begin
  SendACC.Header.Size:=1824;
  SendACC.Header.Code:=$10E;
  SendACC.Header.Index:=30002;
  for i := 0 to 3 do begin
    Move(Player.charInfos[i].Char.Name,SendACC.SelList.Name[i][0],15);
    Move(Player.charInfos[i].Char.bStatus,SendACC.SelList.Status[i],sizeof(TStatus));
    Move(Player.charInfos[i].Char.Equip[0],SendACC.SelList.Equip[i][0],(sizeof(Item)*16));
    SendACC.SelList.Gold[i]:=Player.charInfos[i].Char.Gold;
    SendACC.SelList.Exp[i]:=Player.charInfos[i].Char.Exp;
    SendACC.SelList.GuildIndex[i]:=Player.charInfos[i].Char.GuildIndex;
    SendACC.SelList.PosX[i]:=Trunc(Player.charInfos[i].current.current.x);
    SendACC.SelList.PosY[i]:=Trunc(Player.charInfos[i].current.current.y);
  end;
  SendACC.Gold:=Jogador[clientid].Header.StorageGold;
  Move(Jogador[clientid].Header.StorageItens[0],SendACC.Storage[0],8*128);
  SendACC.Name:=Jogador[clientid].Header.Name;
  SendAcc.Keys:=Jogador[clientid].Header.Pwd;
  SendClientPacket(@SendACC,1824,Clientid);
end;

procedure Functions.Disconnect(Clientid: WORD);
begin
  CountTime[Clientid] := 0;
  IPs[Clientid] := ' ';
  if(Status[Clientid] >= SENHA2)then begin
    Form1.Listbox2.Items.Add('Player Acc: '+Jogador[Clientid].Header.Name+' Clientid: '+inttostr(Clientid)+' se desconectou.');
    Form1.ListBox2.ItemIndex:=Form1.ListBox2.Count-1;
  end;
  if (Jogador[Clientid].Header.isAct) and (Status[Clientid] > 0) then
  begin
    if (Status[Clientid] = PLAYING) then begin
      SendRemoveMob2(Clientid,Clientid,DELETE_DISCONNECT);
      Move(Player[Clientid].Char.Status,Player[Clientid].Char.Status,sizeof(TStatus));
      //retirar do grupo


      //fechar o trade
      MobGrid[Trunc(Player[clientid].current.Current.Y)][Trunc(Player[clientid].current.Current.X)] := 0;
    end;
    Jogador[Clientid].Header.isAct := false;
    SaveAcc(Jogador[Clientid],Clientid);
  end;
  Status[Clientid]:=0;
  //SHandle[Clientid] := 0;
  Server.DisconnectClient(ClientId);
  Server.Connections.Remove(ClientId);
  ZeroMemory(@Jogador[Clientid],sizeof(TAccountFile));
end;

procedure Functions.DisconnectALL();
var i:WORD;
begin
  for i := 1 to MAXCONNECTIONS do
  begin
    CountTime[i] := 0;
    IPs[i] := ' ';
    if (Jogador[i].Header.isAct) and (Status[i] > 0) then
    begin
      Jogador[i].Header.isAct:=false;
      SaveAcc(Jogador[i],i);
    end;
    Status[i]:=0;
    Server.DisconnectClient(i);
    ZeroMemory(@Jogador[i],sizeof(TAccountFile));
  end;
  Server.Connections.Clear;
  Form1.Listbox2.Items.Add('Todos os players foram desconectados.');
  Form1.ListBox2.ItemIndex:=Form1.ListBox2.Count-1;
  Server.CloseServer;
end;

procedure Functions.SendSocketPacket(Buffer: array of Byte; Size:WORD; Socket: TCustomWinSocket);
begin
  //EncDec.Encrypt(@Buffer, Size);
  Socket.SendBuf(BufferDest, Size);
end;

procedure Functions.SendClientPacket(BufferAux: pByte; Size:WORD; Clientid: WORD);
var Header: sHeader;
buffer : TBytes;
begin
  Move(BufferAux^,Bufferr[0],Size);
  Move(Bufferr, Header, 12);
  if(Header.Code <> $181)then
    Log(Form1.ListBox1,'Send Packet: ', Header, Clientid);
  //EncDec.Encrypt(@Bufferr, Size);

  if((Server.Connections.ContainsKey(clientId)) AND  (Server.Connections[clientId]  <> nil)) then
  begin
    SetLength(buffer, Length(BufferDest));
    Move(BufferDest[0], buffer[0], Length(buffer));

    //Server.Connections[clientId].Socket.Write(buffer, Size);
  end;
end;

procedure Functions.SaveAcc(Acc: TAccountFile; index: WORD);
var
  f:file of TAccountFile;
  local: string;
begin
  if(IsLetter(Acc.Header.Name) = false) then
    local:=Diretorio+'\ACCS\'+Acc.Header.Name[1]+'\'+Trim(Acc.Header.Name)+'.acc'
  else
    local:=Diretorio+'\ACCS\etc\'+Trim(Acc.Header.Name)+'.acc';
  if(Status[index] = PLAYING)then begin
    Move(Player[index].Char.Status,Player[index].Char.Status,sizeof(TStatus));
    Move(Player[index],Acc.charInfos[Player[index].Charid],sizeof(charInfoss));
  end;
  AssignFile(f, local);
  ReWrite(f);
  Write(f,Acc);
  CloseFile(f);
end;

procedure Functions.CreateGuildFile(struct: ArqGuild);
var f: file of ArqGuild;
local: string;
begin
  local:=Diretorio+'\guilds\'+inttostr(struct.guildId)+'.guild';
  AssignFile(f, local);
  ReWrite(f);
  Write(f,struct);
  CloseFile(f);
end;

procedure Functions.SendSocketMsg(Socket: TCustomWinSocket; Msg: string);
var p: p101;
begin
  p.Header.Size := 108;
  p.Header.Code := $101;
  p.Header.Index := 0;
  //p.msg:=Msg;
  ZeroMemory(@p.msg,sizeof(p.msg));
  Move(Msg,p.msg[0],length(Msg));
  p.msg[0]:=' ';
  Move(p, Buffer, 108);
  //EncDec.Encrypt(@Buffer, 108);
  Socket.SendBuf(BufferDest, 108);
end;

procedure Functions.SendClientMsg(Clientid: integer; Msg: string);
var p: p101; i: BYTE;
begin
  p.Header.Size := 108;
  p.Header.Code := $101;
  p.Header.Index := 0;
  Msg:=Trim(Msg);
  p.msg:=Msg;
  for i := 0 to length(Msg) do
    p.msg[i]:=p.msg[i+1];
  for i := length(Msg) to 95 do
    p.msg[i]:=#0;
  Move(p, Buffer, 108);
  SendClientPacket(@Buffer, 108, Clientid);
end;

procedure Functions.GetAction(Index: integer; posX:Smallint; posY: smallint; p: p_p366);
begin
	  p^.Header.Size := sizeof(p366);
    p^.Header.Code := $366;
    p^.Header.Index := Index;
    if(index < 1000)then begin
      p^.xSrc := Trunc(Player[index].current.Current.X);
      p^.ySrc := Trunc(Player[index].current.Current.Y);
      p^.mSpeed := Player[index].Char.Status.Speed;
    end
    else
    begin
      p^.xSrc := NpcMob[index].NPC.Last.x;
      p^.ySrc := NpcMob[index].NPC.Last.y;
      p^.mSpeed := 4;
    end;

    p^.xDst := posX;
    p^.yDst := posY;

    p^.mCommand[0] := #0;
    p^.mType := 0;

    MobGrid[p^.ySrc][p^.xSrc]:=0;
    MobGrid[p^.yDst][p^.xDst]:=index;
end;

function Functions.Distance(posX1, posY1: smallint; posX2, posY2: psmallint): Double;
var posX, posY: integer;
begin
    posX := posX2^ - posX1;
    posY := posY2^ - posY1;

    posX := posX * posX;
    posY := posY * posY;

    result:= sqrt(posX + posY);
end;

procedure Functions.GridMulticast(Index: integer; posX:smallint; posY:smallint; buf2: pBYTE; size: WORD);
var VisX,VisY,dVisX,dVisY,minPosX,minPosY,dminPosX,dminPosY,maxPosX,maxPosY: integer;
dmaxPosX,dmaxPosY,nY,nX,mobID,initID: integer;
begin

    if(Index <= 0) or (Index >= 8192)then
        exit;

    MobGrid[Trunc(Player[Index].current.Current.Y)][Trunc(Player[Index].current.Current.X)] := 0;
    MobGrid[posY][posX] := Index;


    VisX := 23; VisY := 23;
    minPosX := Trunc((Player[Index].current.Current.X - 11));
    minPosY := Trunc((Player[Index].current.Current.Y - 11));

	if((minPosX + VisX) >= 4096)then
		VisX := (VisX - (VisX + minPosX - 4096));

	if((minPosY + VisY) >= 4096)then
		VisY := (VisY - (VisY + minPosY - 4096));

  if(minPosX < 0)then
	begin
		minPosX := 0;
		VisX := (VisX + minPosX);
	end;

	if(minPosY < 0)then
	begin
		minPosY := 0;
		VisY := (VisY + minPosY);
	end;

  maxPosX := (minPosX + VisX);
  maxPosY := (minPosY + VisY);

  dVisX := 23; dVisY := 23;
  dminPosX := (posX - 11);
  dminPosY := (posY - 11);

	if((dminPosX + dVisX) >= 4096)then
		dVisX := (dVisX - (dVisX + dminPosX - 4096));

	if((dminPosY + dVisY) >= 4096)then
		dVisY := (dVisY - (dVisY + dminPosY - 4096));

  if(dminPosX < 0)then
	begin
		dminPosX := 0;
		dVisX := (dVisX + dminPosX);
	end;

	if(dminPosY < 0)then
	begin
		dminPosY := 0;
		dVisY := (dVisY + dminPosY);
	end;

  dmaxPosX := (dminPosX + dVisX);
  dmaxPosY := (dminPosY + dVisY);

  for nY := minPosY to maxPosY do
  begin
        for nX := minPosX to maxPosX do
        begin
            mobID := MobGrid[nY][nX];
            if(mobID <= 0) or (Index = mobID)then
                continue;

            if(size <> 0) and (mobID < 1000)then
            begin
                Move(buf2^,bufferr[0],Size);
                SendClientPacket(@Bufferr, size,mobID);
            end;

            if(nX < dminPosX) or (nX >= dmaxPosX) or
			   (nY < dminPosY) or (nY >= dmaxPosY)then
            begin
                if(mobID < 1000)then
					        SendSignalParm(mobID, Index, $165, 0);

				        if(Index < 1000)then
					        SendSignalParm(Index, mobID, $165, 0);
            end;
        end;
    end;

    for nY := dminPosY to dmaxPosY do
    begin
        for nX := dminPosX to dmaxPosX do
        begin
            initID := ItemGrid[nY][nX];
            mobID := MobGrid[nY][nX];
            if(mobid <> 0)then

            if(nX < minPosX) or (nX >= maxPosX) or
			   (nY < minPosY) or (nY >= maxPosY)then
            begin
                if(mobID > 0) and (Index <> mobID)then
                begin
                    if(mobID < 1000)then
                        SendCreateMob(mobID, Index,0)
                    else
                    if(mobID > 1000)then
                    begin
                      if(NpcMob[mobID].NPC.Status.HP > 0)then
                      begin
                        GetCreateNPC(mobID);
                        //Move(p364,BufferRecv,sizeof(p_364h));
                        SendClientPacket(@p364,sizeof(p_364h),Index);
                      end;
                    end;

                    if(Index < 1000) and (mobID < 1000) then
                        SendCreateMob(Index, mobID,0);

                    if(size <> 0) and (mobID < 1000)then
                    begin
                        Move(buf2^,bufferr[0],Size);
                        SendClientPacket(@bufferr, size,mobID);
                    end;
                end;

                if(initID > 0)then
                begin
                    if(Index < 1000)then
                    begin
                        //GetCreateItem(initID, pak);
                        //phSocket.write_socket(Index, pak, paklen);
                    end;
                end;
            end;
        end;
    end;

    Player[Index].Current.Current.X := posX;
    Player[Index].Current.Current.Y := posY;
end;

function Functions.PlayerAction(Index:integer; BufferAux: pBYTE): boolean;
var dstX,i,dstY: integer;
posX,posY: Smallint;
p: p366;
begin
    Move(BufferAux^,Bufferr[0],sizeof(p366));
    Move(Bufferr[0],p,sizeof(p366));
    //CheckPacket(pServer, pCL_366h);

    //if (Trim(p.mCommand) <> '') then
    //  ShowMessage(p.mCommand);

    dstX := p.xDst;
    dstY := p.yDst;

    if(dstX >= 4096) or (dstY >= 4096)then
    begin
      result:=false;
      exit;
    end;

    posX := dstX;
    posY := dstY;

    if(Player[Index].current.Current.X = posX) and (Player[Index].current.Current.Y = posY)then
    begin
      result:=true;
      exit;
    end;

    {for i := 0 to MAX_GUILD_ZONE; i++)
    {
        sGuildZone &zone = Server.GuildZone[i];

        if(posX >= zone.area_guild_min_x && posX <= zone.area_guild_max_x &&
           posY >= zone.area_guild_min_y && posY <= zone.area_guild_max_y)
        begin
            if(zone.owner_index == 0)
                continue;

            if(zone.owner_index != spw.Character.GuildIndex)
            begin
                Server.GetGuildZone(Index, &posX, &posY);
                TeleportTo(Index, posX, posY);

                SendClientMessage(Index, "Esta área pertence a outra guilda.");
                return true;
            end;
          end;
        end;

    if(GetEmptyMobGrid(index,@posX,@posY) =false)then
    begin
		    //Log(WARN, "MobAction: Sem nenhum espaço livre para movimento. Cliente #%03d", Index);

        GetAction(Index, posX, posY,@p);
        GridMulticast(Index, posX, posY, @p, sizeof(p366));
        SendClientPacket(@p, sizeof(p366),Index);
        result:=true;
        exit;
    end;

    GetAction(Index, posX, posY,@p);
    GridMulticast(Index, posX, posY, @p, sizeof(p366));

    if(posX <> dstX) or (posY <> dstY)then
        SendClientPacket(@p, sizeof(p366),Index);

    if(Player[index].MobBaby <> 0)then
    begin
      if(GetEmptyMobGrid(Player[index].MobBaby, @posX, @posY) = false)then
      begin
        exit;
      end;
      GetAction(Player[index].Mobbaby, posX, posY,@p);
      GridMulticast2(posX, posY, @p, sizeof(p366), 0);
      NpcMob[Player[index].Mobbaby].NPC.Last.x:=posX;
      NpcMob[Player[index].Mobbaby].NPC.Last.y:=posY;
    end;

    result:=true;
end;

procedure Functions.GridMulticast2(posX: smallint; posY: smallint; sendPak2: pBYTE; size: WORD; Index: WORD);
var mobID,nY,nX,Visx,VisY,minPosX,minPosY,maxPosX,maxPosY: integer;
code: smallint;
sendpak: array[0..32000] of byte;
begin
  //setlength(sendpak,size);
  Move(sendpak2^,sendpak[0],Size);
  VisX := 23; VisY := 23;
  minPosX := (posX - 11);
  minPosY := (posY - 11);

	if((minPosX + VisX) >= 4096)then
		VisX := (VisX - (VisX + minPosX - 4096));

	if((minPosY + VisY) >= 4096)then
		VisY := (VisY - (VisY + minPosY - 4096));

    if(minPosX < 0)then
	  begin
		  minPosX := 0;
		  VisX := (VisX + minPosX);
	  end;

	if(minPosY < 0)then
	begin
		minPosY := 0;
		VisY := (VisY + minPosY);
	end;

    maxPosX := (minPosX + VisX);
    maxPosY := (minPosY + VisY);

    for nY := minPosY to maxPosY do
    begin
        for nX := minPosX to maxPosX do
        begin
            mobID := MobGrid[nY][nX];
            if(mobID <= 0) or (Index = mobID)then
                continue;

            if(size = 0) or (mobID >= 1000)then
				        continue;

            Move(sendPak[4],code,sizeof(smallint));
            if(code = $338)then
                ZeroMemory(@sendPak[16],4);

			    SendClientPacket(@sendPak, size, mobID);
        end;
    end;
end;

function Functions.SendClientSay(Index: WORD; pak: pBYTE): boolean;
var pServer2: pCL_333h;
begin
    Move(pak^,Bufferr[0],sizeof(pCL_333h));
    Move(Bufferr[0],pServer2,sizeof(pCL_333h));

    pServer2.spawnMessage[95] := #0;

    if(AnsiCompareStr(Trim(pServer2.spawnMessage),'guild') = 0)then
    begin
        SendClientMsg(Index, 'Ainda não implementado.');
        result := true;
        exit;
    end;

    SendChat(Index, pServer2.spawnMessage);
    result:=true;
end;

procedure Functions.SendChat(Index: WORD; str: string);
var pMessage: pCL_333h; i:BYTE;
begin
    pMessage.Header.Size := sizeof(pCL_333h);
    pMessage.Header.Code := $333;
    pMessage.Header.Index := Index;
    //for i:=0 to 95 do
      //pMessage.spawnMessage[i]:=str[i+1];
    Move(str,pMessage.spawnMessage[0],95);
    Move(pMessage,Buffer,pMessage.Header.Size);

    GridMulticast2(Trunc(Player[Index].current.Current.X),Trunc(Player[Index].current.Current.Y),@BufferDest,pMessage.Header.Size, Index);
end;

procedure Functions.CreateItem(Index: WORD; invType: smallint; invSlot:smallint; pitem: TItem);
var sitem: pCL_182h;
begin
    sItem.Header.Size := sizeof(pCL_182h);
    sItem.Header.Code := $182;
    sItem.Header.Index := Index;

    sItem.invType := invType;
    sItem.invSlot := invSlot;

    if(@pitem = NIL)then
        fillchar(sItem.itemData, 0, sizeof(Item))
    else
        Move(pitem,sItem.itemData,sizeof(item));

    Move(sItem,Buffer,sItem.Header.Size);
    SendClientPacket(@Buffer, sItem.Header.Size,Index);
end;

procedure Functions.SendScore(index: WORD);
var pServer2: pCL_336h; i: BYTE;
begin
    if(index <= 0) or (index >= 8192)then
        exit;


    pServer2.Header.Size := sizeof(pCL_336h);
    pServer2.Header.Code := $336;
    pServer2.Header.Index := index;

    if(index < 1000)then
    begin
        pServer2.cur_hp := Player[index].Char.Status.HP;
        pServer2.cur_mp := Player[index].Char.Status.MP;
    end;

    pServer2.critical := Trunc((Player[index].Char.Critical/10)*5);
    pServer2.savemana := Player[index].Char.SaveMana;
    pServer2.guildindex := Player[index].Char.GuildIndex;
    pServer2.guildmember := Player[index].Char.GuildMemberType;
    pServer2.resist1 := Player[index].Char.Resist[0];
    pServer2.resist2 := Player[index].Char.Resist[1];
    pServer2.resist3 := Player[index].Char.Resist[2];
    pServer2.resist4 := Player[index].Char.Resist[3];
    Move(Player[index].Char.Status,pServer2.score,sizeof(TStatus));

    for i:=0 to 15 do begin
      pServer2.Affects[i].Time:=Player[index].Char.affects[i].Time;
      pServer2.Affects[i].Index:=Player[index].Char.affects[i].Index;
    end;
    Move(pServer2,Buffer,pServer2.Header.Size);
    GridMulticast2(Trunc(Player[Index].current.Current.X),Trunc(Player[Index].current.Current.Y),@Buffer,pServer2.Header.Size, 0);
end;

procedure Functions.SendRemoveMob(Index: WORD; pakClient: WORD; delType: integer);
var pRemMob: sHeader2;
begin
    pRemMob.Size := sizeof(sHeader2);
    pRemMob.Code := $165;
    pRemMob.Index := pakClient;

    pRemMob.data := delType;
    if(index < 1000)then
      GridMulticast2(Trunc(Player[Index].current.Current.X),Trunc(Player[Index].current.Current.Y),@pRemMob,pRemMob.Size, 0)
    else
      GridMulticast2(Trunc(NpcMob[Index].NPC.Last.x),Trunc(NpcMob[Index].NPC.Last.y),@pRemMob,pRemMob.Size, 0);
end;

procedure Functions.SendRemoveMob2(Index: WORD; pakClient: WORD; delType: integer);
var pRemMob: sHeader2;
begin
    pRemMob.Size := sizeof(sHeader2);
    pRemMob.Code := $165;
    pRemMob.Index := pakClient;

    pRemMob.data := delType;
    if(index < 1000)then
      GridMulticast2(Trunc(Player[Index].current.Current.X),Trunc(Player[Index].current.Current.Y),@pRemMob,pRemMob.Size, index)
    else
      GridMulticast2(Trunc(NpcMob[Index].NPC.Last.x),Trunc(NpcMob[Index].NPC.Last.y),@pRemMob,pRemMob.Size, index);
end;

procedure Functions.SendEtc(index: WORD);
var pServer2: p337;
begin
	if(index <= 0) or (index >= 1000)then
        exit;

	//Header
	pServer2.Header.Size := sizeof(p337);
	pServer2.Header.Index := index;
	pServer2.Header.Code := $337;

	//Body
	pServer2.hold := Player[index].Char.Hold;
	pServer2.exp := Player[index].Char.Exp;
	pServer2.learn := Player[index].Char.Learn;
  pServer2.Gold:= Player[index].Char.Gold;
	pServer2.Status_Point := Player[index].Char.pStatus;
	pServer2.Master_Point := Player[index].Char.pMaster;
	pServer2.Skills_Point := Player[index].Char.pSkill;

	pServer2.MagicIncrement := Player[index].Char.MagicIncrement;

  Move(pServer2,Buffer,pServer2.Header.Size);
	SendClientPacket(@Buffer,pServer2.Header.Size,index);

end;

procedure Functions.SendEquipItems(Index: WORD; noSendPakClientID: WORD);
var pItem: p36B; x: BYTE; sItem: TItem;
begin

    pItem.Header.Size := sizeof(p36B);
    pItem.Header.Code := $36B;
    pItem.Header.Index := Index;

    for x := 0 to 15 do
    begin
        Move(Player[index].Char.Equip[x],sItem,8);

        if(x = 14)then
            if(sItem.Index >= 2360) and (sItem.Index <= 2389)then
                if(sItem.EF1 = 0)then
                    sItem.Index := 0;
        if(x = 14)then
        pItem.itemIDEF[x] := GetItemIDEF(sItem,true)
        else
        pItem.itemIDEF[x] := GetItemIDEF(sItem,false);

        pItem.pAnctCode[x] := GetAnctCode(sItem);
    end;
    Move(pItem,Buffer,pItem.Header.Size);
    GridMulticast2(Trunc(Player[Index].current.Current.X),Trunc(Player[Index].current.Current.Y),@Buffer,pItem.Header.Size, noSendPakClientID);
end;

function Functions.GetItemPointer(index: WORD; typee: integer; slot: integer): TItem;
begin
	if(index <= 0) or (index >= 8192)then
	begin
		result.Index:=65000;
    exit;
	end;

	case typee of
	EQUIP_TYPE:
  begin
        if(slot = 0)then
        begin
            result.Index:=65000;
            exit;
        end;

		if(slot >= 16)then
    begin
      result.Index:=65000;
      exit;
    end;

		result := Player[index].Char.Equip[slot];
    exit;
  end;
	INV_TYPE:
  begin
		if(slot >= 64)then
    begin
      result.Index:=65000;
      exit;
    end;

        result:= Player[index].Char.Inventory[slot];
        exit;
    end;
	  STORAGE_TYPE:
    begin
		if(slot >= 128) or (index >= 1000)then
		begin
			result.Index:=65000;
      exit;
    end;

        result:= Jogador[index].Header.StorageItens[slot];
        exit;
    end;
	  else
    begin
      result.Index:=65000;
    end;
  end;
end;

function Functions.CanEquip(pItem: TItem; pScore: TStatus; pSlot: integer; pClass:integer; pEquip: array of TItem): boolean;
var ItemRLevel,ItemRSTR,ItemRINT,ItemRDEX,ItemRCON,ItemWType,ItemClass,ItemUnique,ItemPos,SrcItemID,SrcUnique,SrcPos: smallint;
SrcSlot,porcDim,divItemWType: integer;
begin
    if(pItem.Index <= 0) or (pItem.Index >= 6500)then
    begin // Verifica se o id do item eh valido
        result:= false;
        exit;
    end;

    if(pSlot = 15)then
    begin // Verifica se o client esta tentando trocar a capa
        result :=false;
        exit;
    end;

    ItemUnique := ItemList[pItem.Index].Unique;
    if(pSlot <> -1)then
    begin // Verifica o slot do item
        ItemPos := GetItemAbility(pItem, EF_POS);
        if(((ItemPos shr pSlot) and 1) = 0)then
        begin
            result:= false; // Verifica se pode mover o item para este slot
            exit;
        end;

        if(pSlot = 6) or (pSlot = 7)then
        begin // Slot das armas/escudos
            if(pSlot = 6)then
                SrcSlot := 7
            else // pSlot = 7
                SrcSlot := 6;

            SrcItemID := pEquip[SrcSlot].Index;
            if(SrcItemID > 0) and (SrcItemID < 6500)then
            begin // Verifica o id da outra arma
                SrcUnique := ItemList[SrcItemID].Unique;
                SrcPos := GetItemAbility(pEquip[SrcSlot], EF_POS);

                if(ItemPos = 64) or (SrcPos = 64)then
                begin // Verifica se a arma usada eh de 2 maos

                    if(ItemUnique = 46)then
                    begin // Armas de arremeco
                        if(SrcPos <> 128)then
                        begin // A segunda arma esta a mao do escudo
                            result:= false;
                            exit;
                        end;
                    end
                    else if(SrcUnique = 46)then
                    begin // Armas de arremeco
                        if(ItemPos <> 128)then
                        begin // A segunda arma esta a mao do escudo
                            result:= false;
                            exit;
                        end;
                    end
                    else // Outros tipos de armas
                    begin
                        result:= false;
                        exit;
                    end;
            end;
        end;
      end;
    end;
    ItemClass := GetItemAbility(pItem, EF_CLASS);
    if(((ItemClass shr pClass) and 1) = 0)then
    begin
        result:= false; // Classe incompativel
        exit;
    end;

    // Dados do requerimento
    ItemRLevel := GetItemAbility(pItem, EF_LEVEL);
    ItemRSTR := GetItemAbility(pItem, EF_REQ_STR);
    ItemRINT := GetItemAbility(pItem, EF_REQ_INT);
    ItemRDEX := GetItemAbility(pItem, EF_REQ_DEX);
    ItemRCON := GetItemAbility(pItem, EF_REQ_CON);
    ItemWType := GetItemAbility(pItem, EF_WTYPE);

    ItemWType := ItemWType mod 10;
    divItemWType := Trunc((ItemWType / 10));

    if(pSlot = 7) and (ItemWType <> 0)then
    begin
        porcDim := 100;
        if(divItemWType = 0) and (ItemWType > 1)then
            porcDim := 130
        else if(divItemWType = 6) and (ItemWType > 1)then
            porcDim := 150;

        ItemRLevel := Trunc(((ItemRLevel * porcDim) / 100));
        ItemRSTR := Trunc(((ItemRSTR * porcDim) / 100));
        ItemRINT := Trunc(((ItemRINT * porcDim) / 100));
        ItemRDEX := Trunc(((ItemRDEX * porcDim) / 100));
        ItemRCON := Trunc(((ItemRCON * porcDim) / 100));
    end;

    // Verificacao dos atributos do personagem
    if(ItemRSTR <= pScore.STR)and
       (ItemRINT <= pScore.INT) and
       (ItemRDEX <= pScore.DEX) and
       (ItemRCON <= pScore.CON) and
       (ItemRLevel <= pScore.Level)then
        begin
        result:= true;
        exit;
        end;

    result:= false;
end;

function Functions.MoveItem(Index: WORD; pak: pBYTE):boolean;
var p:p376; itemID,mountid,pos: WORD; i: BYTE;
  aux: TItem;
begin
  result:=true;
  Move(pak^,p,sizeof(p376));


	case (p.destType) of
		Inv_Type:
    begin
			case(p.srcType)of
        Inv_Type:
          begin
          if(Player[index].Char.Inventory[p.destslot].Index <> 0) then begin
            Move(Player[index].Char.Inventory[p.destslot],aux,sizeof(Item));
            Move(Player[index].Char.Inventory[p.srcSlot],Player[index].Char.Inventory[p.destslot],sizeof(Item));
            Move(aux,Player[index].Char.Inventory[p.srcSlot],sizeof(Item));
          end
          else
          begin
            Move(Player[index].Char.Inventory[p.srcSlot],Player[index].Char.Inventory[p.destslot],sizeof(Item));
            Move(aux,Player[index].Char.Inventory[p.srcSlot],sizeof(Item));
					  ZeroMemory(@Player[index].Char.Inventory[p.srcSlot],sizeof(Item));
          end;
					SendClientPacket(@p,p.Header.Size,index);
					result:=true;
          exit;
          end;
				Equip_Type:
          begin
          if(Player[index].Char.Inventory[p.destSlot].Index <> 0)then
            exit;
					Move(Player[index].Char.Equip[p.srcslot],Player[index].Char.Inventory[p.destSlot],sizeof(Item));
					ZeroMemory(@Player[index].Char.Equip[p.srcslot],sizeof(Item));
					SendClientPacket(@p,p.Header.Size,index);

          //armas
					if(p.srcSlot = 6) and (Player[index].Char.Equip[7].Index <> 0)then
					begin
						itemID := Player[index].Char.Equip[7].Index;
						pos := GetEffectValue(itemID,EF_POS);

						if(pos = 192)then
						begin
							p.srcSlot := 7;
							p.srcType := Equip_Type;
							p.destSlot := 6;
							p.destType := Equip_Type;
							Move(Player[index].Char.Equip[7],Player[index].Char.Inventory[6],sizeof(Item));
							ZeroMemory(@Player[index].Char.Equip[7],sizeof(Item));
							SendClientPacket(@p,p.Header.Size,index);
            end;

					end;

          if(p.srcSlot = 14)then//montaria
          begin
            if(Player[index].mobbaby<>0)then
              UngenerateBabyMob(Player[index].mobbaby, DELETE_UNSPAWN);
          end;

					SendEquipItems(index,index);
					GetCurrentScore(index);
					SendScore(index);
					SendEtc(index);
          SaveAcc(Jogador[index],index);
					result:=true;
          exit;
        end;
			  Cargo_Type:
        begin
          if(Player[index].Char.Inventory[p.destSlot].Index = 0)then
          begin
            Move(Jogador[index].Header.StorageItens[p.srcSlot],Player[index].Char.Inventory[p.destSlot],8);
            ZeroMemory(@Jogador[index].Header.StorageItens[p.srcSlot],8);
            //CreateItem(Index,CARGO_TYPE,p,Jogador[index].Header.StorageItens[p.destSlot]);
            SaveAcc(Jogador[index],index);
          end
          else
          begin
            Move(Player[index].Char.Inventory[p.destSlot],aux,8);
            Move(Jogador[index].Header.StorageItens[p.srcSlot],Player[index].Char.Inventory[p.destSlot],8);
            Move(aux,Jogador[index].Header.StorageItens[p.srcSlot],8);
            //CreateItem(Index,CARGO_TYPE,pos,Jogador[index].Header.StorageItens[p.destSlot]);
            SaveAcc(Jogador[index],index);
          end;
          SendClientPacket(@p,p.Header.Size,index);
          result:= true;
          exit;
        end;
        else
        begin
          SendClientMsg(index, 'Ocorreu um erro');
          result:= false;
          exit;
        end;
			end;
			result:= true;
      exit;
    end;

		Equip_Type:
    begin
			case(p.srcType)of
				Inv_Type:
        begin
        if(CanEquip(Player[index].Char.Inventory[p.srcSlot],Player[index].Char.Status,p.destSlot,Player[index].Char.ClassInfo,Player[index].Char.Equip)=true)then
        begin
          if(p.destSlot = 14)then//montaria
          begin
            if(Player[index].mobbaby<>0)then
              UngenerateBabyMob(Player[index].mobbaby, DELETE_UNSPAWN);
          end;
          if(Player[index].Char.Equip[p.destSlot].Index = 0)then begin
            Move(Player[index].Char.Inventory[p.srcSlot],Player[index].Char.Equip[p.destSlot],8);
            ZeroMemory(@Player[index].Char.Inventory[p.srcSlot],8);
            SendClientPacket(@p,p.Header.Size,index);
            SendEquipItems(index,index);
            GetCurrentScore(index);
            SendScore(index);
            SendEtc(index);
          end
          else
          begin
            if(p.destSlot = 14)then//montaria
            begin
              if(Player[index].mobbaby<>0)then
                UngenerateBabyMob(Player[index].mobbaby, DELETE_UNSPAWN);
            end;
            Move(Player[index].Char.Equip[p.destSlot],aux,8);
            Move(Player[index].Char.Inventory[p.srcSlot],Player[index].Char.Equip[p.destSlot],8);
            Move(aux,Player[index].Char.Inventory[p.srcSlot],8);
            SendClientPacket(@p,p.Header.Size,index);
            SendEquipItems(index,index);
            GetCurrentScore(index);
            SendScore(index);
            SendEtc(index);
          end;
        end;
        if(p.destSlot = 14)then//montaria
        begin
          if(Player[index].Char.Equip[14].Index >= 2330) and (Player[index].Char.Equip[14].Index <= 2359)then
          begin
            mountid:=Player[index].Char.Equip[14].Index - 2330 + 8;
            GenerateBabyMob(Index, mountid,0);
          end;
        end;
        result:= true;
        exit;
        end;

        Cargo_Type:
          begin
            if(CanEquip(Jogador[index].Header.StorageItens[p.srcSlot],Player[index].Char.Status,p.destSlot,Player[index].Char.ClassInfo,Player[index].Char.Equip)=true)then
            begin
              if(Jogador[index].Header.StorageItens[p.srcSlot].Index = 0)then begin
                Move(Jogador[index].Header.StorageItens[p.srcSlot],Player[index].Char.Equip[p.destSlot],8);
                ZeroMemory(@Jogador[index].Header.StorageItens[p.srcSlot],8);
                SendClientPacket(@p,p.Header.Size,index);
                SendEquipItems(index,index);
                GetCurrentScore(index);
                SendScore(index);
                SendEtc(index);
              end
              else
              begin
                Move(Player[index].Char.Equip[p.destSlot],aux,8);
                Move(Jogador[index].Header.StorageItens[p.srcSlot],Player[index].Char.Equip[p.destSlot],8);
                Move(aux,Jogador[index].Header.StorageItens[p.srcSlot],8);
                SendClientPacket(@p,p.Header.Size,index);
                SendEquipItems(index,index);
                GetCurrentScore(index);
                SendScore(index);
                SendEtc(index);
              end;
            end;
					  result:=true;
            exit;
          end;

        else
        begin
          SendClientMsg(index, 'Ocorreu um erro');
          result:= false;
          exit;
        end;
			end;
			result:= true;
      exit;
    end;

		//destino = banco :/
    Cargo_Type:
    begin
			case(p.srcType)of
				Inv_Type:
          begin
            if(Jogador[index].Header.StorageItens[p.destSlot].Index = 0)then
            begin
              Move(Player[index].Char.Inventory[p.srcSlot],Jogador[index].Header.StorageItens[p.destSlot],8);
              ZeroMemory(@Player[index].Char.Inventory[p.srcSlot],8);
              SaveAcc(Jogador[index],index);
            end
            else
            begin
              Move(Player[index].Char.Inventory[p.srcSlot],aux,8);
              Move(Jogador[index].Header.StorageItens[p.destSlot],Player[index].Char.Inventory[p.srcSlot],8);
              Move(aux,Jogador[index].Header.StorageItens[p.destSlot],8);
              SaveAcc(Jogador[index],index);
            end;
            SendClientPacket(@p,p.Header.Size,index);
					  result:= true;
            exit;
          end;
				Equip_Type:
					begin
            if(Jogador[index].Header.StorageItens[p.destSlot].Index = 0)then begin
              Move(Player[index].Char.Equip[p.srcSlot],Jogador[index].Header.StorageItens[p.destSlot],8);
              ZeroMemory(@Player[index].Char.Equip[p.srcSlot],8);
              SendClientPacket(@p,p.Header.Size,index);
              SendEquipItems(index,index);
              GetCurrentScore(index);
              SendScore(index);
              SendEtc(index);
            end
            else
            begin
              if(CanEquip(Jogador[index].Header.StorageItens[p.destSlot],Player[index].Char.Status,p.srcSlot,Player[index].Char.ClassInfo,Player[index].Char.Equip)=true)then
              begin
                Move(Player[index].Char.Equip[p.srcSlot],aux,8);
                Move(Jogador[index].Header.StorageItens[p.destSlot],Player[index].Char.Equip[p.srcSlot],8);
                Move(aux,Jogador[index].Header.StorageItens[p.destSlot],8);
                SendClientPacket(@p,p.Header.Size,index);
                SendEquipItems(index,index);
                GetCurrentScore(index);
                SendScore(index);
                SendEtc(index);
              end;
            end;
					  result:= true;
            exit;
          end;
				Cargo_Type:
					begin
            if(Jogador[index].Header.StorageItens[p.destSlot].Index = 0)then
            begin
              Move(Jogador[index].Header.StorageItens[p.srcSlot],Jogador[index].Header.StorageItens[p.destSlot],8);
              ZeroMemory(@Jogador[index].Header.StorageItens[p.srcSlot],8);
              SaveAcc(Jogador[index],index);
            end
            else
            begin
              Move(Jogador[index].Header.StorageItens[p.srcSlot],aux,8);
              Move(Jogador[index].Header.StorageItens[p.destSlot],Jogador[index].Header.StorageItens[p.srcSlot],8);
              Move(aux,Jogador[index].Header.StorageItens[p.srcSlot],8);
              SaveAcc(Jogador[index],index);
            end;
            SendClientPacket(@p,p.Header.Size,index);
					  result:= true;
            exit;
          end;
        else
        begin
          SendClientMsg(index, 'Ocorreu um erro');
          result:= false;
          exit;
        end;
			end;
    end;
    else
    begin
			SendClientMsg(index, 'Ocorreu um erro');
			result:= false;
      exit;
	  end;
  end;
end;
//SendClientSignalParm(p->Header.ClientId, 0x7530, 0x3a7, 2);
function Functions.ReadHeightMap():boolean;
var f: file of HeightMap;
local: string;
begin

  local:='HeightMap.dat';


  AssignFile(f, local);
  Reset(f);
  Read(f, pHeightGrid);
  CloseFile(f);

  Form1.ListBox4.Items.Add('HeightMap carregado com sucesso!');

  result:=true;
end;

function Functions.GetEmptyMobGrid(index: WORD; posX, posY: pWORD): boolean;
var nY, nX: integer; i: BYTE;
begin
    if( posX^ < 0) or (posX^ >= 4096) or (posY^ < 0) or ( posY^ >= 4096)then
    begin
        //Log("GetEmptyMobGrid: Posição fora do limite permitido %d,%d.", *posX, *posY);
        result:=false;
        exit;
    end;

    if(MobGrid[posY^][posX^] = Index)then
    begin
        result:=true;
        exit;
    end;

    if(MobGrid[posY^][posX^] = 0)then
        if(pHeightGrid.p[posY^][posX^]<> 127)then
        begin
            result:= true;
            exit;
        end;


    for I := 1 to 6 do
    begin
      for nY := posY^ - i to  posY^ + i do
      begin
          for nX := posX^ - i to posX^ + i do
          begin
              if (nX < 0) or (nY < 0) or (nX >= 4096) or (nY >= 4096)then
                  continue;

              if(MobGrid[nY][nX] = 0)then
              begin
                  if(pHeightGrid.p[nY][nX] <> 127)then
                  begin
                      posX^ := nX;
                      posY^ := nY;
                      result:= true;
                      exit;
                  end;
              end;
          end;
      end;
    end;

    result:= false;
end;

procedure Functions.Movement(spw: psMob2; index, newPosX, newPosY: smallint);
var delay,j,tmp,speed: integer; posX, posY: smallint; dist: Double;
p: p366;
begin
    posX := spw^.NPC.Last.x;
    posY := spw^.NPC.Last.y;

    for j := 0 to 2 do
    begin
        tmp := posX;

        if(posX > newPosX)then  dec(posX)
        else if(posX < newPosX)then  inc(posX);

        if(pHeightGrid.p[posY][posX] = 127)then
            posX := tmp;

        tmp := posY;

        if(posY > newPosY)then  dec(posY)
        else if(posY < newPosY)then inc(posY);

        if(pHeightGrid.p[posY][posX] = 127)then
            posY := tmp;
    end;

    if(GetEmptyMobGrid(Index, @posX, @posY) = false)then
    begin
        //LogFile("MobAction: Nenhum espaço livre no mapa %d,%d.", posX, posY);
        exit;
    end;

    if(spw^.NPC.Last.x = posX) and (spw^.NPC.Last.y = posY)then
    begin
        //spw.nextAction = NO_MORE_ACTION;
        exit;
    end;

    dist := Distance(spw^.NPC.Last.x, spw^.NPC.Last.y,@posX, @posY);

    speed := spw^.NPC.bStatus.Speed * 190;
    delay := Trunc(2300 + (dist * (1000 - speed)));

    spw^.nextAction := GetTickCount() + delay;

    GetAction(Index, posX, posY, @p);
    GridMulticast(Index, posX, posY, @p, p.Header.Size);
end;

function Functions.AddPoints(Index: WORD; p: pByte): boolean;
var onSuccess:boolean; max,reqclass,skillDiv,skillId,skillId2: integer; pServer: p277;
info: psmallint; master: pbyte; master2: byte; item: st_Itemlist;
begin
  Move(p^,pserver,sizeof(p277));
  result:=true;
  case(pServer.Mode)of
    0:
    begin
      if(Player[index].Char.pStatus <= 0)then
          exit;

      info:=@Player[index].Char.bStatus.Str;
      inc(info,pserver.Info);
      if(((pServer.Info mod 2) = 0) and (info^ >= 32000)) or (((pServer.Info mod 2) <> 0) and (info^ >= 12000))then
      begin
          SendClientMsg(Index, 'Máximo de pontos é 32.000');
          exit;
      end;

      inc(info^);
      dec(Player[index].Char.pStatus);

      GetCurrentScore(Index);
      SendEtc(Index);
      SendScore(Index);
    end;
    1:
    begin
        if(Player[index].Char.pMaster <= 0)then
            exit;

        if((Player[index].Char.Learn and (128 shl (pServer.Info * 8))) = 0)then
        begin
            max := (((Player[index].Char.bStatus.Level + 1) * 3) shr 1);
            if(max > 200)then
                max := 200;
        end
        else
            max := 255;

        master := @Player[index].Char.bStatus.wMaster;
        inc(master,pServer.Info);
        if(master^ >= max)then
        begin
            SendClientMsg(Index, 'Máximo de pontos neste atributo.');
            exit;
        end;

        inc(master^);
        dec(Player[index].Char.pMaster);

        GetCurrentScore(Index);
        SendEtc(Index);
        SendScore(Index);
    end;
    2:
    begin
        if(pServer.Info < 5000) or (pServer.Info > 5095)then
          exit;

        skillDiv := Trunc((pServer.Info - 5000) / 24);
        skillID := (pServer.Info - 5000);
        skillID2 := (pServer.Info - 5000) mod 24;

        item:= ItemList[pserver.Info];

        info:=@item.STR;
        inc(info, skillDiv);
        master2 := (Player[index].Char.Status.fMaster) + skillDiv;

        onSuccess := false;
        reqclass := GetEffectValue(pServer.Info, EF_CLASS);

        if((Player[index].Char.Learn and (1 shl skillID2)) = 0)then
            if(master2 >= info^)then
                if(Player[index].Char.pSkill >= SkillsData[skillId].SkillPoint)then
                    if(Player[index].Char.Gold >= item.Price)then
                        if(Player[index].Char.bStatus.Level >= item.Level)then
                            if(reqclass = Player[index].Char.ClassInfo)then
                                onSuccess := true
                            else
                                SendClientMsg(Index, 'Não é possível aprender Skills de outras classes.')
                        else
                            SendClientMsg(Index, 'Level insuficiente para adquirir a Skill.')
                    else
                        SendClientMsg(Index, 'Dinheiro insuficiente para adquirir a Skill.')
                else
                    SendClientMsg(Index, 'Não há Pontos de Skill suficientes.')
            else
                SendClientMsg(Index, 'Não há Pontos de habilidade suficientes.')
        else
            SendClientMsg(Index, 'Você já aprendeu esta skill.');

        if(onSuccess = true)then
        begin
            Player[index].Char.Learn := Player[index].Char.Learn or (1 shl skillID2);
            dec(Player[index].Char.pSkill,SkillsData[skillid].SkillPoint);


            GetCurrentScore(Index);
            SendScore(Index);
            SendEtc(Index);
        end;
    end;
  end;
end;

procedure Functions.SendMobDead(Killer,Killed: WORD; posX, posY: integer);
var pServer: p338; a,d: mob_kill; x:integer;
begin
    if(Killer > 1000) and (Killed < 1000)then
    begin
      a.EnemyList:=@NpcMob[killer].EnemyList;
      a.EnemyIndex:=@NpcMob[killer].EnemyIndex;
      a.Hold:=0;
      a.Exp:=NpcMob[killer].NPC.exp;
      d.EnemyList:=@Player[killed].EnemyList;
      d.EnemyIndex:=@Player[killed].EnemyIndex;
      d.Hold:=0;
      d.Exp:=Player[killed].Char.Exp;
      Player[killed].Dead:=true;
      ZeroMemory(@Player[killed].EnemyList[0],80);
    end
    else
    if(Killer < 1000) and (Killed > 1000)then
    begin
      NpcMob[killed].Dead:=true;
      d.EnemyList:=@NpcMob[killed].EnemyList;
      d.EnemyIndex:=@NpcMob[killed].EnemyIndex;
      d.Hold:=0;
      d.Exp:=NpcMob[killed].NPC.exp;
      a.EnemyList:=@Player[killer].EnemyList;
      a.EnemyIndex:=@Player[killer].EnemyIndex;
      a.Hold:=0;
      a.Exp:=Player[killer].Char.Exp;
      inc(Player[killer].Char.Exp,NpcMob[killed].NPC.exp);
      ZeroMemory(@NpcMob[killed].EnemyList[0],80);
    end
    else
    if(Killer < 1000) and (Killed < 1000)then
    begin
      Player[killed].Dead:=true;
      d.EnemyList:=@Player[killed].EnemyList;
      d.EnemyIndex:=@Player[killed].EnemyIndex;
      d.Exp:=0;
      a.EnemyList:=@Player[killer].EnemyList;
      a.EnemyIndex:=@Player[killer].EnemyIndex;
      a.Hold:=Player[killer].Char.Hold;
      a.Exp:=Player[killer].Char.Exp;
      inc(Player[killed].Char.Hold,5000);
      d.Hold:=Player[killed].Char.Hold;
      if(Player[killed].pk = 0)then //0 = false
      begin
        if(Player[killed].cp < 50) and (Player[killed].cp > -25)then
          dec(Player[killer].cp,2)
        else
        if(Player[killed].cp >= 50)then
          dec(Player[killer].cp,3)
        else
        if(Player[killed].cp <= -25)then
          dec(Player[killer].cp,1);
      end;
      ZeroMemory(@Player[killed].EnemyList[0],80);
    end;

    pServer.Header.Size := 24;
    pServer.Header.Code := $338;
    pServer.Header.Index := $7530;

    pServer.Hold := a.Hold;
    pServer.killer := Killer;
    pServer.killed := Killed;
    pServer.Exp := a.Exp;

    FillChar(d.EnemyList^, -1, (sizeof(pInteger)*20));
    d.EnemyIndex^ := -1;
    //Defender->DamageMax = -1;

    a.EnemyIndex^ := -1;

    for x := 0 to 19 do
    begin
        inc(a.EnemyList,x);
        if(a.EnemyList^ = Killed)then
            a.EnemyList^ := -1;
    end;

    GridMulticast2(posX, posY, @pServer, 24, 0);

    SendRemoveMob(Killer, Killed, 1);

    //SendLevelUP(Killer);
end;

procedure Functions.Weather();
var i: BYTE; changed: boolean; min: integer;
begin
  changed:=false;
  for i := 0 to 3 do
  begin
    if(CityWeather[i].Time >= CityWeather[i].Next)then
    begin
      changed:=true;
      if(i = 3)then
      begin
        //somente gelo e nevasca
        CityWeather[i].Tipo := WeatherEnum(Random(2) + 2);
        CityWeather[i].Time := Now;
        min:=(Random(30)+30);
        CityWeather[i].Next := Now + strtotime('00:'+inttostr(min)+':00');
      end
      else
      begin
        CityWeather[i].Tipo := WeatherEnum(Random(3));
        CityWeather[i].Time := Now;
        min:=(Random(30)+30);
        CityWeather[i].Next := Now + strtotime('00:'+inttostr(min)+':00');
        //IncMinute(CityWeather[i].Next, min);
      end;
    end;
  end;
  if(changed)then
    SendWeather();
end;

procedure Functions.SendWeather(index, cityid: Word);
var p: p18B;
begin
  p.Header.Size := 16;
  p.Header.Code := $18B;
  p.Header.Index:= index;
  p.WeatherId   := BYTE(CityWeather[cityid].Tipo);
  SendClientPacket(@p , 16, index);
end;

procedure Functions.SendWeather();
var p: p18B; i: word;
begin
  p.Header.Size := 16;
  p.Header.Code := $18B;
  for i := 1 to MAXCONNECTIONS do
  begin
    if(Player[i].Char.Name = '')then
      continue;
    p.Header.Index:= i;
    p.WeatherId   := BYTE(CityWeather[Player[i].current.cityID].Tipo);
    SendClientPacket(@p , 16, i);
  end;
end;

procedure Functions.SendLevelUP(index, mobid: WORD);
var exp: cardinal;
begin
  if(mobid > 1000)then
  begin
    //calculo exp


    if(exp <= 0)then
      exp:=1;

    inc(Player[index].Char.Exp, NpcMob[mobid].NPC.exp);
  end;
end;

procedure Functions.AICreateMob(mobindex :WORD);
var i,mobid: WORD;
begin
  if(NpcMob[mobindex].GenerId=0)then
    exit;
  if(NpcMob[mobindex].Dead = false) then
    exit;
  if(Npcs[NpcMob[mobindex].GenerId].MinuteGenerate > 0) and (NpcMob[mobindex].TimeKill = ServerUpTime) then
  begin
    if(NpcMob[mobindex].Dead = true) and
    (MinutesBetween(now, ServerUpTime) >= Npcs[NpcMob[mobindex].GenerId].MinuteGenerate)then
    begin
    if(GetEmptyMobGrid(mobindex,@NpcMob[mobindex].NPC.Last.x,@NpcMob[mobindex].NPC.Last.y))then
      begin
        NpcMob[mobindex].Dead:=false;
        NpcMob[mobindex].NPC.Status.HP:=NpcMob[mobindex].NPC.Status.MaxHP;
        GetCreateNpc(mobindex,SPAWN_TELEPORT);
        GridMulticast2(NpcMob[mobindex].NPC.Last.x,NpcMob[mobindex].NPC.Last.y,@p364,p364.Header.Size,0);
      end;
    end;
  end;
  if(Npcs[NpcMob[mobindex].GenerId].MinuteGenerate > 0)then
  begin
    if(Npcs[NpcMob[mobindex].GenerId].ReviveTime = 0)then//padrao de reviver é 10 segundos
    begin
      if(NpcMob[mobindex].Dead = true) and
      (SecondsBetween(now,NpcMob[mobindex].TimeKill) >= 10)then
      begin
        if(GetEmptyMobGrid(mobindex,@NpcMob[mobindex].NPC.Last.x,@NpcMob[mobindex].NPC.Last.y))then
        begin
          NpcMob[mobindex].Dead:=false;
          NpcMob[mobindex].NPC.Status.HP:=NpcMob[mobindex].NPC.Status.MaxHP;
          GetCreateNpc(mobindex,SPAWN_TELEPORT);
          GridMulticast2(NpcMob[mobindex].NPC.Last.x,NpcMob[mobindex].NPC.Last.y,@p364,p364.Header.Size,0);
        end;
      end;
    end
    else
    begin
      if(NpcMob[mobindex].Dead = true) and
      (SecondsBetween(now,NpcMob[mobindex].TimeKill) >= Npcs[NpcMob[mobindex].GenerId].ReviveTime)then
      begin
        if(GetEmptyMobGrid(mobindex,@NpcMob[mobindex].NPC.Last.x,@NpcMob[mobindex].NPC.Last.y))then
        begin
          NpcMob[mobindex].Dead:=false;
          NpcMob[mobindex].NPC.Status.HP:=NpcMob[mobindex].NPC.Status.MaxHP;
          GetCreateNpc(mobindex,SPAWN_TELEPORT);
          GridMulticast2(NpcMob[mobindex].NPC.Last.x,NpcMob[mobindex].NPC.Last.y,@p364,p364.Header.Size,0);
        end;
      end;
    end;
  end;
end;

procedure Functions.AIMove(mobindex :WORD);
var sort,diffx,diffy,id,x,y: smallint; p: p366;
label GotoSpawn;
label GotoDesty;
begin

		//fazer dps
		//BYTE groups = followquant / 4;
		//NORTE X++
		//SUL X--
		//OESTE Y++
		//LESTE Y--


  //if(NpcMob[mobindex].TimeMove
  id:=NpcMob[mobindex].Generid;
  if (Npcs[id].RouteType = 0) then
  begin
    exit;
  end;


  if(NpcMob[mobindex].NPC.Equip[0].Index = 0)then
    exit;

  if(NpcMob[mobindex].Dead)then
  begin
    exit;
  end;

  if(NpcMob[mobindex].inBattle)then
  begin
    exit;
  end;

  if(Npcs[id].Desty = Npcs[id].SpawnPosy) and (Npcs[id].Destx = Npcs[id].SpawnPosx)then
    exit;

  x := NpcMob[mobindex].NPC.Last.x;
  y := NpcMob[mobindex].NPC.Last.y;
  Randomize;
  sort:=Random(3);

  if(sort = 0)then//x
  begin
    Randomize;
    x:=RandomRange(Npcs[id].SpawnPosx,Npcs[id].Destx);
  end
  else
  if(sort = 1)then//y
  begin
    Randomize;
    y:=RandomRange(Npcs[id].SpawnPosy,Npcs[id].Desty);
  end
  else//x e y
  begin
    Randomize;
    x:=RandomRange(Npcs[id].SpawnPosx,Npcs[id].Destx);
    y:=RandomRange(Npcs[id].SpawnPosy,Npcs[id].Desty);
  end;

  if(not GetEmptyMobGrid(mobindex,@x,@y))then
    Exit;


  p.Header.Size := sizeof(p366);
  p.Header.Code := $367;
  p.Header.Index := mobIndex;

  p.xSrc := NpcMob[mobindex].NPC.Last.x;
  p.ySrc := NpcMob[mobindex].NPC.Last.y;
  p.mSpeed := NpcMob[mobindex].NPC.Status.Speed;

  p.xDst := x;
  p.yDst := y;

  p.mCommand[0] := #0;
  p.mType := 0;

  MobGrid[NpcMob[mobindex].NPC.Last.y][NpcMob[mobindex].NPC.Last.x]:=0;
  MobGrid[y][x]:=mobindex;
  NpcMob[mobindex].NPC.Last.x:=x;
  NpcMob[mobindex].NPC.Last.y:=y;
  NpcMob[mobindex].TimeMove:=Now;
  GridMulticast2(x,y,@p,p.Header.Size,mobindex);
end;

function Functions.GetStartXY(index: WORD): boolean;
var x,y: WORD;
begin
	case(Player[index].current.cityID)of
    0: //armia
    begin
      x:= 2100;
      y:= 2100;
      end;
    1: //azram
    begin
      x := 2507;
      y := 1715;
      end;
    2: //erion
    begin
      x := 2461;
      y := 1997;
      end;
    3: //gelo
    begin
      x := 3645;
      y := 3130;
    end;
	end;
  if(GetEmptyMobGrid(index,@x,@y))then
  begin
    Player[index].current.current.x := x;
    Player[index].current.current.y := y;
    result:=true;
  end
  else
    result:=false;
end;

function Functions.DeleteItem(index: Word; p: pByte) : boolean;
var pak: p2E4;
begin
  Move(p^,pak,20);
  result:=false;
  if(pak.slot < 0) or (pak.slot > 60)then
    exit;
  if(Player[index].Char.Inventory[pak.slot].Index = pak.itemid)then
    ZeroMemory(@Player[index].Char.Inventory[pak.slot],8)
  else
    RefreshInventory(index);
  result:=true;
end;

procedure Functions.DeleteItem(activeChar : PActiveCharacter; slot : BYTE);
begin
  if(slot < 0) or (slot > 60)then
    exit;
  ZeroMemory(@activeChar^.Char.Inventory[slot], 8);
  RefreshInventory(activeChar^.Char.ClientIndex);
end;

procedure Functions.DeleteItem(activeChar : PActiveCharacter; itemId : integer; quant : WORD);
var i,j,lastslot : BYTE;
begin
  lastslot := 0;
  for j := 1 to quant do
  begin
    for i := lastslot to 63 do
    begin
      if (activeChar^.Char.Inventory[i].Index = itemId) then
      begin
        ZeroMemory(@activeChar^.Char.Inventory[i], 8);
        RefreshInventory(activeChar^.Char.ClientIndex);
        lastslot := i;
        break;
      end;
    end;
  end;
end;

function Functions.RequestParty(index: Word; p: pByte): boolean;
var pak: p37F; nick: string;
begin
  Move(p^,pak,sizeof(p37F));
  result:=true;
  if(pak.AlvoID < 1) or (pak.AlvoID > 1000) or (pak.SenderId <> index) then
  begin
    //result:=false;
    exit;
  end;
  if(Player[index].Pt.Leader <> index) and (Player[index].Pt.Leader <> 0) then
  begin
    SendClientMsg(index,'Você não é líder. Saia do grupo para criar um novo grupo.');
    exit;
  end;
  if(Player[pak.AlvoID].Pt.Leader <> 0)then
  begin
    SendClientMsg(index,'O outro jogador já está em um grupo.');
    exit;
  end;
  if(pak.Level <> Player[index].Char.Status.Level) or (pak.MaxHp <> Player[index].Char.Status.MaxHP)
  or (pak.CurHp <> Player[index].Char.Status.HP)then
  begin
    result:=false;
    exit;
  end;
  nick:=pak.Nick[0]+pak.Nick;
  if(AnsiCompareStr(Player[index].Char.Name,nick) <> 0)then
  begin
    result:=false;
    exit;
  end;
  if(Player[pak.AlvoID].Pt.Leader = 0)then
  begin
    Player[pak.AlvoID].Pt.RequestId:=index;
  end;
  SendClientPacket(@pak,sizeof(p37F),pak.AlvoID);
end;

function Functions.ExitParty(index: Word; p: pByte): boolean;
var pak: p37E; id,liderid, exitid: Word; i: BYTE; find: boolean;
begin
  Move(p^,pak,16);
  result:=true;
  if(pak.Header.Index <> index) then
    exit;
  liderid:=Player[index].Pt.Leader;
  if(liderid = index) and (pak.ExitId = 0)then
  begin
    SendExitParty(liderid,-1,false);
    exit;
  end;
  if(liderid=0)then
  begin
    SendClientMsg(index,'Você não está em um grupo.');
    exit;
  end;
  exitid:=pak.ExitId;
  pak.ExitId:=0;
  if(exitid <> 0)then//lider mandou tirar da pt
  begin
    //exitid:=FindinParty(liderid,exitid);
    if(index <> liderid)then
    begin
      SendClientMsg(index,'Somente o lider pode expulsar membros do grupo.');
      exit;
    end
    else
    begin
      SendExitParty(liderid,exitid,true);
      exit;
    end;
  end;
  //exitid:=FindinParty(liderid,index);
  SendExitParty(liderid,index,false);
end;

function Functions.AcceptParty(index: Word; p: pByte): boolean;
var pak: p3AB; spak: p37D; i,pos: BYTE; id: WORD;  nick: string; first: boolean;
begin
  result:=true;
  Move(p^,pak,sizeof(p3AB));
  if(pak.LiderID <> Player[index].Pt.RequestId)then
    exit;
  nick:=pak.Nick[0]+pak.Nick;
  if(AnsiCompareStr(Player[pak.LiderID].Char.Name,nick) <> 0)then
    exit;
  first:=false;
  if(Player[pak.LiderID].Pt.Leader = 0)then
  begin
    Player[pak.LiderID].Pt.Leader:= pak.LiderID;
    first:=true;
  end;
  i:=0;
  while i < 11 do begin
    if(Player[pak.LiderID].Pt.Members[i] = 0)then
      break;
    inc(i);
  end;
  if(i = 11)then
  begin
    SendClientMsg(index,'O grupo está cheio.');
    exit;
  end;
  Player[pak.LiderID].Pt.Members[i]:=index;
  Player[index].Pt.Leader:=pak.LiderID;

  //eviar os membros do grupo e o lider para o novo membro
  //para enviar o lider para o novo membro temos q enviar o Clientid com o index do lider
  //e o liderid com o clientid do lider
  if(first)then //enviar lider para o lider quando o grupo é formado
    SendParty(pak.LiderID,pak.LiderID,pak.LiderID);
  SendParty(pak.LiderID,pak.LiderID,index);
  for i := 0 to 10 do
  begin
    id:=Player[pak.LiderID].Pt.Members[i];
    //para enviar os membros para o novo membro precisamos adicionar +255 ao liderid
    //e o clientid será o id do membro a ser enviado
    if(id <> 0)then
      SendParty(pak.LiderID+255,id,index);
  end;

  //enviar para o lider e os outros membros
  //membro para lider é lider+255 e clientid = ao id do novo membro
  SendParty(pak.LiderID+255,index,pak.LiderID);
  // membro para membro é necessario enviar o LiderId+255
  // e o clientid com o index
  for i := 0 to 10 do
    if(Player[pak.LiderID].Pt.Members[i] <> 0) and (Player[pak.LiderID].Pt.Members[i] < 1000)then
      SendParty(pak.LiderID+255,index,Player[pak.LiderID].Pt.Members[i]);
end;

procedure Functions.SendEmotion(Index: WORD; effType, effValue: smallint);
var pEmotion: p36A;
begin
    pEmotion.Header.Size := sizeof(p36A);
    pEmotion.Header.Code := $36A;
    pEmotion.Header.Index := Index;

    pEmotion.effType := effType;
    pEmotion.effValue := effValue;
    pEmotion.Unknown1 := 0;

    GridMulticast2(Trunc(Player[index].current.current.x),Trunc(Player[index].current.current.y),
    @pEmotion,pEmotion.Header.Size,0); // Envia pro próprio Index.
end;

procedure Functions.LoadMobBaby();
var i: BYTE; local123: string; fs: File of sMob2; erro: boolean;
begin
  erro:=false;
  for i := 0 to MAX_MOB_BABY-1 do
  begin
    if(bmob_name[i] = '')then
        continue;

    local123:=diretorio+'\npc_base\'+bmob_name[i];
    if(fileexists(local123) = false) then begin
      Showmessage('Npc: '+bmob_name[i]+' não encontrado.');
      continue;
      erro:=true;
    end;
    AssignFile(fs, local123);
    Reset(fs);
    Read(fs, MobBabyList[i]);
    CloseFile(fs);
    MobBabyList[i].Stat := MobBabyList[i].bStat;
  end;
  if(erro)then
    Form1.ListBox4.Items.Add('MountBaby carregado com erros!')
  else
    Form1.ListBox4.Items.Add('MountBaby carregado com sucesso!');
end;

function Functions.GetFreeMob():WORD;
var i:WORD;
begin
  result:=0;
  for i := 27000 to 30000 do
    if(NpcMob[i].NPC.Equip[0].Index = 0)then
    begin
      result:=i;
      break;
    end;
end;

procedure Functions.SendParty(leader, member, toclient: WORD);
var i: BYTE; spak: p37D;
begin
  spak.Header.Size:=sizeof(p37D);
  spak.Header.Code:=$37D;
  spak.Header.Index:=$7530;
  spak.unk2:=52428;
  spak.LiderID:=leader;
  spak.ClientId:=member;
  if(member < 1000)then
  begin
    spak.Level:=Player[member].Char.Status.Level;
    spak.MaxHp:=Player[member].Char.Status.MaxHP;
    spak.CurHp:=PLayer[member].Char.Status.HP;
    Move(Player[member].Char.Name[0],spak.Nick[0],16);
  end
  else
  begin
    spak.MaxHp:=NpcMob[member].NPC.Status.MaxHP;
    spak.CurHp:=NpcMob[member].NPC.Status.HP;
    Move(NpcMob[member].NPC.Name[0],spak.Nick[0],16);
    spak.Level:=NpcMob[member].NPC.Status.Level;
  end;
  SendClientPacket(@spak,spak.Header.Size,toclient);
  /*
  if(toall)then
  begin
    for i := 0 to 10 do
    begin
      if(Player[leader].Pt.Members[i] <> 0) and (Player[leader].Pt.Members[i] < 1000)then
        SendClientPacket(@spak,spak.Header.Size,Player[leader].Pt.Members[i]);
    end;

    for i := 0 to 10 do
    begin
      if(Player[leader].Pt.Members[i] <> 0) and (Player[leader].Pt.Members[i] < 1000)then
      begin
        SendClientPacket(@spak,spak.Header.Size,Player[leader].Pt.Members[i]);
      end;
    end;
  end;
  */
end;

function Functions.FindInParty(index, findid: WORD): BYTE;
var i: BYTE;
begin
  result:=11;
  for i := 0 to 10 do
  begin
    if(Player[index].Pt.Members[i] = findid)then
    begin
      result:=i;
      exit;
    end;
  end;
end;

procedure Functions.SendExitParty(leader, exitid: integer; force: boolean);
var i: BYTE; pak: p37E; find: boolean; id: WORD; idOnParty : WORD;
begin
  pak.Header.Size:=sizeof(p37E);
  pak.Header.Code:=$37E;
  pak.Header.Index:=exitid; //não é o clientid e sim a posição na pt
  pak.ExitId:=exitid;
  pak.unk:=0;

  idOnParty := FindinParty(leader,exitid);

  if(exitid = -1)then//lider saiu da pt
  begin
    pak.ExitId:= 1;
    pak.Header.Index:=0;
    Player[leader].Pt.Leader:=0;
    for i := 0 to 10 do
    begin
      id:=Player[leader].Pt.Members[i];
      if(id > 1000)then
      begin
        //remover evocações do lider
        if(NpcMob[id].Ownerid = leader)then
        begin
          if(not NpcMob[Player[leader].Pt.Members[i]].Evocacao)then
            UngenerateBabyMob(Player[leader].Pt.Members[i],DELETE_UNSPAWN);
          //else
            //ungenerateevoacao();
          Player[leader].Pt.Members[i] := 0;
        end;
      end;
    end;
    for i := 0 to 10 do
    begin
      id:=Player[leader].Pt.Members[i];
      Player[leader].Pt.Members[i]:=0;
      if(id <> 0) and (id < 1000)then
      begin
        Player[id].Pt.Leader:=id;
        Move(Player[leader].Pt.Members[0],Player[id].Pt.Members[0],22);
        SendParty(0,id,id);
        break;
        //escolher novo lider
      end;
    end;
    for i := 0 to 10 do
    begin
      if(id <> 0) and (id < 1000) and (Player[leader].Pt.Members[i] <> 0) then
        SendParty(0, id, Player[leader].Pt.Members[i]);

      if(Player[leader].Pt.Members[i] < 1000) and (Player[leader].Pt.Members[i] <> 0)then
        SendClientPacket(@pak,pak.Header.Size,Player[leader].Pt.Members[i]);
    end;
    ZeroMemory(@Player[leader].Pt,sizeof(Party));
  end
  else
  begin
    find:=false;
    for i := 0 to 10 do
    begin
      if(Player[leader].Pt.Members[i] = exitid)then
      begin
        if(force)then //kikdo
          SendClientPacket(@pak,pak.Header.Size,exitid);
        continue;
      end;
      if(Player[leader].Pt.Members[i] <> 0) and
      (Player[leader].Pt.Members[i] < 1000) then begin
        SendClientPacket(@pak,pak.Header.Size,Player[leader].Pt.Members[i]);
        find:=true;
      end
      else
        if(Player[leader].Pt.Members[i] > 1000)then
        begin
          if(NpcMob[Player[leader].Pt.Members[i]].Ownerid = exitid)then
          begin
            if(not NpcMob[Player[leader].Pt.Members[i]].Evocacao)then
            begin
              UngenerateBabyMob(Player[leader].Pt.Members[i],DELETE_UNSPAWN);
              Player[Player[leader].Pt.Members[exitid]].Mobbaby:=0;
            end;
            //else
              //ungenerateevoacao();
            Player[leader].Pt.Members[i]:=0;
          end
          else
            find:=true;
        end;
    end;
  end;
  SendClientPacket(@pak,pak.Header.Size,leader);
  pak.ExitId:=0;
  if(exitid < 1000) and (exitid <> 0)then
  begin
    SendClientPacket(@pak,pak.Header.Size,exitid);
    ZeroMemory(@Player[exitid].Pt,26);
  end;
  Player[leader].Pt.Members[idOnParty]:=0;
  if(not find)then
     ZeroMemory(@Player[leader].Pt,sizeof(Party));
end;

procedure Functions.UngenerateBabyMob(mIndex, ungenEffect: WORD);
var pos: TPosition; i: BYTE;
begin
  pos.x:= NpcMob[mindex].NPC.Last.x;
  pos.y:= NpcMob[mindex].NPC.Last.y;

  Player[NpcMob[mindex].Ownerid].Mobbaby:=0;

  i:=FindinParty(Player[NpcMob[mindex].Ownerid].Pt.Leader,mIndex);
  if(i < 11)then
    SendExitParty(Player[NpcMob[mindex].Ownerid].Pt.Leader,i,false);

  SendRemoveMob(mindex,mindex,ungenEffect);
  ZeroMemory(@NpcMob[mindex],sizeof(sMob2));

  MobGrid[pos.y][pos.x]:=0;
end;

procedure Functions.GenerateBabyMob(Index, mIndex, mobNum: WORD);
var pos: TPosition; i,j: BYTE; id: WORD;
begin
    pos.x := Trunc(Player[Index].Current.current.x);
    pos.y := Trunc(Player[Index].Current.current.y);

    //i := mIndex <= 7;
    id:=GetFreeMob();
    if(id = 0)then
      exit;

    if(not GetEmptyMobGrid(id, @pos.X, @pos.Y))then
      exit;

    i:=0;
    while(i < 12) do
    begin
      if(Player[index].Pt.Leader = 0)then
      begin
        Player[index].Pt.Leader := index;
        Player[index].Pt.Members[i]:=id;
        Move(MobBabyList[mindex],NpcMob[id].NPC,sizeof(sMob2));
        NpcMob[id].Ownerid:=index;
        //Enviar Lider
        SendParty(index,index,index);
        //Enviar Mob
        NpcMob[id].NPC.Status.Level:=Player[index].Char.Status.Level;
        SendParty(index+255,id,index);
        break;
      end
      else
        if(Player[index].Pt.Leader <> index)then
        begin
          if(Player[Player[index].Pt.Leader].Pt.Members[i] <> 0)then
            continue
          else
          begin
            //enviar bixo para o grupo q em q o player está
            NpcMob[id].Ownerid:=index;
            Player[Player[index].Pt.Leader].Pt.Members[i]:=id;
            Move(MobBabyList[mindex],NpcMob[id].NPC,sizeof(sMob2));
            SendParty(Player[index].Pt.Leader+255,id,index);
            SendParty(Player[index].Pt.Leader+255,id,Player[index].Pt.Leader);
            for j := 0 to 10 do
              if(Player[Player[index].Pt.Leader].Pt.Members[j] < 1000) and (Player[Player[index].Pt.Leader].Pt.Members[j] <> 0)then
                SendParty(Player[index].Pt.Leader+255,id,Player[Player[index].Pt.Leader].Pt.Members[j]);
            break;
          end;
        end
        else
        if(Player[index].Pt.Leader = index)then
        begin
          if(Player[index].Pt.Members[i] <> 0)then
            continue
          else
          begin
            //enviar bixo para o grupo em q o player é lider
            NpcMob[id].Ownerid:=index;
            Player[index].Pt.Members[i]:=id;
            Move(MobBabyList[mindex],NpcMob[id].NPC,sizeof(sMob2));
            SendParty(Player[index].Pt.Leader+255,id,index);
            for j := 0 to 10 do
              if(Player[index].Pt.Members[j] < 1000) and (Player[index].Pt.Members[j] <> 0)then
                SendParty(Player[index].Pt.Leader+255,id,Player[index].Pt.Members[j]);
            break;
          end;
        end;

        inc(i);
    end;
    if(i < 12)then
    begin
      NpcMob[id].NPC.Last.x:=pos.x;
      NpcMob[id].NPC.Last.y:=pos.y;

      Player[index].mobbaby:=id;

      GetCreateNpc(id,SPAWN_TELEPORT);
      GridMultiCast2(pos.x,pos.y,@p364,p364.Header.Size,0);

      MobGrid[pos.Y][pos.X] := id;
    end;
end;

procedure Functions.CloseTrade(index: WORD);
var Header: sHeader; i: BYTE;
begin
  ZeroMemory(@Player[index].Trade,sizeof(sTrade));
  for i := 0 to 14 do
    Player[index].Trade.TradeItemSlot[i] := -1;

  /*
  ZeroMemory(@Player[otherPlayer].Trade,sizeof(sTrade));
  for i := 0 to 14 do
    Player[otherPlayer].Trade.TradeItemSlot[i] := $FF;
  */

  Header.Index := index;
  Header.Code := $384;
  Header.Size := 12;
  SendClientPacket(@Header,12,index);
end;

function Functions.GetFreeSlotS(clientid: WORD): BYTE;
var j,i: BYTE;
begin
  result:=0;
  j:=0;
  for i := 0 to 63 do
    if(Player[clientid].Char.Inventory[i].Index = 0)then
      inc(j);
  result:=j;
end;

function Functions.GetQuantTradeItem(clientid: WORD): BYTE;
var j, i: BYTE;
begin
  j := 0;
  for i := 0 to 14 do
    if(Player[clientid].Trade.Itens[i].Index <> 0)then
      inc(j);
  result:=j;
end;

procedure Functions.Trade(index: WORD; pak: pByte);
var p: SendTrade;
otherClientid,Clientid,i,j: WORD;
begin

	move(pak^,p,sizeof(SendTrade));
	otherClientid := p.OtherClientid;
	Clientid := p.Header.Index;
	Player[index].trade.confirma := p.Confirma;
	if(length(Player[otherClientid].Char.Name) <= 0)then
	begin
		SendClientMsg(Clientid, 'Este jogador não está conectado.');
		exit;
	end;
	if((Player[otherClientid].pkstatus = 1) or (Player[Clientid].pkstatus = 1))then
	begin
		SendClientMsg(Clientid, 'Desative o modo pk.');
		exit;
	end;
	if(not(Player[Clientid].Trade.isTrading)) and ((not(Player[otherClientid].trade.isTrading)) and (p.TradeItem[0].Index <= 0))then
	begin
    ZeroMemory(@p, sizeof(SendTrade));
		p.OtherClientid := Clientid;
		p.Header.index := otherClientid;
		p.Header.Size := 156;
		p.Header.Code := $383;
		for i := 0 to 14 do
    begin
			p.TradeItemSlot[i] := -1;
      Player[Clientid].Trade.TradeItemSlot[i] := -1;
    end;
		SendClientPacket(@p,p.Header.Size, otherClientid);
		Player[Clientid].Trade.Timer := now;
		Player[Clientid].Trade.isTrading := true;
		Player[Clientid].Trade.Waiting := true;
		Player[Clientid].Trade.otherClientid := otherClientid;
		exit;
	end
  else
	begin
		if((not(Player[Clientid].Trade.isTrading)) and (Player[otherClientid].Trade.isTrading) and (Player[otherClientid].Trade.otherClientid = Clientid)
			and (Player[otherClientid].Trade.Waiting))then
		begin
			ZeroMemory(@p, sizeof(SendTrade));
	   	p.OtherClientid := Clientid;
	   	p.Header.index := otherClientid;
	   	p.Header.Size := 156;
	   	p.Header.Code := $383;
	   	for i := 0 to 14 do
      begin
	   		p.TradeItemSlot[i] := -1;
        Player[Clientid].Trade.TradeItemSlot[i] := -1;
      end;
	   	SendClientPacket(@p,p.Header.Size, otherClientid);
	   	Player[Clientid].Trade.Timer := now;
	   	Player[Clientid].Trade.isTrading := true;
	   	Player[Clientid].Trade.Waiting := true;
	   	Player[Clientid].Trade.otherClientid := otherClientid;
      exit;
		end;

		if((Player[Clientid].Trade.isTrading) and (Player[Clientid].Trade.otherClientid <> otherClientid))then
		begin
			SendClientMsg(clientid, 'Você já está em uma negociação.');
			Player[Clientid].Trade.isTrading := false;
			Player[Clientid].Trade.Waiting := false;
			Player[Clientid].Trade.otherClientid := 0;
			exit;
		end;

		if((Player[otherClientid].trade.isTrading) and (Player[otherClientid].trade.otherClientid <> Clientid))then
		begin
			SendClientMsg(clientid, 'O outro jogador já está em uma negociação.');
			Player[Clientid].Trade.isTrading := false;
			Player[Clientid].Trade.Waiting := false;
			Player[Clientid].Trade.otherClientid := 0;
			exit;
		end;
	end;
	if((Player[otherClientid].trade.otherClientid <> Clientid) and (Player[Clientid].Trade.otherClientid <> otherClientid))then
	begin
		SendClientMsg(clientid, 'Ocorreu um erro.');
		SendClientMsg(otherclientid, 'Ocorreu um erro.');
		CloseTrade(clientid);
		exit;
	end;
	if(Player[Clientid].trade.Confirma)then
	begin
		if((now - Player[Clientid].trade.Timer) < strtotime('00:00:02'))then
		begin
			SendClientMsg(clientid, 'Aguarde 2 segundos e aperte o botão.');
			Player[Clientid].Trade.Confirma := false;
			Player[Clientid].trade.Timer := now;
			exit;
		end
    else
		begin
			if(Player[otherClientid].trade.Confirma)then
			begin

				if not(CheckItensTrade(clientid,0)) then
				begin
					SendClientMsg(otherclientid, 'Você não tem espaço o suficiente no inventário.');
					SendClientMsg(clientid, 'O outro player não tem espaço o suficiente no inventário.');
					CloseTrade(clientid);
					CloseTrade(otherclientid);
					exit;
				end;
				if not(CheckItensTrade(otherclientid,0)) then
				begin
					SendClientMsg(clientid, 'Você não tem espaço o suficiente no inventário.');
					SendClientMsg(otherclientid, 'O outro player não tem espaço o suficiente no inventário.');
					CloseTrade(clientid);
					CloseTrade(otherclientid);
					exit;
				end;
        /*
				for i:=0 to 14 do
				begin
					if(thisclient->trade.TradeItemSlot[i] > -1 && thisclient->trade.TradeItemSlot[i] < 64)
						ZeroMemory(&thisclient->Inventory[thisclient->trade.TradeItemSlot[i]],8);
					if(otherclient->trade.TradeItemSlot[i] > -1 && otherclient->trade.TradeItemSlot[i] < 64)
						ZeroMemory(&otherclient->Inventory[otherclient->trade.TradeItemSlot[i]],8);
        end;

				for(BYTE i = 0; i < 15; i++)
				begin
					BYTE slot = GetFirstSlotSADD(Clientid,0,64);
					BYTE otherslot = GetFirstSlotSADD(otherClientid,0,64);
					if(slot != -1 && otherclient->trade.Itens[i].Index != 0)
						memcpy(&thisclient->Inventory[slot],&otherclient->trade.Itens[i],8);
					if(otherslot != -1 && thisclient->trade.Itens[i].Index != 0)
					memcpy(&otherclient->Inventory[slot],&thisclient->trade.Itens[i],8);
				end;
        */
				if(Player[clientid].Char.Gold + Player[otherclientid].trade.Gold <= 2000000000)
					and (Player[otherclientid].Char.Gold + Player[clientid].trade.Gold <= 2000000000)then
				begin
					inc(Player[clientid].Char.Gold, Player[otherclientid].trade.Gold);
					inc(Player[otherclientid].Char.Gold, Player[clientid].trade.Gold);
					dec(Player[clientid].Char.Gold, Player[clientid].trade.Gold);
					dec(Player[otherclientid].Char.Gold, Player[otherclientid].trade.Gold);
          RefreshMoney(clientid);
          RefreshMoney(otherClientid);
				end
				else
				begin
					SendClientMsg(clientid, 'Limite de 2 Bilhões de gold.');
					SendClientMsg(otherclientid, 'Limite de 2 Bilhões de gold.');
					CloseTrade(clientid);
					CloseTrade(otherclientid);
					exit;
				end;
				CheckItensTrade(clientid,1);
				CheckItensTrade(otherclientid,1);
				CloseTrade(clientid);
				CloseTrade(otherclientid);
				exit;
			end
      else
			begin
        if (CompareMem(@p.TradeItem[0],@Player[clientid].trade.Itens[0],8*15) <> true) or (p.Gold <> Player[clientid].trade.Gold)
            or (CompareMem(@p.TradeItemSlot[0],@Player[clientid].trade.TradeItemSlot[0],15) <> true)then
        begin
          Player[clientid].trade.confirma := False;
          Player[otherclientid].trade.confirma := False;
        end;
        Player[clientid].trade.Gold := p.Gold;
        Move(p.TradeItem[0],Player[clientid].trade.Itens[0],8*15);
        Move(p.TradeItemSlot[0],Player[clientid].trade.TradeItemSlot[0],15);
				ZeroMemory(@p, sizeof(SendTrade));
        Move(Player[clientid].trade.Itens[0],p.TradeItem[0],8*15);
				Move(Player[clientid].trade.TradeItemSlot[0],p.TradeItemSlot[0],15);
        p.Gold:= Player[clientid].trade.Gold;
        p.OtherClientid := Clientid;
        p.Header.index := otherClientid;
        p.Header.Size := 156;
        p.Header.Code := $383;
        for i := 0 to 14 do
          p.TradeItemSlot[i] := -1;
        p.Confirma := Player[clientid].trade.confirma;
				SendClientPacket(@p,p.Header.Size, otherClientid);
			end;
      exit;
		end;
	end
  else
	begin
		//Recebe os itens e gold para o buffer trade
		if(p.Gold > Player[clientid].Char.Gold)then
		begin
			SendClientMsg(clientid, 'Ocorreu um erro.');
			SendClientMsg(otherclientid, 'Ocorreu um erro.');
			CloseTrade(clientid);
			CloseTrade(otherclientid);
			exit;
		end;
		for i := 0 to 14 do
		begin
			if(p.TradeItemSlot[i] <> -1)then
			begin
				for j := i+1 to 14 do
				begin
					if((p.TradeItemSlot[i] = p.TradeItemSlot[j]) and (i <> j))then
					begin
						SendClientMsg(clientid, 'Ocorreu um erro.');
            SendClientMsg(otherclientid, 'Ocorreu um erro.');
            CloseTrade(clientid);
            CloseTrade(otherclientid);
            exit;
					end;
				end;
				if(p.TradeItemSlot[i] < -1) or (p.TradeItemSlot[i] > 63)then
        begin
					SendClientMsg(clientid, 'Ocorreu um erro.');
          SendClientMsg(otherclientid, 'Ocorreu um erro.');
          CloseTrade(clientid);
          CloseTrade(otherclientid);
          exit;
				end;
				if((CompareMem(@p.TradeItem[i],@Player[clientid].Char.Inventory[p.TradeItemSlot[i]],8) <> true)
					and (p.TradeItem[i].Index <> 0)) then
				begin
					SendClientMsg(clientid, 'Ocorreu um erro.');
          SendClientMsg(otherclientid, 'Ocorreu um erro.');
          CloseTrade(clientid);
          CloseTrade(otherclientid);
          exit;
				end;
			end
      else
			begin
				if(p.TradeItem[i].Index > 0) or
					(Player[clientid].trade.Itens[i].Index > 0)then
				begin
					SendClientMsg(clientid, 'Ocorreu um erro.');
          SendClientMsg(otherclientid, 'Ocorreu um erro.');
          CloseTrade(clientid);
          CloseTrade(otherclientid);
          exit;
				end;
			end;
		end;
    if (CompareMem(@p.TradeItem[0],@Player[clientid].trade.Itens[0],8*15) <> true) or (p.Gold <> Player[clientid].trade.Gold)
        or (CompareMem(@p.TradeItemSlot[0],@Player[clientid].trade.TradeItemSlot[0],15) <> true)then
    begin
      Player[clientid].trade.confirma := False;
      Player[otherclientid].trade.confirma := False;
    end;
		Player[clientid].trade.Gold := p.Gold;
    Move(p.TradeItem[0],Player[clientid].trade.Itens[0],8*15);
    Move(p.TradeItemSlot[0],Player[clientid].trade.TradeItemSlot[0],15);
    ZeroMemory(@p, sizeof(SendTrade));
    p.OtherClientid := Clientid;
    p.Header.index := otherClientid;
    p.Header.Size := 156;
    p.Header.Code := $383;
    p.Confirma := Player[clientid].trade.confirma;
    Move(Player[clientid].trade.Itens[0],p.TradeItem[0],8*15);
    Move(Player[clientid].trade.TradeItemSlot[0],p.TradeItemSlot[0],15);
    p.Gold:= Player[clientid].trade.Gold;
    Player[clientid].trade.Timer := now;
		Player[clientid].trade.Confirma := false;
	  SendClientPacket(@p,p.Header.Size, otherClientid);
		end;
	exit;
end;

function Functions.CheckItensTrade(index: WORD; Mode: BYTE): boolean;
var i,j,otherClientid: WORD;
sloterror: integer;
qitem: BYTE;
items: array[0..63] of item;
begin
	otherclientid := Player[index].trade.otherClientid;
	qitem := GetQuantTradeItem(index);
  sloterror := 0;
	if(qitem <= 0)then
  begin
		result:=true;
    exit;
  end;
  for j := 0 to 63 do
  begin
    if(Player[otherClientid].Char.Inventory[j].index = 0)then
      inc(sloterror);
    if(sloterror >= qitem)then
    begin
      result:=true;
      break;
    end;
  end;
  if(sloterror < qitem)then
  begin
    result:=false;
    exit;
  end;
	if(Mode = 1)then
  begin
    move(Player[index].Char.Inventory[0], items[0], 64*8);
	  for i := 0 to 14 do
	  begin
	  	if((Player[index].trade.Itens[i].Index <> 0) and ((Player[index].trade.TradeItemSlot[i] > -1) and (Player[index].trade.TradeItemSlot[i] < 64)))then
      begin
	  		ZeroMemory(@items[Player[index].trade.TradeItemSlot[i]],8);
        CreateItem(index,INV_TYPE,Player[index].trade.TradeItemSlot[i],items[Player[index].trade.TradeItemSlot[i]]);
      end;
	  end;
    move(items[0],Player[index].Char.Inventory[0],64*8);

    for i := 1 to qitem do
      for j := 0 to 63 do
      begin
        if(Player[otherClientid].Char.Inventory[j].Index = 0)then
        begin
          Move(Player[index].trade.itens[i-1], Player[otherClientid].Char.Inventory[j], 8);
          CreateItem(otherClientId,INV_TYPE,j,Player[index].trade.itens[i-1]);
          break;
        end;
      end;
  end;
end;

function Functions.GetExpApply(exp, index, mobindex: integer): integer;
var attackerLevel, targetLevel: WORD; multiexp,i: integer;
begin
  attackerLevel := Player[index].Char.bStatus.Level;
  if (mobindex > 1000) then
	  targetLevel   := NpcMob[mobindex].NPC.bStatus.Level
  else
    targetLevel   := Player[mobindex].Char.Status.Level;
  inc(attackerLevel);
	inc(targetLevel);

	multiexp := (targetLevel * 100) div attackerLevel;
	if(multiexp < 80) and (attackerLevel >= 50)then
		multiexp := (multiexp * 2) - 100
	else if(multiexp > 200)then
		multiexp := 200;

	if(multiexp < 0)then
		multiexp := 0;

	exp := exp * multiexp div 100;

	for i := 0 to 15 do
	begin
		if(Player[index].Char.affects[i].Index = 39)then//Bau de XP
		begin
			exp := exp * 2;
      break;
		end;
	end;

	//Fadas de XP
	case(Player[index].Char.Equip[13].Index)of
		3900, //
    3903, //
		3906, // Fadas Verdes
		3911, //
		3912, //
		3913, //

		3902, //
		3905, // Fadas Vermelhas
		3908, //

		3914: // Fada Prateada
			exp := exp + ((exp * 16) div 100);

		3915: // Fada Dourada
			exp := exp + ((exp * 18) div 100);
	end;
  /*
	if(pMob[attacker].MOB.MobType == SUBCELESTIAL) //reduz a xp em 75%
		exp / 3;
	else if(pMob[attacker].MOB.MobType == CELESTIAL) //reduz a xp em 50%
		exp / 2;
  */

	result := exp;
end;
}
end.


//Falta fazer:
//Trade
//Guilds
//Levelup e ExpControl
//Npcs Attack AI
//Skills



