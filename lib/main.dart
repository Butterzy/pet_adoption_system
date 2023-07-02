import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_adoption_system/services/auth.dart';
import 'package:pet_adoption_system/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<thisUser?>.value(
      catchError: (context, error) => null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: wrapper(),
      ),
    );
  }
}
