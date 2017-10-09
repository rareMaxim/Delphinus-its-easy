unit UI.PathEditor;

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
  FMX.Edit,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation;

type
  TfrmPathEditor = class(TFrame)
    grpPathes: TGroupBox;
    lstPathes: TListBox;
    grpSelectPath: TGroupBox;
    edt1: TEdit;
    btnBrowse: TEditButton;
    tlb1: TToolBar;
    btnAdd: TButton;
    btnReplace: TButton;
    btnDelete: TButton;
    btn3: TButton;
    procedure btnReplaceClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edt1ChangeTracking(Sender: TObject);
    procedure lstPathesItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
  private
    FProjectPath: string;
    FPathes: string;
    function GetPathes: string;
    procedure SetPathes(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    property ProjectPath: string read FProjectPath write FProjectPath;
    property Pathes: string read GetPathes write SetPathes;
  end;

implementation

uses
  DE.Utils;

{$R *.fmx}

procedure TfrmPathEditor.btnAddClick(Sender: TObject);
begin
  if lstPathes.Items.IndexOf(edt1.Text) = -1 then
    lstPathes.Items.Add(edt1.Text);
end;

procedure TfrmPathEditor.btnBrowseClick(Sender: TObject);
var
  LDir: string;
begin
  if SelectDirectory('Path', '', LDir) then
  begin
    edt1.Text := TUtils.ToLocalPath(LDir, ProjectPath);
  end;
end;

procedure TfrmPathEditor.btnDeleteClick(Sender: TObject);
begin
  lstPathes.Items.Delete(lstPathes.Selected.Index);
end;

procedure TfrmPathEditor.btnReplaceClick(Sender: TObject);
begin
  lstPathes.Selected.Text := edt1.Text;
end;

constructor TfrmPathEditor.Create(AOwner: TComponent);
begin
  inherited;
  lstPathes.Items.Delimiter := ';';
end;

procedure TfrmPathEditor.edt1ChangeTracking(Sender: TObject);
begin
  btnReplace.Enabled := not edt1.Text.Equals(lstPathes.Selected.Text);
end;

function TfrmPathEditor.GetPathes: string;
begin
  Result := lstPathes.Items.Text;
end;

procedure TfrmPathEditor.lstPathesItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  edt1.Text := Item.Text;
end;

procedure TfrmPathEditor.SetPathes(const Value: string);
begin
  lstPathes.Items.DelimitedText := Value;
end;

end.

