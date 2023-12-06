// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/IdScreen.dart';
import 'package:flutter_demo/PDF%20Screen.dart';
import 'package:flutter_demo/Search%20Screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController occupation1 = TextEditingController();
  TextEditingController name1 = TextEditingController();
  TextEditingController mob_no1 = TextEditingController();
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen",
            style: TextStyle(fontSize: 20, color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const IdScreen()));
            },
            icon: const Icon(Icons.person, color: Colors.black, size: 20)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const SearchScreen()));
              },
              icon: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              )),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("One")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("contact")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: InkWell(
                      onTap: () async {
                        await pickAadharImage();
                        await FirebaseFirestore.instance
                            .collection("One")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("contact")
                            .doc(snapshot.data!.docs[index].id)
                            .update({
                          "profile":aadhar.toString()
                            });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(image),
                      ),
                    ),
                    title: Text(
                      snapshot.data!.docs[index]["Name"],
                      style: const TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(snapshot.data!.docs[index]["Mobile"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              FilledButton(
                                                  onPressed: () async {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles();
                                                    if (result != null) {
                                                      PlatformFile file =
                                                          result.files.first;
                                                      doc = File(file.path!);
                                                      print(file.name);
                                                      print(file.bytes);
                                                      print(file.size);
                                                      print(file.extension);
                                                      print(file.path);
                                                      var ref = FirebaseStorage
                                                          .instance
                                                          .ref()
                                                          .child("image")
                                                          .child(
                                                              "document/${file.name}");
                                                      var uploadPdf = await ref
                                                          .putFile(doc!);
                                                      docUrl = await uploadPdf
                                                          .ref
                                                          .getDownloadURL();
                                                      print((docUrl));
                                                    } else {}
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("One")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .set({
                                                      "document": docUrl,
                                                    }, SetOptions(merge: true));
                                                  },
                                                  child: const Text("Upload")),
                                              FilledButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                PdfScreen(
                                                                  url:docUrl,
                                                                )));
                                                  },
                                                  child: const Text("PDFView"))
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            icon: const Icon(Icons.picture_as_pdf)),
                        IconButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Center(child: Text("Welcome")),
                                    content: Column(
                                      children: [
                                        TextFormField(
                                            controller: name,
                                            decoration: const InputDecoration(
                                                hintText: "Name")),
                                        TextFormField(
                                            controller: phone,
                                            decoration: const InputDecoration(
                                                hintText: "Mobile")),
                                        TextFormField(
                                            controller: occupation,
                                            decoration: const InputDecoration(
                                                hintText: "Occupation")),
                                        TextFormField(
                                            controller: mail,
                                            decoration: const InputDecoration(
                                                hintText: "Email")),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("One")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection("contact")
                                                .doc(snapshot
                                                    .data!.docs[index].id)
                                                .update({
                                              "Name": name.text,
                                              "Occupation": occupation.text,
                                              "Phone": phone.text,
                                              "Mail": mail.text
                                            }).then((value) {
                                              name1.clear();
                                              mob_no1.clear();
                                              phone.clear();
                                              mail.clear();
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text("Update")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"))
                                    ],
                                  );
                                }),
                            icon: const Icon(Icons.more_vert)),
                        IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("One")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("contact")
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: AlertDialog(
                  title: const Center(
                    child: Text("Welcome",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  content: Column(
                    children: [
                      TextFormField(
                          controller: name1,
                          decoration: const InputDecoration(hintText: "Name")),
                      TextFormField(
                          controller: mob_no1,
                          decoration: const InputDecoration(hintText: "Mobile")),
                      TextFormField(
                          controller: occupation1,
                          decoration:
                              const InputDecoration(hintText: "Occupation")),
                      TextFormField(
                          controller: email,
                          decoration: const InputDecoration(hintText: "Email")),
                      const SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                          radius: 30,
                          child: InkWell(
                            onTap: () async {
                              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>${aadhar}");
                              await FirebaseFirestore.instance
                                  .collection("One")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .set({
                                "profile": aadhar.toString(),
                              },SetOptions(merge:true)).then((value) => getImage());
                              setState(() {
                                aadhar="";
                              });
                            },
                          ))
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("One")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("contact")
                              .doc()
                              .set({
                            "Name": name1.text,
                            "Mobile": mob_no1.text,
                          }).then((value) {
                            name1.clear();
                            mob_no1.clear();
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("Set")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"))
                  ],
                ),
              );
            }),
        child: const Icon(
          Icons.add,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  File? doc;
  String docUrl = "";
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
