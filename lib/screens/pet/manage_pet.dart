import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/screens/pet/pet_list.dart';
import 'package:pet_adoption_system/screens/pet/add_pet.dart';
import 'package:provider/provider.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/user.dart';

import 'package:pet_adoption_system/services/access_right_database.dart';
import 'package:pet_adoption_system/services/pet_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

import '../../widgets/widgets.dart';

enum PetSwitch { allpet, mypet }

class ManagePetScreen extends StatefulWidget {
  const ManagePetScreen({Key? key}) : super(key: key);

  @override
  State<ManagePetScreen> createState() => _ManagePetScreenState();
}

class _ManagePetScreenState extends State<ManagePetScreen> {
  PetSwitch selectedPetSwitch = PetSwitch.allpet;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  opacity: 0.1,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
                child: Container(
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.indigo,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.indigo,
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
            )),
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
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo, //background color of button
                          //border width and color
                          elevation: 3, //elevation of button
                          shape: const RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(150),
                                topRight: Radius.circular(150)),
                          ),
                          padding:
                              const EdgeInsets.all(20) //content padding inside button
                          ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPet()),
                        );
                      },
                      child: const Text("Create Pet")),
                )),
            Positioned(
              top: 60.0,
              left: 30,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        "Your Pets",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 100.0,
                left: 140,
                child: SizedBox(
                    height: 530,
                    width: 530,
                    child: Image.asset('assets/images/cat1.png'))),
            Positioned(
              top: 120.0,
              bottom: 130.0,
              left: 30,
              right: 30,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: MultiProvider(
                  providers: [
                    StreamProvider<List<PetData>>.value(
                        initialData: const [],
                        value: PetDatabaseService().petdatalist),
                    StreamProvider<List<CommitteeData>>.value(
                        initialData: const [],
                        value: PetDatabaseService().committeeDatalist),
                    StreamProvider<List<ApplicationData>>.value(
                        initialData: const [],
                        value: PetDatabaseService().applicationDataList),
                    StreamProvider<List<function>>.value(
                        initialData: const [],
                        value: AccessRightDatabaseService().functionlist),
                    StreamProvider<List<accessRight>>.value(
                        initialData: const [],
                        value: AccessRightDatabaseService().accessdatalist),
                  ],
                  child: SingleChildScrollView(
                    child: PetList(
                      isMyPet: true,
                    ),
                  ),
                ),
              ),
            ),
            //indigoContainer
          ],
        )
      ],
    );
  }
}
