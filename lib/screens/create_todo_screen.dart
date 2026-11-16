import 'package:flutter/material.dart';

import '../models/todo_item.dart';

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  static int _nextId = 1;

  final TextEditingController _titleController = TextEditingController();
  bool _isImportant = false;
  String? _titleError;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onTitleChanged(String _) {
    if (_titleError != null) {
      setState(() {
        _titleError = null;
      });
    }
  }

  void _submit() {
    final trimmedTitle = _titleController.text.trim();
    if (trimmedTitle.isEmpty) {
      setState(() {
        _titleError = 'Inserisci un titolo per l’attività';
      });
      return;
    }

    final newTodo = TodoItem(
      id: '${DateTime.now().microsecondsSinceEpoch}-${_nextId++}',
      title: trimmedTitle,
      isImportant: _isImportant,
    );

    Navigator.of(context).pop(newTodo);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova attività'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Dettagli attività',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onChanged: _onTitleChanged,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Titolo attività',
                  hintText: 'Es. Preparare gli appunti di lezione',
                  errorText: _titleError,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                child: SwitchListTile(
                  value: _isImportant,
                  onChanged: (value) {
                    setState(() {
                      _isImportant = value;
                    });
                  },
                  title: const Text('Attività importante'),
                  subtitle: Text(
                    _isImportant
                        ? 'Sì — verrà evidenziata nell’elenco'
                        : 'No — priorità normale',
                  ),
                  secondary: Icon(
                    _isImportant
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: _isImportant
                        ? Colors.amber.shade700
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Salva attività'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Annulla'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
