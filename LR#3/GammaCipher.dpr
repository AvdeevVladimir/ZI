program GammaFileCipher;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows, Classes;

// Функция для установки кодировки консоли
procedure SetConsoleEncoding;
begin
  SetConsoleOutputCP(1251);
  SetConsoleCP(1251);
end;

// Функция для очистки экрана (альтернатива ClrScr)
procedure ClearScreen;
var
  i: Integer;
begin
  for i := 1 to 25 do
    Writeln;
end;

// Функция для получения минимального значения
function MinInt(A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

// Функция для условного выбора строки (альтернатива IIf)
function IfThen(Condition: Boolean; const TrueStr, FalseStr: string): string;
begin
  if Condition then
    Result := TrueStr
  else
    Result := FalseStr;
end;

// Аддитивный генератор псевдослучайных чисел (датчик Фибоначчи)
function GetNextAdditiveGamma(var Y0, Y1: Integer): Byte;
const
  M = 4096;   // модуль
var
  Y2: Integer;
begin
  // Аддитивный генератор: Y2 = (Y0 + Y1) mod M
  Y2 := (Y0 + Y1) mod M;

  // Сдвигаем значения для следующей итерации
  Y0 := Y1;
  Y1 := Y2;

  // Берем младший байт для гаммирования (0-255)
  Result := Y2 and $FF;
end;

// Шифрование/дешифрование данных (работает с потоками байт)
procedure ProcessFile(const InputFile, OutputFile: string; var Y0, Y1: Integer);
var
  InputStream: TFileStream;
  OutputStream: TFileStream;
  Buffer: Byte;
  Gamma: Byte;
  FileSize: Int64;
  i: Integer;
begin
  // Проверяем существование входного файла
  if not FileExists(InputFile) then
    raise Exception.Create('Входной файл не найден: ' + InputFile);

  // Открываем входной файл для чтения
  InputStream := TFileStream.Create(InputFile, fmOpenRead or fmShareDenyWrite);
  try
    // Создаем выходной файл
    OutputStream := TFileStream.Create(OutputFile, fmCreate);
    try
      FileSize := InputStream.Size;

      // Обрабатываем файл побайтово
      for i := 0 to FileSize - 1 do
      begin
        // Читаем байт из входного файла
        InputStream.Read(Buffer, 1);

        // Получаем следующий байт гаммы
        Gamma := GetNextAdditiveGamma(Y0, Y1);

        // Применяем гаммирование (XOR)
        Buffer := Buffer xor Gamma;

        // Записываем результат в выходной файл
        OutputStream.Write(Buffer, 1);
      end;
    finally
      OutputStream.Free;
    end;
  finally
    InputStream.Free;
  end;
end;

// Вспомогательная процедура для создания тестового файла
procedure CreateTestFile(const FileName: string);
var
  FileStream: TFileStream;
  TestText: AnsiString;
  Bytes: TBytes;
begin
  TestText := 'Привет, мир! Это тестовый файл для проверки шифрования.' + #13#10 +
              'Вторая строка текста. 1234567890' + #13#10 +
              'Третья строка с русскими символами: Ёжик, яблоко, день.' + #13#10 +
              'Четвертая строка с латиницей: Hello, world! Testing 123.' + #13#10 +
              'Пятая строка: Специальные символы: !@#$%^&*()_+{}[]|;:,.<>?/~';

  // Преобразуем AnsiString в TBytes для записи
  SetLength(Bytes, Length(TestText));
  Move(TestText[1], Bytes[0], Length(TestText));

  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    FileStream.Write(Bytes[0], Length(Bytes));
  finally
    FileStream.Free;
  end;

  Writeln('Создан тестовый файл: ', FileName);
end;

// Функция для получения размера файла
function GetFileSizeEx(const FileName: string): Int64;
var
  Stream: TFileStream;
begin
  if FileExists(FileName) then
  begin
    Stream := TFileStream.Create(FileName, fmOpenRead);
    try
      Result := Stream.Size;
    finally
      Stream.Free;
    end;
  end
  else
    Result := -1;
end;

// Процедура для просмотра содержимого файла
procedure ViewFileContent(const FileName: string);
var
  Stream: TFileStream;
  Buffer: TBytes;
  Content: AnsiString;
  FileSize: Integer;
  i: Integer;
  DisplaySize: Integer;
begin
  if not FileExists(FileName) then
  begin
    Writeln('Файл ', FileName, ' не существует!');
    Exit;
  end;

  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    FileSize := Stream.Size;

    if FileSize = 0 then
    begin
      Writeln('Файл пуст.');
      Exit;
    end;

    // Ограничим просмотр первыми 500 байтами для больших файлов
    if FileSize > 500 then
    begin
      Writeln('Файл большой (', FileSize, ' байт). Показываю первые 500 байт:');
      DisplaySize := 500;
    end
    else
      DisplaySize := FileSize;

    SetLength(Buffer, DisplaySize);
    Stream.Read(Buffer[0], DisplaySize);

    // Пытаемся интерпретировать как текст в кодировке Windows-1251
    SetLength(Content, DisplaySize);
    for i := 0 to DisplaySize - 1 do
    begin
      if Buffer[i] >= 32 then // Печатные символы
        Content[i+1] := AnsiChar(Buffer[i])
      else if Buffer[i] = 13 then // CR
        Content[i+1] := AnsiChar(13)
      else if Buffer[i] = 10 then // LF
        Content[i+1] := AnsiChar(10)
      else if Buffer[i] = 9 then // TAB
        Content[i+1] := AnsiChar(9)
      else
        Content[i+1] := '.'; // Заменяем непечатные символы на точку
    end;

    Writeln('Содержимое файла ', FileName, ':');
    Writeln('-------------------');
    Writeln(string(Content));
    Writeln('-------------------');

    // Показываем HEX дамп для зашифрованных файлов
    if (Pos('Coded', FileName) > 0) or (DisplaySize < 200) then
    begin
      Writeln('HEX дамп (первые 50 байт):');
      for i := 0 to MinInt(DisplaySize, 50) - 1 do
      begin
        Write(IntToHex(Buffer[i], 2), ' ');
        if (i + 1) mod 16 = 0 then
          Writeln;
      end;
      Writeln;
    end;

  finally
    Stream.Free;
  end;
end;

// Процедура для отображения меню
procedure ShowMenu;
begin
  Writeln;
  Writeln('=======================================');
  Writeln('         МЕНЮ ПРОГРАММЫ');
  Writeln('=======================================');
  Writeln('1. Закодировать файл Source.txt -> Coded.txt');
  Writeln('2. Раскодировать файл Coded.txt -> DeCoded.txt');
  Writeln('3. Выполнить полный цикл (кодировать + декодировать)');
  Writeln('4. Просмотреть содержимое файлов');
  Writeln('5. Создать тестовый файл Source.txt');
  Writeln('6. Очистить экран');
  Writeln('0. Выход');
  Writeln('=======================================');
  Write('Выберите действие: ');
end;

// Процедура для просмотра всех файлов
procedure ViewAllFiles;
var
  Choice: string;
begin
  repeat
    Writeln;
    Writeln('--- ПРОСМОТР ФАЙЛОВ ---');
    Writeln('1. Просмотреть Source.txt (исходный)');
    Writeln('2. Просмотреть Coded.txt (зашифрованный)');
    Writeln('3. Просмотреть DeCoded.txt (расшифрованный)');
    Writeln('4. Просмотреть все файлы');
    Writeln('5. Вернуться в главное меню');
    Write('Выберите файл: ');
    Readln(Choice);

    Writeln;

    if Choice = '1' then
      ViewFileContent('Source.txt')
    else if Choice = '2' then
      ViewFileContent('Coded.txt')
    else if Choice = '3' then
      ViewFileContent('DeCoded.txt')
    else if Choice = '4' then
    begin
      ViewFileContent('Source.txt');
      Writeln;
      ViewFileContent('Coded.txt');
      Writeln;
      ViewFileContent('DeCoded.txt');
    end;

    if Choice <> '5' then
    begin
      Writeln;
      Write('Нажмите Enter для продолжения...');
      Readln;
    end;

  until Choice = '5';
end;

// Процедура для вывода информации о файлах
procedure ShowFileInfo;
var
  SourceSize, CodedSize, DecodedSize: Int64;
begin
  SourceSize := GetFileSizeEx('Source.txt');
  CodedSize := GetFileSizeEx('Coded.txt');
  DecodedSize := GetFileSizeEx('DeCoded.txt');

  Writeln;
  Writeln('--- ИНФОРМАЦИЯ О ФАЙЛАХ ---');

  if SourceSize >= 0 then
    Writeln('Source.txt   - размер: ', SourceSize, ' байт - ',
      IfThen(FileExists('Source.txt'), 'существует', 'не существует'))
  else
    Writeln('Source.txt   - не существует');

  if CodedSize >= 0 then
    Writeln('Coded.txt    - размер: ', CodedSize, ' байт - ',
      IfThen(FileExists('Coded.txt'), 'существует', 'не существует'))
  else
    Writeln('Coded.txt    - не существует');

  if DecodedSize >= 0 then
    Writeln('DeCoded.txt  - размер: ', DecodedSize, ' байт - ',
      IfThen(FileExists('DeCoded.txt'), 'существует', 'не существует'))
  else
    Writeln('DeCoded.txt  - не существует');

  // Проверка совпадения исходного и расшифрованного
  if (SourceSize >= 0) and (DecodedSize >= 0) then
  begin
    if SourceSize = DecodedSize then
      Writeln('✓ Размеры Source.txt и DeCoded.txt совпадают')
    else
      Writeln('✗ РАЗМЕРЫ НЕ СОВПАДАЮТ! Source: ', SourceSize, ', DeCoded: ', DecodedSize);
  end;
end;

var
  Y0, Y1: Integer;
  InitialY0, InitialY1: Integer;
  Choice: Char;
begin
  try
    // Устанавливаем кодировку консоли
    SetConsoleEncoding;

    // Начальные параметры аддитивного генератора
    InitialY0 := 4003; // Y0 = 4003
    InitialY1 := 59;   // Y1 = 59

    Writeln('=== Шифрование файлов методом гаммирования (аддитивный датчик) ===');
    Writeln('Параметры генератора: m = 4096, Y0 = 4003, Y1 = 59');
    Writeln('Исходный файл: Source.txt');
    Writeln('Зашифрованный файл: Coded.txt');
    Writeln('Расшифрованный файл: DeCoded.txt');

    repeat
      ShowMenu;
      Readln(Choice);

      case Choice of
        '1': // Закодировать
          begin
            Writeln;
            if not FileExists('Source.txt') then
            begin
              Writeln('Ошибка: Файл Source.txt не найден!');
              Write('Создать тестовый файл? (д/н): ');
              Readln(Choice);
              if (Choice = 'д') or (Choice = 'Д') then
                CreateTestFile('Source.txt')
              else
              begin
                Writeln('Операция отменена.');
                Continue;
              end;
            end;

            try
              Y0 := InitialY0;
              Y1 := InitialY1;
              ProcessFile('Source.txt', 'Coded.txt', Y0, Y1);
              Writeln('✓ Файл успешно закодирован: Source.txt -> Coded.txt');
            except
              on E: Exception do
                Writeln('✗ Ошибка при кодировании: ', E.Message);
            end;

            ShowFileInfo;
          end;

        '2': // Раскодировать
          begin
            Writeln;
            if not FileExists('Coded.txt') then
            begin
              Writeln('Ошибка: Файл Coded.txt не найден!');
              Writeln('Сначала закодируйте файл (пункт 1).');
              Continue;
            end;

            try
              Y0 := InitialY0;
              Y1 := InitialY1;
              ProcessFile('Coded.txt', 'DeCoded.txt', Y0, Y1);
              Writeln('✓ Файл успешно раскодирован: Coded.txt -> DeCoded.txt');
            except
              on E: Exception do
                Writeln('✗ Ошибка при раскодировании: ', E.Message);
            end;

            ShowFileInfo;
          end;

        '3': // Полный цикл
          begin
            Writeln;
            Writeln('--- ВЫПОЛНЕНИЕ ПОЛНОГО ЦИКЛА ---');

            // Проверка/создание исходного файла
            if not FileExists('Source.txt') then
            begin
              Writeln('Файл Source.txt не найден. Создаю тестовый файл...');
              CreateTestFile('Source.txt');
            end;

            // Кодирование
            try
              Y0 := InitialY0;
              Y1 := InitialY1;
              ProcessFile('Source.txt', 'Coded.txt', Y0, Y1);
              Writeln('✓ Этап 1: Кодирование выполнено');
            except
              on E: Exception do
              begin
                Writeln('✗ Ошибка при кодировании: ', E.Message);
                Continue;
              end;
            end;

            // Декодирование
            try
              Y0 := InitialY0;
              Y1 := InitialY1;
              ProcessFile('Coded.txt', 'DeCoded.txt', Y0, Y1);
              Writeln('✓ Этап 2: Декодирование выполнено');
            except
              on E: Exception do
              begin
                Writeln('✗ Ошибка при декодировании: ', E.Message);
                Continue;
              end;
            end;

            Writeln('✓ Полный цикл успешно завершен!');
            ShowFileInfo;
          end;

        '4': // Просмотр файлов
          begin
            ViewAllFiles;
          end;

        '5': // Создать тестовый файл
          begin
            Writeln;
            CreateTestFile('Source.txt');
            ShowFileInfo;
          end;

        '6': // Очистить экран
          begin
            ClearScreen;
            Writeln('=== Шифрование файлов методом гаммирования (аддитивный датчик) ===');
            Writeln('Параметры генератора: m = 4096, Y0 = 4003, Y1 = 59');
            Writeln('Исходный файл: Source.txt');
            Writeln('Зашифрованный файл: Coded.txt');
            Writeln('Расшифрованный файл: DeCoded.txt');
          end;

        '0': // Выход
          begin
            Writeln;
            Writeln('Программа завершена.');
          end;

        else
          Writeln('Неверный выбор. Пожалуйста, выберите 0-6.');
      end;

      if Choice <> '0' then
      begin
        Writeln;
        Write('Нажмите Enter для продолжения...');
        Readln;
      end;

    until Choice = '0';

  except
    on E: Exception do
    begin
      Writeln('Критическая ошибка: ', E.Message);
      Writeln('Нажмите Enter для выхода...');
      Readln;
    end;
  end;
end.
