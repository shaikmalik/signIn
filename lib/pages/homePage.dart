import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key?key}):super(key:key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(title:const Text("HomePage"),centerTitle:true),
    body:Center(
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children:[ 
        Text(user.email!),
        ElevatedButton(child:const Text("SignOut"),onPressed:_signOut)]))
  );

  Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
  Navigator.pop(context);
}
}

