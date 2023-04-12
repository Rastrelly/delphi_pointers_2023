unit upointers2023;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  TDataHolder = record
    x,y:real;
    arr:array of integer;
    s:string;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

  pointer1:Pointer; //general pointer
  pointer2:^Integer; //integer pointer 1
  pointer3:PInteger; //integer pointer 2

  pointer4:^TDataHolder; //pointer to record

  a,b:integer;



implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

  //static pointer

  a:=10;
  b:=35;

  pointer2 := @a;

  ShowMessage('a = '+inttostr(a));

  ShowMessage('pointer2^ = '+inttostr(pointer2^));

  a:=20;

  ShowMessage('pointer2^ = '+inttostr(pointer2^));

  pointer2^:=30;

  ShowMessage('a = '+inttostr(a));

  //dynamic typed pointer

  New(pointer3);

  pointer3^:=35;

  a:=pointer3^;

  Dispose(pointer3);

  ShowMessage('a = '+inttostr(a));

  //dynamic non-typed pointer

  //1) via second pointer
  GetMem(pointer1,SizeOf(integer));

  pointer2:=pointer1;

  pointer2^:=35;

  ShowMessage('pointer1^ = '+inttostr(integer(pointer1^)));

  Freemem(pointer1);

  //2) via buffuer variable
  GetMem(pointer1,SizeOf(integer));

  b:=35;

  Move(b,pointer1^,SizeOf(Integer));

  b:=0; //making sure data is in our
  //allocated memory

  ShowMessage('pointer1^ = '+inttostr(integer(pointer1^)));

  Freemem(pointer1);

  //init TDataHolder record
  New(pointer4);


end;

procedure PrintArr(dh:Pointer;outMemo:TMemo);
var i,l:integer;
begin
  //printing out typed pointer though typecasts
  //from untyped pointer < TDataHolder(dh^) >
  l:=length(TDataHolder(dh^).arr);
  outMemo.Clear;
  for i:=0 to l-1 do
  outMemo.Lines.Add(inttostr(TDataHolder(dh^).arr[i]));
end;

procedure TForm1.Button1Click(Sender: TObject);
var la:integer;
begin
  setlength(pointer4^.arr,Length(pointer4^.arr)+1);
  la:=StrToInt(Edit1.Text);
  pointer4^.arr[High(pointer4^.arr)]:=la;
  PrintArr(pointer4,Memo1);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Dispose(pointer4);
end;

end.

