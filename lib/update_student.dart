import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstore_crud_student_reg/utilities.dart';
import 'package:flutter/material.dart';

class UpdateStudent extends StatefulWidget {
  final String id;

  const UpdateStudent({super.key, required this.id});

  @override
  State<UpdateStudent> createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  final formKey = GlobalKey<FormState>();

  CollectionReference students =
      FirebaseFirestore.instance.collection('student_reg');

  Future<void> updateUser(id, grId, name, fatherName) {
    return students.doc(id).update(
        {'GR': grId, 'Name': name, 'Father\'s Name': fatherName}).then((value) {
      Utilities().toastMessage('User Added');
    }).catchError((e) => Utilities().toastMessage(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Update Student\'s Data',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('student_reg')
                .doc(widget.id)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                Utilities().toastMessage('Something went wrong!');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              var data = snapshot.data!.data();
              var gr = data!['GR'];
              var name = data['Name'];
              var fatherName = data['Father\'s Name'];
              return Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    vertical: 30, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: TextFormField(
                        initialValue: gr,
                        onChanged: (value) => gr = value,
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
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: TextFormField(
                        initialValue: name,
                        onChanged: (value) => name = value,
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
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: TextFormField(
                        initialValue: fatherName,
                        onChanged: (value) => fatherName = value,
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
                                  updateUser(widget.id, gr, name, fatherName);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Update')),
                          ElevatedButton(onPressed: () {}, child: Text('Reset'))
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
