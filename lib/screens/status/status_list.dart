import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:provider/provider.dart';

import 'status_tile.dart';

class StatusList extends StatefulWidget {
  final String? post_ID;
  final bool isMyApplication;
  //final bool isMyPostApplication;
  StatusList({Key? key, required this.isMyApplication, required this.post_ID})
      : super(key: key);

  @override
  State<StatusList> createState() => _StatusListState(post_ID);
}

class _StatusListState extends State<StatusList> {
  final String? post_ID;

  _StatusListState(this.post_ID);
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

      /* debugPrint('total registers in db : ${registerData.length}');
      debugPrint('total registers of this post: ${postRegisteredData.length}');
      debugPrint('this acc user registered  : ${userRegisteredData.length}'); */
      if (widget.isMyApplication) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: userRegisteredData.length,
          itemBuilder: (context, index) {
            postData.sort((a, b) {
              return b.post_start!.compareTo(a.post_start!);
            });
            return StatusTile(
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
            return StatusTile(
              isMyApplication: widget.isMyApplication,
              postData: getPostData(postRegisteredData[index], postData),
              registerData: postRegisteredData[index],
            );
          },
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Center(
          child: const Text(
            'No Registered Post yet',
            style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          ),
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
