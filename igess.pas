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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  f: TextFile;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var s1,s2,s3: string;
begin
  s1:='MSC.Patran generated IGES File from database                            S0000001';
  s2:='msom generated IGES File from database';

  if Length(s2)<72 then s2:=s2+StringOfChar(' ',72-Length(s2));
  s3:=s2+'S0000001';
  mmo1.Lines.Add(IntToStr(Length(s1)));
  mmo1.Lines.Add(s1);
  mmo1.Lines.Add(IntToStr(Length(s3)));
  mmo1.Lines.Add(s2+'S0000001');
  mmo1.Lines.Add(inttostr(length('MSC.Patran generated IGES File from database                            ')));
  mmo1.Lines.Add(inttostr(length(s2)));
end;

end.
