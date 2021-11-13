import 'package:flutter/material.dart';
import 'package:to_do/Models/task.dart';
import 'package:to_do/controller/task_controller.dart';
import 'package:to_do/ui/size_config.dart';
import 'package:to_do/ui/theme.dart';
import 'package:to_do/ui/widgets/button.dart';
import 'package:to_do/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _controller = Get.put(TaskController());

  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  int selectedReminder = 5;
  String _repeat = "none";
  List<int> reminderList = [5, 10, 15, 30];
  List<String> repeatList = ["none", "daily","Weekly", "Monthly"];
  var dateTime = DateTime.now();
  var startDate = DateFormat("hh:mm a").format(DateTime.now()).toString();
  var endTime = DateFormat("hh:mm a").format(
      DateTime.now().add(const Duration(minutes: 15))).toString();
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Get.isDarkMode ? const Icon(
            Icons.arrow_back_ios, color: primaryClr,) : const Icon(
            Icons.arrow_back, color: primaryClr,),

        ),

        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Text("Add Task here", style: Themes().titleStyle,),
              const SizedBox(height: 10,),
              InputField(title: "",
                hint: "enter your title",
                icon: const Icon(Icons.alarm),
                controller: _titleController,),
              const SizedBox(height: 10,),
              InputField(title: "",
                hint: "enter your note",
                icon: const Icon(Icons.note),
                controller: _noteController,),
              const SizedBox(height: 10,),
              InputField(title: "",
                hint: DateFormat.yMd().format(dateTime),
                icon: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    _getDateFromUser();
                  },),),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: InputField(
                    title: "",
                    hint: startDate,
                    icon: IconButton(
                      icon: const Icon(Icons.access_time_filled_outlined),
                      onPressed: () {
                        getTimeFromUser(true);
                      },),),

                  ),
                  Expanded(child: InputField(
                    title: "",
                    hint: endTime,
                    icon: IconButton(
                      icon: const Icon(Icons.access_time_filled_outlined),
                      onPressed: () {
                        getTimeFromUser(false);
                      },),),

                  )
                ],
              ),
              const SizedBox(height: 10,),
              InputField(title: "",
                  hint: "$selectedReminder minutes early",

                  icon: DropdownButton(
                    underline: Container(height: 0,),
                    dropdownColor: Colors.white,
                    items: reminderList.map((e) {
                      return DropdownMenuItem(child: Text("$e"), value: e,);
                    }).toList(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (val) {
                      setState(() {
                        selectedReminder = int.parse(val.toString());
                      });
                    },

                  )
              ),
              const SizedBox(height: 10,),
              InputField(title: "",
                hint: _repeat,
                icon: DropdownButton(
                  underline: Container(height: 0,),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  dropdownColor: Colors.white,
                  items: repeatList.map((e) {
                    return DropdownMenuItem(child: Text(e), value: e,);
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _repeat = val.toString();
                    });
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                    child: Row(
                      children: [
                        Text("choose color", style: Themes().subHeadingStyle,)
                      ],),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: List.generate(3, (index) =>
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: CircleAvatar(
                                radius: 15.0,
                                backgroundColor: index == 0
                                    ? primaryClr
                                    : index == 1 ? orangeClr : pinkClr,
                                child: _selectedColor == index ? const Icon(
                                  Icons.done, color: Colors.white,) : null,
                              ),
                            ),
                          )
                      )
                      ,),
                  )
                ],
              ),
              const SizedBox(height: 30,),
              MyButton(label: "Create Task", onTap: () {
                valdiateInputs();
              })


            ],
          ),
        ),
      ),
    );
  }

  void valdiateInputs() {
    if (_titleController.text.isEmpty) {
      Get.snackbar("required",
          "missing title",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: context.theme.backgroundColor,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.red,)
      );
    } else if (_noteController.text.isEmpty) {
      Get.snackbar("note",
          "missing note",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: context.theme.backgroundColor,
          colorText: Get.isDarkMode ? Colors.white : Colors.black
      );
    } else {

      addTaskToDb();
      Get.back();
    }
  }

  void addTaskToDb() async{

    var value = await _controller.addTaskToDatabase(
        Task(
            title: _titleController.text,
            note: _noteController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(dateTime),
            startTime: startDate,
            endTime: endTime,
            color: _selectedColor,
            remind: selectedReminder,
            repeat: _repeat
        )
    );
    print(value);
    Get.snackbar("Task", "Task Created",snackPosition: SnackPosition.BOTTOM);
    _controller.getTasks();
  }

  void _getDateFromUser() async{
    var pickedTime = await showDatePicker(context: context,
      initialDate: dateTime,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),);

    if(pickedTime != null){
      setState(() {
        dateTime = pickedTime;
      });
    }
  }

  void getTimeFromUser(bool isStartTime)async{
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime?TimeOfDay.fromDateTime(DateTime.now()):TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),
    );
    String formatedTime = pickedTime!.format(context);
    if(isStartTime){
      if(pickedTime !=null){
        setState(() {
          startDate = formatedTime;
        });
      }
    }else{
      if(pickedTime !=null){
        setState(() {
          endTime = formatedTime;
        });
      }
    }
  }


}
