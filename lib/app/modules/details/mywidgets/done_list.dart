import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/app/core/utils/extensions.dart';
import 'package:my_project/app/core/values/colors.dart';
import 'package:my_project/app/modules/home/controller.dart';

class DoneList extends StatelessWidget {
  final homeCtlr = Get.find<HomeController>();
  DoneList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtlr.doneTasks.isNotEmpty ? ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 10.0.wp),
            child: Text(
              'Completed(${homeCtlr.doneTasks.length})',
              style: TextStyle(
                fontSize: 8.0.sp,
                color: Colors.grey
              ),
            ),
          ),
          ...homeCtlr.doneTasks.map((element) => 
            Dismissible(
              key: ObjectKey(element),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => homeCtlr.deleteDoneItem(element),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0.wp),
                  child: const Icon(Icons.delete, color: Colors.white,),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.5.wp, horizontal: 16.0.wp),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(Icons.done, color: blue,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: Text(
                        element['title'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 4.5.sp,
                          decoration: TextDecoration.lineThrough
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          )
        ],
      ) : Container()
    );
  }
}
