import 'package:flutter/material.dart';

ThemeData theme(){
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Avenir',
    textTheme: textTheme(),
  );
}

TextTheme textTheme(){
  return const TextTheme(
    headline1: TextStyle(color: Colors.black,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    ),
    
    headline3: TextStyle(color: Colors.black,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    headline5: TextStyle(color: Colors.black,
    fontSize: 30,
    fontWeight: FontWeight.normal,
    ),
    
    //No touch
    headline6: TextStyle(color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.normal,
    ),

    
  );
}