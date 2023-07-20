import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'utilities.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final formKey = GlobalKey<FormState>();
  late String grId = '';
  late String name = '';
  late String fatherName = '';

  final grController = TextEditingController();
  final nameController = TextEditingController();
  final fatherController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    grController.dispose();
    nameController.dispose();
    fatherController.dispose();
    super.dispose();
  }

  clearTextField() {
    grController.clear();
    nameController.clear();
    fatherController.clear();
  }

  CollectionReference students =
      FirebaseFirestore.instance.collection('student_reg');

  Future<void> addUser() {
    return students.add(
        {'GR': grId, 'Name': name, 'Father\'s Name': fatherName}).then((value) {
      Utilities().toastMessage('User Added');
    }).catchError((e) => Utilities().toastMessage(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Student\'s Data',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding:
                EdgeInsetsDirectional.symmetric(vertical: 30, horizontal: 30),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: TextFormField(
                    controller: grController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'GR:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter GR';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Name';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: TextFormField(
                    controller: fatherController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Father\'s Name:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Father\'s Name';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                grId = grController.text;
                                name = nameController.text;
                                fatherName = fatherController.text;
                                addUser();
                                clearTextField();
                              });
                            }
                          },
                          child: Text('Register')),
                      ElevatedButton(
                          onPressed: () {
                            clearTextField();
                          },
                          child: Text('Reset'))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
