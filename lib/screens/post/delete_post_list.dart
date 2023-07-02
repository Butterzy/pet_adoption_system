import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/screens/post/delete_post_tile.dart';
import 'package:pet_adoption_system/services/pet_database.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:provider/provider.dart';

class DeletePostList extends StatefulWidget {
  final String? post_ID;
  final bool isMyApplication;
  //final bool isMyPostApplication;
  DeletePostList({
    Key? key,
    required this.isMyApplication,
    required this.post_ID,
  }) : super(key: key);

  @override
  State<DeletePostList> createState() => _DeletePostListState(post_ID);
}

class _DeletePostListState extends State<DeletePostList> {
  final String? post_ID;

  _DeletePostListState(this.post_ID);
  @override
  Widget build(BuildContext context) {
    final registerData = Provider.of<List<RegisterData>>(context);
    final postData = Provider.of<List<PostData>>(context);
    final user = Provider.of<thisUser>(context);
    if (registerData.isNotEmpty) {
      List<RegisterData> postRegisteredData = [];
      List<RegisterData> userRegisteredData = [];

      for (var i = 0; i < registerData.length; i++) {
        if (registerData[i].user_ID == user.uid) {
          userRegisteredData.add(registerData[i]);
        }
        if (registerData.elementAt(i).post_ID == post_ID) {
          postRegisteredData.add(registerData[i]);
        }
      }

      debugPrint('total registers in db : ${registerData.length}');
      debugPrint('total registers of this post: ${postRegisteredData.length}');
      debugPrint('this acc user registered  : ${userRegisteredData.length}');
      if (widget.isMyApplication) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: userRegisteredData.length,
          itemBuilder: (context, index) {
            postData.sort((a, b) {
              return b.post_start!.compareTo(a.post_start!);
            });
            return DeletePostTile(
              isMyApplication: widget.isMyApplication,
              //isMyPostApplication: widget.isMyPostApplication,
              postData: getPostData(userRegisteredData[index], postData),
              registerData: userRegisteredData[index],
            );
          },
        );
      } else {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: postRegisteredData.length,
          itemBuilder: (context, index) {
            postData.sort((a, b) {
              return b.post_start!.compareTo(a.post_start!);
            });
            return DeletePostTile(
              isMyApplication: widget.isMyApplication,
              //isMyPostApplication: widget.isMyPostApplication,
              postData: getPostData(userRegisteredData[index], postData),
              registerData: userRegisteredData[index],
            );
          },
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 7),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                  'There are no application for this post',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.indigo)),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                        'Are you sure you want to delete this post?'),
                    elevation: 3.0,
                    actions: [
                      TextButton(
                          onPressed: () {
                            PostDatabaseService(postid: post_ID)
                                .deletePost()
                                .whenComplete(() {
                              showFailedSnackBar('Post Deleted !', context);
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
                size: 50,
              ),
            ),
          ],
        ),
      );
    }
  }

  PostData getPostData(RegisterData registerData, List<PostData> postData) {
    for (var i = 0; i < postData.length; i++) {
      if (registerData.post_ID == postData[i].post_ID) {
        return postData[i];
      }
    }
    return PostData();
  }
}
