unit ConfigureFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ExtDlgs, Unit1, Spin, Buttons, RegSettings;

type
  TConfigureForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    seTimerInterval: TSpinEdit;
    grp1: TGroupBox;
    seNumStars: TSpinEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    clbStarColor: TColorBox;
    lbl3: TLabel;
    clbSFBGColor: TColorBox;
    rgStarDrawingStyle: TRadioGroup;
    edtBmpText: TEdit;
    grp2: TGroupBox;
    lbl4: TLabel;
    mSWText: TMemo;
    lbl5: TLabel;
    clbTextColor: TColorBox;
    lbl6: TLabel;
    clbSWBGColor: TColorBox;
    cbTextFont: TComboBox;
    lbl7: TLabel;
    lbl8: TLabel;
    seFontSize: TSpinEdit;
    seSFStepping: TSpinEdit;
    lbl9: TLabel;
    lbl10: TLabel;
    seSWStepping: TSpinEdit;
    cbRepeat: TCheckBox;
    btn1: TSpeedButton;
    dlgFont1: TFontDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure rgStarDrawingStyleClick(Sender: TObject);
    procedure cbTextFontDropDown(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    FSettings: TSettings;
  public
    { Public declarations }
  end;

var
  ConfigureForm: TConfigureForm;

implementation

uses ScreenSaverUtils, cStarField, ShellAPI {for the link to mail};

{$R *.DFM}
procedure TConfigureForm.FormCreate(Sender: TObject);
begin
  Caption := 'Configure ' + Application.Title;
  seTimerInterval.MaxValue := MaxInt;
  // Disable the window that called the configure form,
  // so the user can't change another ss's properties.
  if ParentSaverHandle <> 0 then
  begin
    // The parent of the handle passed to us is
    // the main Properties dialog box
    EnableWindow(GetParent(ParentSaverHandle), False);
  end;
  FSettings := TSettings.Create;
  with FSettings do begin
    seNumStars.Value := NumStars;
    clbStarColor.Selected := StarColor;
    clbSFBGColor.Selected := SFBGColor;
    edtBmpText.Visible := false;
    case StarDrawingStyle of
      sdDot: rgStarDrawingStyle.ItemIndex := 0;
      sdBlock: rgStarDrawingStyle.ItemIndex := 1;
      sdEllipse: rgStarDrawingStyle.ItemIndex := 2;
      sdBmp: begin
        rgStarDrawingStyle.ItemIndex := 3;
        edtBmpText.Visible := true;
        edtBmpText.Text := BmpText;
      end;
    end;
    seSFStepping.Value := SFStepping;

    seTimerInterval.Value := TimerInterval;

    mSWText.Lines.Clear;
    mSWText.Lines.Assign(ScrollList);
    cbTextFont.Text := FontName;
    clbTextColor.Selected := TextColor;
    clbSWBGColor.Selected := SWBGColor;
    seFontSize.Value := FontSize;
    cbRepeat.Checked := SWRepeat;
    seSWStepping.Value := SWStepping;
  end;
end;

procedure TConfigureForm.FormDestroy(Sender: TObject);
begin
  FSettings.Free;
  if ParentSaverHandle <> 0 then
  begin
    // The parent of the handle passed to us is
    // the main Properties dialog box
    EnableWindow(GetParent(ParentSaverHandle), True);
    SetForegroundWindow(GetParent(ParentSaverHandle));
  end;
end;

procedure TConfigureForm.rgStarDrawingStyleClick(Sender: TObject);
begin
  edtBmpText.Visible := rgStarDrawingStyle.ItemIndex = 3;
end;

procedure TConfigureForm.btnOkClick(Sender: TObject);
begin
  with FSettings do begin
    NumStars := seNumStars.Value;
    StarColor := clbStarColor.Selected;
    SFBGColor := clbSFBGColor.Selected;
    case rgStarDrawingStyle.ItemIndex of
      0: StarDrawingStyle := sdDot;
      1: StarDrawingStyle := sdBlock;
      2: StarDrawingStyle := sdEllipse;
      3: begin
           StarDrawingStyle := sdBmp;
           BmpText := edtBmpText.Text;
      end;
    end;

    SFStepping := seSFStepping.Value;
    TimerInterval := seTimerInterval.Value;
    ScrollList.Assign(mSWText.Lines);
    FontName := cbTextFont.Text;
    TextColor := clbTextColor.Selected;
    SWBGColor := clbSWBGColor.Selected;
    FontSize := seFontSize.Value;
    SWRepeat := cbRepeat.Checked;
    SWStepping :=seSWStepping.Value;
  end;
  FSettings.SaveRegistrySettings;
  Close;
end;

procedure TConfigureForm.cbTextFontDropDown(Sender: TObject);
begin
  cbTextFont.Items.AddStrings(Screen.Fonts);
end;

procedure TConfigureForm.btn1Click(Sender: TObject);
begin
  with dlgFont1.Font do begin
    Name := cbTextFont.Text;
    Size := seFontSize.Value;
    Color := clbTextColor.Selected;
  end;
  if dlgFont1.Execute then begin
    cbTextFont.Text := dlgFont1.Font.Name;
    seFontSize.Value := dlgFont1.Font.Size;
    clbTextColor.Selected := dlgFont1.Font.Color;
  end;
end;

procedure TConfigureForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
