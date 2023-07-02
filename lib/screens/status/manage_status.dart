import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/status/status_list.dart';
import 'package:pet_adoption_system/services/access_right_database.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:provider/provider.dart';

enum StatusSwitch { allapplications, myapplication }

class ManageStatus extends StatefulWidget {
  PostData postData;
  ManageStatus({Key? key, required this.postData}) : super(key: key);

  @override
  State<ManageStatus> createState() => _ManageStatusState();
}

class _ManageStatusState extends State<ManageStatus> {
  StatusSwitch selectedStatusSwitch = StatusSwitch.allapplications;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
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
                  child: Text(
                      '${widget.postData.post_name}\'s Adoption Application',
                      overflow: TextOverflow.clip,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.white)),
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
                  )),
                  Positioned(
                  bottom: 15.0,
                  left: 140,
                  child: Container(
                      height: 530,
                      width: 530,
                      child: Image.asset('assets/images/greycat.png'))),
              Positioned(
                top: 210.0,
                left: 0,
                right: 0,
                child: MultiProvider(
                  providers: [
                    StreamProvider<List<RegisterData>>.value(
                        value: PostDatabaseService().registerdata,
                        initialData: []),
                    StreamProvider<List<PostData>>.value(
                        value: PostDatabaseService().postdata, initialData: []),
                    StreamProvider<List<function>>.value(
                        initialData: [],
                        value: AccessRightDatabaseService().functionlist),
                    StreamProvider<List<accessRight>>.value(
                        initialData: [],
                        value: AccessRightDatabaseService().accessdatalist),
                  ],
                  child: Container(
                      height: MediaQuery.of(context).size.height - 250,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: StatusList(
                            isMyApplication: false,
                            post_ID: widget.postData.post_ID!,
                          ),
                        ),
                      )),
                  /* child: SingleChildScrollView(
                child: 
                    Container(
                        child: StatusList(isMyApplication: true)),
                  
                ), */
                ),
              )
            ],
          ),
        ));
  }
}
