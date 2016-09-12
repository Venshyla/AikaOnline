unit Log;

interface

uses Vcl.StdCtrls, Windows,System.SysUtils;

type TLogType = (Packets, ConnectionsTraffic, Warnings, ServerStatus);

type TLog = class(TObject)
  public
    procedure Clear();
    procedure Write(str : string; logType : TLogType); overload;
    procedure Write(obj : TObject; logType : TLogType); overload;
    procedure Space(logType: TLogType);
end;

Procedure LogTxt(Str : String);

implementation
{ TLog }

uses GlobalDefs;

Procedure LogTxt(Str : String);
var  NomeDoLog: string;
 Arquivo: TextFile;
 begin
  NomeDoLog := 'Log.txt';
  AssignFile(Arquivo, NomeDoLog);
  if FileExists(NomeDoLog) then
  Append(arquivo)
  { se existir, apenas adiciona linhas }
  else	ReWrite(arquivo);
          { cria um novo se não existir }
           try	WriteLn(arquivo, Str);
           	WriteLn(arquivo,'----------------');
             finally	CloseFile(arquivo)
              end;
              end;

procedure TLog.Clear;
begin
  //GameServerForm.PacketsListBox.Clear;
  //GameServerForm.ConnectionsListBox.Clear;
  //GameServerForm.WarningsListBox.Clear;
  //GameServerForm.ServerStatusListBox.Clear;
end;

procedure TLog.Write(str: string; logType : TLogType);
begin
  case logType of
    Packets:
    begin
      Writeln(str);
    end;

    ConnectionsTraffic:
    begin
     Writeln(str);
    end;

    Warnings:
    begin
      SetConsoleTextAttribute(GetStdHandle(
                          STD_OUTPUT_HANDLE),
                          FOREGROUND_RED OR
                          FOREGROUND_INTENSITY);
      Writeln(str);

      SetConsoleTextAttribute(GetStdHandle(
                          STD_OUTPUT_HANDLE),
                          FOREGROUND_RED OR FOREGROUND_GREEN OR FOREGROUND_BLUE);
    end;

    ServerStatus:
    begin
      Writeln(str);
      LogTxt(Str);
    end;
  end;
end;

procedure TLog.Space(logType: TLogType);
begin
  Write('--------------------------------------------------------------', logType);
end;

procedure TLog.Write(obj: TObject; logType: TLogType);
begin
  Write(obj.ToString(), logType);
        LogTxt(obj.ToString);
end;

end.
