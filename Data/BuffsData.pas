unit BuffsData;

interface
uses PlayerData, System.Generics.Collections;

procedure GetAffectScore(Character: PCharacter);
procedure AddBMBuff(Character: PCharacter; affect: TAffect);

implementation

uses Windows, GlobalDefs, Util, ItemFunctions;

procedure AddBMBuff(Character: PCharacter; affect: TAffect);
var att, latk, ldef, skillID: Integer;
  def: Integer;
begin

end;

procedure GetAffectScore(Character: PCharacter);
var x, i: Byte;
  value: Byte;
  affect: TAffect;
  aux, aux2: Integer;
  passive: Integer;
begin

end;


end.


