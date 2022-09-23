import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key?key}):super(key:key);
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(title:const Text("Reset Page"),centerTitle:true),
    body:Container(
      padding:const EdgeInsets.all(20),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children:[
          FlutterLogo(size:120),
          const SizedBox(height:10),
          const Text("Reset Password",style:TextStyle(fontSize:24)),
          const SizedBox(height:8),
          TextFormField(
                  obscureText: false,
                  controller:emailController,
                  decoration:InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:const BorderSide(color:Colors.blue),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    hintText: "Enter Email : ",
                    label: const Text("Email: ")
                  )
                ),
          const SizedBox(height:10),
          ElevatedButton(
            child:Text("Submit"),
            onPressed:resetFunction
          )
        ]
      )
    )
  );

  Future resetFunction() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
    emailController.clear();
  }
}




