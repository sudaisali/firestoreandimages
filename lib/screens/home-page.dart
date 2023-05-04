import 'package:firestoreandimages/screens/view_user.dart';
import 'package:flutter/material.dart';

import 'add_user.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
       appBar: AppBar(
         elevation: 2,
         title: Text("Users"),
         centerTitle: true,
         bottom:  TabBar(
           padding: EdgeInsets.zero,
           indicatorWeight: 2,
           tabs: [
             Tab(icon: Icon(Icons.add),text: 'Add Profile',),
             Tab(icon: Icon(Icons.view_array),text: 'View Profile',)
           ],
         ),
       ),
        body: TabBarView(
          children:const  [
                AddUsers(),
                ViewUsers(),
          ],
        ),
      ),
    );
  }
}
