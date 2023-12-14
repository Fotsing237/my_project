import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/app/core/utils/extensions.dart';
import 'package:my_project/app/core/values/colors.dart';
import 'package:my_project/app/data/models/task.dart';
import 'package:my_project/app/modules/home/controller.dart';
import 'package:my_project/app/widgets/icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddCard extends StatelessWidget {
  final homeCtlr = Get.find<HomeController>();
  AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;

    return Container(
      width: squareWidth / 2,
      height: squareWidth / 1.25,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 3.0.wp),
            radius: 5,
            title: 'Task Type',
            content: Form(
              key: homeCtlr.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                    child: TextFormField(
                      controller: homeCtlr.editCtlr,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter ypur task title';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0.wp),
                    child: Wrap(
                      spacing: 1.5.wp,
                      children: icons
                          .map((e) => Obx(() {
                                final index = icons.indexOf(e);
                                return ChoiceChip(
                                  selectedColor: Colors.grey[200],
                                  pressElevation: 0,
                                  backgroundColor: Colors.white,
                                  label: e,
                                  selected: homeCtlr.chipIndex.value == index,
                                  onSelected: (bool selected) {
                                    homeCtlr.chipIndex.value =
                                        selected ? index : 0;
                                  },
                                );
                              }))
                          .toList(),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(100, 40)),
                      onPressed: () {
                        if (homeCtlr.formKey.currentState!.validate()) {
                          int icon =
                              icons[homeCtlr.chipIndex.value].icon!.codePoint;
                          String color = icons[homeCtlr.chipIndex.value].color!.toHex();
                          var task = Task(
                            title: homeCtlr.editCtlr.text,
                            icon: icon,
                            color: color,
                          );
                          Get.back();
                          homeCtlr.addTask(task)
                              ? EasyLoading.showSuccess(
                                  'Created Successfully')
                              : EasyLoading.showError('Duplicated Task');
                        }
                      },
                      child: const Text('Confirm')),
                ],
              ),
            )
          );
          homeCtlr.editCtlr.clear();
          homeCtlr.changeChipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [6, 3],
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.0.wp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
