import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/services/access_right_database.dart';

class PetDatabaseService {
  final String? uid; //userid
  final String? petid;
  final String? requestid;
  final String? applicationid;
  PetDatabaseService(
      {this.uid, this.petid, this.requestid, this.applicationid});

  //collection reference
  final CollectionReference petCollection =
      FirebaseFirestore.instance.collection('pets');

  Future createPetData(PetData petData, BuildContext buildContext,
      List<function>? functionList) async {
    DocumentReference petDocument = petCollection.doc();
    return await petDocument.set({
      'pet_name': petData.pet_name,
      'pet_registerDate': DateTime.now().toString(),
      'pet_category': petData.pet_category,
      'pet_owner': uid,
    }).then((value) async {
      await createDefaultapplication(petDocument.id, functionList);
    });
  }

  Future updatePetData(PetData petData, BuildContext buildContext) async {
    return await petCollection.doc(petid).update(
        {'pet_name': petData.pet_name, 'pet_category': petData.pet_category});
  }

  PetData _petDataFromSnapshot(DocumentSnapshot snapshot) {
    return PetData(
        pet_ID: petid,
        pet_name: snapshot['pet_name'],
        pet_category: snapshot['pet_category']);
  }

  // petlist from snapshot
  List<PetData> _petListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return PetData(
            pet_ID: doc.id,
            pet_name: doc.get('pet_name'),
            pet_category: doc.get('pet_category'));
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  //get pet list stream
  Stream<List<PetData>> get petdatalist {
    return petCollection
        .where('pet_owner', isEqualTo: uid)
        .snapshots()
        .map(_petListFromSnapshot);
  }

  Stream<PetData> get petdata {
    return petCollection.doc(petid).snapshots().map(_petDataFromSnapshot);
  }

/*   Future uploadImage(File? image, BuildContext context, String id) async {
    if (id != null) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('pets')
          .child('${id}/logo')
          .child("logo_$postID");

      await ref.putFile(image!);
      String logo = await ref.getDownloadURL();

      //upload url to cloudfirestore
      await firebaseFirestore
          .collection('pets')
          .doc(id)
          .update({'pet_image': logo});
    } else {
      return null;
    }
  } */

  Future deletePet() async {
    DocumentReference petDocument = petCollection.doc(petid);
    return await FirebaseFirestore.instance
        .runTransaction((transaction) async => transaction.delete(petDocument));
  }

  //committee member......................................................

  final CollectionReference committeeCollection =
      FirebaseFirestore.instance.collection('committee');

  Future createOwnerData(String petID, String ownerID) async {
    return await committeeCollection.doc().set({
      'pet_ID': petID,
      'user_ID': uid,
      'isApproved': true,
      'approved_by': uid,
      'approved_date': DateTime.now().toString(),
      'application_ID': ownerID,
    });
  }

  Future updateCommitteeData(String application_ID) async {
    return await committeeCollection.doc(requestid).update({
      'application_ID': application_ID,
    });
  }

  Future requestAdoptPet(String memberID) async {
    return await committeeCollection.doc().set({
      'pet_ID': petid,
      'user_ID': uid,
      'isApproved': false,
      'approved_by': '',
      'approved_date': '',
      'application_ID': memberID,
    });
  }

  Future approveRequestCM() async {
    return await committeeCollection.doc(requestid).update({
      'isApproved': true,
      'approved_by': uid,
      'approved_date': DateTime.now().toString(),
    });
  }

  Future rejectKickCM() async {
    DocumentReference committeeDocument = committeeCollection.doc(requestid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(committeeDocument));
  }

  CommitteeData _committeeDataFromSnapshot(DocumentSnapshot snapshot) {
    return CommitteeData(
      committee_ID: requestid,
      pet_ID: snapshot['pet_ID'],
      user_ID: snapshot['user_ID'],
      isApproved: snapshot['isApproved'],
      approved_by: snapshot['approved_by'],
      approved_date: snapshot['approved_date'],
      application_ID: snapshot['application_ID'],
    );
  }

  List<CommitteeData> _committeeListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return CommitteeData(
          committee_ID: doc.id,
          pet_ID: doc.get('pet_ID'),
          user_ID: doc.get('user_ID'),
          isApproved: doc.get('isApproved'),
          approved_by: doc.get('approved_by'),
          approved_date: doc.get('approved_date'),
          application_ID: doc.get('application_ID'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<CommitteeData>> get committeeDatalist {
    return committeeCollection
        .where('pet_ID', isEqualTo: petid)
        .snapshots()
        .map(_committeeListFromSnapshot);
  }

  Stream<CommitteeData> get committeedata {
    return committeeCollection
        .doc(requestid)
        .snapshots()
        .map(_committeeDataFromSnapshot);
  }

  //pet structure (application)

  final CollectionReference applicationCollection =
      FirebaseFirestore.instance.collection('applications');

  Future createDefaultapplication(
      String petID, List<function>? functionList) async {
    List<accessRight> access_right = [];
    for (var i = 0; i < functionList!.length; i++) {
      var data = accessRight(
          function_ID: functionList[i].function_ID,
          access_right_code: functionList[i].access_right_code);
      access_right.add(data);
    }
    DocumentReference applicationDocument = applicationCollection.doc();
    await applicationDocument.set({
      'application_name': 'Owner',
      'seq_number': '1',
      'pet_ID': petID,
    });
    await applicationCollection.doc().set({
      'application_name': 'Member',
      'seq_number': '5',
      'pet_ID': petID,
    });
    await createOwnerData(petID, applicationDocument.id);
    await AccessRightDatabaseService(applicationid: applicationDocument.id)
        .createAccessRight(access_right);
  }

  Future createapplication(
      ApplicationData applicationData, List<accessRight> accessData) async {
    DocumentReference applicationDocument = applicationCollection.doc();
    return await applicationDocument.set({
      'application_name': applicationData.application_name,
      'seq_number': applicationData.seq_number,
      'pet_ID': petid,
    }).then((value) =>
        AccessRightDatabaseService(applicationid: applicationDocument.id)
            .createAccessRight(accessData));
  }

  Future updateapplication(
      ApplicationData applicationData, List<accessRight> accessData) async {
    return await applicationCollection.doc(applicationid).update({
      'application_name': applicationData.application_name,
      'seq_number': applicationData.seq_number,
    }).then((value) => AccessRightDatabaseService(applicationid: applicationid)
        .updateAccessRight(accessData));
  }

  ApplicationData _applicationDataFromSnapshot(DocumentSnapshot snapshot) {
    return ApplicationData(
      application_ID: applicationid,
      application_name: snapshot['application_name'],
      seq_number: snapshot['seq_number'],
      pet_ID: snapshot['pet_ID'],
    );
  }

  List<ApplicationData> _applicationListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return ApplicationData(
          application_ID: doc.id,
          application_name: doc.get('application_name'),
          seq_number: doc.get('seq_number'),
          pet_ID: doc.get('pet_ID'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<ApplicationData> get applicationData {
    return applicationCollection
        .doc(applicationid)
        .snapshots()
        .map(_applicationDataFromSnapshot);
  }

  Stream<List<ApplicationData>> get applicationDataList {
    return applicationCollection.snapshots().map(_applicationListFromSnapshot);
  }

  Future deleteApplication() async {
    DocumentReference applicationDocument =
        applicationCollection.doc(applicationid);
    await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(applicationDocument));
    await AccessRightDatabaseService(applicationid: applicationid)
        .deleteAccessRight();
  }
}
