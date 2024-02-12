import 'package:shared_preferences/shared_preferences.dart';
import 'package:todotask/models/task_model.dart';

class PrefsService {
  static Future<bool> saveTaskToDevice(String taskString) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (sharedPreferences.containsKey('savedtasks')) {
        var temp = sharedPreferences.getStringList('savedtasks')!;
        temp.add(taskString);
        sharedPreferences.setStringList('savedtasks', temp);
      } else {
        sharedPreferences.setStringList('savedtasks', [taskString]);
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Task>> getTasks() async {
    List<Task> mytasks = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('savedtasks')) {
      var temp = sharedPreferences.getStringList('savedtasks')!;
      print(temp.length);
      for (var task in temp) {
        mytasks.add(Task.taskfromString(task));
      }
    }
    //  print(mytasks);
    return mytasks;
  }

  static Future<bool> delTask(int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('savedtasks')) {
      var temp = sharedPreferences.getStringList('savedtasks')!;
      temp.removeAt(index);
      sharedPreferences.setStringList('savedtasks', temp);
      return true;
    }

    return false;
  }

  static Future<bool> editTask(int index, String taskString) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('savedtasks')) {
      var temp = sharedPreferences.getStringList('savedtasks')!;
      temp[index] = taskString;
      sharedPreferences.setStringList('savedtasks', temp);
      return true;
    }

    return false;
  }

  static Future<bool> markAsDone(
    int index,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('savedtasks')) {
      var temp = sharedPreferences.getStringList('savedtasks')!;
      Task task = Task.taskfromString(temp[index]);

      var donetask =
          '${task.name}~%~${task.desc}~%~${task.imp}~%~${task.dueon}~%~true';
      temp[index] = donetask;
      sharedPreferences.setStringList('savedtasks', temp);
      return true;
    }

    return false;
  }
}
