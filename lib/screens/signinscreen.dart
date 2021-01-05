import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machine_learning_flutter_app/models/userdata.dart';
import 'package:provider/provider.dart';
import 'package:machine_learning_flutter_app/database/firestorefunctions.dart';
import 'package:machine_learning_flutter_app/ux/popups.dart';
import 'package:machine_learning_flutter_app/screens/capturescreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:machine_learning_flutter_app/ux/customcolors.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'sign_in_screen';


  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{



  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Stack(
          children: <Widget>[


            Positioned.fill(top: 0, right: -1,child: SvgPicture.asset('assets/background.svg', fit: BoxFit.fill,),),

            Align(alignment: Alignment.topCenter, child: Image.asset('assets/carclean.png', height: 350, width: 450,),),

            Align(alignment: Alignment.bottomCenter, child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              height: height / 1.8,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    Text('Welcome to Pothole Detector', style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: darkText,
                    ),
                    ),
                    SizedBox(height: 60,),
                    InkWell(
                      child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40)), color: buttonOrange
                  ,),
                  child: Center(child: Stack(
                    children: <Widget>[
                      Align(alignment: Alignment.center ,child: Text('Login with Google', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),)),
                      Align(alignment: Alignment.centerRight,child: Padding(
                        padding: const EdgeInsets.only(right:16.0),
                        child: Image.asset('assets/login_google_150.png',height: 30, width: 30,
                            fit: BoxFit.cover),
                      ),
                      ),
                    ],
                  )),
                ),

                onTap: (){

                  _googleSignUp();

                },),

                    SizedBox(height: 50,),
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Text("Or via social media"),
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),

                    SizedBox(height: 10,),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/facebook.svg', width: 35, height: 35,),
                        SizedBox(width: 20,),
                        SvgPicture.asset('assets/twitter.svg', width: 35, height: 35,),
                        SizedBox(width: 20,),
                        SvgPicture.asset('assets/email.svg', width: 35, height: 35,),
                      ],
                    )
                ],),
              ),)
              ,),



          ],
        ),
    );
  }

  Future<void> _googleSignUp() async {

    final globalData = Provider.of<UserData>(context, listen: false);

    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email'
        ],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );


      final User user = (await _auth.signInWithCredential(credential)).user;

      if (user.emailVerified){

      } else {

        // Open popup to inform user of the error
        showAlertDialog(context: context, title: 'Error', text: 'Google email is not verified');

      }

      int timeNow = DateTime.now().millisecondsSinceEpoch;

      // Json for saving new user to database
      Map<String, dynamic> userInfo =   {
        'userName' : user.displayName,
        'userEmail' : user.email,
        'userJoinDate' :  timeNow,
        'userAchievments' : {},
        'userRecentActivity' : {},
        'userAvatar' : user.photoUrl,
      };

//      // Create a new user in the database
//      await updateFirestoreDocument(userInfo,'users', user.uid);
//
//
//      // Set the user id in a global variable
//      globalData.setUserID(user.uid);
//
//      // Update the previous screens with the user id / logged in status
//      globalData.notifyListeners();


      Navigator.pushNamed(
        context, CaptureScreen.id);

      return user;
    }catch (e) {
      // Open popup to inform user of the error
      showAlertDialog(context: context, title: 'Error', text: 'Sign in encountered an error: ' + e.toString());
    }
  }
}
