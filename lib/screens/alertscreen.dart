import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_learning_flutter_app/ux/customcolors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:machine_learning_flutter_app/ux/popups.dart';
import 'package:machine_learning_flutter_app/screens/alertscreen.dart';
import 'package:machine_learning_flutter_app/database/firestorefunctions.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:machine_learning_flutter_app/models/userdata.dart';
import 'package:connectivity_widget/connectivity_widget.dart';


class AlertScreen extends StatefulWidget {
  static const String id = 'alert_screen';
  Map <String, dynamic> arguments;

  AlertScreen(this.arguments);

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen>{

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  String _address;
  Position _position;
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<UserData>(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    _position = widget.arguments['position'];

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

            Align(alignment: Alignment.topCenter, child: Image.asset('assets/emailclean.png', height: 200, width: 300,),),

            Align(alignment: Alignment.bottomCenter, child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              height: height -180,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 40,),
                    Center(child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20)),child: Image.file(File(widget.arguments['image']), width: double.infinity, height: 225, fit: BoxFit.fill,))),
                    SizedBox(height: 50,),

                    FutureBuilder<dynamic>(
                      future: _getAddressFromLatLng(_position), // async work
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting: return Text('Loading....');
                          default:
                            if (snapshot.hasError){

                              return Text('Error: ${snapshot.error}', textAlign: TextAlign.center, style: GoogleFonts.roboto(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: darkText,
                              ),
                              );
                            } else {

                              _address = snapshot.data;

                              return
                              Text(_address, textAlign: TextAlign.center, style: GoogleFonts.roboto(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: darkText,
                              ),
                              );
                            }
                        }
                      },
                    ),

                    SizedBox(height: 10,),

                    Text(widget.arguments['position'].toString(), textAlign: TextAlign.center, style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: darkText,
                    ),
                    ),

                    SizedBox(height: 50,),

                  ],),
              ),)
              ,),

            Align(alignment: Alignment.center, child: loading ? CircularProgressIndicator() : SizedBox(),),

            Padding(
              padding: const EdgeInsets.only(bottom:40.0, left: 20, right: 20),
              child: Align(alignment: Alignment.bottomCenter, child: InkWell(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40)), color: buttonOrange
                    ,),
                  child: Center(child: Stack(
                    children: <Widget>[
                      Align(alignment: Alignment.center ,child: Text('Alert Authorities'.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),)),
                    ],
                  )),
                ),

                onTap: () async{

                  bool connected = await ConnectivityUtils.instance.isPhoneConnected();

                  if (connected) {
                    var uuid = Uuid();

                    setState(() {
                      loading = true;
                    });

                    await alertAuthorities(
                      context: context,
                      dbID: uuid.v4(),
                      name: userData.getUserName,
                      email: userData.getUserEmail,
                      address: _address,
                      lat: _position.latitude,
                      long: _position.longitude,
                      fileName: widget.arguments['image'],
                    );
                  } else {
                    showAlertDialog(text: 'Please connect to the internet to continue', title: 'No Internet', context: context, firstScreen: true);
                  }


                },),
              ),
            )


          ],
        ),
      ),
    ),
    );
  }



  Future<String> _getAddressFromLatLng(Position currentPosition) async {

    String address = 'No address found';

    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      address = '';

      if (place.name != ''){
        address = address + place.name + ', ';
      }

      if (place.thoroughfare != ''){
        address = address + place.thoroughfare + ', ';
      }
      if (place.subThoroughfare != ''){
        address = address + place.subThoroughfare + ', ';
      }
     
      if (place.locality != ''){
        address = address + place.locality + ', ';
      }
      if (place.subLocality != ''){
        address = address + place.subLocality + ', ';
      }
      if (place.country != ''){
        address = address + place.country + ', ';
      }

    } catch (e) {
      print(e);
    }

    return address;
  }
}
