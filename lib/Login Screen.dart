// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/Email%20Screen.dart';
import 'package:flutter_demo/Home%20Screen.dart';
import 'package:flutter_demo/Phone%20Screen.dart';
import 'package:flutter_demo/Welcome%20Screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool password=true;
  final _auth=FirebaseAuth.instance;
  final _googleSignin =GoogleSignIn();
  String _error="";

  void check() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    bool? d = pre.getBool('logstatus');
    if (d == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) =>HomeScreen()));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade400,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Login Screen",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(
            height:50,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Sign up / Log in to continue",
                  style: TextStyle(
                      fontSize:20,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            width: 300,
            child: TextFormField(
              controller: mail,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Email Address"),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            width: 300,
            child: TextFormField(
              controller: pass,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Password"),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                if (mail.text.isNotEmpty &&
                    pass.text.isNotEmpty) {
                  try {
                    var creter = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: mail.text,
                        password: pass.text);
                  }
                  on FirebaseAuthException catch(e){
                    if(e.code=='weak-password'){
                      print('The password provided is too weak');
                    }else if(e.code=='email-already-in-use'){
                      print('The account already exists for that mail');
                    }
                  }
                  catch (e) {
                    print(e);
                  }
                  try {
                    var login = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: mail.text,
                        password: pass.text)
                        .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>   const HomeScreen(),
                        )));
                    SharedPreferences pref =
                    await SharedPreferences.getInstance();
                    await pref.setBool('logstatus', true);
                    pass.clear();
                    mail.clear();
                  } catch (e) {
                    print(e.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please Fill the above fields')));
                }
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 50),
                  backgroundColor: Colors.purple,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
          const SizedBox(height: 10),
          TextButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder:(ctx)=>const MailScreen()));
              },
              child: const Text(
                "Create an new account",
                style: TextStyle(fontSize:15, color: Colors.black),
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async{
                    try{
                      final GoogleSignInAccount?googleUser=
                          await _googleSignin.signIn();
                      final GoogleSignInAuthentication googleAuth =
                      await googleUser!.authentication;
                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );
                      final userCredential =
                      await _auth.signInWithCredential(credential);
                      print(
                          ">>>>>>>>>>>>>>>>>>>>>${userCredential.user!.uid}");
                      if (userCredential.user != null) {
                        String email = googleUser.email;
                        String? name = googleUser.displayName;
                        final currentUser =
                            FirebaseAuth.instance!.currentUser;
                        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${email}");
                        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${name}");
                        final snapshot = await FirebaseFirestore.instance
                            .collection("One")
                            .doc(currentUser!.uid)
                            .get();
                        if (snapshot.exists) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>HomeScreen(),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>Welcome(
                                  phone: '',occupation: '', email:email, name:name!,)
                              ));
                        }
                      }
                    } on FirebaseAuthException catch (v){
                      setState(() {
                        _error = v.message!;
                      });

                    }catch (v){
                      setState(() {
                        _error = "Failed to sign in with google";
                      });
                    }
                    },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 50),
                      backgroundColor: Colors.purple,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    "Google",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(ctx)=>const PhoneScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 50),
                      backgroundColor: Colors.purple,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    "Phone",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
