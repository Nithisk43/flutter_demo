import 'dart:io';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class PdfScreen extends StatefulWidget {
  String url;
  PdfScreen({super.key,required this.url});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late PDFDocument document;
  bool _isLoading = true;
  loadDocument() async{
    document = await PDFDocument.fromURL(widget.url);
    setState(() {
      _isLoading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDocument();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _isLoading? const Center(child: CircularProgressIndicator(),)
              : PDFViewer(
            document: document,
            backgroundColor: Colors.cyan,
            scrollDirection: Axis.vertical,
            enableSwipeNavigation: true,
            indicatorBackground: Colors.pink,
            // showIndicator: false,
            pickerButtonColor: Colors.purpleAccent,
            // showPicker: false,
            showNavigation: false,

          )
      ),
    );
  }
  File?doc;
  String docUrl="";
}
