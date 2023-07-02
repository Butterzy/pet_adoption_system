import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/application/application_form.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetail extends StatefulWidget {
  final PostData postData;
  final bool isRegistered;
  final bool isRegistrationClosed;

  PostDetail({
    Key? key,
    required this.isRegistered,
    required this.isRegistrationClosed,
    required this.postData,
  }) : super(key: key);

  @override
  State<PostDetail> createState() => PostDetailState();
}

class PostDetailState extends State<PostDetail> with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  bool isLoading = false;
  String buttonText = '';

  @override
  void initState() {
    super.initState();
    if (widget.isRegistrationClosed) {
      widget.isRegistered
          ? buttonText = 'Applied'
          : buttonText = 'Adoption Closed';
    } else {
      widget.isRegistered ? buttonText = 'Applied' : buttonText = 'Adopt Now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 350,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                      ),
                      Hero(
                          tag: widget.postData.post_image!,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 1.6,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.orange,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: CachedNetworkImage(
                                imageUrl: widget.postData.post_image!,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error,
                                        color: Colors.red, size: 30),
                              ),
                            ),
                          )),
                      Positioned(
                        bottom: 0.0,
                        right: 50,
                        left: 50,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 7,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(45),
                              bottomRight: Radius.circular(45),
                              topLeft: Radius.circular(45),
                              bottomLeft: Radius.circular(45),
                            ),
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 5.0),
                            ],
                          ),
                          child: Column(
                            children: [
                              Column(children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 30.0,top:20,bottom: 10),
                                              child: Text(
                                                '${widget.postData.post_name!}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3!
                                                    .copyWith(color: Colors.black),
                                                softWrap: false,
                                                maxLines: 5,
                                              ),
                                            ),
                                            

buildInfo(
                                                  context,
                                                  widget.postData.post_gender!,
                                                  genderIcon(widget
                                                      .postData.post_gender!)),
                                  ],
                                ),
                              ]),
                              Column(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 25.0),
                                  child: Table(
                                    columnWidths: const {
                                      0: FractionColumnWidth(0.7),
                                      1: FractionColumnWidth(0.3)
                                    },
                                    //  border: TableBorder.all(width:1, color:Colors.black45),
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Text(
                                            '${widget.postData.post_type} - ${widget.postData.post_color} ',
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    color: Colors.grey[500]),
                                            softWrap: false,
                                            maxLines: 3,
                                          ),
                                        ),
                                        Text(
                                          ' ${widget.postData.post_age}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  color: Colors.grey[500]),
                                          textAlign: TextAlign.end,
                                          softWrap: false,
                                          maxLines: 5,
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ]),
                              Column(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Table(
                                    columnWidths: const {
                                      0: FractionColumnWidth(1.0),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 40.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.indigo,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                '${widget.postData.post_location!}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color:
                                                            Colors.grey[500]),
                                                softWrap: false,
                                                maxLines: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40.0,
                        right: 15.0,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.withOpacity(0.4),
                          child: IconButton(
                            onPressed: () async {
                              await Share.share(
                                  'Come and take a look on ${widget.postData.post_name} at https://www.flutter/pet_adoption_system/petpost=8756427s5gd63.com ! ');
                            },
                            icon: const Icon(
                              Icons.share,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40.0,
                        left: 15.0,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.withOpacity(0.4),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 30, right: 30),
                        child: Table(
                          columnWidths: const {
                            0: FractionColumnWidth(0.9),
                            1: FractionColumnWidth(0.1)
                          },
                          children: [
                            TableRow(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_pin,
                                        color: Colors.indigo,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${widget.postData.pet_owner!}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(color: Colors.black),
                                        softWrap: false,
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50.0),
                                    child: Text(
                                      '${widget.postData.myrole!}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(color: Colors.grey[500]),
                                      softWrap: false,
                                      maxLines: 5,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 30,
                                child: IconButton(
                                    onPressed: () async {
                                      launchWhatsApp(
                                          phone: widget.postData.post_contact!);
                                    },
                                    icon: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(pi),
                                      child: Icon(
                                        Icons.call,
                                        size: 35,
                                      ),
                                    )),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Column(children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width-150,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              topLeft: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),
                            color: Colors.indigo,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color.fromARGB(167, 182, 182, 182),
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 3.0),
                            ],
                          ),
                          child: Table(
                            columnWidths: const {
                              0: FractionColumnWidth(0.2),
                              1: FractionColumnWidth(0.2),
                              2: FractionColumnWidth(0.2),
                              3: FractionColumnWidth(0.2)
                            },
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      const Icon(
                                        MdiIcons.pawOff,
                                        size: 70,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Color.fromARGB(
                                                167, 182, 182, 182),
                                            blurRadius: 1,
                                            offset: Offset(3.0, 3.0),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Spayed',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('${widget.postData.post_spayed}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      const Icon(
                                        MdiIcons.medication,
                                        size: 70,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Color.fromARGB(
                                                167, 182, 182, 182),
                                            blurRadius: 1,
                                            offset: Offset(3.0, 3.0),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Dewormed',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('${widget.postData.post_dewormed}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      const Icon(
                                        MdiIcons.needle,
                                        size: 70,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Color.fromARGB(
                                                167, 182, 182, 182),
                                            blurRadius: 1,
                                            offset: Offset(3.0, 3.0),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Vaccinated',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('${widget.postData.post_vaccinated}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      const Icon(
                                        MdiIcons.armFlex,
                                        size: 70,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Color.fromARGB(
                                                167, 182, 182, 182),
                                            blurRadius: 1,
                                            offset: Offset(3.0, 3.0),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Spayed',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('${widget.postData.post_health}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Table(
                      columnWidths: const {
                        0: FractionColumnWidth(1.0),
                      },
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 30, right: 30),
                            child: Text(
                              '${widget.postData.post_desc}',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headline5!,
                              maxLines: 10,
                              softWrap: true,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ElevatedButton(
              onPressed: () async {
                if (widget.isRegistrationClosed) {
                  if (widget.isRegistered) {
                    showNormalSnackBar('You have applied this post', context);
                  } else {
                    showNormalSnackBar('Application has closed', context);
                  }
                } else {
                  if (widget.isRegistered) {
                    showNormalSnackBar('You have applied this post', context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicationForm(
                            postData: widget.postData,
                          ),
                        ));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              child: Text(
                buttonText,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  void launchWhatsApp({required String phone}) async {
    String url = "https://wa.me/$phone";
    await canLaunch(url) ? launch(url) : print("Unable to launch WhatsApp");
  }

  SizedBox buildInfo(BuildContext context, String userData, IconData icon) {
    return SizedBox(
      child: Row(children: [
        Icon(
          icon,
          color: Colors.indigo,
          size: 50,
          shadows: [Shadow(color: Colors.grey, blurRadius: 1)],
        ),
      ]),
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
}
