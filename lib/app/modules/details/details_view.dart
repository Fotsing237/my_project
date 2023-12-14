import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/app/core/utils/extensions.dart';
import 'package:my_project/app/modules/details/mywidgets/doing_list.dart';
import 'package:my_project/app/modules/details/mywidgets/done_list.dart';
import 'package:my_project/app/modules/home/controller.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DetailsPage extends StatelessWidget {
  final homeCtlr = Get.find<HomeController>();
  DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var task = homeCtlr.task.value!;
    var color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: homeCtlr.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                          homeCtlr.updateItem();
                          homeCtlr.changeTask(null);
                          homeCtlr.editCtlr.clear();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.wp),
                child: Row(
                  children: [
                    Icon(
                      IconData(task.icon, fontFamily: 'MaterialIcons'),
                      color: color,
                    ),
                    SizedBox(
                      width: 3.0.wp,
                    ),
                    Text(
                      task.title,
                      style: TextStyle(
                          fontSize: 8.0.sp, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Obx(() {
                var totalTasks =
                    homeCtlr.doingTasks.length + homeCtlr.doneTasks.length;
                return Padding(
                  padding:
                      EdgeInsets.only(top: 3.0.wp, left: 18.0.wp, right: 18.0.wp),
                  child: Row(
                    children: [
                      Text(
                        '$totalTasks Tasks',
                        style: TextStyle(fontSize: 6.0.sp, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 3.0.wp,
                      ),
                      Expanded(
                          child: StepProgressIndicator(
                        totalSteps: totalTasks == 0 ? 1 : totalTasks,
                        currentStep: homeCtlr.doneTasks.length,
                        size: 5,
                        padding: 0,
                        selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [color.withOpacity(0.5), color]),
                        unselectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [Colors.grey[300]!, Colors.grey[300]!]),
                      ))
                    ],
                  ),
                );
              }),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 5.0.wp),
                child: TextFormField(
                  controller: homeCtlr.editCtlr,
                  autofocus: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!)),
                      prefixIcon: Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.grey[400],
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (homeCtlr.formKey.currentState!.validate()) {
                              var success =
                                  homeCtlr.addItem(homeCtlr.editCtlr.text);
                              if (success) {
                                EasyLoading.showSuccess(
                                    "item added successfully");
                              } else {
                                EasyLoading.showError("item already exist");
                              }
                              homeCtlr.editCtlr.clear();
                            }
                          },
                          icon: const Icon(Icons.done))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter an item";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              DoingList(),
              DoneList(),
            ],
          ),
        ),
      ),
    );
  }
}
