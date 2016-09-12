unit CombatHandlers;

interface


// 39D, 39E, 36C
// 39E -> Desnecessário da Huntress
// 36C -> Ataque em área
// 39D -> Ataque com um alvo


Uses PlayerData, BaseMob, MiscData, ItemFunctions, Log,
   Windows, Messages, SysUtils, Variants, Classes, Graphics, DateUtils,
   Controls, Forms, Dialogs, ScktComp, Packets, StdCtrls, Player, MMSystem,
   Generics.Collections, Functions, BMBuffs, HTBuffs, TKBuffs, FMBuffs;

  type TCombatHandlers = class(TObject)

    public
      class var SkillMethods : TDictionary<byte, TMethod>;

      class procedure RegisterSkills; static;

      class function GetSkillDamage(var attacker : TBaseMob; SkillId, weather, weapondamage: integer): integer; static;

      class function HandleAttack(var attacker : TBaseMob; targetId : WORD; skillId : Integer; cooldown: Boolean = true) : boolean; overload; static;
      class function HandleSingleTarget(var attacker : TBaseMob; var buffer : array of Byte) : boolean; static;
      class function HandleAoE(var attacker : TBaseMob; var buffer : array of Byte) : boolean; static;

    private
      class function CheckSkill(const mob: TBaseMob; skillId : Int16): boolean; static;
      class function DiscountMP(var attacker : TBaseMob; skillId : Int16) : boolean; static;
  end;

type TSingleTargetSkill = procedure(var attacker, target: TBaseMob; skillId : Byte) of object;
type TAoESkill = procedure(var attacker, target: TBaseMob; packet: TProcessAoEAttack) of object;

implementation

Uses GlobalDefs;


class procedure TCombatHandlers.RegisterSkills;
var skill: TSkillData;
    ProcName: string;
    Routine: TMethod;
label
  fim;
begin
  SkillMethods := TDictionary<byte, TMethod>.Create(SkillsData.Count);

  for skill in SkillsData do
  begin
    ProcName := StringReplace(skill.Name, 'ç', 'c', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'é', 'e', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ú', 'u', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'á', 'a', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'í', 'i', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ã', 'a', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'ê', 'e', [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, '_', '' , [rfReplaceAll, rfIgnoreCase]);
    ProcName := StringReplace(ProcName, 'â', 'a', [rfReplaceAll, rfIgnoreCase]);

    if (skill.Index >= 0) and (skill.Index <= 23) then
    begin //TK
      Routine.Data := Pointer(TKBuffs.TTKBuffs);
      Routine.Code := TKBuffs.TTKBuffs.MethodAddress(ProcName);
    end
    else if (skill.Index >= 24) and (skill.Index <= 47) then
    begin //FM
      Routine.Data := Pointer(FMBuffs.TFMBuffs);
      Routine.Code := FMBuffs.TFMBuffs.MethodAddress(ProcName);
    end
    else if (skill.Index >= 48) and (skill.Index <= 71) then
    begin //BM
      Routine.Data := Pointer(BMBuffs.TBMBuffs);
      Routine.Code := BMBuffs.TBMBuffs.MethodAddress(ProcName);
    end
    else if (skill.Index >= 72) and (skill.Index <= 95) then
    begin //HT
      Routine.Data := Pointer(HTBuffs.THTBuffs);
      Routine.Code := HTBuffs.THTBuffs.MethodAddress(ProcName);
    end;

    if (Assigned(Routine.Code)) then
      SkillMethods.Add(skill.Index, Routine);
  end;
end;

class function TCombatHandlers.HandleAoE(var attacker: TBaseMob; var buffer: array of Byte): boolean;
var packet: TProcessAoEAttack absolute buffer;
    targetId : WORD;
  i: Integer;
begin
  result := true;
  for i := 0 to 12 do
  begin
    targetId := packet.Targets[i].Index;
    HandleAttack(attacker, targetId, packet.SkillIndex, false);
  end;
  attacker.UsedSkill(packet.SkillIndex);
end;

class function TCombatHandlers.HandleSingleTarget(var attacker: TBaseMob; var buffer: array of byte) : boolean;
var packet: TProcessAttackOneMob absolute buffer;
begin
  result := true;
  HandleAttack(attacker, packet.Target.Index, packet.SkillIndex);
end;


class function TCombatHandlers.HandleAttack(var attacker: TBaseMob; targetId: WORD; skillId: Integer; cooldown: Boolean): boolean;
var target : TBaseMob; damage : integer;
begin
  result := false;

  if not(attacker.IsActive) or not(TBaseMob.GetMob(targetId, target)) then exit;

  if (skillId <> -1) AND not(attacker.CheckCooldown(skillId)) then
    exit;

  if not CheckSkill(attacker, skillId) then exit;
  if not DiscountMP(attacker, skillId) then exit;

//  attacker.AddToEnemyList(target);
  result := true;

  if skillId = -1 then
  begin
    attacker.SendDamage(target, skillId);
    exit;
  end;

  if (SkillsData[skillId].TargetType = 0) and (attacker.ClientId <> target.ClientId) then
  begin
    // 0- Si mesmo; 1- inimigo; 2- outro player; 3- skill em volta do player(suponho); 4- skill em area
    result := False;
    exit;
  end;

  if not(SkillMethods.ContainsKey(skillId)) then
  begin
    damage := GetSkillDamage(attacker, skillId, 0, attacker.LeftDamage + attacker.RightDamage);
    //falta calcular a defesa do oponente
    attacker.SendDamage(target, skillId, damage);
  end
  else
    TSingleTargetSkill(SkillMethods[skillId])(attacker, target, skillId);

  if cooldown then attacker.UsedSkill(skillId);
end;

class function TCombatHandlers.CheckSkill(const mob: TBaseMob; skillId: Int16): boolean;
begin
  if(skillId = -1) then
  begin
    result := true;
    exit;
  end;

  result := false;

  {if not(SkillMethods.ContainsKey(skillId)) then
  begin
    if(mob.IsPlayer) then
      Players[mob.ClientId].SendClientMessage('Essa Skill ainda não foi implementada');
    exit;
  end;}

  if not(mob.Character.HaveSkill(skillId)) then
  begin
    if(mob.IsPlayer) then
      Players[mob.ClientId].SendClientMessage('Você não possui essa Skill');
    exit;
  end;
  result := true;
end;

class function TCombatHandlers.DiscountMP(var attacker : TBaseMob; skillId: Int16): boolean;
var mp: Integer;
begin
  if(skillId = -1) THEN
  begin
    result := true;
    exit;
  end;

  mp := attacker.Character.CurrentScore.CurMP - SkillsData[skillId].ManaSpent;
  if(mp < 0) then
  begin
    result := false;
    exit;
  end;
  attacker.Character.CurrentScore.CurMP := mp;
  attacker.SendCurrentHPMP;
  result := true;
end;

class function TCombatHandlers.GetSkillDamage(var attacker : TBaseMob; SkillId, weather, weapondamage: integer): integer;
var SkillInstanceType, SkillMaster, Level, MobAprend, SkillInstanceValue,
SkillAffectValue, calcSkillDmg, calcSkillNum: integer;
begin
	SkillInstanceType := strtoint(SkillsData[SkillId].InstanceType);
	SkillMaster := ((SkillId mod 24) shr 3) + 1;
	Level := attacker.Character.CurrentScore.Level;
	if(Level < 0) then
		Level := 0;

  {
  if(mob->Evol == MORTAL) or  (mob->Evol == ARCH) then
	begin
		if(Level >= MAX_LEVELMA) then
			Level := MAX_LEVELMA;
	end
	else
	begin
		if(Level >= 199)
			Level := 199;
	end;
  }

  case SkillMaster of
    0: MobAprend := attacker.Character.CurrentScore.wMaster;
    1: MobAprend := attacker.Character.CurrentScore.fMaster;
    2: MobAprend := attacker.Character.CurrentScore.sMaster;
    3: MobAprend := attacker.Character.CurrentScore.tMaster;
  end;


	SkillInstanceValue := strtoint(SkillsData[SkillId].InstanceValue);
	SkillAffectValue := strtoint(SkillsData[SkillId].AffectValue);
	calcSkillDmg := 0;

	if(SkillInstanceType = 0)then
	begin
		if(SkillId = 11) then
			calcSkillDmg := (MobAprend div 10) + SkillAffectValue;
		if(SkillId = 13) then
			calcSkillDmg := ((MobAprend * 3) shr 2) + SkillAffectValue;
		if(SkillId = 41) then
			calcSkillDmg := (MobAprend div 25) + 2;
		if(SkillId = 43) then
			calcSkillDmg := (MobAprend div 3) + SkillAffectValue;
		if(SkillId = 44) then
			calcSkillDmg := ((((MobAprend * 3) div 20) + SkillAffectValue) shr 1);
		if(SkillId = 45) then
			calcSkillDmg := (MobAprend div 10) + SkillAffectValue;

		result := calcSkillDmg;
    exit;
	end;
	if(SkillInstanceType >= 1) and (SkillInstanceType <= 5)then
	begin
		calcSkillNum := SkillId shr 3;

		if(SkillId = 97)then
			calcSkillDmg := (Level * 15) + SkillInstanceValue
		else if((not(Boolean(attacker.Character.ClassInfo))) and (calcSkillNum = 1))then
			calcSkillDmg := (SkillInstanceValue + MobAprend + (Level shr 1) + (attacker.Character.CurrentScore.Attack shr 1) + (weapondamage * 3))
		else if((not(Boolean(attacker.Character.ClassInfo))) and (calcSkillNum <> 1)) then
			calcSkillDmg := ((SkillInstanceValue + MobAprend) + ((Level shr 1) + weapondamage + (attacker.Character.CurrentScore.Str shr 2)))
		else if((attacker.Character.ClassInfo = 1) or (attacker.Character.ClassInfo = 2))then
			calcSkillDmg := (SkillInstanceValue + MobAprend + (Level shr 1) + (attacker.Character.CurrentScore.INT div 3))
		else if(attacker.Character.ClassInfo = 3)then
			calcSkillDmg := (SkillInstanceValue + MobAprend + (Level shr 1) + (attacker.Character.CurrentScore.STR shr 1) + (weapondamage * 3));

		if(weather = 1) then
		begin
			if(SkillInstanceType = 2)then
				calcSkillDmg := calcSkillDmg * 90 div 100;
			if(SkillInstanceType = 5)then
				calcSkillDmg := calcSkillDmg * 130 div 100;
		end
		else if(weather = 2) and (SkillInstanceType = 3)then
			calcSkillDmg := calcSkillDmg * 120 div 100;

		if(SkillId = 97)then
			calcSkillDmg := calcSkillDmg
		else if((Boolean(attacker.Character.ClassInfo)) or (calcSkillNum <> 1))then
		begin
			if(attacker.Character.ClassInfo = 3) then
				calcSkillDmg := ((calcSkillDmg * 5) shl 2)
			else
			begin
				calcSkillDmg := ((((attacker.Character.MagicIncrement * 2) + 100) * calcSkillDmg) div 100);
				calcSkillDmg := ((calcSkillDmg * 5) shr 2);
			end;
		end
		else
			calcSkillDmg := ((calcSkillDmg * 5) shr 2);

		result := calcSkillDmg;
    exit;
	end
	else if(SkillInstanceType = 6) then
		calcSkillDmg := (((MobAprend * 3) shr 1) + SkillInstanceValue)
	else if(SkillInstanceType = 11) then
		calcSkillDmg := SkillInstanceValue
	else
		calcSkillDmg := attacker.Character.MagicIncrement;

	result := calcSkillDmg;
end;

end.
