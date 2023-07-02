import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/screens/article/article.dart';

import 'package:pet_adoption_system/screens/pet/manage_pet.dart';
import 'package:pet_adoption_system/screens/report/graph.dart';
import 'package:pet_adoption_system/screens/status/status_tile.dart';

import 'package:provider/provider.dart';
import 'package:pet_adoption_system/models/user.dart';

import 'package:pet_adoption_system/screens/profile/edit_profilepic.dart';
import 'package:pet_adoption_system/screens/profile/edit_profile.dart';
import 'package:pet_adoption_system/services/auth.dart';
import 'package:pet_adoption_system/services/user_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  bool isLoading = false;

  get userData => UserData();
  get petprofileData => PetData();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Center(
                  child: StreamBuilder<UserData>(
                      stream: UserDatabaseService(uid: user!.uid).userData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserData userData = snapshot.data!;
                          user_role = userData.user_role ?? "";
                          return Stack(
                            children: [
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
                                  child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(150),
                                      bottomRight: Radius.circular(150)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.indigo,
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 10.0),
                                  ],
                                ),
                              )),
                              Positioned(
                                top: 60.0,
                                left: 100.0,
                                child: Row(
                                  children: [
                                    buildProfileAvatar(userData),
                                    buildNameTitle(context, userData),
                                  ],
                                ),
                              ),
                              Positioned(
                                  bottom: 0.0,
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 14,
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
                                top: 50.0,
                                right: 15.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(0.4),
                                  child: IconButton(
                                      onPressed: () async {
                                        setState(() => isLoading = true);
                                        await _auth.signOut().then((value) {
                                          showSuccessSnackBar(
                                              'Signed Out', context);
                                        }).catchError((e) {
                                          showFailedSnackBar(
                                              e.toString(), context);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.logout_outlined,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              //indigoContainer
                              Positioned(
                                top: 200.0,
                                left: 150,
                                right: 150,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2.7,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(45),
                                      bottomRight: Radius.circular(45),
                                      topLeft: Radius.circular(45),
                                      bottomLeft: Radius.circular(45),
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(1.0, 3.0),
                                          blurRadius: 5.0),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        buildProfileInfo(
                                            context,
                                            userData.user_email!,
                                            Icons.mail_outline_outlined),

                                        buildProfileInfo(
                                            context,
                                            userData.user_HPno!,
                                            Icons.phone_android_outlined),

                                        buildProfileInfo(
                                            context,
                                            userData.user_gender!,
                                            genderIcon(userData.user_gender!)),

                                        //address here
                                        buildProfileInfo(
                                            context,
                                            getAddress(userData),
                                            Icons.location_on_outlined),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 25, bottom: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          height: 70,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.indigo,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfile(
                                                            userData: userData,
                                                          )),
                                                );
                                              },
                                              child: Text(
                                                'Edit Profile',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color: Colors.white),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 310.0,
                                left: 50,
                                right: 50,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 6.8,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(45),
                                      bottomRight: Radius.circular(45),
                                      topLeft: Radius.circular(45),
                                      bottomLeft: Radius.circular(45),
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(1.0, 3.0),
                                          blurRadius: 5.0),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        child: InkWell(
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(45),
                                                    topLeft:
                                                        Radius.circular(45),
                                                  ),
                                                  color: Colors.white),
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 50.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit_note_sharp,
                                                          color: Colors.indigo,
                                                          size: 35.0,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text('Manage Pet',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .indigo)),
                                                      ],
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: Icon(Icons
                                                        .keyboard_arrow_right),
                                                  )
                                                ],
                                              )),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ManagePetScreen()),
                                            );
                                          },
                                        ),
                                      ),
                                      user_role == 'admin'
                                          ? GestureDetector(
                                              child: InkWell(
                                                child: Container(
                                                    color: Colors.white,
                                                    height: 60,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 50.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .article_outlined,
                                                                color: Colors
                                                                    .indigo,
                                                                size: 30.0,
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Text(
                                                                  'Manage Article',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.indigo)),
                                                            ],
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20.0),
                                                          child: Icon(Icons
                                                              .keyboard_arrow_right),
                                                        )
                                                      ],
                                                    )),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ManageArticleScreen()),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(
                                              color: Colors.white,
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                      user_role == 'admin'
                                          ? GestureDetector(
                                              child: InkWell(
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(45),
                                                        bottomLeft:
                                                            Radius.circular(45),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    height: 60,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 50.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .auto_graph_outlined,
                                                                color: Colors
                                                                    .indigo,
                                                                size: 30.0,
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Text(
                                                                  'Manage Report',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.indigo)),
                                                            ],
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20.0),
                                                          child: Icon(Icons
                                                              .keyboard_arrow_right),
                                                        )
                                                      ],
                                                    )),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Graph()),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(45),
                                                  bottomLeft:
                                                      Radius.circular(45),
                                                ),
                                                color: Colors.white,
                                              ),
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return loadingIndicator();
                        }
                      }),
                ),
              ],
            ),
          );
  }

  IconData genderIcon(String gender) {
    if (gender.isNotEmpty) {
      if (gender == 'Male') {
        return MdiIcons.genderMale;
      } else {
        return MdiIcons.genderFemale;
      }
    }
    return MdiIcons.genderMaleFemale;
  }

  String getAddress(UserData userData) {
    List<String> values = [
      '${userData.user_addStreet1} ',
      ' ${userData.user_addStreet2}',
      '${userData.user_addPostcode} ${userData.user_addCity}',
      userData.user_addState.toString()
    ];
    if (values.toSet().toList().toString() == '[,  ]') {
      return '';
    } else {
      String result = values.map((val) => val.trim()).join(',\n');
      return result;
    }
  }

  SizedBox buildProfileInfo(
      BuildContext context, String userData, IconData icon) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 20, bottom: 15),
          child: Row(children: [
            Icon(icon, color: Colors.indigo, size: 30),
            Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(userData,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.black)))
          ])),
    );
  }

  Container buildNameTitle(BuildContext context, UserData? userData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 25, bottom: 10),
        child: Text(
          '${userData!.user_name!} ${userData.user_lastName!}',
          style: const TextStyle(fontSize: 50, color: Colors.white),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  GestureDetector buildProfileAvatar(UserData? userData) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.indigo,
        radius: 50.0,
        child: CircleAvatar(
          backgroundImage: userData!.user_photo!.isNotEmpty
              ? NetworkImage('${userData.user_photo}')
              : const AssetImage('assets/images/logo.png') as ImageProvider,
          radius: 50.0,
          backgroundColor: Colors.white,
/*           child: Stack(
            children: const [
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 17.0,
                  child: Icon(Icons.edit),
                ),
              )
            ],
          ), */
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => changeProfilePicture()),
        );
      },
    );
  }
}
