unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Button3: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    function EncryptChar(ch: Char; Key: Integer): Char;
    function DecryptChar(ch: Char; Key: Integer): Char;
    function ProcessString(const S: string; Key: Integer; Encrypt: Boolean): string;
    function ReadFileAsString(const FileName: string): string;
    procedure WriteStringToFile(const FileName, Content: string);

  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Caption := 'Шифр Цезаря';

  Label1.Caption := 'Исходный файл:';
  Label2.Caption := 'Выходной файл:';
  Label3.Caption := 'Ключ (1-25):';
  Label4.Caption := 'Пароль:';

  Button1.Caption := '...';
  Button2.Caption := '...';
  Button3.Caption := 'Зашифровать';
  Button4.Caption := 'Расшифровать';

  Edit3.PasswordChar := '*';
  Edit3.Text := '1234';

  SpinEdit1.MinValue := 1;
  SpinEdit1.MaxValue := 25;
  SpinEdit1.Value := 3;

  OpenDialog1 := TOpenDialog.Create(Self);
  OpenDialog1.Filter := 'Все файлы (*.*)|*.*';

  SaveDialog1 := TSaveDialog.Create(Self);
  SaveDialog1.Filter := 'Все файлы (*.*)|*.*';

  Edit1.Clear;
  Edit2.Clear;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text := OpenDialog1.FileName;
    if Edit2.Text = '' then
      Edit2.Text := ChangeFileExt(Edit1.Text, '_encrypted.txt');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Edit2.Text := SaveDialog1.FileName;
end;

function TForm1.ReadFileAsString(const FileName: string): string;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromFile(FileName);
    Result := List.Text;
  finally
    List.Free;
  end;
end;

procedure TForm1.WriteStringToFile(const FileName, Content: string);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.Text := Content;
    List.SaveToFile(FileName);
  finally
    List.Free;
  end;
end;

// Шифрование одного символа
function TForm1.EncryptChar(ch: Char; Key: Integer): Char;
begin
  if (ch >= 'A') and (ch <= 'Z') then
    Result := Char(Ord('A') + (Ord(ch) - Ord('A') + Key) mod 26)
  else if (ch >= 'a') and (ch <= 'z') then
    Result := Char(Ord('a') + (Ord(ch) - Ord('a') + Key) mod 26)
  else if (ch >= '0') and (ch <= '9') then
    Result := Char(Ord('0') + (Ord(ch) - Ord('0') + Key) mod 10)
  else
    Result := ch;
end;

// Расшифровка одного символа
function TForm1.DecryptChar(ch: Char; Key: Integer): Char;
begin
  if (ch >= 'A') and (ch <= 'Z') then
    Result := Char(Ord('A') + (Ord(ch) - Ord('A') - Key + 26) mod 26)
  else if (ch >= 'a') and (ch <= 'z') then
    Result := Char(Ord('a') + (Ord(ch) - Ord('a') - Key + 26) mod 26)
  else if (ch >= '0') and (ch <= '9') then
    Result := Char(Ord('0') + (Ord(ch) - Ord('0') - Key + 10) mod 10)
  else
    Result := ch;
end;

// Обработка всей строки
function TForm1.ProcessString(const S: string; Key: Integer; Encrypt: Boolean): string;
var
  i: Integer;
begin
  Result := '';
  Key := Key mod 26;

  for i := 1 to Length(S) do
  begin
    if Encrypt then
      Result := Result + EncryptChar(S[i], Key)
    else
      Result := Result + DecryptChar(S[i], Key);
  end;
end;

// Шифрование
procedure TForm1.Button3Click(Sender: TObject);
var
  Content, EncryptedText, EncryptedPassword: string;
begin
  if Edit1.Text = '' then
  begin
    ShowMessage('Выберите файл для шифрования!');
    Exit;
  end;

  if Trim(Edit3.Text) = '' then
  begin
    ShowMessage('Введите пароль!');
    Edit3.SetFocus;
    Exit;
  end;

  try
    Screen.Cursor := crHourGlass;

    Content := ReadFileAsString(Edit1.Text);
    EncryptedText := ProcessString(Content, SpinEdit1.Value, True);
    EncryptedPassword := ProcessString(Edit3.Text, SpinEdit1.Value, True);

    WriteStringToFile(Edit2.Text, EncryptedPassword + #13#10 + EncryptedText);

    Screen.Cursor := crDefault;

    ShowMessage('Файл зашифрован!');

  except
    on E: Exception do
    begin
      Screen.Cursor := crDefault;
      ShowMessage('Ошибка: ' + E.Message);
    end;
  end;
end;

// Расшифровка
procedure TForm1.Button4Click(Sender: TObject);
var
  Content, DecryptedPassword, DecryptedText: string;
  FileEncryptedPassword, FileEncryptedText: string;
  p: Integer;
begin
  if Edit1.Text = '' then
  begin
    ShowMessage('Выберите файл для расшифровки!');
    Exit;
  end;

  if Trim(Edit3.Text) = '' then
  begin
    ShowMessage('Введите пароль!');
    Edit3.SetFocus;
    Exit;
  end;

  try
    Screen.Cursor := crHourGlass;

    Content := ReadFileAsString(Edit1.Text);

    p := Pos(#13#10, Content);

    if p = 0 then
    begin
      Screen.Cursor := crDefault;
      ShowMessage('Ошибка: Неверный формат файла!');
      Exit;
    end;

    FileEncryptedPassword := Copy(Content, 1, p - 1);
    FileEncryptedText := Copy(Content, p + 2, Length(Content));

    DecryptedPassword := ProcessString(FileEncryptedPassword, SpinEdit1.Value, False);

    if DecryptedPassword <> Edit3.Text then
    begin
      Screen.Cursor := crDefault;
      ShowMessage('НЕПРАВИЛЬНЫЙ ПАРОЛЬ!');
      Exit;
    end;

    DecryptedText := ProcessString(FileEncryptedText, SpinEdit1.Value, False);
    WriteStringToFile(Edit2.Text, DecryptedText);

    Screen.Cursor := crDefault;

    ShowMessage('Файл расшифрован!');

  except
    on E: Exception do
    begin
      Screen.Cursor := crDefault;
      ShowMessage('Ошибка: ' + E.Message);
    end;
  end;
end;

end.
