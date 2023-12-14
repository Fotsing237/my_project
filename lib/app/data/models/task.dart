import 'package:equatable/equatable.dart';

class Task extends Equatable{
  final String title;
  final int icon;
  final String color;
  List<dynamic>? tasks;

   Task({
    required this.title,
    required this.icon,
    required this.color,
    this.tasks
  });

  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<dynamic>? tasks,
  }) => Task(
    title: title ?? this.title,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    tasks: tasks ?? this.tasks
  );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    icon: json['icon'],
    color: json['color'],
    tasks: json['tasks']
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'icon': icon,
    'color': color,
    'tasks': tasks,
  };
  
  @override
  List<Object?> get props => [title, icon, color];
}
