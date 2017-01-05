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

  for i:=0 to 18 do
  begin
    if Length(g[i])<72 then g[i]:=g[i]+StringOfChar(' ',72-Length(g[i]));
    if i<9 then g[i]:=g[i]+'G000000'+inttostr(i+1)
    else g[i]:=g[i]+'G00000'+inttostr(i+1);
    mmo1.Lines.Add(g[i]);
  end;
  mmo1.Lines.Add(g[i]);

end;

procedure TForm1.btn_exportClick(Sender: TObject);
var i: Integer;
begin
  AssignFile(f, ExtractFileDir(ParamStr(0))+'/igess-test.igs');
  Rewrite(f);
  writeln(f, s1);
  writeln(f, s2);
  for i:=0 to 18 do writeln(f, g[i]);
  CloseFile(f);


end;

end.
