unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, DESXUnit;

type
  TMainForm = class(TForm)
    pcMain: TPageControl;
    tsText: TTabSheet;
    tsFiles: TTabSheet;
    tsKeys: TTabSheet;
    lblSource: TLabel;
    memSource: TMemo;
    lblEncrypted: TLabel;
    memEncrypted: TMemo;
    lblDecrypted: TLabel;
    memDecrypted: TMemo;
    btnEncryptString: TButton;
    btnDecryptString: TButton;
    gbSourceFile: TGroupBox;
    edSourceFile: TEdit;
    btnBrowseSource: TButton;
    gbDestFile: TGroupBox;
    edDestFile: TEdit;
    btnBrowseDest: TButton;
    btnEncryptFile: TButton;
    btnDecryptFile: TButton;
    ProgressBar1: TProgressBar;
    gbKeys: TGroupBox;
    lblKey1: TLabel;
    edKey1: TEdit;
    lblKey2: TLabel;
    edKey2: TEdit;
    lblKey3: TLabel;
    edKey3: TEdit;
    btnSetKeys: TButton;
    btnGenerateRandomKeys: TButton;
    lblKeyStatusTitle: TLabel;
    lblKeyStatus: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSetKeysClick(Sender: TObject);
    procedure btnGenerateRandomKeysClick(Sender: TObject);
    procedure btnEncryptStringClick(Sender: TObject);
    procedure btnDecryptStringClick(Sender: TObject);
    procedure btnBrowseSourceClick(Sender: TObject);
    procedure btnBrowseDestClick(Sender: TObject);
    procedure btnEncryptFileClick(Sender: TObject);
    procedure btnDecryptFileClick(Sender: TObject);

  private
    { Private declarations }
    FDESX: TDESX;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FDESX := TDESX.Create;

  btnSetKeysClick(Sender);

  memSource.Font.Name := 'Courier New';
  memEncrypted.Font.Name := 'Courier New';
  memDecrypted.Font.Name := 'Courier New';

  memSource.Clear;
  memEncrypted.Clear;
  memDecrypted.Clear;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDESX);
end;

procedure TMainForm.btnSetKeysClick(Sender: TObject);
var
  Key1, Key2, Key3: array[0..7] of Byte;
  i: Integer;
begin
  if (Length(edKey1.Text) <> 8) or (Length(edKey2.Text) <> 8) or (Length(edKey3.Text) <> 8) then
  begin
    MessageDlg('Каждый ключ должен содержать ровно 8 символов!', mtWarning, [mbOK], 0);
    Exit;
  end;

  for i := 0 to 7 do
  begin
    Key1[i] := Byte(edKey1.Text[i+1]);
    Key2[i] := Byte(edKey2.Text[i+1]);
    Key3[i] := Byte(edKey3.Text[i+1]);
  end;

  FDESX.SetKeys(Key1, Key2, Key3);

  lblKeyStatus.Caption := 'Ключи успешно установлены';
  lblKeyStatus.Font.Color := clGreen;

  MessageDlg('Ключи успешно установлены!', mtInformation, [mbOK], 0);
end;

procedure TMainForm.btnGenerateRandomKeysClick(Sender: TObject);
var
  i: Integer;
  KeyStr: string;
begin
  Randomize;

  KeyStr := '';
  for i := 1 to 8 do
    KeyStr := KeyStr + Chr(Ord('A') + Random(26));
  edKey1.Text := KeyStr;

  KeyStr := '';
  for i := 1 to 8 do
    KeyStr := KeyStr + Chr(Ord('0') + Random(10));
  edKey2.Text := KeyStr;

  KeyStr := '';
  for i := 1 to 8 do
    KeyStr := KeyStr + Chr(Ord('A') + Random(26));
  edKey3.Text := KeyStr;

  btnSetKeysClick(Sender);
end;

procedure TMainForm.btnEncryptStringClick(Sender: TObject);
var
  SourceText: AnsiString;
  EncryptedText: AnsiString;
begin
  if memSource.Lines.Text = '' then
  begin
    MessageDlg('Введите текст для шифрования!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if lblKeyStatus.Caption = 'Ключи не установлены' then
  begin
    MessageDlg('Сначала установите ключи на вкладке "Настройки ключей"!', mtWarning, [mbOK], 0);
    Exit;
  end;

  try
    Screen.Cursor := crHourGlass;

    SourceText := AnsiString(memSource.Lines.Text);

    EncryptedText := FDESX.EncryptString(SourceText);

    memEncrypted.Clear;
    memEncrypted.Lines.Add(string(EncryptedText));

    memDecrypted.Clear;

    Screen.Cursor := crDefault;

    MessageDlg('Текст успешно зашифрован!', mtInformation, [mbOK], 0);
  except
    on E: Exception do
    begin
      Screen.Cursor := crDefault;
      MessageDlg('Ошибка при шифровании: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TMainForm.btnDecryptStringClick(Sender: TObject);
var
  EncryptedText: AnsiString;
  DecryptedText: AnsiString;
  CleanText: string;
  i: Integer;
begin
  if memEncrypted.Lines.Text = '' then
  begin
    MessageDlg('Нет зашифрованного текста для расшифровки!', mtWarning, [mbOK], 0);
    Exit;
  end;
  if lblKeyStatus.Caption = 'Ключи не установлены' then
  begin
    MessageDlg('Сначала установите ключи на вкладке "Настройки ключей"!', mtWarning, [mbOK], 0);
    Exit;
  end;

  try
    Screen.Cursor := crHourGlass;

    if memEncrypted.Lines.Count > 0 then
      CleanText := memEncrypted.Lines[0]
    else
      CleanText := memEncrypted.Lines.Text;

    CleanText := StringReplace(CleanText, ' ', '', [rfReplaceAll]);
    CleanText := StringReplace(CleanText, #9, '', [rfReplaceAll]); // убираем табуляцию
    CleanText := StringReplace(CleanText, #13, '', [rfReplaceAll]); // убираем возврат каретки
    CleanText := StringReplace(CleanText, #10, '', [rfReplaceAll]); // убираем перевод строки

    for i := 1 to Length(CleanText) do
    begin
      if not (CleanText[i] in ['0'..'9', 'A'..'F', 'a'..'f']) then
      begin
        MessageDlg('Ошибка: неверный формат зашифрованных данных', mtError, [mbOK], 0);
        Screen.Cursor := crDefault;
        Exit;
      end;
    end;

    EncryptedText := AnsiString(CleanText);
    DecryptedText := FDESX.DecryptString(EncryptedText);

    memDecrypted.Clear;
    memDecrypted.Lines.Add(string(DecryptedText));

    Screen.Cursor := crDefault;

    MessageDlg('Текст успешно расшифрован!', mtInformation, [mbOK], 0);
  except
    on E: Exception do
    begin
      Screen.Cursor := crDefault;
      MessageDlg('Ошибка при расшифровании: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TMainForm.btnBrowseSourceClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Выберите исходный файл';
  OpenDialog1.Filter := 'Все файлы|*.*|Текстовые файлы|*.txt|Зашифрованные файлы|*.enc';

  if OpenDialog1.Execute then
    edSourceFile.Text := OpenDialog1.FileName;
end;

procedure TMainForm.btnBrowseDestClick(Sender: TObject);
begin
  SaveDialog1.Title := 'Укажите имя результирующего файла';
  SaveDialog1.Filter := 'Все файлы|*.*|Текстовые файлы|*.txt|Зашифрованные файлы|*.enc';

  if SaveDialog1.Execute then
    edDestFile.Text := SaveDialog1.FileName;
end;

procedure TMainForm.btnEncryptFileClick(Sender: TObject);
begin
  if edSourceFile.Text = '' then
  begin
    MessageDlg('Выберите исходный файл для шифрования!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if edDestFile.Text = '' then
  begin
    MessageDlg('Укажите имя результирующего файла!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if lblKeyStatus.Caption = 'Ключи не установлены' then
  begin
    MessageDlg('Сначала установите ключи на вкладке "Настройки ключей"!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if not FileExists(edSourceFile.Text) then
  begin
    MessageDlg('Исходный файл не существует!', mtWarning, [mbOK], 0);
    Exit;
  end;

  try
    Screen.Cursor := crHourGlass;

    ProgressBar1.Position := 0;
    ProgressBar1.Max := 100;

    if FDESX.EncryptFile(edSourceFile.Text, edDestFile.Text) then
    begin
      ProgressBar1.Position := 100;
      MessageDlg('Файл успешно зашифрован!', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('Ошибка при шифровании файла!', mtError, [mbOK], 0);

    Screen.Cursor := crDefault;

  except
    on E: Exception do
    begin
      Screen.Cursor := crDefault;
      MessageDlg('Ошибка: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TMainForm.btnDecryptFileClick(Sender: TObject);
begin
  if edSourceFile.Text = '' then
  begin
    MessageDlg('Выберите исходный файл для расшифровки!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if edDestFile.Text = '' then
  begin
    MessageDlg('Укажите имя результирующего файла!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if lblKeyStatus.Caption = 'Ключи не установлены' then
  begin
    MessageDlg('Сначала установите ключи на вкладке "Настройки ключей"!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if not FileExists(edSourceFile.Text) then
  begin
    MessageDlg('Исходный файл не существует!', mtWarning, [mbOK], 0);
    Exit;
  end;

  try
    Screen.Cursor := crHourGlass;

    ProgressBar1.Position := 0;
    ProgressBar1.Max := 100;

    if FDESX.DecryptFile(edSourceFile.Text, edDestFile.Text) then
    begin
      ProgressBar1.Position := 100;
      MessageDlg('Файл успешно расшифрован!', mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('Ошибка при расшифровании файла!' + #13#10 +
                 'Возможно, файл поврежден или использованы неверные ключи.',
                 mtError, [mbOK], 0);

    Screen.Cursor := crDefault;

  except
    on E: Exception do
    begin
      Screen.Cursor := crDefault;
      MessageDlg('Ошибка: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.
