import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/services/user_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../post/post_detail.dart';

class HomeTile extends StatelessWidget {
  final PostData postData;
  final PetData petData;
  final bool isRegistered;
  final bool isRegistrationClosed;
  const HomeTile(
      {Key? key,
      required this.postData,
      required this.petData,
      required this.isRegistered,
      required this.isRegistrationClosed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetail(
                postData: postData,
                isRegistrationClosed: isRegistrationClosed,
                isRegistered: isRegistered,
              ),
            ),
          );
        },
        child: StreamBuilder<UserData>(
            stream: UserDatabaseService(uid: user!.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
               
                return Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    // Max Size Widget
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                          boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                        ),
                        
                      ),
                    ),
                    Positioned(
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
                            blurRadius: 10.0),
                      ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0)), // Image border
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(48), // Image radius
                                child: Image.network(postData.post_image!,
                                    fit: BoxFit.cover),
                              ),
                            )
                        ),
                      ),
                    ),
                     Positioned(
                        bottom:20.0,
                        left: 40,
                        child: SizedBox(
                          height: 80,
                          width: MediaQuery.of(context).size.width-160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${postData.post_name}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(color: Colors.indigo),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                        children: <Widget>[
                                          Icon(
                                                Icons.location_on,
                                                color: Colors.indigo,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                '${postData.post_location!}',
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
                                ],
                              ),
                              Text(
                                'Posted ${timeago.format(DateTime.parse(postData.post_date!))}',
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        )), 
                  ],
                );
              } else {
                return loadingIndicator();
              }
            }),
      ),
    );
  }
}
