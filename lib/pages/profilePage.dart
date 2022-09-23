import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile/main.dart';
import 'package:profile/pages/themeNotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'editPage.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key?key}):super(key:key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   String email='';
   String password='';  
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  
  File? image;
  String url =
      'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Y2F0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60';

  String selectedColor = "system";
  List<String> colors = ['dark', 'light', 'system'];
  late ThemeData activeTheme;

  final darkTheme = ThemeData(
    primaryColor:Colors.black,
    accentColor:Colors.grey,
    brightness: Brightness.dark
  );

  final lightTheme = ThemeData(
    primaryColor:Colors.white,
    accentColor:Colors.yellowAccent,
    brightness:Brightness.light
  );

  final systemTheme = ThemeData(
    primaryColor:Colors.green,
    accentColor:Colors.amber,
    brightness:Brightness.light
  );

  @override
initState() {         // this is called when the class is initialized or called for the first time
  super.initState(); 
  getData(); //  this is the material super constructor for init state to link your instance initState to the global initState context
}
  
   getData()async {
      print(999);
      final currentUser = FirebaseAuth.instance.currentUser!;
      setState(() {
        email = currentUser.email!;
      });
  }

   
  
  
  @override
  Widget build(BuildContext context) {
      
    



    final themeNotifier = Provider.of<ThemeNotifier>(context);
    themeNotifier.getTheme;
   return Scaffold(
    appBar:AppBar(
      leading:const Icon(Icons.arrow_back),
      title:const Text("Profile Page1"),
      centerTitle:true, 
      actions: [
        TextButton(
            onPressed: (){
              themeChangeDialog(themeNotifier);
            },
            child: const Text("Change Theme", style: TextStyle(fontSize: 20,color:Colors.white)))
      ]    
    ),
    
    body:SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding:const EdgeInsets.all(10),
        child:Row(
          children:[
            Column(
              children:[
              InkWell(
            child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: image == null
                      ? NetworkImage(url)
                      : FileImage(image!) as ImageProvider,
                )),
            onTap: () => pickImage(ImageSource.gallery),
            onDoubleTap: () => pickImage(ImageSource.camera)),
        
              const SizedBox(height:8),
            const Text("users",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))
              ]
            ),            
            Container(
                  padding:const EdgeInsets.all(10),
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                  
                  Text("Email: $email"),
                  const SizedBox(height:8),
                  Text("Password: $password"),
                  const SizedBox(height:8),
                  SizedBox(
              height:40,
              width:200,
              child: ElevatedButton.icon(
              onPressed: (){
               Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>EditPage()));
              },
              
                  icon:const Icon(Icons.edit),
                  label:const Text("Edit Profile")
              ,),
            ),
              ElevatedButton.icon(
              onPressed: (){
               Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
              },
              
                  icon:const Icon(Icons.logout),
                  label:const Text("Log out")
              ,),

              ]
              
              ),
                )
              
            
          ]
        )
      ),
    )
    );
  }

  

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
  void onThemeChange(String value, ThemeNotifier themeNotifier) async {
    if (value == 'dark') {
      themeNotifier = themeNotifier.setThemeData(darkTheme);
    } else if (value == 'light') {
      themeNotifier = themeNotifier.setThemeData(lightTheme);
    } else {
      themeNotifier = themeNotifier.setThemeData(systemTheme);
    }
    final pref = await SharedPreferences.getInstance();
    pref.setString('ThemeMode', value);
  }

  themeChangeDialog(ThemeNotifier themeNotifier) {
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                  title: const Text("Change Theme"),
                  content: Container(
                      height: 250,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RadioGroup<String>.builder(
                                groupValue: selectedColor,
                                onChanged: (value) {
                                 if(mounted) {
                                  setState(() => selectedColor = value!);
                                 }
                                 onThemeChange(selectedColor, themeNotifier);
                                },
                                items: colors,
                                itemBuilder: (item) => RadioButtonBuilder(item))
                          ])),
                  actions: [
                    MaterialButton(
                        child: const Text("Close"),
                        onPressed: () => Navigator.pop(context))
                  ]);
            }));
  


  
}
}