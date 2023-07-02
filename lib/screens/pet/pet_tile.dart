import 'package:flutter/material.dart';
import 'package:pet_adoption_system/mainpage.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/pet/delete_pet.dart';
import 'package:pet_adoption_system/screens/post/post.dart';
import 'package:pet_adoption_system/screens/pet/edit_pet.dart';
import 'package:pet_adoption_system/services/pet_database.dart';
import 'package:provider/provider.dart';
import 'package:pet_adoption_system/models/access_right.dart';

import 'package:pet_adoption_system/models/pet.dart';

import 'package:pet_adoption_system/models/user.dart';

import 'package:pet_adoption_system/shared/constants.dart';

class PetTile extends StatelessWidget {
  final PetData petData;
  final bool isMyPet;
  final bool isRequested;
  final bool isJoined;
  final String applicationID;

  // final accessLimit accessLimitData;
  PetTile({
    Key? key,
    required this.petData,
    required this.isMyPet,
    required this.isRequested,
    required this.isJoined,
    required this.applicationID,
    // required this.accessLimitData
  }) : super(key: key);

  String buttonText = '';
  get userData => UserData();

  @override
  Widget build(BuildContext context) {
    if (isRequested) {
      isJoined ? buttonText = 'Adopted' : buttonText = 'Requested';
    } else {
      buttonText = 'Adopt Me';
    }

    final functionList = Provider.of<List<function>>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        child: Card(
          color: Colors.indigo[100],
          elevation: 10.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: Card(
            shadowColor: Colors.indigoAccent,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.indigo[100],
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.pets,
                      size: 70,
                      color: Colors.indigo,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(petData.pet_name!,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.indigo)),
                        Text(
                          petData.pet_category!,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.grey),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Text(petData.pet_registerDate ?? ''),
                ],
              ),
              onTap: () {
                if (isMyPet) {
                  _showEditPanel(petData, context, functionList);
                } else {}
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showEditPanel(
      PetData petData, BuildContext context, List<function> functionList) {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (context) {
          return Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                      child: Container(
                          height: 5.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0)))),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.indigo))),
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: const Text(
                        'Edit Pet Action',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.indigo),
                      ),
                    ),
                    InkWell(
                      child: _buildListItem('Edit Pet Info', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPet(petData: petData),
                            ));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Manage Pet Post', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  //RegisterPetPost(),
                                  Post(petData: petData),
                            ));
                      },
                    ),
                    const SizedBox(width: 10.0),
                    InkWell(
                      child: _buildDeleteItem(context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  //RegisterPetPost(),
                                  DeletePet(petData: petData),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Container _buildListItem(String text, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Container _buildDeleteItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
