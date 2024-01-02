import 'package:cloud_firestore/cloud_firestore.dart';

class firebasedata {
  final CollectionReference emplist =
      FirebaseFirestore.instance.collection('employee_data');

  // insert
  Future<void> addname(String name) {
    return emplist.add({'Emp_Name': name, 'Time': Timestamp.now()});
  }

  // fetch
  Stream<QuerySnapshot> getname() {
    final namedisp = emplist.orderBy('Time', descending: true).snapshots();
    return namedisp;
  }

  // update

  Future<void> updateemp(String docID, String name) {
    return emplist.doc(docID)
        .update({'Emp_Name': name, 'Time': Timestamp.now()});
  }
  // delete
  Future<void> delete(String docID) {
    return emplist.doc(docID)
        .delete();
  }
}
