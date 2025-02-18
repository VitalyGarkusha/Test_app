import 'package:flutter/material.dart';

class TreeItem {
  String title;
  bool isExpanded;
  bool isChecked;
  List<TreeItem> children;
  TreeItem? parent; // Ссылка на родительский узел

  TreeItem({
    required this.title,
    this.isExpanded = false,
    this.isChecked = false,
    List<TreeItem>? children,
    this.parent, // Инициализация родительского узла
  })  : children = children ?? [] {
    // Устанавливаем родительский узел для всех детей
    for (var child in this.children) {
      child.parent = this;
    }
  }

  void toggle() => isExpanded = !isExpanded;

  void addNode(String title) {
    TreeItem newChild = TreeItem(title: title, parent: this); // Устанавливаем родителя
    children.add(newChild);
  }

  void removeNode(TreeItem node) {
    children.remove(node);
  }
}