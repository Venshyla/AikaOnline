unit TKBuffs;

interface

Uses PlayerData, BaseMob, MiscData, ItemFunctions, Log,
   Windows, Messages, SysUtils, Variants, Classes, DateUtils,
   Packets, Player,
   Generics.Collections, Functions;

  type TTKBuffs = class(TObject)
  published
    procedure Assalto(var attacker, target: TBaseMob; skillId: Byte);
    procedure AuradaVida(var attacker, target: TBaseMob; skillId: Byte);
    procedure Perseguicao(var attacker, target: TBaseMob; skillId: Byte);
    procedure Samaritano(var attacker, target: TBaseMob; skillId: Byte);
  end;

implementation

Uses GlobalDefs;

var Affects : TAffect;

procedure TTKBuffs.Samaritano(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 24;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.fMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.fMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TTKBuffs.AuradaVida(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 17;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.fMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.fMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TTKBuffs.Assalto(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 13;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.sMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.sMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure TTKBuffs.Perseguicao(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 13;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.sMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.sMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

end.
