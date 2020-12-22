import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:machine_learning_flutter_app/screens/alertscreen.dart';
import 'package:machine_learning_flutter_app/screens/capturescreen.dart';
import 'package:machine_learning_flutter_app/screens/resultsscreen.dart';
import 'package:machine_learning_flutter_app/screens/signinscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:machine_learning_flutter_app/database/firestorefunctions.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_core/firebase_core.dart';
import 'package:machine_learning_flutter_app/models/userdata.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UserData>(create: (_) => UserData()),
  ], child: PotHoleApp()));



}


class PotHoleApp extends StatefulWidget {

  @override
  _PotHoleAppState createState() => _PotHoleAppState();
}

class _PotHoleAppState extends State<PotHoleApp> {

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
          title: 'Pothole App',
          theme: ThemeData(
            primaryColor: Colors.white,
            //accentColor: pinkLight,
          ),
          initialRoute: SignInScreen.id,
          onGenerateRoute: (RouteSettings settings) {
            var routes = <String, WidgetBuilder>{
              SignInScreen.id: (context) => SignInScreen(),
              CaptureScreen.id: (context) => CaptureScreen(),
              ResultsScreen.id: (context) => ResultsScreen(settings.arguments),
              AlertScreen.id: (context) => AlertScreen(),
            };
            WidgetBuilder builder = routes[settings.name];
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          }),
    );
  }
}

