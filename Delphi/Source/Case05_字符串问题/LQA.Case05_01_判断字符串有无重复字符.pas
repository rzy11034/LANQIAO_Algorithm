﻿unit LQA.Case05_01_判断字符串有无重复字符;

{ **
  请实现一个算法，确定一个字符串的所有字符是否全都不同(有没有重复字符)
  *
  * }

interface

uses
  System.SysUtils,
  LQA.Utils;

procedure Main;

implementation

function CheckDifferent(const str: UString): boolean;
var
  arr: TArr_int;
  c: UChar;
  i, j: integer;
begin
  SetLength(arr, 128);

  for i := 0 to str.Length - 1 do
  begin
    c := str.Chars[i];
    j := Ord(c);

    if arr[j] = 0 then
      Inc(arr[j], 1)
    else
      Exit(False);
  end;

  Result := True;
end;

procedure Main;
var
  s: UString;
begin
  s := 'asdff';
  WriteLn(CheckDifferent(s));
end;

end.
