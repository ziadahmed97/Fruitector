import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'report.dart';

class ReportData {
  final List<String> predictions;
  final List<Widget> responseWidgets;
  final int freshCount;
  final int rottenCount;

  ReportData({
    required this.predictions,
    required this.responseWidgets,
    required this.freshCount,
    required this.rottenCount,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File> _files = [];
  bool _isTherePrediction = false;

  String? body = "";

  Future<void> uploadImages() async {
    final List<XFile>? myFiles = await ImagePicker().pickMultiImage();
    if (myFiles != null) {
      setState(() {
        // Add the new images to the existing list instead of replacing it
        _files.addAll(myFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  Future captureImages() async {
    List<XFile> newImages = [];
    bool isTakingPictures = true;

    while (isTakingPictures) {
      XFile? newImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (newImage != null) {
        newImages.add(newImage);

        isTakingPictures = await askUser();
      } else {
        isTakingPictures = false;
      }
    }

    if (newImages.isNotEmpty) {
      setState(() {
        _files.addAll(newImages.map((image) => File(image.path)).toList());
      });
    }
  }

  List<String> responses = [];
  List<Widget> responseWidgets = [];

  int freshCount = 0;
  int rottenCount = 0;

  Future<void> predict() async {
    if (_files.isEmpty) return;

    List<String> newResponses = [];
    List<Widget> newResponseWidgets = [];
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    for (var file in _files) {
      String base64 = base64Encode(file.readAsBytesSync());
      var response = await http.put(
        Uri.parse("http://192.168.100.142:5000/classify_and_detect"),
        body: base64,
        headers: requestHeaders,
      );
      newResponses.add(response.body);

      int freshInResponse = 'fresh'.allMatches(response.body).length;
      int rottenInResponse = 'rotten'.allMatches(response.body).length;
      freshCount += freshInResponse;
      rottenCount += rottenInResponse;

      newResponseWidgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.file(file, width: 100, height: 100),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("predictions: ${response.body}" ,style :TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter')),
                  Row(
                    children: [
                      Text('Fresh: $freshInResponse',style :TextStyle(
                        fontSize: 16,)),
                      SizedBox(width: 10,),
                      Text( 'Rotten: $rottenInResponse',style :TextStyle(
                        fontSize: 16,))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    setState(() {
      responses = newResponses;
      responseWidgets = newResponseWidgets;
      _isTherePrediction = true;
    });
    final reportData = ReportData(
      predictions: newResponses,
      responseWidgets: newResponseWidgets,
      freshCount: freshCount,
      rottenCount: rottenCount,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportScreen(reportData: reportData),
      ),
    );
  }

  Future<void> showSelectionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Choose option'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  child: Text(
                    'Select from Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF246D48)),
                  onPressed: () {
                    uploadImages();
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                ElevatedButton(
                  child: Text('Capture from Camera',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF246D48)),
                  onPressed: () {
                    captureImages();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> askUser() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Text(
                'Would you like to take another picture?',
                style: TextStyle(fontSize: 20),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFF38B376)),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFE84141)),
                      child: Text('No',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0XFF246D48),
    ));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF246D48),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SvgPicture.asset(
            width: 40,
            height: 40,
            'assets/Icons/REPORTT 1.svg',
            color: Colors.white,
            semanticsLabel: 'SVG Icon',
          ),
        ),
        onPressed: () {
          if (_isTherePrediction) {
            final reportData = ReportData(
              predictions: responses,
              responseWidgets: responseWidgets,
              freshCount: freshCount,
              rottenCount: rottenCount,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportScreen(reportData: reportData),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("No prediction data available."),
                backgroundColor: Color(0XFF246D48),
              ),
            );
          }
        },
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          color: Color(0XFF246D48),
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Center(
              child: Text(
                "Classify your target Fruit",
                style: TextStyle(
                    fontSize: 24, fontFamily: 'Inter', color: Colors.white),
              ),
            ),
          ),
        ),
        _files.isEmpty
            ? Text("")
            : Column(
                children: [
                  SizedBox(height: 124),
                  SizedBox(
                    height: 241.64,
                    width: 248,
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _files.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                              height: 224,
                              width: 224,
                              child: Image.file(_files[index]));
                        },
                      ),
                    ),
                  ),
                ],
              ),
        SizedBox(height: 44.5),
        Column(children: [
          if (_files.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                if (_files.isNotEmpty) {
                  _isTherePrediction = true;
                  predict();
                }
              },
              child: Text(
                "Predict",
                style: TextStyle(
                    fontSize: 25, fontFamily: 'Inter', color: Colors.white),
              ),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0XFF246D48)),
            ),
          SizedBox(height: 16),
          if (_files.isNotEmpty)
            ElevatedButton(
              onPressed: () => showSelectionDialog(context),
              child: Text(
                "add more images",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Inter',
                  color: Color(0xFF246D48),
                ),
              ),
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 2, color: Color(0xFF246D48)),
              ),
            ),
          if (_files.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: InkWell(
                onTap: () => showSelectionDialog(context),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12.withOpacity(0.2),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage('assets/images/ThreeFruits.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 16),
          if (_files.isEmpty)
            Text(
              "Classify",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 21,
                  fontWeight: FontWeight.w500),
            ),
        ]),
      ]),
    );
  }
}
