import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/pet/delete_pet_list.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:provider/provider.dart';

enum PostSwitch { upcoming, expired }

class DeletePet extends StatefulWidget {
  PetData petData;
  DeletePet({Key? key, required this.petData}) : super(key: key);

  @override
  State<DeletePet> createState() => _DeletePetState();
}

class _DeletePetState extends State<DeletePet> {
  PostSwitch selectedPostSwitch = PostSwitch.upcoming;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamProvider<List<PostData>>.value(
        initialData: [],
        value: PostDatabaseService(petid: widget.petData.pet_ID).postdata,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
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
                        height: MediaQuery.of(context).size.height / 6,
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
                        child: Center(
                          child: Text("${widget.petData.pet_name}'s Posts",
                              overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: Colors.white)),
                        ),
                      )),
                      Positioned(
                          bottom: 100.0,
                          left: 140,
                          child: Container(
                              height: 530,
                              width: 530,
                              child:
                                  Image.asset('assets/images/readycat.png'))),
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
                            child: Center(
                              child: Text(
                                'Please make sure there are no pet post before you delete the pet ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: Colors.white),
                                
                              ),
                            ),
                          )),
                      Positioned(
                        top: 210.0,
                        left: 0,
                        right: 0,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  ContainerSelection(context,
                                      PostSwitch.upcoming, 'Active Poast'),
                                  ContainerSelection(context,
                                      PostSwitch.expired, 'Expired Post'),
                                ],
                              ),
                              buildGradientLine(
                                selectedPostSwitch == PostSwitch.upcoming
                                    ? Colors.indigo
                                    : Colors.indigo,
                                selectedPostSwitch == PostSwitch.expired
                                    ? Colors.indigo
                                    : Colors.indigo,
                              ),
                              Container(child: getCustomContainer())
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container ContainerSelection(
      BuildContext context, PostSwitch postSwitch, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.vertical(top: Radius.elliptical(75, 150)),
        color: selectedPostSwitch == postSwitch ? Colors.indigo : Colors.white,
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextButton(
          onPressed: () {
            setState(() => selectedPostSwitch = postSwitch);
          },
          child: Text(
            title,
            style: TextStyle(
                color: selectedPostSwitch == postSwitch
                    ? Colors.white
                    : Colors.indigo),
          )),
    );
  }

  Widget getCustomContainer() {
    switch (selectedPostSwitch) {
      case PostSwitch.upcoming:
        return DeletePetList(pet_ID: widget.petData.pet_ID!, isExpired: false);
      case PostSwitch.expired:
        return DeletePetList(pet_ID: widget.petData.pet_ID!, isExpired: true);
    }
  }
}
