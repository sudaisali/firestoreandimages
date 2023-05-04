import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class AddUsers extends StatefulWidget {
  const AddUsers({Key? key}) : super(key: key);

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  var newurl;
  final userName = TextEditingController();
  final password = TextEditingController();
  final _db = FirebaseFirestore.instance;
  String? pathins ;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _image;
  final _picker = ImagePicker();
  Future getImagePicked() async {
    final pickedfile = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedfile != null) {
        _image = File(pickedfile.path);
        print(_image);
      } else {
        Fluttertoast.showToast(msg: "Image Not found");
      }
    });
  }
  void uploadimage(){
    pathins = DateTime.now().toString();
    firebase_storage.Reference ref =firebase_storage.FirebaseStorage.instance
        .ref("profileimage$pathins");
    firebase_storage.UploadTask uploadTask =ref.putFile(_image!.absolute);
    Future.value(uploadTask).then((value)async{
      newurl =await ref.getDownloadURL();
      _db.collection("Users").doc(pathins).set({
        "username": userName.text.toString(),
        "password":password.text.toString(),
        "Image":newurl,
      });
    }).then((value){
     Fluttertoast.showToast(msg :"photo uploaded successfully");
    }).onError((error,
        stackTrace){
      Fluttertoast.showToast(msg : error.toString());
    });



  }
  void uploaddata(){
    _db.collection("Users").doc(pathins).set(
        {

        }
    ).then((value){
      Fluttertoast.showToast(msg: "Data Save Successfully");
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getImagePicked();
              },
                child:  Container(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(300),
                      child:  _image != null ? Image.file(_image!
                          .absolute,
                        fit: BoxFit.fill,): Icon(Icons.camera)),
                )
            ),
      
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: userName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_2_rounded),
                  hintText: 'User Name'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'password'),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){
                uploadimage();
                uploaddata();

              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                ),
                child: Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    ));
  }
}
