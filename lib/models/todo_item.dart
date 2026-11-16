import 'package:flutter/foundation.dart';

@immutable
class TodoItem {
  const TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isImportant = false,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final bool isImportant;

  TodoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isImportant,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isImportant: isImportant ?? this.isImportant,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TodoItem &&
        other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted &&
        other.isImportant == isImportant;
  }

  @override
  int get hashCode => Object.hash(id, title, isCompleted, isImportant);
}
