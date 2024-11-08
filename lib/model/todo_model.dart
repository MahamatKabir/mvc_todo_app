// lib/model/todo_model.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SubTask {
  String title;
  bool isDone;

  SubTask({
    required this.title,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      title: json['title'],
      isDone: json['isDone'],
    );
  }
}

class Todo {
  String title;
  bool isDone;
  String category;
  String priority; // Nouvelle propriété pour la priorité
  List<SubTask> subTasks; // Nouvelle propriété pour les sous-tâches
  DateTime creationDate; // Ajout du champ de date de création
  Todo({
    required this.title,
    this.isDone = false,
    required this.category,
    required this.priority, // Requis maintenant
    List<SubTask>? subTasks, // Optionnel à la création
    required this.creationDate,
  }) : subTasks =
            subTasks ?? []; // Initialiser à une liste vide si aucune donnée

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
      'category': category,
      'priority': priority,
      'creationDate': creationDate,
      'subTasks': subTasks.map((subTask) => subTask.toJson()).toList(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isDone: json['isDone'],
      category: json['category'],
      priority: json['priority'], // Récupérer la priorité
      creationDate: json["creationDate"],
      subTasks: (json['subTasks'] as List)
          .map((subTaskJson) => SubTask.fromJson(subTaskJson))
          .toList(),
    );
  }
}

class TodoModel {
  List<Todo> todos = [];

  Future<void> loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosData = prefs.getString('todos');
    if (todosData != null) {
      List<dynamic> jsonData = json.decode(todosData);
      todos = jsonData.map((data) => Todo.fromJson(data)).toList();
    }
  }

  Future<void> saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonData =
        todos.map((todo) => json.encode(todo.toJson())).toList();
    await prefs.setString('todos', json.encode(jsonData));
  }

  void addTodo(Todo todo) {
    todos.add(todo);
    saveTodos();
  }

  void removeTodo(Todo todo) {
    todos.remove(todo);
    saveTodos();
  }

  void toggleTodoStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    saveTodos();
  }

  void addSubTask(Todo todo, SubTask subTask) {
    todo.subTasks.add(subTask);
    saveTodos();
  }

  void toggleSubTaskStatus(Todo todo, SubTask subTask) {
    subTask.isDone = !subTask.isDone;
    saveTodos();
  }
}
