import 'package:get/get.dart';
import 'package:my_project/app/data/provider/task/provider.dart';
import 'package:my_project/app/data/services/storage/repository.dart';
import 'package:my_project/app/modules/home/controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(
        taskRepository: TaskRepository(
          taskProvider: TaskProvider()
        ),
      ),
    );
  }
}
