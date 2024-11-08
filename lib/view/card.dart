import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_todo_app/model/todo_model.dart';
import 'package:mvc_todo_app/view/text.dart';

class TodoCard extends StatefulWidget {
  final Todo todo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddSubTask;
  final TextEditingController subTaskController;

  const TodoCard({
    required this.todo,
    required this.onEdit,
    required this.onDelete,
    required this.onAddSubTask,
    required this.subTaskController,
  });

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  // Méthode pour obtenir la couleur en fonction de la priorité
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Haute':
        return Colors.red.shade100;
      case 'Moyenne':
        return Colors.orange.shade100;
      case 'Basse':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getPriorityTextColor(String priority) {
    switch (priority) {
      case 'Haute':
        return Colors.red.shade800;
      case 'Moyenne':
        return Colors.orange.shade800;
      case 'Basse':
        return Colors.green.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: _isExpanded ? 6 : 3,
      borderRadius: BorderRadius.circular(15.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: _toggleExpansion,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.todo.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: widget.onEdit,
                      splashRadius: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: widget.onDelete,
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Catégorie avec icône de dossier
                    Chip(
                      avatar: Icon(Icons.folder, color: Colors.blue[700]),
                      label: Text(widget.todo.category),
                      backgroundColor: Colors.blue[50],
                      labelStyle: TextStyle(color: Colors.blue[700]),
                    ),
                    // Priorité avec icône et couleur en fonction de la priorité
                    Chip(
                      avatar: Icon(Icons.star,
                          color: _getPriorityTextColor(widget.todo.priority)),
                      label: Text('Priorité : ${widget.todo.priority}'),
                      backgroundColor: _getPriorityColor(widget.todo.priority),
                      labelStyle: TextStyle(
                          color: _getPriorityTextColor(widget.todo.priority)),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm')
                      .format(widget.todo.creationDate),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                AnimatedOpacity(
                  opacity: widget.todo.subTasks.isNotEmpty ? 1 : 0,
                  duration: Duration(milliseconds: 300),
                  child: widget.todo.subTasks.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6.0),
                            Text(
                              'Sous-tâches :',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            ...widget.todo.subTasks.map(
                              (subTask) => Padding(
                                padding:
                                    const EdgeInsets.only(left: 12.0, top: 2.0),
                                child: Text(
                                  '- $subTask',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
                AnimatedCrossFade(
                  firstChild: SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      Divider(color: Colors.blueGrey[200], thickness: 1.2),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: widget.subTaskController,
                                hintText: 'Nouvelle sous-tâche',
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: widget.onAddSubTask,
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
