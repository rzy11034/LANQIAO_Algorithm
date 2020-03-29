﻿unit LQA.DSA.ArrayList;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  {%H-}Rtti,
  LQA.DSA.Interfaces,
  LQA.DSA.UString;

type
  generic TArrayList<T> = class(TInterfacedObject, specialize IList<T>)
  private type
    TArr = array of T;
    TImpl = specialize TImpl<T>;

  var
    _data: array of T;
    _size: integer;
    _cmp: TImpl.ICmp;

    procedure __reSize(newCapacity: integer);

  public
    ///<summary> 构造函数，传入数组构造Array </summary>
    constructor Create(const arr: array of T);
    ///<summary>
    ///构造函数，传入数组的容量capacity构造Array。
    ///默认数组的容量capacity:=10
    ///</summary>
    constructor Create(capacity: integer = 10);

    ///<summary> 获取数组中的元数个数 </summary>
    function GetSize: integer;
    ///<summary> 获取数组的容量 </summary>
    function GetCapacity: integer;
    ///<summary> 返回数组是否有空 </summary>
    function IsEmpty: boolean;
    ///<summary> 获取index索引位置元素 </summary>
    function GetItem(index: integer): T;
    ///<summary> 获取第一个元素</summary>
    function GetFirst: T;
    ///<summary> 获取最后一个元素</summary>
    function GetLast: T;
    ///<summary> 修改index索引位置元素 </summary>
    procedure SetItem(index: integer; e: T);
    ///<summary> 向所有元素后添加一个新元素 </summary>
    procedure AddLast(e: T);
    ///<summary> 在第index个位置插入一个新元素e </summary>
    procedure Add(index: integer; e: T);
    ///<summary> 在所有元素前添加一个新元素 </summary>
    procedure AddFirst(e: T);
    ///<summary> 添加数组所有元素 </summary>
    procedure AddRange(const arr: array of T);
    ///<summary> 查找数组中是否有元素e </summary>
    function Contains(e: T): boolean;
    ///<summary> 查找数组中元素e忆的索引，如果不存在元素e，则返回-1 </summary>
    function IndexOf(e: T): integer;
    ///<summary> 从数组中删除index位置的元素，返回删除的元素 </summary>
    function Remove(index: integer): T;
    ///<summary> 从数组中删除第一个元素，返回删除的元素 </summary>
    function RemoveFirst: T;
    ///<summary> 从数组中删除i最后一个元素，返回删除的元素 </summary>
    function RemoveLast: T;
    ///<summary> 从数组中删除元素e </summary>
    procedure RemoveElement(e: T);
    ///<summary> 返回一个数组 </summary>
    function ToArray: TArr;
    function ToString: UString; reintroduce;

    property Count: integer read GetSize;
    property Comparer: TImpl.ICmp read _cmp write _cmp;
    property Items[i: integer]: T read GetItem write SetItem; default;
  end;

implementation

{ TArrayList }

procedure TArrayList.Add(index: integer; e: T);
var
  i: integer;
begin
  if (index < 0) or (index > _size) then
    raise Exception.Create('Add failed. Require index >= 0 and index <= Size.');

  if (_size = Length(_data)) then
    __reSize(2 * Length(Self._data));

  for i := _size - 1 downto index do
    _data[i + 1] := _data[i];

  _data[index] := e;
  Inc(_size);
end;

procedure TArrayList.AddFirst(e: T);
begin
  Add(0, e);
end;

procedure TArrayList.AddLast(e: T);
begin
  Add(_size, e);
end;

procedure TArrayList.AddRange(const arr: array of T);
var
  i: integer;
begin
  for i := 0 to Length(arr) - 1 do
  begin
    Self.AddLast(arr[i]);
  end;
end;

function TArrayList.Contains(e: T): boolean;
var
  i: integer;
begin
  for i := 0 to _size - 1 do
  begin
    if _cmp.Compare(_data[i], e) = 0 then
      Exit(true);
  end;

  Result := false;
end;

constructor TArrayList.Create(capacity: integer);
begin
  SetLength(_data, capacity);
  _cmp := TImpl.TCmp.Default;
end;

constructor TArrayList.Create(const arr: array of T);
var
  i, n: integer;
begin
  n := Length(arr);
  Self.Create(n);

  for i := 0 to n - 1 do
    _data[i] := arr[i];

  _size := n;
end;

function TArrayList.IndexOf(e: T): integer;
var
  i: integer;
begin
  for i := 0 to _size - 1 do
  begin
    if _Cmp.Compare(_data[i], e) = 0 then
      Exit(i);
  end;

  Result := -1;
end;

function TArrayList.GetItem(index: integer): T;
begin
  if (index < 0) or (index > _size) then
    raise Exception.Create('Get failed. Index is illegal.');

  Result := _data[index];
end;

function TArrayList.GetCapacity: integer;
begin
  Result := Length(Self._data);
end;

function TArrayList.GetFirst: T;
begin
  Result := GetItem(0);
end;

function TArrayList.GetLast: T;
begin
  Result := GetItem(_size - 1);
end;

function TArrayList.GetSize: integer;
begin
  Result := Self._size;
end;

function TArrayList.IsEmpty: boolean;
begin
  Result := Self._size = 0;
end;

function TArrayList.Remove(index: integer): T;
var
  i: integer;
  res: T;
begin
  if (index < 0) or (index > _size) then
    raise Exception.Create('Remove failed. Index is illegal.');

  res := _data[index];

  for i := index + 1 to _size - 1 do
    _data[i - 1] := _data[i];

  Dec(Self._size);

  if (_size = Length(Self._data) div 4) and (Length(Self._data) div 2 <> 0) then
    __reSize(Length(Self._data) div 2);

  Result := res;
end;

procedure TArrayList.RemoveElement(e: T);
var
  index, i: integer;
begin
  for i := 0 to _size - 1 do
  begin
    index := IndexOf(e);

    if index <> -1 then
      Remove(index);
  end;
end;

function TArrayList.RemoveFirst: T;
begin
  Result := Remove(0);
end;

function TArrayList.RemoveLast: T;
begin
  Result := Remove(_size - 1);
end;

procedure TArrayList.SetItem(index: integer; e: T);
begin
  if (index < 0) or (index > _size) then
    raise Exception.Create('Set failed. Require index >= 0 and index < Size.');

  _data[index] := e;
end;

function TArrayList.ToArray: TArr;
var
  i: integer;
  arr: TArr;
begin
  SetLength(arr, _size);

  for i := 0 to _size - 1 do
    arr[i] := _data[i];

  Result := arr;
end;

function TArrayList.ToString: UString;
var
  res: TStringBuilder;
  i: integer;
  Value: TValue;
begin
  res := TStringBuilder.Create;
  try
    res.AppendFormat('Array: Size = %d, capacity = %d',
      [Self._size, Length(Self._data)]);
    res.AppendLine;
    res.Append('  [');

    for i := 0 to _size - 1 do
    begin
      TValue.Make(@_data[i], TypeInfo(T), Value);

      if not (Value.IsObject) then
        res.Append(Value.ToString)
      else
        res.Append(Value.AsObject.ToString);

      if i <> _size - 1 then
        res.Append(', ');
    end;

    res.Append(']');
    Result := res.ToString;

  finally
    res.Free;
  end;
end;

procedure TArrayList.__reSize(newCapacity: integer);
begin
  SetLength(Self._data, newCapacity);
end;

end.