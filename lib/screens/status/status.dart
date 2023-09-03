import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/status/status_list.dart';
import 'package:pet_adoption_system/services/access_right_database.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:provider/provider.dart';

enum StatusSwitch { allapplications, myapplication }

class Status extends StatefulWidget {
  Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  StatusSwitch selectedStatusSwitch = StatusSwitch.allapplications;
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
                width: MediaQuery.of(context).size.width / 2,
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
            left: 40,
            child: Padding(
              padding: EdgeInsets.only(left: 30, top: 25, bottom: 10),
              child: Text('Your Applications',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          Positioned(
              bottom: 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height / 15,
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
            top: 150.0,
            left: 10,
            right: 10,
            child: Stack(children: [
              Container(
                
                height: MediaQuery.of(context).size.height - 250,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                    topLeft: Radius.circular(45),
                    bottomLeft: Radius.circular(45),
                  ),
                ),
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
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      child: Container(
                          child: StatusList(
                        isMyApplication: true,
                        post_ID: '',
                      )),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
