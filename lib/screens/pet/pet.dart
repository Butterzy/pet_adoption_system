import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/home/home_list.dart';
import 'package:pet_adoption_system/services/pet_database.dart';
import 'package:pet_adoption_system/services/post_database.dart';

enum PetSwitch { allclub, myclub }

class Pet extends StatefulWidget {
  Pet({Key? key}) : super(key: key);

  @override
  State<Pet> createState() => _PetState();
}

class _PetState extends State<Pet> {
  PetSwitch selectedPetSwitch = PetSwitch.allclub;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          // Max Size Widget
          
          Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/background.png"),
                                    opacity: 0.1,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

          Positioned(
              top: 60,
              child: Container(
                height: MediaQuery.of(context).size.height / 14,
                width: MediaQuery.of(context).size.width / 3,
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(250)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
              )),

          const Positioned(
            top: 60.0,
            left: 60,
            child: Padding(
              padding: EdgeInsets.only(left: 30, top: 25, bottom: 10),
              child: Text('Pets',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          Positioned(
              bottom: 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height / 14,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(150),
                      topRight: Radius.circular(150)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.indigo,
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
              )),
              
          Positioned(
            top: 170.0,
            left: 10,
            right: 10,
            child: Container(
              height: MediaQuery.of(context).size.height - 250,
              
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: MultiProvider(
                  providers: [
                    StreamProvider<List<PostData>>.value(
                        value: PostDatabaseService().postdata, initialData: []),
                    StreamProvider<List<PetData>>.value(
                        value: PetDatabaseService().petdatalist,
                        initialData: []),
                    StreamProvider<List<RegisterData>>.value(
                        value: PostDatabaseService().registerDatalist,
                        initialData: []),
                  ],
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(child: HomeList()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

}
