import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machine_learning_flutter_app/models/userdata.dart';
import 'package:provider/provider.dart';
import 'package:machine_learning_flutter_app/database/firestorefunctions.dart';
import 'package:machine_learning_flutter_app/ux/popups.dart';
import 'package:machine_learning_flutter_app/screens/capturescreen.dart';

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
      body: SafeArea(
        child: Stack(
            children: <Widget>[
              Align(alignment: Alignment.center,child: InkWell(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 0.5), color: Colors.white,),
                  child: Center(child: Stack(
                    children: <Widget>[
                      Align(alignment: Alignment.center ,child: Text('Login with Google', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16),)),
                      Align(alignment: Alignment.centerRight,child: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: Image.asset('assets/login_google_150.png',height: 35, width: 35,
                            fit: BoxFit.cover),
                      ),
                      ),
                    ],
                  )),
                ),

                onTap: (){

                  _googleSignUp();

                },),)


            ],
          ),
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
