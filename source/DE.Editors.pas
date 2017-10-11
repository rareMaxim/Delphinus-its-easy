unit DE.Editors;

interface

uses
  FMX.ListBox;

type
  TGridEditors = class
  public
    class function IDEVersion(const ASelected: string = ''): TComboBox;
  end;

implementation

uses
  DE.Constants;

{ TGridEditors }

class function TGridEditors.IDEVersion(const ASelected: string): TComboBox;
var
  i: Integer;
begin
  Result := TComboBox.Create(nil);
  for i := Low(DE.Constants.CDelphiNames) to High(DE.Constants.CDelphiNames) do
  begin
    Result.Items.Add(DE.Constants.CDelphiNames[i]);
  end;
  Result.ItemIndex := Result.Items.IndexOf(ASelected);
end;

end.

