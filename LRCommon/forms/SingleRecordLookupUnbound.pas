unit SingleRecordLookupUnbound;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, Data.DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, RzButton,
  RzPanel, Vcl.StdCtrls, Vcl.Mask, RzEdit, Vcl.ExtCtrls, dxCore, Utilities,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinTheBezier, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TfmSingleRecordLookupUnbound = class(TForm)
    gbSearchString: TRzGroupBox;
    ebSearchString: TRzEdit;
    pnButtons: TRzPanel;
    pnOKCancel: TRzPanel;
    btnOK: TRzBitBtn;
    btnClose: TRzBitBtn;
    gbGrid: TRzGroupBox;
    gLookUp: TcxGrid;
    lvLookUp: TcxGridLevel;
    tvData: TcxGridTableView;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ebSearchStringChange(Sender: TObject);
    procedure ebSearchStringKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    FPrimaryKey: Integer;
    procedure LoadSort(AGridTableView: TcxGridTableView; AFormKeyName: String);
    procedure SaveSort(AGridTableView: TcxGridTableView; AFormKeyName: String);
    function GetPrimaryKey: Integer; virtual; abstract;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    property PrimaryKey: Integer read FPrimaryKey;
  end;

implementation

{$R *.dfm}
{===============================================================================
  Custom Methods
===============================================================================}
constructor TfmSingleRecordLookupUnbound.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ebSearchString.Width := gbSearchString.Width - (2 * ebSearchString.Left);
end;

procedure TfmSingleRecordLookupUnbound.LoadSort(AGridTableView: TcxGridTableView; AFormKeyName: String);
var
  i: Integer;
  LAllColumnsExist: Boolean;
  LSortList, LSortOrderList: TStringList;
begin
  LSortList := TStringList.Create;
  try
    LSortList.Delimiter := ',';
    LSortOrderList := TStringList.Create;
    try
      LSortOrderList.Delimiter := ',';
      LSortList.DelimitedText := TUtilities.GetFormKey(AFormKeyName, 'LastSort');
      LSortOrderList.DelimitedText := TUtilities.GetFormKey(AFormKeyName, 'LastSortOrder');
      LAllColumnsExist := TRUE;
      for i := 0 to (LSortList.Count - 1) do
        LAllColumnsExist := LAllColumnsExist and (StrToIntDef(LSortList[i], -1) >= 0) and (StrToIntDef(LSortList[i], -1) < AGridTableView.ColumnCount);
      LAllColumnsExist := LAllColumnsExist and (LSortOrderList.Count = LSortList.Count);
      if LAllColumnsExist then
      begin
        for i := 0 to (LSortList.Count - 1) do
          AGridTableView.Columns[StrToIntDef(LSortList[i], -1)].SortOrder := TdxSortOrder(StrToIntDef(LSortOrderList[i], 0));
      end;
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;

procedure TfmSingleRecordLookupUnbound.SaveSort(AGridTableView: TcxGridTableView; AFormKeyName: String);
var
  i: Integer;
  LSortList, LSortOrderList: TStringList;
  LSortIndex: Integer;
begin
  LSortList := TStringList.Create;
  try
    LSortOrderList := TStringList.Create;
    try
      TUtilities.SetFormKey(AFormKeyName, 'LastSort', '');
      TUtilities.SetFormKey(AFormKeyName, 'LastSortOrder', '');
      LSortIndex := AGridTableView.ColumnCount;
      //Pre Size  Lists
      for i := 0 to (AGridTableView.ColumnCount - 1) do
      begin
        if soNone <> AGridTableView.Columns[i].SortOrder then
        begin
          LSortList.Append('');
          LSortOrderList.Append('');
        end;
      end;
      for i := 0 to (AGridTableView.ColumnCount - 1) do
      begin
        if soNone <> AGridTableView.Columns[i].SortOrder then
        begin
          LSortList[AGridTableView.Columns[i].SortIndex] := IntToStr(i);
          LSortOrderList[AGridTableView.Columns[i].SortIndex] := IntToStr(Integer(AGridTableView.Columns[i].SortOrder));
        end;
      end;
      LSortList.Delimiter := ',';
      LSortOrderList.Delimiter := ',';
      Assert(LSortList.Count = LSortOrderList.Count);
      TUtilities.SetFormKey(AFormKeyName, 'LastSort', LSortList.DelimitedText);
      TUtilities.SetFormKey(AFormKeyName, 'LastSortOrder', LSortOrderList.DelimitedText);
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;
{===============================================================================
  End Of Custom Methods
===============================================================================}
procedure TfmSingleRecordLookupUnbound.ebSearchStringChange(Sender: TObject);
var
  recIndex, rowIndex: Integer;
  LColIndex, i: Integer;
begin
  inherited;
  LColIndex := -1;
  for i := 0 to (tvData.ColumnCount - 1) do
  begin
    if (soNone <> tvData.Columns[i].SortOrder) and (0 = tvData.Columns[i].SortIndex) then
    begin
      LColIndex := i;
      BREAK;
    end;
  end;

  if -1 = LColIndex  then
    EXIT;

  recIndex := tvData.DataController.FindRecordIndexByText(1, LColIndex, ebSearchString.Text, true, true, true);
  rowIndex := tvData.DataController.GetRowIndexByRecordIndex(recIndex, True);
  tvData.Controller.FocusedRowIndex := rowIndex;
end;

procedure TfmSingleRecordLookupUnbound.ebSearchStringKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  try
    case key of
      VK_UP: tvData.Controller.FocusedRowIndex := tvData.Controller.FocusedRowIndex - 1;
      VK_DOWN: tvData.Controller.FocusedRowIndex := tvData.Controller.FocusedRowIndex + 1;
    end;
  except
  end;
end;

procedure TfmSingleRecordLookupUnbound.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: btnClose.Click;
    VK_RETURN: btnOK.Click;
  end;
end;

procedure TfmSingleRecordLookupUnbound.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmSingleRecordLookupUnbound.btnOKClick(Sender: TObject);
begin
  FPrimaryKey := GetPrimaryKey;
  if FPrimaryKey < 0 then
    EXIT;

  ModalResult := mrOK;
end;

end.
