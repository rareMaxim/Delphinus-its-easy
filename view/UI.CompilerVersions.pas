unit UI.CompilerVersions;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Layouts;

type
  TCompilerVersions = class(TFrame)
    lytPackageCompiler: TLayout;
    lblMin: TLabel;
    lblMax: TLabel;
    cbbMax: TComboBox;
    cbbMin: TComboBox;
  private
    procedure SetMax(const Value: Integer);
    procedure SetMin(const Value: Integer);
    function GetMax: Integer;
    function GetMin: Integer;
    { Private declarations }
  protected
    procedure FillVersions;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Min: Integer read GetMin write SetMin;
    property Max: Integer read GetMax write SetMax;
  end;

implementation

uses
  DE.Constants,
  DE.Utils;

{$R *.fmx}

{ TCompilerVersions }

constructor TCompilerVersions.Create(AOwner: TComponent);
begin
  inherited;
  FillVersions;
end;

destructor TCompilerVersions.Destroy;
begin

  inherited;
end;

procedure TCompilerVersions.FillVersions;
var
  i: Integer;
begin
  for i := Low(DE.Constants.CDelphiNames) to High(DE.Constants.CDelphiNames) do
  begin
    cbbMin.Items.Add(DE.Constants.CDelphiNames[i]);
    cbbMax.Items.Add(DE.Constants.CDelphiNames[i]);
  end;
end;

function TCompilerVersions.GetMax: Integer;
begin
  Result := TUtils.DelphiNameToId(cbbMax.Selected.Text);
end;

function TCompilerVersions.GetMin: Integer;
begin
  Result := TUtils.DelphiNameToId(cbbMin.Selected.Text);
end;

procedure TCompilerVersions.SetMax(const Value: Integer);
begin
  cbbMax.ItemIndex := cbbMax.Items.IndexOf(TUtils.DelphiIdToName(Value));
end;

procedure TCompilerVersions.SetMin(const Value: Integer);
begin
  cbbMin.ItemIndex := cbbMin.Items.IndexOf(TUtils.DelphiIdToName(Value));
end;

end.

