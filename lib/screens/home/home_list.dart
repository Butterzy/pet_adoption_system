import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/screens/home/home_tile.dart';
import 'package:provider/provider.dart';

class HomeList extends StatefulWidget {
  HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => HomeListState();
}

class HomeListState extends State<HomeList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostData>>(context);
    final pets = Provider.of<List<PetData>>(context);
    final registerData = Provider.of<List<RegisterData>>(context);
    final user = Provider.of<thisUser>(context);

    if (posts.isNotEmpty) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45),
            bottomRight: Radius.circular(45),
            topLeft: Radius.circular(45),
            bottomLeft: Radius.circular(45),
          ),
        ),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            posts.sort((a, b) {
              return b.post_date!.compareTo(a.post_date!);
            });
            return HomeTile(
              postData: posts[index],
              petData: getThePet(pets, posts[index]),
              isRegistered: isRegistered(registerData, posts[index], user),
              isRegistrationClosed:
                  isRegistrationClosed(registerData, posts[index]),
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Text(
          'No Post posted yet',
          style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0)
        ),
      );
    }
  }

  PetData getThePet(List<PetData> pets, PostData post) {
    PetData thePet = PetData();
    for (var i = 0; i < pets.length; i++) {
      if (post.pet_ID == pets[i].pet_ID) {
        return pets[i];
      }
    }
    return thePet;
  }

  bool isRegistered(
      List<RegisterData> registerData, PostData post, thisUser user) {
    for (var i = 0; i < registerData.length; i++) {
      if (post.post_ID == registerData[i].post_ID &&
          registerData[i].user_ID == user.uid) {
        return true;
      }
    }
    return false;
  }

  bool isRegistrationClosed(List<RegisterData> registerData, PostData post) {
    var count = 0;
    var numAdoption = post.post_numAdoption?.toInt() ?? 0;
    for (var i = 0; i < registerData.length; i++) {
      if (post.post_ID == registerData[i].post_ID) {
        count++;
      }
    }
    if (count < numAdoption) {
      if (DateTime.parse(post.post_end!).compareTo(DateTime.now()) < 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
