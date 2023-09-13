import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IssuesList extends StatefulWidget {
  @override
  State<IssuesList> createState() => _IssuesListState();
}

class _IssuesListState extends State<IssuesList> {
  CollectionReference student = FirebaseFirestore.instance.collection('issues');
  List issues = [];

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await student.get();
    issues = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(issues);
    setState(() {
      
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: issues.length,
        itemBuilder: (context, index) {
          final item = issues[index];
          return ListTile(
            leading: Image.network(item["media"]), // Display the image
            title: Text(item["type"]), // Display the name
            subtitle: Text(item["detail"]), // Display the description
            onTap: () {
              // Handle item tap (if needed)
            },
          );
        },
      );
  }
}
