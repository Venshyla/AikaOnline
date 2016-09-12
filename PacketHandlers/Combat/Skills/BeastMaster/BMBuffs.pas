unit BMBuffs;

interface

Uses PlayerData, BaseMob, MiscData, ItemFunctions, Log,
   Windows, Messages, SysUtils, Variants, Classes, Graphics, DateUtils,
   Controls, Forms, Dialogs, ScktComp, Packets, StdCtrls, Player, MMSystem,
   Generics.Collections, Functions;

  type TBMBuffs = class(TObject)
  published
    procedure ChangeFace(var attacker, target : TBaseMob; skillId, face, vdiv, master : Byte);
    procedure Lobisomem(var attacker, target : TBaseMob; skillId : Byte);
    procedure Astaroth(var attacker, target: TBaseMob; skillId: Byte);
    procedure Eden(var attacker, target: TBaseMob; skillId: Byte);
    procedure HomemUrso(var attacker, target: TBaseMob; skillId: Byte);
    procedure Tita(var attacker, target: TBaseMob; skillId: Byte);
  end;

implementation

Uses GlobalDefs;

var Affects : TAffect;

procedure TBMBuffs.ChangeFace(var attacker, target : TBaseMob; skillId, face, vdiv, master : Byte);
var sanc : BYTE;
begin

end;

procedure TBMBuffs.Lobisomem(var attacker, target : TBaseMob; skillId : Byte);
begin
  ChangeFace(attacker, target, skillId, 22, 25, 1);
end;

procedure TBMBuffs.HomemUrso(var attacker, target : TBaseMob; skillId : Byte);
begin
  ChangeFace(attacker, target, skillId, 23, 25, 2);
end;

procedure TBMBuffs.Astaroth(var attacker, target : TBaseMob; skillId : Byte);
begin
  ChangeFace(attacker, target, skillId, 24, 25, 3);
end;

procedure TBMBuffs.Tita(var attacker, target : TBaseMob; skillId : Byte);
begin
  ChangeFace(attacker, target, skillId, 25, 25, 4);
end;

procedure TBMBuffs.Eden(var attacker, target : TBaseMob; skillId : Byte);
begin
  ChangeFace(attacker, target, skillId, 32, 25, 5);
end;

end.
