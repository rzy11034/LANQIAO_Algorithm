﻿unit DeepStar.DSA.Tree.Test.AVLTree;

interface

uses
  System.SysUtils,
  DeepStar.DSA.Tree.AVLTree,
  LQA.Utils;

procedure Main;

implementation

type
  TAVL_int_int = TAVLTree<integer, integer>;

procedure Main;
var
  tree: TAVL_int_int;
  arr: TArr_int;
  i: integer;
begin
  tree := TAVL_int_int.Create;

  tree.Add(1, 1);
  WriteLn(tree.Height);
  tree.Add(2, 2);
  tree.Add(3, 3);

end;

end.
