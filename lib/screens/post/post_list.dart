import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/post/post_tile.dart';
import 'package:provider/provider.dart';


class PostList extends StatefulWidget {
  final String pet_ID;
  final bool isExpired;
  PostList({Key? key, required this.isExpired, required this.pet_ID})
      : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostData>>(context);
    
    if (posts.isNotEmpty) {
      List<PostData> upcomingPost = [];
      List<PostData> expiredPost = [];
      for (var i = 0; i < posts.length; i++) {
        //if the end time is before now (expired)
        if (DateTime.parse(posts[i].post_end!).compareTo(DateTime.now()) <
            0) {
          expiredPost.add(posts[i]);
          expiredPost.sort((a, b) {
            return b.post_end!.compareTo(a.post_end!);
          });
        } else {
          //if the end time is after now (upcoming)
          upcomingPost.add(posts[i]);
          upcomingPost.sort((a, b) {
            return b.post_end!.compareTo(a.post_end!);
          });
        }
      }
      if (widget.isExpired) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: expiredPost.length,
          itemBuilder: (context, index) {
            return PostTile(
                pet_ID: widget.pet_ID,
                postData: expiredPost[index],
                isExpired: widget.isExpired);
          },
        );
      } else {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: upcomingPost.length,
          itemBuilder: (context, index) {
            return PostTile(
                pet_ID: widget.pet_ID,
                postData: upcomingPost[index],
                isExpired: widget.isExpired);
          },
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child:  Text('No Pet Posted Yet',
            style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.indigo)),
      );
    }
  }
}
