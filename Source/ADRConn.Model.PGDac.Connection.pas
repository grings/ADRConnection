unit ADRConn.Model.PgDAC.Connection;

interface

uses
  ADRConn.Model.Interfaces,
  ADRConn.Model.Params,
  System.Classes,
  System.SysUtils,
  Data.DB,
  MemDS,
  DBAccess,
  PgAccess;

type
  TADRConnModelPgDACConnection = class(TInterfacedObject, IADRConnection)
  private
    FConnection: TPgConnection;
    FParams: IADRConnectionParams;

    procedure Setup;
  protected
    function Connection: TCustomConnection;
    function Component: TComponent;

    function Params: IADRConnectionParams;

    function Connected: Boolean;
    function Connect: IADRConnection;
    function Disconnect: IADRConnection;
    function StartTransaction: IADRConnection;
    function Commit: IADRConnection;
    function Rollback: IADRConnection;
    function InTransaction: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IADRConnection;
  end;

implementation

{ TADRConnModelPgDACConnection }

function TADRConnModelPgDACConnection.Commit: IADRConnection;
begin
  Result := Self;
  FConnection.Commit;
end;

function TADRConnModelPgDACConnection.Component: TComponent;
begin
  Result := FConnection;
end;

function TADRConnModelPgDACConnection.Connect: IADRConnection;
begin
  Result := Self;
  if not FConnection.Connected then
  begin
    Setup;
    FConnection.Connected := True;
  end;
end;

function TADRConnModelPgDACConnection.Connected: Boolean;
begin
  Result := (Assigned(FConnection)) and (FConnection.Connected);
end;

function TADRConnModelPgDACConnection.Connection: TCustomConnection;
begin
  Result := FConnection;
end;

constructor TADRConnModelPgDACConnection.Create;
begin
  FConnection := TPgConnection.Create(nil);
  FParams := TADRConnModelParams.New(Self);
end;

destructor TADRConnModelPgDACConnection.Destroy;
begin
  FConnection.Free;
  inherited;
end;

function TADRConnModelPgDACConnection.Disconnect: IADRConnection;
begin
  Result := Self;
  FConnection.Connected := False;
end;

function TADRConnModelPgDACConnection.InTransaction: Boolean;
begin
  Result := FConnection.InTransaction;
end;

class function TADRConnModelPgDACConnection.New: IADRConnection;
begin
  Result := Self.Create;
end;

function TADRConnModelPgDACConnection.Params: IADRConnectionParams;
begin
  Result := FParams;
end;

function TADRConnModelPgDACConnection.Rollback: IADRConnection;
begin
  Result := Self;
  FConnection.Rollback;
end;

procedure TADRConnModelPgDACConnection.Setup;
var
  LParams: TArray<string>;
  LName: string;
  LValue: string;
begin
  FConnection.Database := FParams.Database;
  FConnection.Username := FParams.UserName;
  FConnection.Password := FParams.Password;
  FConnection.Server := FParams.Server;
  FConnection.Port := FParams.Port;
  FConnection.Schema := FParams.Schema;

  LParams := FParams.ParamNames;
  for LName in LParams do
  begin
    LValue := FParams.ParamByName(LName);
    FConnection.ParamByName(LName).Value := LValue;
  end;
end;

function TADRConnModelPgDACConnection.StartTransaction: IADRConnection;
begin
  Result := Self;
  FConnection.StartTransaction;
end;

end.
