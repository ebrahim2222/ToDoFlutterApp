import 'package:flutter/material.dart';
import 'package:to_do/Models/task.dart';
import 'package:to_do/ui/size_config.dart';
import 'package:to_do/ui/theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);
   final Task task;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: SizeConfig.orientation == Orientation.landscape? EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(4)):EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
      child: SizedBox(
        height: 120,
        width:SizeConfig.orientation == Orientation.landscape? SizeConfig.screenWidth/2 :SizeConfig.screenWidth ,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: _getBGColor(task.color!),
          ),

          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            children: [
              Expanded(child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(margin:const EdgeInsets.only(left: 10),child: Text(task.title!)),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const SizedBox(width: 5,),
                        const Icon(
                          Icons.access_time_rounded
                        ),
                        const SizedBox(width: 5,),
                        Text("${task.startTime} - ${task.endTime}")
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(margin:const EdgeInsets.only(left: 10),child: Text(task.note!))
                  ],
                ),
              )),
              Container(),
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: RotatedBox(quarterTurns: 3,
                  child: Text(task.isCompleted == 0?"TODO":"Completed"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getBGColor(int color) {
    switch(color){
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
