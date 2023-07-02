import 'package:flutter/material.dart';

import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/status/edit_status.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationDetails extends StatefulWidget {
  final RegisterData registerData;

  ApplicationDetails({required this.registerData});

  @override
  _ApplicationDetailsState createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends State<ApplicationDetails> {
  String error = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.registerData.register_ID}',
          style: const TextStyle(color: Colors.white), //<-- SEE HERE
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Are you sure?'),
                  elevation: 3.0,
                  actions: [
                    TextButton(
                        onPressed: () {
                          PostDatabaseService(
                                  registerid: widget.registerData.register_ID)
                              .deleteRegistration()
                              .whenComplete(() {
                            showFailedSnackBar('Application Deleted', context);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }).catchError((e) =>
                                  showFailedSnackBar(e.toString(), context));
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
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          IconButton(
              tooltip: 'Completed',
              onPressed: () async {
                setState(() => isLoading = true);
                CompleteAdoption completeAdoption = CompleteAdoption(
                  register_id: widget.registerData.register_ID,
                  pet_category: widget.registerData.pet_category,
                );
                dynamic result = PostDatabaseService(
                        registerid: widget.registerData.register_ID)
                    .createCompleteAdoption(completeAdoption)
                    .whenComplete(() {
                  Navigator.of(context).pop();
                  showSuccessSnackBar('Completed !', context);
                }).catchError((e) => print(e));

                if (result == null) {
                  setState(() {
                    error = 'Could not apply  please try again';
                    isLoading = false;
                  });
                }
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ))
        ],
      ),

      //---------------------------APPLICATION FORM STARTS HERE-----------------
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            children: [
              buildDivider('Application Status'),

              Table(
                columnWidths: const {
                  0: FlexColumnWidth(3),
                },
                children: [
                  TableRow(children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.indigo,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${widget.registerData.app_status}',
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
                  ])
                ],
              ),
              buildDivider('Adopter'),
              const SizedBox(height: 20.0),
              Container(
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
                              '${widget.registerData.app_fname} ${widget.registerData.app_lname}',
                            ),
                            Text(
                              '${widget.registerData.app_gender}',
                            ),
                            Text(
                              'Occupation : ${widget.registerData.app_occupation}',
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
                              '${widget.registerData.app_cfname} ${widget.registerData.app_clname}',
                            ),
                            Text(
                              '${widget.registerData.app_gender1}',
                            ),
                            Text(
                              'Occupation : ${widget.registerData.app_occupation1}',
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),

              buildDivider('Contact'),
              const SizedBox(height: 20.0),
              Container(
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
                              '${widget.registerData.app_addStreet1} ',
                            ),
                            Text(
                              '${widget.registerData.app_addStreet2}',
                            ),
                            Text(
                              '${widget.registerData.app_addPostcode}',
                            ),
                            Text(
                              '${widget.registerData.app_addCity} ${widget.registerData.app_addState}',
                            ),
                            Text(
                              '${widget.registerData.app_addState}',
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
                              '${widget.registerData.app_HPno}',
                            ),
                            Text(
                              '${widget.registerData.app_email}',
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),
              //-------------------------Questions and Considerations--------------------------

              buildDivider('Questions and Considerations'),
              const SizedBox(height: 20.0),
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
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.indigo,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${widget.registerData.app_q9}',
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
                                '${widget.registerData.app_q7}',
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
                                '${widget.registerData.app_q3}',
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
                                '${widget.registerData.app_q4}',
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
                                '${widget.registerData.app_q5}',
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
                                '${widget.registerData.app_q6}',
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
                                '${widget.registerData.app_q2}',
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
                                '${widget.registerData.app_q1}',
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
                                '${widget.registerData.app_q8}',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditStatus(
                                  registerData: widget.registerData)));
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width / 2.4, 45),
                      backgroundColor: Colors.indigo[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Edit Status',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      launchWhatsApp(phone: widget.registerData.app_HPno!);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width / 2.4, 45),
                      backgroundColor: Colors.indigo[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
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
                        Text(
                          'Contact Applicant',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
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
