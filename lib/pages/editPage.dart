import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profile/pages/profilePage.dart';

class EditPage extends StatefulWidget {

  const EditPage({Key?key}):super(key:key);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

 late String name = nameController.text;
 late   String username=usernameController.text;
 late   String password = passwordController.text;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(title:const Text("Edit Page"),centerTitle:true),
    body:SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children:[
        FlutterLogo(size:120),
                const SizedBox(height:8),
                const Text("Welcome to Flutter",style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
                
                TextFormField(
                  obscureText: false,
                  controller:usernameController,
                  decoration:InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:const BorderSide(color:Colors.blue),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Enter your Username: ",
                    label: const Text("Username")
                  )
                ),
                
                
                const SizedBox(height:20),
        ElevatedButton.icon(
              onPressed: (){
                String username=usernameController.text;
                String password = passwordController.text;
                resetFunction(username);
               Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>ProfilePage()));
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)
                ),
                icon:const Icon(Icons.edit),
                label:const Text("Edit Profile")
    
        
              ),
              const SizedBox(height:20),
        ElevatedButton.icon(
              onPressed: (){
                
               Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>ProfilePage()));
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)
                ),
                icon:const Icon(Icons.photo),
                label:const Text("Go To Profile")
    
        
              ,)
              
      ])
      
      ),
    ));

Future resetFunction(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
   usernameController.clear();
  }

}

