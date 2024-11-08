import 'package:flutter/material.dart';
import 'package:mvc_todo_app/view/card.dart';
import 'package:mvc_todo_app/view/dropdown.dart';
import 'package:mvc_todo_app/view/text.dart';
import '../controller/todo_controller.dart';
import '../model/todo_model.dart';

class TodoView extends StatefulWidget {
  final TodoController controller;

  TodoView({required this.controller});

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subTaskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Travail';
  String _selectedPriority = 'Moyenne';

  String _selectedFilterCategory = 'Toutes';
  String _selectedFilterPriority = 'Toutes';
  String _searchText = '';

  void _showEmptyFieldAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Champ vide'),
          content: const Text('Veuillez entrer une tâche avant d\'ajouter.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouvelle Catégorie'),
          content: CustomTextField(
            controller: _categoryController,
            hintText: 'Nom de la catégorie',
          ),
          actions: [
            TextButton(
              onPressed: () {
                String newCategory = _categoryController.text.trim();
                if (newCategory.isNotEmpty &&
                    !widget.controller.categories.contains(newCategory)) {
                  setState(() {
                    widget.controller.addCategory(newCategory);
                    _selectedCategory = newCategory;
                  });
                }
                _categoryController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Ajouter'),
            ),
            TextButton(
              onPressed: () {
                _categoryController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _editTodo(int index) {
    final todo = widget.controller.todos[index];
    final TextEditingController editTitleController =
        TextEditingController(text: todo.title);
    String editSelectedCategory = todo.category;
    String editSelectedPriority = todo.priority;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier la tâche'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: editTitleController,
                hintText: 'Titre de la tâche',
              ),
              CustomDropdown<String>(
                value: editSelectedCategory,
                items: widget.controller.categories,
                onChanged: (newValue) {
                  setState(() {
                    editSelectedCategory = newValue!;
                  });
                },
              ),
              CustomDropdown<String>(
                value: editSelectedPriority,
                items: ['Haute', 'Moyenne', 'Basse'],
                onChanged: (newValue) {
                  setState(() {
                    editSelectedPriority = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String newTitle = editTitleController.text.trim();
                if (newTitle.isNotEmpty) {
                  setState(() {
                    widget.controller.editTodo(
                      index,
                      newTitle,
                      editSelectedCategory,
                      editSelectedPriority,
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enregistrer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _addSubTask(int index) {
    final todo = widget.controller.todos[index];
    String newSubTaskTitle = _subTaskController.text.trim();

    if (newSubTaskTitle.isNotEmpty) {
      setState(() {
        widget.controller.addSubTask(index, newSubTaskTitle);
        _subTaskController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de Tâches'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _searchController,
              hintText: 'Rechercher une tâche',
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _textController,
              hintText: 'Nouvelle tâche',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    value: _selectedCategory,
                    items: widget.controller.categories,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewCategory,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    value: _selectedPriority,
                    items: ['Haute', 'Moyenne', 'Basse'],
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPriority = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.isEmpty) {
                  _showEmptyFieldAlert();
                } else {
                  setState(() {
                    widget.controller.addTodo(
                      _textController.text,
                      _selectedCategory,
                      _selectedPriority,
                    );
                    _textController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Ajouter la tâche'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.controller.todos.length,
                itemBuilder: (context, index) {
                  final todo = widget.controller.todos[index];
                  if ((_selectedFilterCategory != 'Toutes' &&
                          todo.category != _selectedFilterCategory) ||
                      (_selectedFilterPriority != 'Toutes' &&
                          todo.priority != _selectedFilterPriority) ||
                      (_searchText.isNotEmpty &&
                          !todo.title
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()))) {
                    return Container(); // Masquer les tâches qui ne correspondent pas
                  }
                  return TodoCard(
                    todo: todo,
                    onEdit: () => _editTodo(index),
                    onDelete: () {
                      setState(() {
                        widget.controller.removeTodoAt(index);
                      });
                    },
                    onAddSubTask: () => _addSubTask(index),
                    subTaskController: _subTaskController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
