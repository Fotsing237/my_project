import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/app/core/utils/extensions.dart';
import 'package:my_project/app/modules/home/controller.dart';

class DoingList extends StatelessWidget {
  final homeCtlr = Get.find<HomeController>();
  DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeCtlr.doingTasks.isEmpty && homeCtlr.doneTasks.isEmpty
      ? Column(
          children: [
            Image.asset(
              'assets/images/task.png',
              fit: BoxFit.cover,
              width: 65.0.wp,
            ),
            Text(
              'Add Task',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
            )
          ],
        )
      : ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 10.0.wp),
            child: Text(
              'On going (${homeCtlr.doingTasks.length})',
              style: TextStyle(
                fontSize: 7.0.wp,
                color: Colors.grey
              ),
            ),
          ),
          ...homeCtlr.doingTasks.map(
            (element) => Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.wp, horizontal: 16.0.wp),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      fillColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.grey),
                      value: element['done'],
                      onChanged: (value) {
                        homeCtlr.doneItem(element['title']);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                    child: Text(
                      element['title'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 4.5.sp,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ).toList(),
          if(homeCtlr.doingTasks.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
              child: const Divider(thickness: 2,),
            ), 
        ],
      )
    );
  }
}
