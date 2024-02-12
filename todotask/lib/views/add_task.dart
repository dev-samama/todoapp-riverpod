import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';

import '../constants.dart';
import '../models/task_model.dart';
import '../providers/task_providers.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({
    Key? key,
    required this.cb,
  }) : super(key: key);

  final VoidCallback cb;

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  final TextEditingController tcont = TextEditingController();
  final TextEditingController desccont = TextEditingController();
  bool isImp = false;
  String dateString = '';

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    final isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text(
          "Add New Task",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: MyColors.primaryBtnC,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextFormField(
                controller: tcont,
                maxLines: 2,
                maxLength: 60,
                decoration: InputDecoration(
                  hintText: "Enter name here...",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyColors.primaryBtnC,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyColors.primaryBtnC,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 20,
                maxLength: 500,
                controller: desccont,
                decoration: InputDecoration(
                  hintText:
                      "Enter the task's\n\n-steps\n-instructions\n\n here...",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyColors.primaryBtnC,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyColors.primaryBtnC,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mark as Important'),
                    CupertinoSwitch(
                      thumbColor: isImp ? Colors.white : Colors.blueGrey,
                      activeColor: Colors.blueGrey,
                      value: isImp,
                      onChanged: (bool? v) {
                        setState(() {
                          isImp = v!;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () async {
                    var selecteddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2040),
                    );
                    if (selecteddate != null) {
                      setState(() {
                        dateString = selecteddate.toString().split(' ')[0];
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Due Date:'),
                      IconButton(
                        onPressed: () async {
                          var selecteddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2040),
                          );
                          if (selecteddate != null) {
                            setState(() {
                              dateString =
                                  selecteddate.toString().split(' ')[0];
                            });
                          }
                        },
                        icon: const Icon(Icons.open_in_browser_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: isLoading,
                      child: Opacity(
                        opacity: isLoading ? 0.5 : 1,
                        child: MaterialButton(
                          textColor: MyColors.background,
                          height: 70,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minWidth: s.width * 0.95,
                          color: MyColors.primaryBtnC,
                          child: const Text(
                            "Save Task",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            if (tcont.text.length < 5) {
                              Toast.show('Title/Name is too short...');
                              return;
                            }
                            if (desccont.text.length < 5) {
                              Toast.show('Description is too short...');
                              return;
                            }
                            if (dateString == '') {
                              Toast.show('Please select a due-date...');
                              return;
                            } else {
                              Task newTask = Task(
                                name: tcont.text,
                                desc: desccont.text,
                                imp: isImp,
                                dueon: dateString,
                                isDone: false,
                              );

                              ref.watch(addTaskProvider(newTask));

                              Toast.show('Task saved!');
                              Navigator.pop(context);
                              widget.cb();
                            }
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isLoading,
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 70,
                            child: SpinKitDoubleBounce(
                                color: MyColors.primaryBtnC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
