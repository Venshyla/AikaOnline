
unit Aylin;

interface

Uses MiscData, PlayerData,
   Windows, Messages, SysUtils, Variants, Classes,Graphics,
   Controls, Forms, Dialogs, ScktComp, Packets, StdCtrls, Player, MMSystem;


  type
    AylinClass = class(TObject)
    public
      function GetMatchCombine(quantidade : integer) : integer;
      procedure GetRefineMachine(var item, item2: TItem; var player : TPlayer; slot, sanc: BYTE);
      procedure AylinProc(var player : TPlayer; packet : TCompoundersPacket);
  end;

implementation

Uses GlobalDefs, NpcFunctions, ItemFunctions;

procedure AylinClass.AylinProc(var player : TPlayer; packet : TCompoundersPacket);
var i : WORD; find : boolean; quant : BYTE; quant2, sanc : integer;	item1 : integer; item2 : integer;
    anct : integer; idjoia : WORD; timesrv : integer; chance : integer;
begin

end;

procedure AylinClass.GetRefineMachine(var item, item2: TItem; var player : TPlayer; slot, sanc: BYTE);
begin

end;

function AylinClass.GetMatchCombine(quantidade : integer) : integer;
var chance : integer; i,value : integer;
begin
	chance := 12; //chance inicial
	value := 2;   //base
	for i := 0 to quantidade do //exponente
	begin;
		value := value * 2;
	end;
	inc(chance,value);
	if (quantidade = 3) then
	begin;
		dec(chance); //15% ¬¬
	end;
	{
	1 jóia: +4% Sucesso.
    2 jóias: +8% Sucesso.
    3 jóias: +15% Sucesso.
    4 jóias: +32% Sucesso.
	}
	if (chance > 32) then result := 32 else result := chance;

end;

end.

