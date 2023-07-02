import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/article.dart';



import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/screens/article/article_list.dart';
import 'package:pet_adoption_system/services/access_right_database.dart';
import 'package:pet_adoption_system/services/article_database.dart';
import 'package:pet_adoption_system/services/user_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

import 'package:provider/provider.dart';

enum PetPostSwitch { discover, follow }

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PetPostSwitch selectedPetPostSwitch = PetPostSwitch.discover;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return Scaffold(
      body: StreamBuilder<UserData>(
          stream: UserDatabaseService(uid: user!.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(fit: StackFit.passthrough, children: <Widget>[
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
                    top: 50.0,
                    left: 330.0,
                    child: Container(
                        height: 130,
                        width: 130,
                        child: Image.asset('assets/images/logowhite.png'))),
                Positioned(
                  top: 180,
                  left: 250,
                  child: Text('Pet Adoption System',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white)),
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
                  top: 240.0,
                  left: 195,
                  right: 405,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 8,
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
                            color: Colors.indigo,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          FutureBuilder<int>(
                            future: getTotalAdopted(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text('${snapshot.data}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(color: Colors.indigo));
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          const SizedBox(height: 5.0),
                          Text('Adopted',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 240.0,
                  left: 405,
                  right: 195,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 8,
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
                            color: Colors.indigo,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          FutureBuilder<int>(
                            future: getTotalPets(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text('${snapshot.data}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(color: Colors.red));
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          const SizedBox(height: 5.0),
                          Text('Homeless',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 430.0,
                  bottom: 10.0,
                  left: 30,
                  right: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: MultiProvider(
                      providers: [
                        StreamProvider<List<ArticleData>>.value(
                            value: ArticleDatabaseService().articledatalist,
                            initialData: []),
                        StreamProvider<List<function>>.value(
                            initialData: [],
                            value:
                                AccessRightDatabaseService().functionlist),
                        StreamProvider<List<accessRight>>.value(
                            initialData: [],
                            value: AccessRightDatabaseService()
                                .accessdatalist),
                      ],
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                child: ArticleList(
                              isMyArticle: false,
                            )),
                            const SizedBox(height: 10.0)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                    top: 225,
                    child: Container(
                        height: 250,
                        width: 250,
                        child: Image.asset('assets/images/cat.png'))),
                Positioned(
                    top: 180,
                    right: 0.0,
                    child: Container(
                        height: 350,
                        width: 285,
                        child: Image.asset('assets/images/dog.png'))),
              ]);
            } else {
              return loadingIndicator();
            }
          }),
    );
  }

  Future<int> getTotalPets() async {
    final CollectionReference petsCollection =
        FirebaseFirestore.instance.collection('pets');
    QuerySnapshot snapshot = await petsCollection.get();
    int count = snapshot.size;
    return count;
  }

  Future<int> getTotalAdopted() async {
    final CollectionReference adoptedCollection =
        FirebaseFirestore.instance.collection('adopted');
    QuerySnapshot snapshot = await adoptedCollection.get();
    int count = snapshot.size;
    return count;
  }
}

GestureDetector buildProfileAvatar(UserData? userData) {
  return GestureDetector(
    child: CircleAvatar(
      backgroundColor: Colors.indigo[100],
      radius: 55.0,
      child: CircleAvatar(
        backgroundImage: userData!.user_photo!.isNotEmpty
            ? NetworkImage('${userData.user_photo}')
            : const AssetImage('assets/images/logo.png') as ImageProvider,
        radius: 50.0,
        backgroundColor: Colors.white,
      ),
    ),
    onTap: () {},
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
