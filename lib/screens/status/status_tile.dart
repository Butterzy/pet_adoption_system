import 'package:flutter/material.dart';

import 'package:pet_adoption_system/models/post.dart';

import 'package:pet_adoption_system/screens/application/edit_application.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

var user_role = "";

class StatusTile extends StatefulWidget {
  RegisterData? registerData;
  PostData? postData;
  final bool isMyApplication;

  // final accessLimit accessLimitData;
  StatusTile({
    Key? key,
    required this.registerData,
    required this.postData,
    required this.isMyApplication,
    // required this.accessLimitData
  }) : super(key: key);

  @override
  State<StatusTile> createState() => _StatusTileState();
}

class _StatusTileState extends State<StatusTile> {
  late RegisterData registerData; // Declare registerData as non-nullable late

  @override
  void initState() {
    super.initState();
    registerData =
        widget.registerData!; // Initialize registerData from widget property
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              // Max Size Widget
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  height: 580,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.1, 1.1),
                          blurRadius: 5.0),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 90,
                left: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 430,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.1, 1.1),
                              blurRadius: 5.0),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0)), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(48), // Image radius
                          child: Image.network(
                              widget.postData!.post_image ?? "",
                              fit: BoxFit.cover),
                        ),
                      )),
                ),
              ),

              Positioned(
                  bottom: 20.0,
                  left: 40,
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width - 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildStatusInfo(context, registerData.app_status!,
                                statusIcon(registerData.app_status!)),
                          ],
                        ),
                        Text(
                            'Applied ${timeago.format(DateTime.parse(widget.registerData?.app_time ?? ''))}'),
                      ],
                    ),
                  )),

              Positioned(
                  top: 25.0,
                  left: 40,
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width - 120,
                    child: Center(
                      child: Text("${widget.postData?.post_name ?? ''}",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.indigo)),
                    ),
                  )),
            ],
          ),
          onTap: () {
            if (widget.isMyApplication) {
              _showEditPanel(widget.registerData!, context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ApplicationDetails(registerData: registerData),
                ),
              );
            }
          },
        ));
  }

  void _showEditPanel(
    RegisterData registerData,
    BuildContext context,
  ) {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (context) {
          return SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                      child: Container(
                          height: 5.0,
                          width: 80.0,
                          decoration: const BoxDecoration(
                              color: Colors.indigo,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)))),
                    ),
                    buildDivider('Status'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Colors.indigo,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${registerData.app_status}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    buildDivider('Adopter'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.indigo[100],
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(children: [
                              Icon(
                                Icons.person,
                                size: 130.0,
                                color: Colors.indigo[300],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${registerData.app_fname} ${registerData.app_lname}',
                                    ),
                                    Text(
                                      '${registerData.app_gender}',
                                    ),
                                    Text(
                                      'Occupation : ${registerData.app_occupation}',
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.person,
                                size: 130.0,
                                color: Colors.indigo[300],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${registerData.app_cfname} ${registerData.app_clname}',
                                    ),
                                    Text(
                                      '${registerData.app_gender1}',
                                    ),
                                    Text(
                                      'Occupation : ${registerData.app_occupation1}',
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    buildDivider('Contact'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.indigo[100],
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(children: [
                              Icon(
                                Icons.home,
                                size: 130.0,
                                color: Colors.indigo[300],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${registerData.app_addStreet1} ',
                                    ),
                                    Text(
                                      '${registerData.app_addStreet2}',
                                    ),
                                    Text(
                                      '${registerData.app_addPostcode}',
                                    ),
                                    Text(
                                      '${registerData.app_addCity} ${registerData.app_addState}',
                                    ),
                                    Text(
                                      '${registerData.app_addState}',
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.phone,
                                size: 130.0,
                                color: Colors.indigo[300],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${registerData.app_HPno}',
                                    ),
                                    Text(
                                      '${registerData.app_email}',
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    buildDivider('Questions and Considerations'),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(children: [
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Why do you want to own a pet?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q9}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ])
                      ],
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(children: [
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Are all members of your household in agreement with this adoption?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q7}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Does your social/work life allow for a pet?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q3}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              )
                            ],
                          ),
                        ]),
                        TableRow(children: [
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'How many adults are in your household?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q4}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'How many children are in your household?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q5}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              )
                            ],
                          ),
                        ]),
                        TableRow(children: [
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Who will be the pet\'s primary caregiver?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q6}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Is your place of residence suited for a pet?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q2}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              )
                            ],
                          ),
                        ]),
                        TableRow(children: [
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Do you currently have any pets?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q1}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.question_mark_outlined,
                                size: 30.0,
                                color: Colors.indigo[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Do you know about any allergies?',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.indigo,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${registerData.app_q8}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              )
                            ],
                          ),
                        ]),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'Applied Time : ${registerData.app_time}',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.indigo[100],
                              ),
                              child: Row(
                                children: [
                                  _buildCancel('Request Cancel', context),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Are you Sure?'),
                                elevation: 3.0,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        PostDatabaseService(
                                                registerid: widget
                                                    .registerData?.register_ID)
                                            .cancelRegistration(
                                                registerData, context)
                                            .whenComplete(() {
                                          Navigator.of(context).pop();
                                          
                                          showSuccessSnackBar(
                                              'Request Sent !', context);
                                        }).catchError((e) => showFailedSnackBar(
                                                e.toString(), context));
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'))
                                ],
                              ),
                            );
                          },
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.indigo[100],
                              ),
                              
                              child: Row(
                                children: [
                                  _buildContact('Contact Post Owner', context),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            launchWhatsApp(
                                phone: registerData.postowner_contact!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ));
        });
  }

  Container _buildCancel(String text, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: 50,
      
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cancel,
            color: Colors.red,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text('Request Cancel'),
        ],
      ),
    );
  }

  Container _buildContact(String text, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: 50,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.phone,
            color: Colors.indigo,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text('Contact Post Owner'),
        ],
      ),
    );
  }
}

SizedBox buildStatusInfo(
    BuildContext context, String registerData, IconData icon) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 3,
    child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 20, bottom: 15),
        child: Row(children: [
          Icon(icon, color: statusColor(registerData), size: 25),
          Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(registerData,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.indigo)))
        ])),
  );
}

IconData statusIcon(String status) {
  if (status.isNotEmpty) {
    if (status == 'Reject') {
      return Icons
          .circle; // You can set a different icon for 'Reject' status if needed
    } else {
      return Icons.circle;
    }
  }
  return Icons.circle;
}

Color statusColor(String status) {
  if (status.isNotEmpty) {
    if (status == 'Rejected') {
      return Colors.red; // Set red color for 'Reject' status
    } else if (status == 'Request Cancel') {
      return Colors.amber;
    } else {
      return Colors.green; // Set green color for other status values
    }
  }
  return Colors.green; // Set a default color if status is empty or unrecognized
}

Row buildDivider(String label) {
  return Row(children: <Widget>[
    Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: const Divider(color: Colors.black38, height: 36)),
    ),
    Text(label),
    Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 10.0),
          child: const Divider(color: Colors.black38, height: 36)),
    ),
  ]);
}

void launchWhatsApp({required String phone}) async {
  String url = "https://wa.me/$phone";
  await canLaunch(url) ? launch(url) : print("Unable to launch WhatsApp");
}
