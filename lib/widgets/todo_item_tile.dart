import 'package:flutter/material.dart';

import '../models/todo_item.dart';

class TodoItemTile extends StatelessWidget {
  const TodoItemTile({
    super.key,
    required this.todo,
    required this.onToggleCompleted,
    required this.onDelete,
  });

  final TodoItem todo;
  final VoidCallback onToggleCompleted;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = todo.isCompleted;
    final isImportant = todo.isImportant;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      color: isCompleted
          ? colorScheme.surfaceContainerLow
          : colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isImportant && !isCompleted
              ? colorScheme.tertiary.withValues(alpha: 0.65)
              : colorScheme.outlineVariant.withValues(alpha: 0.7),
          width: isImportant && !isCompleted ? 1.4 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onToggleCompleted,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: (_) => onToggleCompleted(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isCompleted ? FontWeight.w400 : FontWeight.w600,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isCompleted
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _StatusBadge(isCompleted: isCompleted),
                        if (isImportant)
                          _ImportanceBadge(isCompleted: isCompleted),
                      ],
                    ),
                  ],
                ),
              ),
              if (isImportant)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.star_rounded,
                    color: isCompleted
                        ? colorScheme.onSurfaceVariant
                        : Colors.amber.shade700,
                    semanticLabel: 'Attività importante',
                  ),
                ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Elimina attività',
                color: colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isCompleted
            ? colorScheme.secondaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isCompleted ? 'Completata' : 'Da fare',
        style: theme.textTheme.labelSmall?.copyWith(
          color: isCompleted
              ? colorScheme.onSecondaryContainer
              : colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ImportanceBadge extends StatelessWidget {
  const _ImportanceBadge({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isCompleted
            ? colorScheme.surfaceContainerHighest
            : Colors.amber.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Importante',
        style: theme.textTheme.labelSmall?.copyWith(
          color: isCompleted
              ? colorScheme.onSurfaceVariant
              : Colors.amber.shade900,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
