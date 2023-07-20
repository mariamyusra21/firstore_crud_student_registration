import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstore_crud_student_reg/utilities.dart';
import 'package:flutter/material.dart';

import 'update_student.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final Stream<QuerySnapshot> studentStream =
      FirebaseFirestore.instance.collection("student_reg").snapshots();

  CollectionReference students =
      FirebaseFirestore.instance.collection('student_reg');

  Future<void> deleteStudent(id) {
    return students.doc(id).delete().then((value) {
      Utilities().toastMessage('User Deleted');
    }).catchError((e) => Utilities().toastMessage(e));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: studentStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storeDocs = [];
          snapshot.data?.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storeDocs.add(a);
            a['id'] = document.id;
          }).toList();

          return Scaffold(
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              // color: Colors.deepPurple,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: <int, TableColumnWidth>{
                    0: FixedColumnWidth(50),
                    1: FixedColumnWidth(80),
                    2: FixedColumnWidth(120),
                    3: FixedColumnWidth(100),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Cell(text: 'GR:'),
                      Cell(
                        text: 'Name:',
                      ),
                      Cell(text: 'Father\'s Name:'),
                      Cell(text: 'Actions:')
                    ]),
                    for (var i = 0; i < storeDocs.length; i++) ...[
                      TableRow(children: [
                        Cell(text: storeDocs[i]['GR']),
                        Cell(
                          text: storeDocs[i]['Name'],
                        ),
                        Cell(text: storeDocs[i]['Father\'s Name']),
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateStudent(
                                              id: storeDocs[i]['id'])));
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  print(deleteStudent(storeDocs[i]['id']));
                                },
                                icon: Icon(Icons.delete),
                              )
                            ],
                          ),
                        )
                      ]),
                    ]
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class Cell extends StatelessWidget {
  const Cell({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
