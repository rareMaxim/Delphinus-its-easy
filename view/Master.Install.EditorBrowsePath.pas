unit Master.Install.EditorBrowsePath;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  UI.PlatformSelector,
  DN.JSonFile.Installation,
  UI.CompilerVersions,
  UI.PathEditor;

type
  TEdtBrowserPath = class(TForm)
    lyt1: TLayout;
    btn1: TButton;
    btn2: TButton;
  private
    FPathEditor: TfrmPathEditor;
    FPlatforms: TPlatformSelector;
    FCompilerVers: TCompilerVersions;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function EditPath(const APrjPath: string; var ASerchPath: TSearchPath): Boolean;
  end;

var
  EdtBrowserPath: TEdtBrowserPath;

implementation

uses
  DE.Utils;
{$R *.fmx}

constructor TEdtBrowserPath.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPathEditor := TfrmPathEditor.Create(Self);
  FPathEditor.Parent := Self;
  FPathEditor.Align := TAlignLayout.Bottom;
  FPathEditor.Align := TAlignLayout.Top;

  FPlatforms := TPlatformSelector.Create(Self);
  FPlatforms.Parent := Self;
  FPlatforms.Align := TAlignLayout.Bottom;
  FPlatforms.Align := TAlignLayout.Top;

  FCompilerVers := TCompilerVersions.Create(Self);
  FCompilerVers.Parent := Self;
  FCompilerVers.Align := TAlignLayout.Bottom;
  FCompilerVers.Align := TAlignLayout.Top;
end;

destructor TEdtBrowserPath.Destroy;
begin

  inherited;
end;

class function TEdtBrowserPath.EditPath(const APrjPath: string; var ASerchPath: TSearchPath): Boolean;
var
  MyClass: TEdtBrowserPath;
begin
  MyClass := TEdtBrowserPath.Create(nil);
  try
    MyClass.FPathEditor.ProjectPath := APrjPath;
    MyClass.Position := TFormPosition.MainFormCenter;
    MyClass.FPathEditor.Pathes := ASerchPath.Path;
    MyClass.FPlatforms.Platforms := ASerchPath.Platforms;
    MyClass.FCompilerVers.Min := ASerchPath.CompilerMin;
    MyClass.FCompilerVers.Max := ASerchPath.CompilerMax;
    Result := IsPositiveResult(MyClass.ShowModal);
    if Result then
    begin
      ASerchPath.Path := MyClass.FPathEditor.Pathes;
      ASerchPath.Platforms := MyClass.FPlatforms.Platforms;
      ASerchPath.CompilerMin := MyClass.FCompilerVers.Min;
      ASerchPath.CompilerMax := MyClass.FCompilerVers.Max;
    end;
  finally
    MyClass.Free;
  end;
end;

end.

