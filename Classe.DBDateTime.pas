{ -----------------------------------------------------------------------------
  Author:    Messias Natal
  Date:      18-Setembro-2021
  Description: Componente Para Vincular o DataSource e DataField - FREE
  ----------------------------------------------------------------------------- }
{ ******************************************************************************
  |* Historico
  |*
  |* 18/09/2021: Messias Antonio Natal
  |*  - Criação e distribuição da Primeira Versão
  *******************************************************************************}

unit Classe.DBDateTime;

interface

uses
  Vcl.ComCtrls,
  Vcl.Dialogs,
  Data.DB,
  System.Classes,
  System.SysUtils;

type
  TDBDateTime = class (TDateTimePicker)
  private
    FDataSource: TDataSource;
    FDataField: string;
    procedure OnDBDateTimeChange(Sender: TObject);
    function ValidadeDataField: Boolean;
  published
    property DataSource: TDataSource read FDataSource write FDataSource;
    property DataField: string read FDataField write FDataField;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  const
    MSG_DATAFIELD_NOTFOUND = 'DataField "%s" Not Found';
  end;

procedure register;

implementation

{ TDBDateTime }

procedure register;
begin
  RegisterComponents('DBDateTime',[TDBDateTime]);
end;

constructor TDBDateTime.Create(AOwner: TComponent);
begin
  inherited;
  Self.OnChange := OnDBDateTimeChange;
end;

destructor TDBDateTime.Destroy;
begin
  FDataSource.DataSet := nil;
  FDataSource.OnDataChange := nil;
  FDataSource.OnStateChange := nil;
  FDataSource.OnUpdateData := nil;
  Self.OnChange := nil;
  inherited;
end;

procedure TDBDateTime.OnDBDateTimeChange(Sender: TObject);
begin
  if not ValidadeDataField then
    Exit;
  FDataSource.DataSet.FieldByName(FDataField).AsDateTime := TDateTimePicker(Sender).DateTime;
end;

function TDBDateTime.ValidadeDataField: Boolean;
begin
  Result := True;
  if (FDataSource.DataSet <> nil) and (FDataSource.DataSet.Fields.FindField(DataField) = nil) then
  begin
    Result := False;
    Self.Enabled := False;

    FDataSource.DataSet := nil;
    FDataSource.OnDataChange := nil;
    FDataSource.OnStateChange := nil;
    FDataSource.OnUpdateData := nil;
    Self.OnChange := nil;

    MessageDlg(System.SysUtils.Format(MSG_DATAFIELD_NOTFOUND,[DataField]),mtWarning,[mbok],0);
  end;
end;

end.
