﻿unit DeepStar.DSA.Tree.AVLTree;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Math,
  DeepStar.DSA.Tree.BinarySearchTree;

type
  generic TAVLTree<K, V> = class(specialize TBinarySearchTree<K, V>)
  private type
    TAVLNode = class(TNode)
    public
      Height: integer;
      constructor Create(newKey: K; newValue: V; newParent: TNode);

      // 获取该节点平衡因子
      function BalanceFactor: integer;
      // 更新高度
      procedure UpdateHeight;

    end;

  protected
    // 判断传入节点是否平衡（平衡因子的绝对值 <= 1）
    function __isBalanced(node: TAVLNode): boolean;
    function __CreateNode(newKey: K; newValue: V; newParent: TNode): TNode; override;

  public
    constructor Create;
    destructor Destroy; override;
    function Height:integer;
  end;

implementation

{ TAVLTree }

constructor TAVLTree.Create;
begin
  inherited Create;
end;

destructor TAVLTree.Destroy;
begin
  inherited Destroy;
end;

function TAVLTree.Height: integer;
begin
  Result := (_root as TAVLNode).Height;
end;

function TAVLTree.__CreateNode(newKey: K; newValue: V; newParent: TNode): TNode;
begin
  Result := TAVLNode.Create(newKey, newValue, newParent);
end;

function TAVLTree.__isBalanced(node: TAVLNode): boolean;
begin
  Result := Abs(node.BalanceFactor) <= 1;
end;

{ TAVLTree.TAVLNode }

constructor TAVLTree.TAVLNode.Create(newKey: K; newValue: V; newParent: TNode);
begin
  inherited Create(newKey, newValue, newParent);
  Height := 1;
end;

function TAVLTree.TAVLNode.BalanceFactor: integer;
var
  leftHeight, rightHeight: integer;
begin
  leftHeight := IfThen(Left = nil, 0, (Left as TAVLNode).Height);
  rightHeight := IfThen(Right = nil, 0, (Right as TAVLNode).Height);
  Result := leftHeight - rightHeight;
end;

procedure TAVLTree.TAVLNode.UpdateHeight;
var
  leftHeight, rightHeight: integer;
begin
  leftHeight := IfThen(left = nil, 0, (Left as TAVLNode).Height);
  rightHeight := IfThen(Right = nil, 0, (Right as TAVLNode).Height);
  Height := 1 + Max(leftHeight, rightHeight);
end;

end.
