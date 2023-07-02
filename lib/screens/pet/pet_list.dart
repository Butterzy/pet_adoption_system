import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/screens/pet/pet_tile.dart';
import 'package:provider/provider.dart';

//This class is defining a widget that displays a list of pets in a ListView.
class PetList extends StatefulWidget {
  final bool isMyPet;
/*  final bool postedpet; */
  PetList({
    Key? key,
    required this.isMyPet,
    /*      required this.postedpet */
  }) : super(key: key);

  @override
  State<PetList> createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  @override
  Widget build(
    BuildContext context,
  ) {
    /* The widget retrieves data from several providers using the Provider.of method, 
    which is a way to access data stored in the Flutter Provider package.  */

    final pets = Provider.of<List<PetData>>(
        context); //a list of PetProfileData objects, which represents pets owned by users in the app.
    final committee = Provider.of<List<CommitteeData>>(
        context); //a list of CommitteeData objects, which represent user roles within an organization.
    final application = Provider.of<List<ApplicationData>>(
        context); //a list of applicationData objects, which represent applications that users can hold within an organization.

    final user = Provider.of<thisUser>(
        context); //a thisUser object, which represents the current user of the app.

/* The widget first checks if the pets list is not empty. 
If it's not empty, it iterates over the pets list and filters out pets that are not owned by the current user 
and not approved by the organization's committee. */
    if (pets.isNotEmpty) {
      //a new empty list called mypetlist is created to store the pets that meet certain criteria.
      List<PetData> mypetlist = [];

      //Then, a loop is started over the pets list to check each pet in the list.
      for (var i = 0; i < pets.length; i++) {
        //Within the first loop, another loop is started over the committee list to check each committee data in the list.
        for (var j = 0; j < committee.length; j++) {
/* an if statement is used to check if the pet_ID of the current PetProfileData object in the pets list matches 
the club_ID of the current CommitteeData object in the committee list 
AND if the user_ID of the current CommitteeData object in the committee list matches 
the uid of the thisUser object retrieved from the Provider.of method call AND if the isApproved 
property of the current CommitteeData object is true. */

          if (pets[i].pet_ID == committee[j].pet_ID &&
              committee[j].user_ID == user.uid &&
              committee[j].isApproved == true) {
//then the current PetProfileData object is added to the mypetlist list using the add() method
            mypetlist.add(pets[i]);
//the mypetlist list is sorted in descending order based on the pet_name property of each PetProfileData object using the sort() method.
            mypetlist.sort((a, b) {
              return b.pet_name!.compareTo(a.pet_name!);
            });
          }
        }
      }
//The filtered pets are then sorted by name in descending order.
      pets.sort((a, b) {
        return b.pet_name!.compareTo(a.pet_name!);
      });

/* Next, the widget checks if the isMyPet variable is true. 
If it's true, it displays a ListView of pets that belong to the current user. 
Otherwise, it displays a ListView of all pets.       */

//--------------------------------------isMyPet---------------------------------------------------------
      if (widget.isMyPet) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: mypetlist.length,
          itemBuilder: (context, index) {
            /* Each pet is displayed using a PetTile widget, 
            which takes several arguments including the PetProfileData object and 
            booleans indicating whether the pet has been requested or joined by the current user. */

            return PetTile(
              applicationID: getApplicationID(application, mypetlist[index]),
              petData: mypetlist[index],
              isMyPet: widget.isMyPet,
              // accessLimitData: getAccessRight(mypetlist[index], committee, user, application, accessRightList, functionList),
              isRequested: isRequested(committee, mypetlist[index], user),
              isJoined: isJoined(committee, mypetlist[index], user),
            );
          },
        );
      } else {
        //if (widget.isAllPet)

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: pets.length,
          itemBuilder: (context, index) {
            /* Each pet is displayed using a PetTile widget, 
            which takes several arguments including the PetProfileData object and 
            booleans indicating whether the pet has been requested or joined by the current user. */

            return PetTile(
              applicationID: getApplicationID(application, pets[index]),
              petData: pets[index],
              isMyPet: widget.isMyPet,
              /*getAccessRight is to determine what actions the current user is allowed to perform on the pet based on their role and access rights within the organization. */

              // accessLimitData: getAccessRight(pets[index], committee, user, application, accessRightList, functionList),
              isRequested: isRequested(committee, mypetlist[index], user),
              isJoined: isJoined(committee, mypetlist[index], user),
            );
          },
        );
      }
    } else {
      //if the pets list is empty, the widget displays a message indicating that there are no pets to display.
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: Text(
          'No Pet',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.indigo),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  bool isRequested(List<CommitteeData> committeeData, PetData petprofileData,
      thisUser user) {
    for (var i = 0; i < committeeData.length; i++) {
      if (petprofileData.pet_ID == committeeData[i].pet_ID &&
          committeeData[i].user_ID == user.uid) {
        return true;
      }
    }
    return false;
  }

  bool isJoined(List<CommitteeData> committeeData, PetData petprofileData,
      thisUser user) {
    bool isJoined = false;
    for (var i = 0; i < committeeData.length; i++) {
      if (petprofileData.pet_ID == committeeData[i].pet_ID &&
          committeeData[i].user_ID == user.uid) {
        return isJoined = committeeData[i].isApproved!;
      }
    }
    return isJoined;
  }

  String getApplicationID(
      List<ApplicationData> applications, PetData petprofileData) {
    String applicationID = '';
    if (applications.isNotEmpty) {
      applications.sort((a, b) => a.seq_number!.compareTo(b.seq_number!));
      applicationID = applications[applications.length - 1].application_ID!;
      return applicationID;
    } else {
      return applicationID;
    }
  }

  accessLimit getAccessRight(
      PetData petData,
      List<CommitteeData> cmData,
      thisUser user,
      List<ApplicationData> applicationData,
      List<accessRight> accessRightList,
      List<function> functionList) {
    List<CommitteeData> myCom = [];
    for (var i = 0; i < cmData.length; i++) {
      if (petData.pet_ID == cmData[i].pet_ID && cmData[i].user_ID == user.uid) {
        //get joined application id
        var currentAccessRight = accessRightList
            .where((r) => r.application_ID == cmData[i].application_ID)
            .toList();
        for (var i = 0; i < currentAccessRight.length; i++) {
          var function = functionList
              .where((r) => r.function_ID == currentAccessRight[i].function_ID)
              .first;
          return accessLimit(
              function_name: function.function_name,
              access_right_code: currentAccessRight[i].access_right_code);
        }
      }
    }
    return accessLimit();
  }
}
