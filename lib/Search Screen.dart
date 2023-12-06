import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

String search = "";

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PreferredSize(
          preferredSize: const Size(200, 50),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white,
              hintText: "Search",
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      controller.clear();
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.black)),
            ),
            onChanged: (e){
              setState(() {});
              print(search);
            },
          ),
        ),
      ),
      body: controller.text.isEmpty?
         StreamBuilder(
           stream:FirebaseFirestore.instance
              .collection("One")
             .doc(FirebaseAuth.instance.currentUser!.uid)
             .collection("contact")
             .snapshots(),
             builder:(context,snapshot){
               print(snapshot.data!.docs.length);
               int length = snapshot.data!.docs.length;
               return ListView.builder(
                   itemCount: length,
                   itemBuilder: (BuildContext context, int index) {
                     return ListTile(
                       title: Text(snapshot.data!.docs[index]['Name']),
                       subtitle: Text(
                           snapshot.data!.docs[index]['Mobile']),
                     );
                   });
             }):
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("One")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("contact")
              .snapshots(),
          builder: (context, snapshot) {
            print(snapshot.data!.docs.length);
            int length = snapshot.data!.docs.length;

            return ListView.builder(
                itemCount: length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!.docs[index]['Name']
                      .toString()
                      .toLowerCase()
                      .contains(controller.text.toLowerCase()) ||
                      snapshot.data!.docs[index]['Mobile']
                          .toString()
                          .toLowerCase()
                          .contains(controller.text)) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['Name']),
                      subtitle: Text(
                          snapshot.data!.docs[index]['Mobile'].toString()),
                    );
                  }
                  return Container();
                });
          }

      ),
    );
  }
}
