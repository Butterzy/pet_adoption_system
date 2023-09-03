import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/post/delete_post.dart';
import 'package:pet_adoption_system/screens/post/edit_post.dart';
import 'package:pet_adoption_system/screens/status/manage_status.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

class DeletePetTile extends StatelessWidget {
  final String pet_ID;
  final PostData postData;
  final bool isExpired;
  DeletePetTile(
      {Key? key,
      required this.postData,
      required this.isExpired,
      required this.pet_ID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        child: Card(
          elevation: 2.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: ListTile(
            title: Text(postData.post_name!),
            subtitle: Text(postData.post_ID!),
            iconColor: Colors.indigo,
            trailing: isExpired
                ? const Icon(Icons.expand_more)
                : const Icon(Icons.edit),
          ),
        ),
        onTap: () {
          if (isExpired) {
            _showEditPanel(postData, context);
          } else {
            _showEditPanel(postData, context);
          }
        },
      ),
    );
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

   void _showEditPanel(PostData postData, BuildContext context) {
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
                        'Edit Post Action',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.indigo),
                      ),
                    ),
                    InkWell(
                      child: _buildListItem('Edit Post Info', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPost(
                                    pet_ID: pet_ID, postData: postData)));
                      },
                    ),
                    InkWell(
                      child: _buildListItem('Manage Applications', context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  //RegisterPetPost(),
                                  ManageStatus(
                                postData: postData,
                              ),
                            ));
                      },
                    ),
                    InkWell(
                      child: _buildDeleteItem(context),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  //RegisterPetPost(),
                                  DeletePost(postData: postData),
                            ));
                        /* showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Are you Sure?'),
                            elevation: 3.0,
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    PostDatabaseService(
                                            petid: pet_ID,
                                            postid: postData.post_ID)
                                        .deletePost()
                                        .whenComplete(() {
                                      showFailedSnackBar(
                                          'Post Deleted !', context);
                                      Navigator.of(context).pop();
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
                        ); */
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
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