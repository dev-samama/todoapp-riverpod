class Task {
  final String name;
  final String desc;
  final bool imp;
  bool isDone;
  final String dueon;

  Task(
      {required this.name,
      required this.desc,
      required this.imp,
      required this.dueon,
      required this.isDone});

  static String tasktoString(Task task) {
    return '${task.name}~%~${task.desc}~%~${task.imp}~%~${task.dueon}~%~${task.isDone}';
  }

  static Task taskfromString(String taskString) {
    return Task(
        name: taskString.split('~%~').first,
        desc: taskString.split('~%~')[1],
        imp: taskString.split('~%~')[2] == 'true' ? true : false,
        dueon: taskString.split('~%~')[3],
        isDone: taskString.split('~%~')[4] == 'true' ? true : false);
  }
}

class EditTaskModel {
  final int index;
  final String task;

  EditTaskModel({required this.index, required this.task});
}
