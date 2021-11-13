import 'package:get/get.dart';
import 'package:to_do/Models/task.dart';
import 'package:to_do/database/d_base.dart';

class TaskController extends GetxController{
  RxList<Task> taskList = <Task>[].obs;

  Future<int> addTaskToDatabase(Task task) async {
    return DatabaseHelper.insert(task: task);
  }

  Future<void> getTasks() async{
      var query = await DatabaseHelper().query();
      taskList.assignAll(query.map((data) => Task.fromJson(data)).toList());
  }

  Future<int> delete(Task task) async {
    return await DatabaseHelper().delete(task);
  }

  Future<int> updateTask(Task task) async {
    return await DatabaseHelper().update(task);
  }
}