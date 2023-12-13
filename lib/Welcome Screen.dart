import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/Home%20Screen.dart';


class Welcome extends StatefulWidget {
  String name;
  String email;
  String occupation;
  String phone;
    Welcome({super.key,required this.phone,required this.occupation,required this.email,required this.name});


  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
    TextEditingController email =TextEditingController();
  TextEditingController occupation = TextEditingController();
    TextEditingController name1=TextEditingController();
    TextEditingController phone1=TextEditingController();
   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     name1 = TextEditingController(text: widget.name);
     email = TextEditingController(text: widget.email);
     phone1 = TextEditingController(text: widget.phone);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
              width: 300,
              child: Center(
                child: Text("Welcome",
                    style: TextStyle(fontSize:20,fontWeight:FontWeight.bold,color: Colors.black)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height:50,
                width:300,
                child: TextFormField(
                  controller:name1,
                  textAlign:TextAlign.start,
                  keyboardType:TextInputType.text,
                  decoration:InputDecoration(
                    border:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(10)),
                    filled:true,
                    fillColor:Colors.white,
                    hintText: "Name"
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height:50,
                width:300,
                child: TextFormField(
                  controller:email,
                  textAlign:TextAlign.start,
                  keyboardType:TextInputType.text,
                  decoration:InputDecoration(
                      border:OutlineInputBorder(
                          borderRadius:BorderRadius.circular(10)),
                      filled:true,
                      fillColor:Colors.white,
                      hintText: "Mail"
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height:50,
                width:300,
                child: TextFormField(
              controller:phone1,
              textAlign:TextAlign.start,
              keyboardType:TextInputType.number,
              decoration:InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(10)),
                  filled:true,
                  fillColor:Colors.white,
                  hintText: "Phone"
              ),
            )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height:50,
                width:300,
                child: TextFormField(
              controller:occupation,
              textAlign:TextAlign.start,
              keyboardType:TextInputType.text,
              decoration:InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(10)),
                  filled:true,
                  fillColor:Colors.white,
                  hintText: "Occupation"
              ),
            )),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: ()async{
                  await FirebaseFirestore.instance
                  .collection("One")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    "Name":name1.text,
                    "Phone":phone1.text,
                    "Mail":email.text,
                    "Occupation":occupation.text
                  }).then((value){
                   return Navigator.push(context,MaterialPageRoute(builder: (ctx)=> HomeScreen()));
                  });
                  },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 50),
                    backgroundColor: Colors.purple,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text("Submit",
                    style: TextStyle(fontSize: 20, color: Colors.white))),

          ],
        ),
      ),
    );
  }
}
