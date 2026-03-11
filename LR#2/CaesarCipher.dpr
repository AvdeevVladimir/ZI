program DoubleSquareCipherEnglish;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

const
  ENG_ALPHABET = 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
  ALPH_SIZE = 25;

function PrepareText(const Input: string): string;
var
  i: Integer;
  UpperStr: string;
begin
  Result := '';
  UpperStr := UpperCase(Input);

  for i := 1 to Length(UpperStr) do
  begin
    if Pos(UpperStr[i], ENG_ALPHABET) > 0 then
      Result := Result + UpperStr[i];
  end;

  if Odd(Length(Result)) then
    Result := Result + 'X';  // Исправлено: 'Х' -> 'X' (латиница)
end;

function BuildSquare(const Keyword: string): string;
var
  i: Integer;
  Used: array[0..255] of Boolean;
begin
  Result := '';
  FillChar(Used, SizeOf(Used), 0);

  for i := 1 to Length(Keyword) do
  begin
    if (Pos(Keyword[i], ENG_ALPHABET) > 0) and (not Used[Ord(Keyword[i])]) then
    begin
      Result := Result + Keyword[i];
      Used[Ord(Keyword[i])] := True;
    end;
  end;

  for i := 1 to ALPH_SIZE do
  begin
    if not Used[Ord(ENG_ALPHABET[i])] then
      Result := Result + ENG_ALPHABET[i];
  end;
end;

procedure FindPosition(const Square: string; Ch: Char; var Row, Col: Integer);
var
  PosInSquare: Integer;
begin
  PosInSquare := Pos(Ch, Square);
  if PosInSquare > 0 then
  begin
    Dec(PosInSquare);
    Row := PosInSquare div 5;
    Col := PosInSquare mod 5;
  end
  else
  begin
    Row := 0;
    Col := 0;
  end;
end;

function Encrypt(const PlainText, Key1, Key2: string): string;
var
  Square1, Square2: string;
  i: Integer;
  r1, c1, r2, c2: Integer;
  PreparedText: string;
begin
  PreparedText := PrepareText(PlainText);
  Square1 := BuildSquare(Key1);
  Square2 := BuildSquare(Key2);

  Result := '';

  i := 1;
  while i < Length(PreparedText) do
  begin
    FindPosition(Square1, PreparedText[i], r1, c1);
    FindPosition(Square2, PreparedText[i+1], r2, c2);

    // Берем букву из первого квадрата с координатами (r1, c2)
    Result := Result + Square1[r1 * 5 + c2 + 1];
    // Берем букву из второго квадрата с координатами (r2, c1)
    Result := Result + Square2[r2 * 5 + c1 + 1];

    Inc(i, 2);
  end;
end;

function Decrypt(const CipherText, Key1, Key2: string): string;
var
  Square1, Square2: string;
  i: Integer;
  r1, c1, r2, c2: Integer;
  Ch1, Ch2: Char;
begin
  Square1 := BuildSquare(Key1);
  Square2 := BuildSquare(Key2);

  Result := '';

  i := 1;
  while i < Length(CipherText) do
  begin
    Ch1 := CipherText[i];
    Ch2 := CipherText[i+1];

    // Находим позиции зашифрованных букв в соответствующих квадратах
    FindPosition(Square1, Ch1, r1, c1);  // первая буква - из первого квадрата
    FindPosition(Square2, Ch2, r2, c2);  // вторая буква - из второго квадрата

    // Для дешифровки используем обратные координаты:
    // Исходная первая буква находится в первом квадрате на позиции (r1, c2)
    Result := Result + Square1[r1 * 5 + c2 + 1];
    // Исходная вторая буква находится во втором квадрате на позиции (r2, c1)
    Result := Result + Square2[r2 * 5 + c1 + 1];

    Inc(i, 2);
  end;
end;

procedure PrintSquare(const Square: string; const Title: string);
var
  i, j: Integer;
begin
  Writeln(Title);
  Writeln('   0 1 2 3 4');
  for i := 0 to 4 do
  begin
    Write(i, ': ');
    for j := 0 to 4 do
    begin
      if (i * 5 + j + 1) <= Length(Square) then
        Write(Square[i * 5 + j + 1], ' ')
      else
        Write('? ');
    end;
    Writeln;
  end;
  Writeln;
end;

var
  PlainText, CipherText, DecryptedText: string;
  Key1, Key2: string;
  PreparedOriginal: string;
  i: Integer;
begin
  try
    SetConsoleOutputCP(1251);
    SetConsoleCP(1251);

    Writeln('ШИФР "ДВОЙНОЙ КВАДРАТ" УИТСТОНА');
    Writeln('================================');
    Writeln;

    Write('Введите первое ключевое слово: ');
    Readln(Key1);
    Key1 := UpperCase(Key1);

    Write('Введите второе ключевое слово: ');
    Readln(Key2);
    Key2 := UpperCase(Key2);
    Writeln;

    PrintSquare(BuildSquare(Key1), 'Первый квадрат (ключ: ' + Key1 + '):');
    PrintSquare(BuildSquare(Key2), 'Второй квадрат (ключ: ' + Key2 + '):');

    Write('Введите текст для шифрования: ');
    Readln(PlainText);
    Writeln;

    CipherText := Encrypt(PlainText, Key1, Key2);
    Writeln('Зашифрованный текст: ', CipherText);
    Writeln;

    DecryptedText := Decrypt(CipherText, Key1, Key2);
    Writeln('Расшифрованный текст: ', DecryptedText);
    Writeln;

    PreparedOriginal := PrepareText(PlainText);
    if PreparedOriginal = DecryptedText then
    begin
      Writeln('УСПЕХ! Расшифровка совпадает с исходным текстом.');
    end
    else
    begin
      Writeln('ПРЕДУПРЕЖДЕНИЕ: Расшифровка отличается от оригинала.');
      Writeln('Оригинал (подготовленный): ', PreparedOriginal);
      Writeln('Расшифровка: ', DecryptedText);

      Writeln;
      Writeln('ДИАГНОСТИКА:');
      Writeln('Длина подготовленного оригинала: ', Length(PreparedOriginal));
      Writeln('Длина расшифровки: ', Length(DecryptedText));

      if Length(PreparedOriginal) = Length(DecryptedText) then
      begin
        for i := 1 to Length(PreparedOriginal) do
        begin
          if PreparedOriginal[i] <> DecryptedText[i] then
            Writeln('Позиция ', i, ': ', PreparedOriginal[i], ' -> ', DecryptedText[i]);
        end;
      end;
    end;

    Writeln;
    Write('Нажмите Enter для выхода...');
    Readln;

  except
    on E: Exception do
      Writeln('Ошибка: ', E.Message);
  end;
end.
