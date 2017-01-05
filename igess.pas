unit igess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    mmo1: TMemo;
    btn_export: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
    s1,s2: string;
    g: array[0..25] of string;
    fname: string; // полное имя файла выгрузки
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  f: TextFile;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var nsId, dtime: string;
    i: Integer;
begin
  fname:=ExtractFileDir(ParamStr(0))+'/igess-test.igs';
  // Start Section – a human readable prologue to the file.
  // It contains one or more lines.
  s1:='msom generated IGES File from database';
  if Length(s1)<72 then s1:=s1+StringOfChar(' ',72-Length(s1))+'S0000001';
  s2:=paramstr(0);
  if Length(s2)<72 then s2:=s2+StringOfChar(' ',72-Length(s2))+'S0000002';
  mmo1.Lines.Add(s1);
  mmo1.Lines.Add(s2);

  // Global Section. The required Global Section contains information describing the preprocessor and information needed by postprocessors to handle the file.
  g[0]:=','; // 2.2.4.3.1 Parameter Delimiter Character.
  g[1]:=','; // 2.2.4.3.2 Record Delimiter.
  //The string data type consists of a nonzero, unsigned integer value (character count), followed by the Hollerith delimiter ("H"), followed by the quantity of contiguous characters specified by the character count.
  // see 2.2.2.3 String data type.
  g[2]:='22H'+'MSC.Patran IGES Access'+','; // 2.2.4.3.3 Product Identification From Sender.
  g[3]:=IntToStr(Length(fname))+'H'+fname+','; // 2.2.4.3.4 File Name.

  //2.2.4.3.5 Native System ID
  nsId:='msom v.1 Arkhipov S.V.';
  g[4]:=IntToStr(Length(nsId))+'H'+nsId+','; // 2.2.4.3.5 Native System ID

  g[5]:=g[4]; // 2.2.4.3.6 Preprocessor Version. ...this value may be the same as the Native System ID field
  g[6]:='32'+','; // 2.2.4.3.7 Number of Binary Bits for Integer Representation
  g[7]:='38'+','; // 2.2.4.3.8 Single-Precision Magnitude. Величина одинарной точности
  g[8]:='6'+','; // 2.2.4.3.9 Single-Precision Significance. Значение одинарной точности
  g[9]:=','; // 2.2.4.3.10 Double-Precision Magnitude. Величина двойной точности
  g[10]:=','; // 2.2.4.3.11 Double-Precision Significance.
  g[11]:=g[2]; // 2.2.4.3.12 Product Identification for the Receiver. The default value is the value specified in parameter 3. Идентификация продукта для приемника
  g[12]:= '1.0'+','; // 2.2.4.3.13 Model Space Scale. The default value is 1.0.
  g[13]:='1'+','; // 2.2.4.3.14 Units Flag. The default value is 1.
  g[14]:= '4HINCH'+','; // 2.2.4.3.15   Units   Name.
  g[15]:='1'+','; // 2.2.4.3.16 Maximum Number of Line Weight Gradations. The default value is 1.
  g[16]:='0'+','; // 2.2.4.3.17 Width of Maximum Line Weight in Units.

  dtime:=FormatDateTime('yyyymmdd"."hhnnss', Now);
  g[17]:=IntToStr(Length(dtime))+'H'+dtime+','; // 2.2.4.3.18 Date and Time of Exchange File Generation.

  g[18]:='0.500000E-02'+','; // 2.2.4.3.19 Minimum User-Intended Resolution.
  g[19]:='8.'+','; // 2.2.4.3.20 Approximate Maximum Coordinate Value. field contains the upper bound on the absolute values of all coordinate data actually occurring in this model   ECO653 after transformation (e.g., 1000.0 means for all coordinates, |X|, |Y|, |Z|<= 1000.0)
  g[20]:='13H'+'Arkhipov S.V.'+','; // 2.2.4.3.21 Name of Author.
  g[21]:='3HBSU'+','; // 2.2.4.3.22 Author’s Organization
  g[22]:='11'+','; // 2.2.4.3.23 Version Flag. 11 - Version 5.3
  g[23]:='0'+',';// 2.2.4.3.24 Drafting Standard Flag. 0 - None - No standard specified (default)
  g[24]:=g[17]; // 2.2.4.3.25 Date and Time Model was Created or Modified
  g[25]:=';'; // 2.2.4.3.26 Application Protocol/Subset Identifier. The ECO643 default value is NULL, which is interpreted as “unspecified.”
  for i:=0 to 25 do
  begin
    if Length(g[i])<72 then g[i]:=g[i]+StringOfChar(' ',72-Length(g[i]));
    if i<9 then g[i]:=g[i]+'G000000'+inttostr(i+1)
    else g[i]:=g[i]+'G00000'+inttostr(i+1);
    mmo1.Lines.Add(g[i]);
  end;

  // Directory Entry Section
  // У Раздела Записи каталога есть одна запись Записи каталога для каждого объекта в файле. Запись Записи каталога для каждого объекта фиксирована в размере и содержит 20 полей восьми символов каждый в двух последовательных строках с 80 символами. Значения выровнены по правому знаку в каждом поле. За исключением полей, пронумерованных 10, 16, 17, 18, и 20, все поля в этом разделе должны быть или целым числом или типами данных указателя. В этом разделе слово “число” иногда используется вместо слова “целое число”.
  // Цели Раздела Записи каталога состоят в том, чтобы обеспечить индекс для файла и содержать информацию атрибута для каждого объекта. Порядок записей Записи каталога в Разделе Записи каталога произволен.
  // В Разделе Записи каталога, полностью пробел (т.е., пустое) принято значение по умолчанию поле; постпроцессоры должны присвоить значения по умолчанию, определенные в этой Спецификации (значения варьируются типом объекта). Поля 1, 2, 10, 11, 14, и 20 не должны быть приняты значение по умолчанию кроме Сжатых файлов Формата.
end;

procedure TForm1.btn_exportClick(Sender: TObject);
var i: Integer;
begin
  AssignFile(f, ExtractFileDir(ParamStr(0))+'/igess-test.igs');
  Rewrite(f);
  writeln(f, s1);
  writeln(f, s2);
  for i:=0 to 25 do writeln(f, g[i]);
  CloseFile(f);
end;

end.
