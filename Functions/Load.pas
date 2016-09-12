unit Load;

interface

uses Windows, SysUtils, Classes, MiscData, PlayerData, Dialogs, Functions, NPC;

type TLoad = class
  public
    class procedure InitCharacters(); static;
    class procedure ItemsList(); static;
    class procedure MobList(); static;
    class procedure QuestList(); static;
    class procedure InstantiateNPCs; static;
    class function InstantiateNPC(var npc: TNpc; var npcId: WORD; var errorsCount, errorsRead: Integer; const mobGenerData: TMOBGener; leaderId: Integer) : Boolean; static;
    class procedure TeleportList(); static;
    class function HeightMap: Boolean; static;
    class procedure SkillData(); static;
    class procedure MobBaby(); static;
end;

Const
  MAX_ITEMLIST = 6500;

implementation
{ TLoad }

uses GlobalDefs, Log, Util, Generics.Collections;

class function TLoad.HeightMap: Boolean;
var f: file of THeightMap;
  local: string;
begin
  ZeroMemory(@HeightGrid, SizeOf(THeightMap));
  local := 'HeightMap.dat';
  AssignFile(f, local);
  Reset(f);
  Read(f, HeightGrid);
  CloseFile(f);

  Logger.Write('HeightMap carregado com sucesso!', TLogType.ServerStatus);
  Result := true;
end;

class procedure TLoad.InitCharacters;
begin
  ZeroMemory(@InitialCharacters[0], 6 * sizeof(TCharacter));

  //Guerreiro
  InitialCharacters[0].ClassInfo                 := 01; InitialCharacters[0].Level                     := 01;
  InitialCharacters[0].CurrentScore.str          := 15; InitialCharacters[0].CurrentScore.Int          := 05;
  InitialCharacters[0].CurrentScore.agility      := 09; InitialCharacters[0].CurrentScore.Cons         := 16;
  InitialCharacters[0].CurrentScore.Sizes.Altura := $07; InitialCharacters[0].CurrentScore.Sizes.Tronco := $77;
  InitialCharacters[0].CurrentScore.Sizes.Perna  := $77; InitialCharacters[0].CurrentScore.Sizes.Corpo  := $01;
  InitialCharacters[0].CurrentScore.CurHP       := 404; InitialCharacters[0].CurrentScore.MaxHP        := 404;
  InitialCharacters[0].CurrentScore.CurMP       := 202; InitialCharacters[0].CurrentScore.MaxMP        := 202;
  InitialCharacters[0].CurrentScore.pSkill:=0;          InitialCharacters[0].Gold:= 1000;
  InitialCharacters[0].Equip[3].Index:= 1719; InitialCharacters[0].Equip[3].MIN:= 100;InitialCharacters[0].Equip[3].MAX:= 100;
  InitialCharacters[0].Equip[3].APP  := 1719;
  InitialCharacters[0].Equip[5].Index:= 1779; InitialCharacters[0].Equip[5].MIN:= 100;InitialCharacters[0].Equip[5].MAX:= 100;
  InitialCharacters[0].Equip[5].APP:= 1779;
  InitialCharacters[0].Equip[6].Index:= 1069; InitialCharacters[0].Equip[6].MIN:= 160;InitialCharacters[0].Equip[6].MAX:= 160;
  InitialCharacters[0].Equip[6].APP:= 1069;

  //templario
  InitialCharacters[1].ClassInfo                 := 11; InitialCharacters[1].Level                      := 01;
  InitialCharacters[1].CurrentScore.str          := 14; InitialCharacters[1].CurrentScore.Int           := 06;
  InitialCharacters[1].CurrentScore.agility      := 10; InitialCharacters[1].CurrentScore.Cons          := 14;
  InitialCharacters[1].CurrentScore.Sizes.Altura := $07; InitialCharacters[1].CurrentScore.Sizes.Tronco  := $77;
  InitialCharacters[1].CurrentScore.Sizes.Perna  := $77; InitialCharacters[1].CurrentScore.Sizes.Corpo   := $00;
  InitialCharacters[1].CurrentScore.CurHP        := 383; InitialCharacters[1].CurrentScore.MaxHP        := 383;
  InitialCharacters[1].CurrentScore.CurMP        := 272; InitialCharacters[1].CurrentScore.MaxMP        := 272;
  InitialCharacters[1].CurrentScore.pSkill:=0;           InitialCharacters[1].Gold:= 1000;
  InitialCharacters[1].Equip[3].Index:= 1839; InitialCharacters[1].Equip[3].MIN:= 120;InitialCharacters[1].Equip[3].MAX:= 120;
  InitialCharacters[1].Equip[3].app:= 1839;
  InitialCharacters[1].Equip[5].Index:= 1899; InitialCharacters[1].Equip[5].MIN:= 120;InitialCharacters[1].Equip[5].MAX:= 120;
  InitialCharacters[1].Equip[5].app:= 1899;
  InitialCharacters[1].Equip[6].Index:= 1034; InitialCharacters[1].Equip[6].MIN:= 140;InitialCharacters[1].Equip[6].MAX:= 140;
  InitialCharacters[1].Equip[6].app:= 1034;
  InitialCharacters[1].Equip[15].Index:= 1309; InitialCharacters[1].Equip[15].MIN:= 120;InitialCharacters[1].Equip[15].MAX:= 120;
  InitialCharacters[1].Equip[15].app:= 1309;

  //Atirador
  InitialCharacters[2].ClassInfo                 := 21; InitialCharacters[2].Level                      := 01;
  InitialCharacters[2].CurrentScore.str          := 08; InitialCharacters[2].CurrentScore.Int           := 09;
  InitialCharacters[2].CurrentScore.agility      := 16; InitialCharacters[2].CurrentScore.Cons          := 12;
  InitialCharacters[2].CurrentScore.Luck         := 05;
  InitialCharacters[2].CurrentScore.Sizes.Altura := $07; InitialCharacters[2].CurrentScore.Sizes.Tronco  := $77;
  InitialCharacters[2].CurrentScore.Sizes.Perna  := $77; InitialCharacters[2].CurrentScore.Sizes.Corpo   := $00;
  InitialCharacters[2].CurrentScore.CurHP        := 343; InitialCharacters[2].CurrentScore.MaxHP        := 343;
  InitialCharacters[2].CurrentScore.CurMP        := 252; InitialCharacters[2].CurrentScore.MaxMP        := 252;
  InitialCharacters[2].CurrentScore.pSkill:=0;           InitialCharacters[2].Gold:= 1000;
  InitialCharacters[2].Equip[3].Index:= 1959; InitialCharacters[2].Equip[3].MIN:= 80;InitialCharacters[2].Equip[3].MAX:= 80;
  InitialCharacters[2].Equip[3].app:= 1959;
  InitialCharacters[2].Equip[5].Index:= 2019; InitialCharacters[2].Equip[5].MIN:= 80;InitialCharacters[2].Equip[5].MAX:= 80;
  InitialCharacters[2].Equip[5].app:= 2019;
  InitialCharacters[2].Equip[6].Index:= 1209; InitialCharacters[2].Equip[6].MIN:= 160;InitialCharacters[2].Equip[6].MAX:= 160;
  InitialCharacters[2].Equip[6].app:= 1209;
  //Pistoleiro
  InitialCharacters[3].ClassInfo                 := 31; InitialCharacters[3].Level                      := 01;
  InitialCharacters[3].CurrentScore.str          := 08; InitialCharacters[3].CurrentScore.Int           := 10;
  InitialCharacters[3].CurrentScore.agility      := 14; InitialCharacters[3].CurrentScore.Cons          := 12;
  InitialCharacters[3].CurrentScore.Luck         := 06;
  InitialCharacters[3].CurrentScore.Sizes.Altura := $07; InitialCharacters[3].CurrentScore.Sizes.Tronco  := $77;
  InitialCharacters[3].CurrentScore.Sizes.Perna  := $77; InitialCharacters[3].CurrentScore.Sizes.Corpo   := $00;
  InitialCharacters[3].CurrentScore.CurHP        := 323; InitialCharacters[3].CurrentScore.MaxHP        := 323;
  InitialCharacters[3].CurrentScore.CurMP        := 282; InitialCharacters[3].CurrentScore.MaxMP        := 282;
  InitialCharacters[3].CurrentScore.pSkill:=0;           InitialCharacters[3].Gold:= 1000;
  InitialCharacters[3].Equip[3].Index:= 2079; InitialCharacters[3].Equip[3].MIN:= 80;InitialCharacters[3].Equip[3].MAX:= 80;
  InitialCharacters[3].Equip[3].app:= 2079;
  InitialCharacters[3].Equip[5].Index:= 2139; InitialCharacters[3].Equip[5].MIN:= 80;InitialCharacters[3].Equip[5].MAX:= 80;
  InitialCharacters[3].Equip[5].app:= 2139;
  InitialCharacters[3].Equip[6].Index:= 1174; InitialCharacters[3].Equip[6].MIN:= 140;InitialCharacters[3].Equip[6].MAX:= 140;
  InitialCharacters[3].Equip[6].app:= 1174;
  //Feiticeiro Negro
  InitialCharacters[4].ClassInfo                 := 41; InitialCharacters[4].Level                      := 01;
  InitialCharacters[4].CurrentScore.str          := 07; InitialCharacters[4].CurrentScore.Int           := 16;
  InitialCharacters[4].CurrentScore.agility      := 09; InitialCharacters[4].CurrentScore.Cons          := 08;
  InitialCharacters[4].CurrentScore.Luck         := 10;
  InitialCharacters[4].CurrentScore.Sizes.Altura := $07; InitialCharacters[4].CurrentScore.Sizes.Tronco  := $77;
  InitialCharacters[4].CurrentScore.Sizes.Perna  := $77; InitialCharacters[4].CurrentScore.Sizes.Corpo   := $00;
  InitialCharacters[4].CurrentScore.CurHP        := 323; InitialCharacters[4].CurrentScore.MaxHP        := 323;
  InitialCharacters[4].CurrentScore.CurMP        := 654; InitialCharacters[4].CurrentScore.MaxMP        := 654;
  InitialCharacters[4].CurrentScore.pSkill:=0;           InitialCharacters[4].Gold:= 1000;
  InitialCharacters[4].Equip[3].Index:= 2199; InitialCharacters[4].Equip[3].MIN:= 60;InitialCharacters[4].Equip[3].MAX:= 60;
  InitialCharacters[4].Equip[3].app:= 2199;
  InitialCharacters[4].Equip[5].Index:= 2259; InitialCharacters[4].Equip[5].MIN:= 60;InitialCharacters[4].Equip[5].MAX:= 60;
  InitialCharacters[4].Equip[5].app:= 2259;
  InitialCharacters[4].Equip[6].Index:= 1279; InitialCharacters[4].Equip[6].MIN:= 160;InitialCharacters[4].Equip[6].MAX:= 160;
  InitialCharacters[4].Equip[6].app:= 1279;
  //Clerigo
  InitialCharacters[5].ClassInfo                 := 51; InitialCharacters[5].Level                      := 01;
  InitialCharacters[5].CurrentScore.str          := 07; InitialCharacters[5].CurrentScore.Int           := 15;
  InitialCharacters[5].CurrentScore.agility      := 10; InitialCharacters[5].CurrentScore.Cons          := 09;
  InitialCharacters[5].CurrentScore.Luck         := 09;
  InitialCharacters[5].CurrentScore.Sizes.Altura := $07; InitialCharacters[5].CurrentScore.Sizes.Tronco  := $77;
  InitialCharacters[5].CurrentScore.Sizes.Perna  := $77; InitialCharacters[5].CurrentScore.Sizes.Corpo   := $00;
  InitialCharacters[5].CurrentScore.CurHP        := 302; InitialCharacters[5].CurrentScore.MaxHP        := 302;
  InitialCharacters[5].CurrentScore.CurMP        := 545; InitialCharacters[5].CurrentScore.MaxMP        := 545;
  InitialCharacters[5].CurrentScore.pSkill:=0;           InitialCharacters[5].Gold:= 1000;
  InitialCharacters[5].Equip[3].Index:= 2319; InitialCharacters[5].Equip[3].MIN:= 60;InitialCharacters[5].Equip[3].MAX:= 60;
  InitialCharacters[5].Equip[3].app:= 2319;
  InitialCharacters[5].Equip[5].Index:= 2379; InitialCharacters[5].Equip[5].MIN:= 60;InitialCharacters[5].Equip[5].MAX:= 60;
  InitialCharacters[5].Equip[5].app:= 2379;
  InitialCharacters[5].Equip[6].Index:= 1244; InitialCharacters[5].Equip[6].MIN:= 140;InitialCharacters[5].Equip[6].MAX:= 140;
  InitialCharacters[5].Equip[6].app:= 1244;
end;

class procedure TLoad.ItemsList;
var f: TFileStream;
buffer: array of BYTE;
local: string;
I,j, size: Integer;
ItemListB: array of TItemList;
Item : TItemList;
begin
  local:=getcurrentdir+'\ItemList.bin';

  if not(FileExists(local)) then
  begin
    showmessage('Arquivo não encontrado. Coloque o ItemList.bin na mesma pasta que o Leitor de ItemList.');
    exit;
  end;

  F := TFileStream.Create(local, fmOpenRead);
  size := F.Size;
  SetLength(buffer,size);
  F.Read(buffer[0],size);
  F.Free;

  for I := 0 to size do
  begin
    buffer[i] := $5A xor buffer[i];
  end;

  setlength(ItemListB, Round(size/140));
  Move(buffer[0], ItemListB[0], size);

  j := Round(size/140);
  for I := 0 to j do
  begin
    //ZeroMemory(@Item,sizeof(TItemList));
    //Move(ItemListB[i].Name[0],Item.Name,sizeof(TItemListConvert));
    //Item.Index := i;
    ItemList.Add(i, ItemListB[i]);
  end;

  Logger.Write('ItemList carregado com sucesso!', TLogType.ServerStatus);
end;

class procedure TLoad.MobBaby;
begin

end;


class function TLoad.InstantiateNPC(var npc: TNpc; var npcId: WORD; var errorsCount, errorsRead: Integer; const mobGenerData: TMOBGener; leaderId: Integer) : Boolean;
begin

end;

class procedure TLoad.InstantiateNPCs;
var errorsCount, errorsRead, i, generId : Integer;
    mobGenerData: TMOBGener;

    leaderCharacterFile, followerCharacterFile: file of TCharacter;
    npcId, followerId, leaderId: WORD;
//    npc, follower : TNpc;
    npcsErrors: string;
begin
  npcId := 1001;
  errorsCount := 0;
  errorsRead  := 0;
  ZeroMemory(@NPCs, SizeOf(NPCs));

  for generId := 0 to (MobGener.Count - 1) do
  begin
    try
      mobGenerData := MobGener[generId];
      if not(InstantiateNpc(NPCs[npcId], npcId, errorsCount, errorsRead, mobGenerData, npcId)) then
      begin
        continue;
      end;

      if(mobGenerData.MinGroup < 1) AND (mobGenerData.MaxGroup < 1) then
        continue;

      leaderId := npcId - 1;
      for followerId := mobGenerData.MinGroup to mobGenerData.MaxGroup do
      begin
        InstantiateNPC(NPCs[npcId], npcId, errorsCount, errorsRead, mobGenerData, leaderId);
      end;
    except
      Inc(errorsRead);
    end;
  end;
  InstantiatedNPCs := npcId;

  if(errorsCount > 0) then
    Logger.Write(IntToStr(errorsCount)+ ' mobs não encontrados!', TLogType.ServerStatus);

  if(errorsRead > 0) then
    Logger.Write(IntToStr(errorsRead) + ' mobs com erro de leitura!', TLogType.ServerStatus);
end;

class procedure TLoad.MobList;
var DataFile : TextFile;
  line : string;
  aux: TMOBGener;
  i : BYTE;
begin
  MobGener.Clear;

  AssignFile(DataFile, 'NPCGener.txt');
  Reset(DataFile);

  ZeroMemory(@aux, sizeof(TMOBGener));
  aux.ID := -1;
  while not EOF(DataFile) do
  begin
    readln(DataFile, line);

    if (Trim(line) = '') then
      continue;

    if Pos('#',line) > 0 then
    begin
      Delete(line, Pos('#',line), 1);
      Delete(line, Pos('[',line), 1);
      Delete(line, Pos(']',line), 1);
      aux.ID := StrToIntDef(Trim(line),0);
      continue;
    end
    else if Pos('MinuteGenerate',line) > 0 then
    begin
      Delete(line,Pos('MinuteGenerate',line),Length('MinuteGenerate'));
      Delete(line,Pos(':',line),1);
      aux.MinuteGenerate := StrToIntDef(Trim(line),0);
    end
    else if Pos('MaxNumMob',line) > 0 then
    begin
      Delete(line,Pos('MaxNumMob',line),Length('MaxNumMob'));
      Delete(line,Pos(':',line),1);
      aux.MaxNumMob := StrToIntDef(Trim(line),0);
    end
    else if Pos('MinGroup',line) > 0 then
    begin
      Delete(line,Pos('MinGroup',line),Length('MinGroup'));
      Delete(line,Pos(':',line),1);
      aux.MinGroup := StrToIntDef(Trim(line),0);
    end
    else if Pos('MaxGroup',line) > 0 then
    begin
      Delete(line,Pos('MaxGroup',line),Length('MaxGroup'));
      Delete(line,Pos(':',line),1);
      aux.MaxGroup := StrToIntDef(Trim(line),0);
    end
    else if Pos('Leader',line) > 0 then
    begin
      Delete(line,Pos('Leader',line), Length('Leader'));
      Delete(line,Pos(':',line),1);
      aux.Leader := Trim(line);
    end
    else if Pos('Follower',line) > 0 then
    begin
      Delete(line,Pos('Follower',line),Length('Follower'));
      Delete(line,Pos(':',line),1);
      aux.Follower := Trim(line);
    end
    else if Pos('RouteType',line) > 0 then
    begin
      Delete(line,Pos('RouteType',line),Length('RouteType'));
      Delete(line,Pos(':',line),1);
      aux.RouteType := StrToIntDef(Trim(line),0);
    end
    else if Pos('Formation',line) > 0 then
    begin
      Delete(line,Pos('Formation',line),Length('Formation'));
      Delete(line,Pos(':',line),1);
      aux.Formation := StrToIntDef(Trim(line),0);
    end
    else if Pos('StartX',line) > 0 then
    begin
      Delete(line,Pos('StartX', line),Length('StartX'));
      Delete(line,Pos(':',line),1);
      aux.SpawnSegment.Position.X := StrToIntDef(Trim(line),0);
    end
    else if Pos('StartY',line) > 0 then
    begin
      Delete(line,Pos('StartY',line),Length('StartY'));
      Delete(line,Pos(':',line),1);
      aux.SpawnSegment.Position.Y := StrToIntDef(Trim(line),0);
    end
    else if Pos('StartWait',line) > 0 then
    begin
      Delete(line,Pos('StartWait',line),Length('StartWait'));
      Delete(line,Pos(':',line), 1);
      aux.SpawnSegment.WaitTime := StrToIntDef(Trim(line),0);
    end
    else if (Pos('Segment',line) > 0) and (Pos('X',line) > 0) then
    begin
      Delete(line,Pos('Segment',line),Length('Segment'));
      i := StrToIntDef(Copy(Trim(line),1,1), 0);
      if i = 0 then
        continue;
      Delete(line,Pos(inttostr(i),line),1);
      Delete(line,Pos('X',line),1);
      Delete(line,Pos(':',line),1);

      aux.AddSegmentData(i, StrToIntDef(Trim(line), 0), -1);
    end
    else if (Pos('Segment',line) > 0) and (Pos('Y', line) > 0) then
    begin
      Delete(line,Pos('Segment',line), Length('Segment'));
      i := StrToIntDef(Copy(Trim(line),1,1), 0);
      if i = 0 then
        continue;
      Delete(line,Pos(inttostr(i),line),1);
      Delete(line,Pos('Y',line),1);
      Delete(line,Pos(':',line),1);
      aux.AddSegmentData(i, -1, StrToIntDef(Trim(line), 0));
    end
    else if (Pos('Segment',line) > 0) and (Pos('Wait', line) > 0) then
    begin
      Delete(line,Pos('Segment',line), Length('Segment'));
      i := StrToIntDef(Copy(Trim(line),1,1), 0);
      if i = 0 then
        continue;
      Delete(line,Pos(inttostr(i),line),1);
      Delete(line,Pos('Wait',line),1);
      Delete(line,Pos(':',line),1);
      aux.AddSegmentData(i, StrToIntDef(Trim(line), 0));
    end
    else if (Pos('Segment',line) > 0) and (Pos('Action', line) > 0) then
    begin
      Delete(line,Pos('Segment',line), Length('Segment'));
      i := StrToIntDef(Copy(Trim(line),1,1), 0);
      if i = 0 then
        continue;
      Delete(line, Pos(inttostr(i),line),1);
      Delete(line, Pos('Action', line), Length('Action'));
      Delete(line, Pos(':',line), 1);
      aux.AddSegmentData(i, Trim(line));
    end
    else if Pos('********************', line) > 0 then
    begin
      if aux.ID = -1 then
        continue;
      MobGener.Add(aux.ID, aux);
      ZeroMemory(@aux, sizeof(TMOBGener));
    end;
  end;
  CloseFile(DataFile);

  TLoad.InstantiateNPCs;
  Logger.Write(IntToStr(InstantiatedNPCs) + ' mobs foram instanciados!', TLogType.ServerStatus)
end;

class procedure TLoad.QuestList;
var DataFile : TextFile;
    lineFile : String;
    fileStrings : TStringList;
    quest: TQuest;
    capacity: Int8;
begin

end;

class procedure TLoad.SkillData;
var DataFile : TextFile;
    lineFile : String;
    fileStrings : TStringList;
    skill : TSkillData;
    skillId : Integer;
begin
  SkillsData.Clear;

  AssignFile(DataFile, 'Skilldata.csv');
  Reset(DataFile);

  fileStrings := TStringList.Create;

  while not EOF(DataFile) do
  begin
    Readln(DataFile, lineFile);
    ExtractStrings([','],[' '],PChar(Linefile),fileStrings);
    if(TFunctions.IsNumeric(fileStrings.strings[0], skillId) = false)then begin
      filestrings.Clear;
      continue;
    end;
    skill.Index         := skillId;
    skill.SkillPoint    := StrToIntDef(fileStrings.Strings[1],0);
    skill.TargetType    := StrToIntDef(fileStrings.Strings[2],-1);
    skill.Name          := fileStrings.Strings[22];
    skill.ManaSpent     := StrToIntDef(fileStrings.Strings[3], 0);
    skill.Delay         := StrToIntDef(fileStrings.Strings[4], 0);

    skill.InstanceType  := fileStrings.Strings[6];
    skill.InstanceValue := fileStrings.Strings[7];
    skill.AffectValue   := fileStrings.Strings[11];
    skill.AffectTime    := StrToIntDef(fileStrings.Strings[12],0);

    filestrings.Clear;
    SkillsData.Add(skill)
  end;
  fileStrings.Free;
  Logger.Write('SkillData carregado com sucesso!', TLogType.ServerStatus);
  CloseFile(DataFile);


end;


class procedure TLoad.TeleportList;
var DataFile : TextFile;
    lineFile : String;
    fileStrings : TStringList;
    teleport : TTeleport;
begin
  TeleportsList.Clear;

  AssignFile(DataFile, 'Teleports.csv');
  Reset(DataFile);

  fileStrings := TStringList.Create;

  while not EOF (DataFile) do
  begin
    Readln(DataFile, lineFile);
    ExtractStrings([','], [' '], pChar(Linefile), fileStrings);

    if(TFunctions.IsNumeric(fileStrings.strings[0]) = false)then begin
      filestrings.Clear;
      continue;
    end;

    //Adiciona na estrutura;
    teleport.Scr1.X := strtoint(fileStrings.Strings[0]);
    teleport.Scr1.Y := strtoint(fileStrings.Strings[1]);//nome
    teleport.Dest1.X := strtoint(fileStrings.Strings[2]);//
    teleport.Dest1.Y := strtoint(fileStrings.Strings[3]);//
    teleport.Price := strtoint(fileStrings.Strings[4]);//
    teleport.Time := strtoint(fileStrings.Strings[5]);//
    filestrings.Clear;
    TeleportsList.Add(teleport);
  end;
  fileStrings.Free;
  Logger.Write('Teleportes carregados com sucesso!', TLogType.ServerStatus);
  CloseFile(DataFile);
end;

end.
