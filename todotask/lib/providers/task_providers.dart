import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todotask/models/task_model.dart';
import 'package:todotask/services/prefs_service.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);
final taskListProvider = FutureProvider<List<Task>>((ref) async {
  return await PrefsService.getTasks();
});

final addTaskProvider = FutureProvider.family<Future<bool>, Task>((ref, task) {
  // isLoadingRef = true;
  // ref.watch(isLoadingProvider);

  try {
    return PrefsService.saveTaskToDevice(Task.tasktoString(task));
  } finally {
    // isLoadingRef = false;
  }
});

final deleteTaskProvider = FutureProvider.family<bool, int>((ref, index) {
  return PrefsService.delTask(index);
});

final editTaskProvider =
    FutureProvider.family<bool, EditTaskModel>((ref, edittask) {
  return PrefsService.editTask(edittask.index, edittask.task);
});

final markTaskAsDoneProvider = FutureProvider.family<bool, int>((ref, index) {
  return PrefsService.markAsDone(index);
});
