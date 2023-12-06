import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/Home%20Screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'Welcome Screen.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key, required this.mob_no});
  String mob_no;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String code = "";
  String smsCode = "";
  String? _verificationCode;
  final TextEditingController _pinput = TextEditingController();

  verifyPhonenumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${widget.mob_no}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          final User? user = FirebaseAuth.instance.currentUser;
          final uid = user!.uid;
          print(">>>>>>>>>>>>>>>>>>>>${uid}");
          var im = await FirebaseFirestore.instance
              .collection("One")
              .doc(uid)
              .get();
          if (im.exists) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return  HomeScreen();
              },
            ));
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Welcome(phone: '', occupation: '', email: '', name: '',);
              },
            ));
          }
        });
      },
      verificationFailed: (FirebaseAuthException s) {
        print(s);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("${s.message}"),
            );
          },
        );
      },
      codeSent: (String? verificationID, int? resendToken) {
        setState(() {
          print(">>>>>>>>>>>>>>>>>>>>>>>>${verificationID}");
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> submitOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationCode!, smsCode: _pinput.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final curentuser = FirebaseAuth.instance.currentUser;
      final snapshot = await FirebaseFirestore.instance
          .collection("One")
          .doc(curentuser!.uid)
          .get();
      if (snapshot.exists) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return  HomeScreen();
          },
        ));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Welcome(phone: '', occupation: '', email: '', name: '',);
          },
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhonenumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
            width: 300,
            child: Column(
              children: [
                Text("Welcome",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text("Sign up /Log into Continue",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))
              ],
            ),
          ),
          const SizedBox(
            height: 50,
            width: 300,
            child: Center(
              child: Text("Enter the 6 digit Otp",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _pinput,
              onCompleted: (v) {
                setState(() {
                  smsCode = _pinput.text;
                });
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                submitOtp();
              },
              style:ElevatedButton.styleFrom(
                fixedSize:const Size(100,50),
                backgroundColor:Colors.purple,
                shape:ContinuousRectangleBorder(
                  borderRadius:BorderRadius.circular(10))
              ),
              child: const Text("Verify",
                  style: TextStyle(fontSize: 20, color: Colors.white)))
        ],
      ),
    );
  }
}
