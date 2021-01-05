import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'package:machine_learning_flutter_app/ux/popups.dart';
import 'package:machine_learning_flutter_app/screens/resultsscreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_learning_flutter_app/ux/customcolors.dart';

class CaptureScreen extends StatefulWidget {
  static const String id = 'capture_screen';


  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>{

  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(top: 0, right: -1,child: SvgPicture.asset('assets/background.svg', fit: BoxFit.fill,),),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: Align(alignment: Alignment.topCenter, child: Image.asset('assets/walkincgclean2.png', height: 350, width: 450,),),
          ),

          Align(alignment: Alignment.bottomCenter, child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40))),
            height: height / 2.1,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      width: 300,
                      height: 55,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: buttonOrange
                        ,),
                      child: Center(child: Stack(
                        children: <Widget>[
                          Align(alignment: Alignment.center ,child: Text('Capture', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
                        ],
                      )),
                    ),

                    onTap: (){
                      showPicker(context);
                    },),
                ],),
            ),)
            ,),
          _loading
              ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
              : Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image == null ? Container() : Image.file(_image),
                SizedBox(
                  height: 20,
                ),
                _outputs != null
                    ? Text(
                  "${_outputs[0]["label"]}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    background: Paint()..color = Colors.white,
                  ),
                )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Material(
                    color: Colors.white,
                    child: ListTile(
                        leading: Icon(Icons.photo_library, color: darkText,),
                        title: Text('Photo Library', style: TextStyle(color: darkText, fontWeight: FontWeight.bold),),
                        onTap: () {
                          pickImageGallery();
                          Navigator.of(context).pop();
                        }),
                  ),
                  Material(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.photo_camera, color: darkText,),
                      title: Text('Camera', style: TextStyle(color: darkText, fontWeight: FontWeight.bold),),
                      onTap: () {
                        pickImageCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  pickImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  pickImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }



  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;

      String result = output[0]['index'] == 0 ? 'Pothole Not Found': 'Pothole Found';

      print(output[0]['index']);

      Navigator.pushNamed(context, ResultsScreen.id, arguments: result);

    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/colab-pothole.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
