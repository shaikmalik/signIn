import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profile/pages/forgotPage.dart';
import 'package:profile/pages/homePage.dart';
import 'package:profile/pages/profilePage.dart';
import 'package:profile/pages/signUp.dart';
import 'package:profile/pages/themeNotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'google_sign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((pref){
    var themeColor = pref.getString('ThemeMode');
    if(themeColor == 'dark') {
      activeTheme = darkTheme;
    } else if(themeColor == 'light') {
      activeTheme = lightTheme;
    } else {
      activeTheme = systemTheme;
    }
});
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<ThemeNotifier>(create: (context){
        return ThemeNotifier(activeTheme);
      }),
      ChangeNotifierProvider<GoogleSignInProvider>(
    create:(context) {
      return GoogleSignInProvider();

    }
    )],child:
    MaterialApp(
    home:MainPage(),
    )));
    


}




  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  
    String username=usernameController.text;
    String password = passwordController.text;
    String uid = usernameController.text.trim();




class LoginPage extends StatefulWidget {
  
  const LoginPage({Key?key }):super(key:key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) => Scaffold(
    
    appBar:AppBar(
      title:const Text("SignIn/SignUp Page"),
      centerTitle:true
    ),
    body:SingleChildScrollView(
      padding:const EdgeInsets.all(20),
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children:[
          FlutterLogo(size:120),
              const SizedBox(height:8),
              const Text("Welcome to Flutter",style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
              const SizedBox(height:10),
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
              const SizedBox(height:8),
              TextFormField(
                obscureText: false,
                controller:passwordController,
                decoration:InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:const BorderSide(color:Colors.blue),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: "Password : ",
                  label: const Text("Password")
                )
              ),
              const SizedBox(height:20),
              ElevatedButton.icon(
                style:ElevatedButton.styleFrom(
                  minimumSize:const Size.fromHeight(50)
                ),
                icon:const Icon(Icons.lock_open),
                label:const Text("Signin"),
                onPressed:signIn,
              ),
              const SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text("No Account ? "),
                  const SizedBox(width:10),
                  ElevatedButton(
                      child:Text("Sign Up"),
                      onPressed:() {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp()));
                      }
                    )
                ]
              ),
              const SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text("Forgot Password"),
                  const SizedBox(width:10),
                  ElevatedButton(
                      child:Text("Reset Password"),
                      onPressed:() {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>ForgotPage()));
                      }
                    )
                ]
              ),
              const SizedBox(height:20),
              ElevatedButton(
                      child:Text("Login with Google"),
                      onPressed:() {
                        final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
                        provider.googleLogIn();
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>HomePage()));
                      }
                    )
        ]
      )
    )
  );

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email:usernameController.text.trim(), password: passwordController.text.trim());    
    
    FirebaseFirestore.instance.collection('users')
    .add({
      'username':usernameController.text.trim(),
      'password':passwordController.text.trim(),
    });

    usernameController.clear();
    passwordController.clear();

    Navigator.push(context,MaterialPageRoute(builder: (context)=> ProfilePage()));
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      home:MyApp(),
      theme:themeNotifier.getTheme,
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
     
        body:StreamBuilder<User?>(
          stream:FirebaseAuth.instance.authStateChanges(),
          builder:(context,snapshot) {
            if(snapshot.hasData) {
              print(123);
              return ProfilePage();
            } else {
              return LoginPage();
            }
          }
        ),
    
      
  );
}
