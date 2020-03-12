﻿unit LQA.Case07_06_WholeArrangement_1;

{**
 * 编写一个方法，确定某字符串的所有排列组合。

 给定一个string A和一个int n,代表字符串和其长度，请返回所有该字符串字符的排列，
 保证字符串长度小于等于11且字符串中字符均为大写英文字符，

 *}

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  LQA.Utils;

procedure Main;

implementation

// 逐步生成----迭代法
function Solution(const str: UString): TList_str;
var
  res, tmpList: TList_str;
  s, tmpStr: UString;
  c: UChar;
  i, j: integer;
begin
  res := TList_str.Create;
  res.Add(str.Chars[0]);

  for i := 1 to str.Length - 1 do
  begin
    tmpList := TList_str.Create;
    c := str.Chars[i];

    for s in res do
    begin
      // 加到左边
      tmpList.Add(c + s);
      // 加到右边
      tmpList.Add(s + c);
      // 加到中间
      for j := 1 to s.Length - 1 do
      begin
        tmpStr := s.Substring(0, j) + c + s.Substring(j, s.Length);
        tmpList.Add(tmpStr);
      end;
    end;

    res := tmpList;
  end;

  Result := res;
end;

procedure Main;
var
  s: UString;
  tmp: TList_str;
begin
  s := 'ABCD';
  tmp := Solution(s);
  TArrayUtils_str.Print(tmp.ToArray);
end;

end.
