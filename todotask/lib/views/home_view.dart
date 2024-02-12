import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:todotask/constants.dart';
import 'package:todotask/services/prefs_service.dart';
import 'package:todotask/views/add_task.dart';
import 'package:todotask/views/edit_task.dart';

import '../providers/task_providers.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    ToastContext().init(context);
    var tasksAsyncValue = ref.watch(taskListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('What To Do?'),
        backgroundColor: MyColors.primaryBtnC,
        actions: [
          SizedBox(
            height: 20,
            width: 20,
            child: Hero(
                tag: 'one',
                child: Lottie.asset('lib/assets/app-main.json',
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      drawer: const Drawer(),
      body: SizedBox(
          height: s.height,
          child: Column(
            children: [
              Expanded(
                  child: tasksAsyncValue.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const Center(child: Text('No tasks available'));
                  } else {
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              task.imp
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.green,
                                              child: Icon(
                                                Icons.priority_high,
                                                size: 15,
                                                color: Colors.white,
                                              ))),
                                    )
                                  : const SizedBox(),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.blueGrey)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ExpansionTile(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey)),
                                      title: Text(
                                        task.name,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      expandedAlignment: Alignment.centerLeft,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(task.desc)),
                                        ),
                                        //      Text('Due on:   ${task.dueon}'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Text('Due on:   ${task.dueon}'),
                                            const Spacer(),
                                            task.isDone
                                                ? const SizedBox()
                                                : IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                              builder: (context) => EditTask(
                                                                  cb: () => ref
                                                                      .refresh(
                                                                          taskListProvider),
                                                                  index: index,
                                                                  task: task)));
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.orange,
                                                    )),
                                            task.isDone
                                                ? SizedBox(
                                                    child: Text(
                                                      'Done',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: MyColors
                                                              .secondaryBtnC),
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () async {
                                                      await PrefsService
                                                          .markAsDone(index);
                                                      tasksAsyncValue =
                                                          ref.refresh(
                                                              taskListProvider);
                                                      Toast.show(
                                                          'Marked as done...');
                                                    },
                                                    icon: const Icon(
                                                      Icons.done,
                                                      color: Colors.green,
                                                    )),
                                            IconButton(
                                                onPressed: () {
                                                  PrefsService.delTask(index);
                                                  Toast.show('Deleted...');
                                                  tasksAsyncValue = ref.refresh(
                                                      taskListProvider);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) {
                  return const Center(
                    child: Text('No tasks to show. Create new tasks '),
                  );
                },
              ))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primaryBtnC,
        child: const Icon(Icons.add_box),
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AddTask(
                        cb: () => ref.refresh(taskListProvider),
                      )));
        },
      ),
    );
  }
}
