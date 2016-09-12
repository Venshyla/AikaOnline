unit FMBuffs;

interface

Uses PlayerData, BaseMob, MiscData, ItemFunctions, Log,
   Windows, Messages, SysUtils, Variants, Classes, Graphics, DateUtils,
   Controls, Forms, Dialogs, ScktComp, Packets, StdCtrls, Player, MMSystem,
   Generics.Collections, Functions;

  type TFMBuffs = class(TObject)
  published
    procedure Cancelamento(var attacker, target: TBaseMob; skillId: Byte);
    procedure ControledeMana(var attacker, target: TBaseMob; skillId: Byte);
    procedure EscudoMagico(var attacker, target: TBaseMob; skillId: Byte);
    procedure ToquedaAthena(var attacker, target: TBaseMob; skillId: Byte);
    procedure Velocidade(var attacker, target: TBaseMob; skillId: Byte);
    procedure ArmaMagica(var attacker, target : TBaseMob; skillId : Byte);
    procedure Trovao(var attacker, target : TBaseMob; skillId : Byte);
    procedure NevoaVenenosa(var attacker, target : TBaseMob; skillId : Byte);
    procedure Cura(var attacker, target: TBaseMob; skillId: Byte);
    procedure Flash(var attacker, target : TBaseMob; skillId : Byte);
    procedure Recuperar(var attacker, target : TBaseMob; skillId : Byte);
    procedure Renascimento(var attacker, target : TBaseMob; skillId : Byte);
  end;

implementation

Uses GlobalDefs;

var Affects : TAffect;

procedure TFMBuffs.ArmaMagica(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 9;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.EscudoMagico(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 11;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.ToquedaAthena(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 15;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.ControledeMana(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 18;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.Velocidade(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 2;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.Cancelamento(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 32;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.Trovao(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 22;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.sMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.sMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.NevoaVenenosa(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 20;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.Cura(var attacker, target : TBaseMob; skillId : Byte);
var damage : integer;
begin
  damage := ((attacker.Character.CurrentScore.fMaster * 3) div 2);
  if(target.ClientId < 1000) then
  begin
    inc(target.Character.CurrentScore.curHP,damage);
    attacker.SendDamage(target, skillId, damage);
  end;
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.Flash(var attacker, target : TBaseMob; skillId : Byte);
begin
  attacker.SendDamage(target, skillId, 0);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TFMBuffs.Recuperar(var attacker, target : TBaseMob; skillId : Byte);
var damage : integer;
begin
  damage := ((attacker.Character.CurrentScore.fMaster * 3) div 2);
  if(attacker.ClientId < 1000) then
  begin
    inc(attacker.Character.CurrentScore.curHP,damage);
    attacker.SendDamage(attacker, skillId, damage);
  end;
  attacker.SendAffects();
  attacker.GetCurrentScore();
  attacker.SendScore();
end;

procedure TFMBuffs.Renascimento(var attacker, target : TBaseMob; skillId : Byte);
var damage: integer;
begin
  damage := (target.Character.CurrentScore.maxHP * ((target.Character.CurrentScore.fMaster div 12)+30)) div 100;

  target.Character.CurrentScore.maxHP := damage;
  attacker.SendDamage(target, skillId, damage);

  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

end.
