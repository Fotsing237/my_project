import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/app/core/utils/extensions.dart';
import 'package:my_project/app/modules/home/controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddDialog extends StatelessWidget {
  final homeCtlr = Get.find<HomeController>();
  AddDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                          homeCtlr.editCtlr.clear();
                          homeCtlr.changeTask(null);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        )),
                    TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {
                          if (homeCtlr.formKey.currentState!.validate()) {
                            if (homeCtlr.task.value == null) {
                              EasyLoading.showError("Please select a task type");
                            } else {
                              var success = homeCtlr.updateTask(
                                homeCtlr.task.value!,
                                homeCtlr.editCtlr.text
                              );
                              if (success) {
                                EasyLoading.showSuccess(
                                    "item added successfully");
                                Get.back();
                                homeCtlr.changeTask(null);
                              } else {
                                EasyLoading.showError("item already exist");
                              }
                              homeCtlr.editCtlr.clear();
                            }
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 6.0.wp,
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                child: Text(
                  'New Task',
                  style:
                      TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                child: TextFormField(
                  controller: homeCtlr.editCtlr,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  )),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your item';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 4.0.wp, left: 4.0.wp, right: 4.0.wp, bottom: 2.0.wp),
                child: Text(
                  'Add to',
                  style: TextStyle(
                    fontSize: 10.0.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              ...homeCtlr.tasks
                  .map(
                    (element) => Obx(
                      () => InkWell(
                        onTap: () => homeCtlr.changeTask(element),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.0.wp, horizontal: 5.0.wp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    IconData(element.icon,
                                        fontFamily: 'MaterialIcons'),
                                    color: HexColor.fromHex(element.color),
                                  ),
                                  SizedBox(
                                    width: 3.0.wp,
                                  ),
                                  Text(
                                    element.title,
                                    style: TextStyle(
                                        fontSize: 9.0.wp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              if (homeCtlr.task.value == element)
                                const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
