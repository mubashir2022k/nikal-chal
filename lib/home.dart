import 'package:abc/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final TextEditingController _textEditingController = TextEditingController();
  final firebasedata _fst = firebasedata();
  void openbox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _textEditingController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        // add new employee
                        _fst.addname(_textEditingController.text);
                      } else {
                        _fst.updateemp(docID, _textEditingController.text);
                      }
                      // clear textcontroller
                      _textEditingController.clear();

                      // close box
                      Navigator.pop(context);
                    },
                    child: Text("ADD"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee Name")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openbox();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fst.getname(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List namelist = snapshot.data!.docs;
            return ListView.builder(
              itemCount: namelist.length,
              itemBuilder: (context, index) {
                // get each doc
                DocumentSnapshot document = namelist[index];
                String docid = document.id;
                // get name from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String names = data['Emp_Name'];
                //display as a list
                return ListTile(
                  title: Text(names),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () => openbox(docID: docid),
                          icon: Icon(Icons.update_rounded)),
                           IconButton(
                          onPressed: () => _fst.delete(docid),icon: Icon(Icons.delete)),
                    ],
                  ),
                );
                //get name from each doc
              },
            ); //display as a list
          } else {
            return ListTile(title: Text('No Data'));
          }
        },
      ),
    );
  }
}
