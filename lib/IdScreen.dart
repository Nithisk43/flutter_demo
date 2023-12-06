import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/Login%20Screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class IdScreen extends StatefulWidget {
  const IdScreen({super.key});

  @override
  State<IdScreen> createState() => _IdScreenState();
}

class _IdScreenState extends State<IdScreen> {
  TextEditingController name1 = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone1 = TextEditingController();
  TextEditingController occupation = TextEditingController();
  String docUrl="";
  String image = "";
  bool loading = true;
  double progress = 0.0;
  String aadharFilePath = "";
  String filepath = "";
  File? file;
  String aadhar = "";
  File? imageAadhar;
  String downloadurl = "";
  UploadTask? task;

  Future<void> getImage() async {
    await FirebaseFirestore.instance
        .collection("One")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {});
      image = value["profile"];
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orangeAccent.shade200,
        body: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 200,
                width: 50,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder:(ctx)=>const LoginScreen()));
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      size: 20,
                      color: Colors.black,
                    )),
              ),
            ),
            Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      pickAadharImage();
                      },
                    child:CircleAvatar(
                      radius:60,
                      backgroundImage:NetworkImage(aadhar),
                    )),
                TextButton(onPressed:()async{
                  print(
                      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${aadhar}");
                  await FirebaseFirestore.instance
                      .collection("One")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'profile': aadhar.toString(),
                  }).then((value) => getImage());
                  setState(() {
                    aadhar = "";
                  });
                }, child:const Text("Take me")),
               ]
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("One")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.data!["Name"]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data!["Mail"]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data!["Phone"]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data!["Occupation"]),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ));
  }
  Future pickAadharImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      print("imageTemp ====? ${imageTemp}");
      aadharFilePath = basename(imageTemp.path);
      print("aadharFilePath ====? ${aadharFilePath}");
      setState(() => this.imageAadhar = imageTemp);
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();
      // Create a reference to "mountains.jpg"
      final mountainImagesRef =
      storageRef.child("AdminAadharImage/${aadharFilePath}");
      await mountainImagesRef.putFile(imageTemp);
      String aadharurl = await mountainImagesRef.getDownloadURL();
      print(aadharurl);
      setState(() {
        aadhar = aadharurl;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
