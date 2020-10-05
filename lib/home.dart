import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading;
  File _image;
  List _output;
  final picker = ImagePicker();

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: "assets/labels.txt",
    );
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 85,
            ),
            Text(
              "TeachableMachine CNN", //Convolutional neural network
              style: TextStyle(
                color: Color(
                  0xFFEEDA28,
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Detect Dogs and Cats",
              style: TextStyle(
                color: Color(
                  0xFFE99600,
                ),
                fontWeight: FontWeight.w500,
                fontSize: 28,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: _loading
                  ? Container(
                      width: 280,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/cat.png",
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Container(
                            height: 250,
                            child: Image.file(_image),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _output != null
                              ? Text(
                                  '${_output[0]['label']}'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        "Take a photo",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: pickGalleryImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        "Upload Image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
