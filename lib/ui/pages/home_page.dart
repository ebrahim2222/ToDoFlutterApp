import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/Models/task.dart';
import 'package:to_do/controller/task_controller.dart';
import 'package:to_do/services/notification_services.dart';
import 'package:to_do/services/theme_services.dart';
import 'package:to_do/ui/pages/add_task_page.dart';
import 'package:to_do/ui/size_config.dart';
import 'package:to_do/ui/widgets/button.dart';
import 'package:to_do/ui/widgets/input_field.dart';
import 'package:to_do/ui/theme.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:to_do/ui/widgets/task_tile.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/Models/task.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _controller = Get.put(TaskController());
  late NotificationServices _notificationServices;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getTask();
    _notificationServices = NotificationServices();
    _notificationServices.initializeNotification();
    _notificationServices.requestIosPermission();
  }

  var _selectedValue;
  var x = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Get.put(TaskController());


    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Get.isDarkMode
              ? const Icon(
                  Icons.wb_sunny,
                )
              : const Icon(
                  Icons.dark_mode,
                  color: Colors.black,
                ),
          onPressed: () {
            ThemeServices().switchTheme();
          },
        ),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
      ),
      body: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              _addTask(),
              _DatePicker(),
              _showTask(),
            ],
          )),
    );
  }

  getTask() async {
    _controller.getTasks();
  }

  _addTask() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: Themes().subTitleStyle,
              ),
              Text(
                "Today",
                style: Themes().subHeadingStyle,
              ),
            ],
          ),
          MyButton(
            label: "Add Task",
            onTap: () async {
              await Get.to(const AddTaskPage());
              // NotificationServices().scheduledNotification();
            },
          ),
        ],
      ),
    );
  }

  _DatePicker() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          // New date selected
          setState(() {
            _selectedValue = date;
          });
        },
      ),
    );
  }

  _showTask() {
    if (_controller.taskList.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 150),
        child: Column(
          children: [
            SvgPicture.asset("images/task.svg"),
          ],
        ),
      );
    } else {
      return Expanded(
          child: ListView.builder(
        itemBuilder: (ctx, index) {
          var task = _controller.taskList[index];
          if(task.repeat == "daily" || task.date == DateFormat.yMd().format(_selectedValue)||
              (task.repeat == "Weekly" && _selectedValue.difference(DateFormat.yMd().parse(task.date!)).inDays % 7==0)||
              (task.repeat == "Monthly" && DateFormat.yMd().parse(task.date!).day == _selectedValue.day)
          ){
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 1375),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      showBottomSheet(task);
                    },
                    child: TaskTile(task: task),
                  ),
                ),
              ),
            );
          }else{
            return Container();
          };
        },
        itemCount: _controller.taskList.length,
      ));
    }
  }

  showBottomSheet(Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.theme.backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            task.isCompleted == 1
                ? Container()
                : MyButton(
                    label: "Complete Task",
                    onTap: () {
                      _controller.updateTask(task);
                      getTask();
                      NotificationServices().cancelNotification(task);
                      Get.back();
                    },
                  ),
            const SizedBox(
              height: 20,
            ),
            MyButton(label: "Cancel Task", onTap: () {
              print("cancel button pressed");
              _controller.delete(task);
              NotificationServices().cancelNotification(task);
              Get.back();
              getTask();
            }),
            const SizedBox(
              height: 20,
            ),
            MyButton(
                label: "Back",
                onTap: () {
                  Get.back();
                }),
          ],
        ),
      ),
    ));
  }
}
