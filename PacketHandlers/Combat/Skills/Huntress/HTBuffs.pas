unit HTBuffs;

interface

Uses PlayerData, BaseMob, MiscData, ItemFunctions, Log,
   Windows, Messages, SysUtils, Variants, Classes, DateUtils,
   Packets, Player, Generics.Collections, Functions;

  type THTBuffs = class(TObject)
  published
    procedure EncantarGelo(var attacker, target: TBaseMob; skillId: Byte);
    procedure EscudoDourado(var attacker, target: TBaseMob; skillId: Byte);
    procedure EvasaoAprimorada(var attacker, target: TBaseMob; skillId: Byte);
    procedure Imunidade(var attacker, target: TBaseMob; skillId: Byte);
    procedure ToxinaDeSerpente(var attacker, target: TBaseMob; skillId: Byte);
    procedure TrocaDeEspirito(var attacker, target: TBaseMob; skillId: Byte);
    procedure LigacaoEspectral(var attacker, target : TBaseMob; skillId : Byte);
    procedure TempestadeDeRaios(var attacker, target : TBaseMob; skillId : Byte);
  end;

implementation

Uses GlobalDefs, CombatHandlers;

var Affects : TAffect;

procedure THTBuffs.LigacaoEspectral(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 37;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.sMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.sMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure THTBuffs.EncantarGelo(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 27;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.fMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.fMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure THTBuffs.Imunidade(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 19;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.fMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.fMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure THTBuffs.TrocaDeEspirito(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 38;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.sMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.sMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure THTBuffs.EscudoDourado(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 31;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.sMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.sMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure THTBuffs.EvasaoAprimorada(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 26;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure THTBuffs.ToxinaDeSerpente(var attacker, target : TBaseMob; skillId : Byte);
begin
  Affects.Index  := 36;
  Affects.Master := 1;
  Affects.Value  := attacker.Character.CurrentScore.tMaster;
  Affects.Time   := ((SkillsData[skillId].AffectTime div 2) + (attacker.Character.CurrentScore.tMaster div 5));

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

procedure THTBuffs.TempestadeDeRaios(var attacker, target : TBaseMob; skillId : Byte);
var damage: integer;
begin
  damage := TCombatHandlers.GetSkillDamage(attacker, skillId, 0, attacker.LeftDamage + attacker.RightDamage);

  target.AddAffect(Affects);
  target.SendAffects();
  target.GetCurrentScore();
  target.SendScore();
end;

end.
