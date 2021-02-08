import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_learning_flutter_app/ux/customcolors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:machine_learning_flutter_app/ux/popups.dart';
import 'package:machine_learning_flutter_app/screens/alertscreen.dart';
import 'package:machine_learning_flutter_app/screens/capturescreen.dart';
import 'package:connectivity_widget/connectivity_widget.dart';


class ResultsScreen extends StatefulWidget {
  static const String id = 'results_screen';
  Map <String, dynamic> arguments;


  ResultsScreen(this.arguments);


  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>{

  Position _currentPosition;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body:
      ConnectivityWidget(
        builder: (context, isOnline) =>
      Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            //Positioned.fill(top: 0, right: -1,child: SvgPicture.asset('assets/background.svg', fit: BoxFit.fill,),),
            Positioned.fill(top: 0, right: 0,child: Container(color: buttonOrange,),),

            Align(alignment: Alignment.bottomCenter, child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              height: height - 50,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    SizedBox(height: 40,),
                    Center(child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20)),child: Image.file(File(widget.arguments['image']), width: double.infinity, height: 250, fit: BoxFit.fill,))),
                    SizedBox(height: 50,),
                    Text(widget.arguments['result'].toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: darkText,
                    ),
                    ),

                    SizedBox(height: 50,),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40)), color: buttonOrange
                          ,),
                        child: Center(child: Stack(
                          children: <Widget>[
                            Align(alignment: Alignment.center ,child: widget.arguments['value'] == 0 ? Text('Try Again'.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),): Text('Get Location'.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),)),
                          ],
                        )),
                      ),

                      onTap: () async{
                        bool connected = await ConnectivityUtils.instance.isPhoneConnected();
                        final Geolocator _geolocator = Geolocator();
                        bool locationEnabled = await _geolocator.isLocationServiceEnabled();

                        if (locationEnabled){

                          if (connected) {
                            if (widget.arguments['value'] == 0){
                              Navigator.pushNamed(context, CaptureScreen.id);
                            } else {
                              await _getCurrentLocation();
                            }
                          } else {
                            showAlertDialog(text: 'Please connect to the internet to continue', title: 'No Internet', context: context, firstScreen: true);
                          }

                        } else {

                          showAlertDialog(text: 'Please enable gps location to continue', title: 'No GPS', context: context, firstScreen: true);
                        }



                      },),
                  ],),
              ),)
              ,),
          ],
        ),
      ),
    ),
    );
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          _currentPosition = position;

          Position position2 = Position(latitude: -8.6829571, longitude: 115.156312);
          Position position3 = Position(latitude: -31.89405, longitude: 115.89125);

          var arguments = {'position' : position, 'image' : widget.arguments['image']};

          Navigator.pushNamed(context, AlertScreen.id, arguments: arguments);

    }).catchError((e) {
      showAlertDialog(text: 'Error', title: e.toString(), context: context, firstScreen: false);
    });
  }
}
