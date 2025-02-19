import 'package:flutter/material.dart';
import 'tree_item.dart';
void main() {
  runApp(MyTreeViewApp());
}

class MyTreeViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      home: TreeViewScreen(),
    );
  }
}

class TreeViewScreen extends StatefulWidget {
  @override
  _TreeViewScreenState createState() => _TreeViewScreenState();
}

class _TreeViewScreenState extends State<TreeViewScreen> {
  final List<TreeItem> nodes = [
    TreeItem(title: 'Parent', parent: null), // Корневой элемент
  ];

  void addNode(TreeItem parent) {
    setState(() {
      parent.addNode('New Child');
    });
  }

  void removeNode(TreeItem parent, TreeItem node) {
    // Проверяем, является ли узел корневым
    if (node == nodes[0]) {
      // Если это корневой элемент, ничего не делаем
      return;
    }
    setState(() {
      parent.removeNode(node);
    });
  }

  void updateParentCheckbox(TreeItem child, bool? value) {
    // Обновляем состояние родительских узлов
    TreeItem? parent = child.parent;
    while (parent != null) {
      setState(() {
        parent?.isChecked = value!;
      });
      parent = parent.parent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Test_app'))),
      body: ListView.builder(
        itemCount: nodes.length,
        itemBuilder: (context, index) {
          return _buildTreeItem(nodes[index]);
        },
      ),
    );
  }

  Widget _buildTreeItem(TreeItem item) {
    TextEditingController controller = TextEditingController(text: item.title);

    return ExpansionTile(
      title: Row(
        children: [
          Checkbox(
            value: item.isChecked,
            onChanged: (value) {
              setState(() {
                item.isChecked = value!;
                // Обновляем состояние всех вышестоящих элементов
                updateParentCheckbox(item, value);
              });
            },
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter text',
              ),
              controller: controller,
              onSubmitted: (value) {
                setState(() {
                  item.title = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addNode(item),
          ),
          // Условие для отображения кнопки удаления
          if (item != nodes[0]) // Проверяем, не является ли элемент корнем
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Удаляем узел, если он не корень
                removeNode(item.parent ?? nodes[0], item);
              },
            ),
        ],
      ),
      trailing: item.children.isNotEmpty
          ? Icon(
        item.isExpanded ? Icons.remove : Icons.add,
      )
          : SizedBox(), // Убираем иконку, если нет дочерних элементов
      children: item.children.map((child) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0), // Отступ для дочерних элементов
          child: _buildTreeItem(child),
        );
      }).toList(),
      onExpansionChanged: (expanded) {
        setState(() {
          item.isExpanded = expanded; // Устанавливаем состояние развёрнутости
        });
      },
    );
  }
}
