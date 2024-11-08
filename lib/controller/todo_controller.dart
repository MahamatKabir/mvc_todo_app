// lib/controller/todo_controller.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo_model.dart';

class TodoController {
  List<Todo> todos = [];
  List<String> categories = ['Travail', 'Personnel', 'Maison'];

  TodoController() {
    loadFromLocal(); // Charger les données au démarrage
  }

  Future<void> addTodo(String title, String category, String priority) async {
    todos.add(Todo(
      title: title,
      category: category,
      priority: priority,
      creationDate: DateTime.now(),
    ));
    await saveToLocal();
  }

  Future<void> addCategory(String newCategory) async {
    if (!categories.contains(newCategory)) {
      categories.add(newCategory);
      await saveToLocal();
    }
  }

  void toggleTodoStatus(int index) async {
    todos[index].isDone = !todos[index].isDone;
    await saveToLocal();
  }

  void removeTodoAt(int index) async {
    todos.removeAt(index);
    await saveToLocal();
  }

  Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todosJson = todos
        .map((todo) => jsonEncode({
              'title': todo.title,
              'isDone': todo.isDone,
              'category': todo.category,
              'priority': todo.priority,
            }))
        .toList();
    await prefs.setStringList('todos', todosJson);
    await prefs.setStringList('categories', categories);
  }

  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todosJson = prefs.getStringList('todos');
    List<String>? savedCategories = prefs.getStringList('categories');

    if (todosJson != null) {
      todos = todosJson.map((todoString) {
        final Map<String, dynamic> todoMap = jsonDecode(todoString);
        return Todo(
          title: todoMap['title'],
          isDone: todoMap['isDone'],
          category: todoMap['category'],
          creationDate: DateTime.now(),
          priority:
              todoMap['priority'], // Ajout de la récupération de la priorité
        );
      }).toList();
    }

    if (savedCategories != null) {
      categories = savedCategories;
    }
  }

  Future<void> editTodo(int index, String newTitle, String newCategory,
      String newPriority) async {
    todos[index].title = newTitle;
    todos[index].category = newCategory;
    todos[index].priority = newPriority;
    await saveToLocal();
  }

  void addSubTask(int todoIndex, String subTaskTitle) {
    if (todoIndex >= 0 && todoIndex < todos.length) {
      todos[todoIndex].subTasks.add(SubTask(title: subTaskTitle));
    }
  }

  void toggleSubTaskStatus(int todoIndex, int subTaskIndex) {
    if (todoIndex >= 0 && todoIndex < todos.length) {
      final subTask = todos[todoIndex].subTasks[subTaskIndex];
      subTask.isDone = !subTask.isDone;
    }
  }
}
