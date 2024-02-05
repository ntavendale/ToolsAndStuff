unit BaseModalForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel, RzButton,
  RzEdit, Vcl.StdCtrls, Vcl.Mask, RzLabel;

type
  TfmBaseModalForm = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    pnOKCancel: TRzPanel;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  protected
    { Protected declarations }
    function RaiseOKError: Boolean; virtual; abstract;
    function RaiseCancelError: Boolean; virtual; abstract;
    function CanOK: Integer; virtual; abstract;
    function CanCancel: Boolean; virtual; abstract;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfmBaseModalForm.btnCancelClick(Sender: TObject);
begin
  if CanCancel then
  begin
    ModalResult := mrCancel
  end
  else
  begin
    if RaiseCancelError then
      ModalResult := mrCancel;
  end;
end;

procedure TfmBaseModalForm.btnOKClick(Sender: TObject);
begin
  var LResult := CanOK;
  if  LResult > 0 then
  begin
    ModalResult := mrOK
  end
  else if LResult < 0 then
  begin
    if RaiseOKError then
      ModalResult := mrOK;
  end;
end;

procedure TfmBaseModalForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: btnOK.Click;
    VK_ESCAPE: btnCancel.Click;
  end;
end;

end.
