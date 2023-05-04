import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewUsers extends StatefulWidget {
  const ViewUsers({Key? key}) : super(key: key);

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  final firestore = FirebaseFirestore.instance.collection("Users").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.connectionState  == ConnectionState.waiting)
                  return CircularProgressIndicator();
                if(snapshot.hasError)
                  return Text("Error");
                else{
                  return Expanded(child:
                  ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context , index){
                      return ListTile(
                        leading: CircleAvatar(
                          child: Image.network(
                              snapshot.data!.docs[index]['Image'].toString()),
                        ),
                        title: Text(snapshot.data!.docs[index]['username']
                            .toString()),
                        subtitle: Text(snapshot.data!.docs[index]['password']
                            .toString()),
                      );
                      }
                  ));
                }

              })
        ],
      ),

    );
  }
}
