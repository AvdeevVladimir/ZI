program DoubleSquareCipherEnglish;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

const
  // Английский алфавит (26 букв, но для квадрата 5x5 нужно 25)
  // Убираем одну букву, например 'J'
  ENG_ALPHABET = 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
  ALPH_SIZE = 25;

// Функция для удаления неподходящих символов и приведения к верхнему регистру
function PrepareText(const Input: string): string;
var
  i: Integer;
  UpperStr: string;
begin
  Result := '';
  UpperStr := UpperCase(Input);

  for i := 1 to Length(UpperStr) do
  begin
    // Оставляем только буквы из алфавита
    if Pos(UpperStr[i], ENG_ALPHABET) > 0 then
      Result := Result + UpperStr[i];
  end;

  // Если длина нечетная, добавляем 'Х' (чтобы было четное количество)
  if Odd(Length(Result)) then
    Result := Result + 'Х';
end;

// Построение квадрата по ключевому слову
function BuildSquare(const Keyword: string): string;
var
  i: Integer;
  Used: array[0..255] of Boolean;
begin
  Result := '';
  FillChar(Used, SizeOf(Used), 0);

  // Сначала добавляем уникальные буквы ключа
  for i := 1 to Length(Keyword) do
  begin
    if (Pos(Keyword[i], ENG_ALPHABET) > 0) and (not Used[Ord(Keyword[i])]) then
    begin
      Result := Result + Keyword[i];
      Used[Ord(Keyword[i])] := True;
    end;
  end;

  // Затем добавляем остальные буквы алфавита
  for i := 1 to ALPH_SIZE do
  begin
    if not Used[Ord(ENG_ALPHABET[i])] then
      Result := Result + ENG_ALPHABET[i];
  end;
end;

// Поиск координат буквы в квадрате
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

// Функция шифрования
function Encrypt(const PlainText, Key1, Key2: string): string;
var
  Square1, Square2: string;
  i: Integer;
  r1, c1, r2, c2: Integer;
  PreparedText: string;
begin
  // Подготовка текста и квадратов
  PreparedText := PrepareText(PlainText);
  Square1 := BuildSquare(Key1);
  Square2 := BuildSquare(Key2);

  Result := '';

  // Обрабатываем по парам (только четное количество символов)
  i := 1;
  while i < Length(PreparedText) do
  begin
    // Находим координаты в квадратах
    FindPosition(Square1, PreparedText[i], r1, c1);
    FindPosition(Square2, PreparedText[i+1], r2, c2);

    // Шифрование по правилу: (r1,c2) из первого квадрата и (r2,c1) из второго
    Result := Result + Square1[r1 * 5 + c2 + 1];
    Result := Result + Square2[r2 * 5 + c1 + 1];

    Inc(i, 2);
  end;
end;

// Функция дешифрования
function Decrypt(const CipherText, Key1, Key2: string): string;
var
  Square1, Square2: string;
  i: Integer;
  r1, c1, r2, c2: Integer;
begin
  Square1 := BuildSquare(Key1);
  Square2 := BuildSquare(Key2);

  Result := '';

  i := 1;
  while i < Length(CipherText) do
  begin
    // Находим координаты в квадратах
    FindPosition(Square1, CipherText[i], r1, c1);
    FindPosition(Square2, CipherText[i+1], r2, c2);

    // Дешифрование - обратный процесс
    Result := Result + Square1[r1 * 5 + c2 + 1];
    Result := Result + Square2[r2 * 5 + c1 + 1];

    Inc(i, 2);
  end;
end;

// Вспомогательная функция для вывода квадрата
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

// Основная программа
var
  PlainText, CipherText, DecryptedText: string;
  Key1, Key2: string;
  PreparedOriginal: string;
  i: Integer;  // Объявляем переменную для цикла
begin
  try
    // Настройка консоли для русского языка
    SetConsoleOutputCP(1251);
    SetConsoleCP(1251);

    Writeln('ШИФР "ДВОЙНОЙ КВАДРАТ" УИТСТОНА');
    Writeln('================================');
    Writeln;

    // Ввод ключей
    Write('Введите первое ключевое слово: ');
    Readln(Key1);
    Key1 := UpperCase(Key1);

    Write('Введите второе ключевое слово: ');
    Readln(Key2);
    Key2 := UpperCase(Key2);
    Writeln;

    // Показываем сгенерированные квадраты
    PrintSquare(BuildSquare(Key1), 'Первый квадрат (ключ: ' + Key1 + '):');
    PrintSquare(BuildSquare(Key2), 'Второй квадрат (ключ: ' + Key2 + '):');

    // Ввод текста для шифрования
    Write('Введите текст для шифрования: ');
    Readln(PlainText);
    Writeln;

    // Шифрование
    CipherText := Encrypt(PlainText, Key1, Key2);
    Writeln('Зашифрованный текст: ', CipherText);
    Writeln;

    // Дешифрование
    DecryptedText := Decrypt(CipherText, Key1, Key2);
    Writeln('Расшифрованный текст: ', DecryptedText);
    Writeln;

    // Проверка
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

      // Дополнительная диагностика
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
