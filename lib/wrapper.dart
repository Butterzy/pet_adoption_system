import 'package:flutter/material.dart';
import 'package:pet_adoption_system/mainpage.dart';
import 'package:provider/provider.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/screens/authenticate/authenticate.dart';


class wrapper extends StatelessWidget {
  const wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);

    //return home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return MainPage();
    }
  }
}
