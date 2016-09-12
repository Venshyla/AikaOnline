unit Main;

interface

uses PlayerData, MiscData,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    edit1: TLabeledEdit;
    edit2: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  f:file of TAccountFile;
  Acc:      TAccountFile;
  local: string;
  i: Integer;
begin
  if (length(edit1.text) < 4) then
  begin
    Showmessage('Id curto demais. Deve ter pelo menos 4 digitos.');
    exit;
  end;
  if (length(edit2.Text) < 4) then
  begin
    Showmessage('Senha curta demais. Deve ter pelo menos 4 digitos.');
    exit;
  end;
  local := getCurrentDir + '\ACCS\' + Trim(edit1.text[1]) + '\' + Trim(edit1.text) + '.acc';
  if (FileExists(local)) then begin showmessage('Conta ja existente.'); exit; end;
  Zeromemory(@Acc,sizeof(TAccountFile));
  Acc.Header.UserName:=edit1.Text;
  Acc.Header.Password:=edit2.Text;

  AssignFile(f, local);
  ReWrite(f);
  Write(f,Acc);
  CloseFile(f);

      Showmessage('Conta: '+Edit1.Text +#13#13' Criada com sucesso!!!');
end;

end.
