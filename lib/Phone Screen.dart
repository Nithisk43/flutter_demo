import 'package:flutter/material.dart';
import 'package:flutter_demo/OtpScreen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController mob_no = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent.shade200,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
            width: 300,
            child: Center(
              child: Text("Phone Screen",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            child: TextFormField(
              controller: mob_no,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Mobile.No or Phone.no"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                print(">>>>>>>>>>>>>>>${mob_no.text}");
                Navigator.push(context,MaterialPageRoute(builder:(ctx)=>OtpScreen(mob_no:mob_no.text)));
              },
              style: ElevatedButton.styleFrom(
                fixedSize:const Size(100,50),
                backgroundColor:Colors.purple,
                shape: ContinuousRectangleBorder(
                  borderRadius:BorderRadius.circular(10)
                )),
              child: const Text("Submit",
                  style: TextStyle(fontSize: 20, color: Colors.white))),
        ],
      ),
    );
  }
}
