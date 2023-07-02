import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/post.dart';
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
                : const Icon(Icons.delete),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Are you Sure?'),
              elevation: 3.0,
              actions: [
                TextButton(
                    onPressed: () {
                      PostDatabaseService(
                              petid: pet_ID, postid: postData.post_ID)
                          .deletePost()
                          .whenComplete(() {
                        showFailedSnackBar('Post Deleted !', context);
                        Navigator.of(context).pop();
                      }).catchError(
                              (e) => showFailedSnackBar(e.toString(), context));
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
    );
  }

}
