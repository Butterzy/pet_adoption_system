import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () => Navigator.pushNamed(context, '/'));
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 125,
            height: 125,
          ),
        ),
        Container(
          child: Text(
            'Pet Adoption System',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.indigo),
          ),
        )
      ]),
    );
  }
}
