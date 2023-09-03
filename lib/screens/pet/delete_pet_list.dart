import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/screens/pet/delete_pet_tile.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:provider/provider.dart';

import '../../services/pet_database.dart';

class DeletePetList extends StatefulWidget {
  final String pet_ID;
  final bool isExpired;

  DeletePetList({Key? key, required this.isExpired, required this.pet_ID})
      : super(key: key);

  @override
  State<DeletePetList> createState() => _DeletePetListState();
}

class _DeletePetListState extends State<DeletePetList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostData>>(context);

    if (posts.isNotEmpty) {
      List<PostData> upcomingPost = [];
      List<PostData> expiredPost = [];
      for (var i = 0; i < posts.length; i++) {
        //if the end time is before now (expired)
        if (DateTime.parse(posts[i].post_end!).compareTo(DateTime.now()) < 0) {
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
            return DeletePetTile(
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
            return DeletePetTile(
                pet_ID: widget.pet_ID,
                postData: upcomingPost[index],
                isExpired: widget.isExpired);
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
              child: Text('There are no existing posts for this pet',
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
                    title:
                        const Text('Are you sure you want to delete this pet?'),
                    elevation: 3.0,
                    actions: [
                      TextButton(
                          onPressed: () {
                            PetDatabaseService(petid: widget.pet_ID)
                                .deletePet()
                                .whenComplete(() {
                              showFailedSnackBar('Pet Deleted', context);
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
}
