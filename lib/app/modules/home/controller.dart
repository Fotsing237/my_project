import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_project/app/data/models/task.dart';
import 'package:my_project/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});

  final formKey = GlobalKey<FormState>();
  final editCtlr = TextEditingController();
  final tabIndex = 0.obs;
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTasks = <dynamic>[].obs;
  final doneTasks = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    editCtlr.dispose();
    super.onClose();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? select) {
    task.value = select;
  }

  void changeTaskItems(List<dynamic> select) {
    doingTasks.clear();
    doneTasks.clear();
    for (int i = 0; i < select.length; i++) {
      var item = select[i];
      var status = item['done'];
      if (status == true) {
        doneTasks.add(item);
      } else {
        doingTasks.add(item);
      }
    }
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  updateTask(Task task, String title) {
    var myTasks = task.tasks ?? [];
    if (containsTask(myTasks, title)) {
      return false;
    }
    var myTask = {'title': title, 'done': false};
    myTasks.add(myTask);

    var newTask = task.copyWith(tasks: myTasks);
    int oldIndex = tasks.indexOf(task);
    tasks[oldIndex] = newTask;
    tasks.refresh();
    return true;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  bool containsTask(List myTasks, String title) {
    return myTasks.any((element) => element['title'] == title);
  }

  bool addItem(String title) {
    var doingItem = {'title': title, 'done': false};
    if (doingTasks
        .any((element) => mapEquals<String, dynamic>(doingItem, element))) {
      return false;
    }
    var doneItem = {'title': title, 'done': true};
    if (doneTasks
        .any((element) => mapEquals<String, dynamic>(doneItem, element))) {
      return false;
    }
    doingTasks.add(doingItem);
    return true;
  }

  void updateItem() {
    var newItem = <Map<String, dynamic>>[];
    newItem.addAll([...doingTasks, ...doneTasks]);
    var newTask = task.value!.copyWith(tasks: newItem);
    int oldIndex = tasks.indexOf(task.value);
    tasks[oldIndex] = newTask;
    tasks.refresh();
  }

  void doneItem(String title) {
    var doingItem = {'title': title, 'done': false};
    int index = doingTasks.indexWhere(
        (element) => mapEquals<String, dynamic>(doingItem, element));
    doingTasks.removeAt(index);
    var doneItem = {'title': title, 'done': true};
    doneTasks.add(doneItem);
    doingTasks.refresh();
    doneTasks.refresh();
  }

  void deleteDoneItem(dynamic doneItem) {
    int index = doneTasks.indexWhere((element) => mapEquals(doneItem, element));
    doneTasks.removeAt(index);
    doingTasks.refresh();
  }

  bool isItemEmpty(Task task) {
    return task.tasks == null
        // which is equivalent to
        ||
        task.tasks!.isEmpty;
  }

  int getDoneItems(Task task) {
    var result = 0;
    for (int i = 0; i < task.tasks!.length; i++) {
      if (task.tasks![i]['done'] == true) {
        result += 1;
      }
    }
    return result;
  }

  int getTotalTask() {
    var result = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].tasks != null) {
        result += tasks[i].tasks!.length;
      }
    }
    return result;
  }

  int getTotalDoneItem() {
    var result = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].tasks != null) {
        for (int j = 0; j < tasks[i].tasks!.length; j++) {
          if (tasks[i].tasks![j]['done'] == true) {
            result += 1;
          }
        }
      }
    }
    return result;
  }
}
