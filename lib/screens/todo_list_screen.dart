import 'package:flutter/material.dart';

import '../models/todo_item.dart';
import '../widgets/empty_todos_view.dart';
import '../widgets/todo_item_tile.dart';
import '../widgets/todo_summary_header.dart';
import 'create_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];

  int get _completedCount => _todos.where((todo) => todo.isCompleted).length;

  Future<void> _openCreateTodoScreen() async {
    final newTodo = await Navigator.of(context).push<TodoItem>(
      MaterialPageRoute(
        builder: (context) => const CreateTodoScreen(),
      ),
    );

    if (!mounted || newTodo == null) return;

    setState(() {
      _todos.add(newTodo);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Attività aggiunta'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _toggleTodoCompleted(String id) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        final current = _todos[index];
        _todos[index] = current.copyWith(isCompleted: !current.isCompleted);
      }
    });
  }

  Future<void> _confirmDeleteTodo(TodoItem todo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          title: const Text('Elimina attività'),
          content: Text('Vuoi eliminare l’attività "${todo.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _todos.removeWhere((item) => item.id == todo.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie attività'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TodoSummaryHeader(
              completedCount: _completedCount,
              totalCount: _todos.length,
            ),
            Expanded(
              child: _todos.isEmpty
                  ? const EmptyTodosView()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 96),
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        final todo = _todos[index];
                        return TodoItemTile(
                          key: ValueKey(todo.id),
                          todo: todo,
                          onToggleCompleted: () =>
                              _toggleTodoCompleted(todo.id),
                          onDelete: () => _confirmDeleteTodo(todo),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateTodoScreen,
        tooltip: 'Aggiungi attività',
        icon: const Icon(Icons.add),
        label: const Text('Aggiungi attività'),
      ),
    );
  }
}
