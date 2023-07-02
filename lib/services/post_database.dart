import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_adoption_system/models/post.dart';

class PostDatabaseService {
  final String? postid;
  final String? petid;
  final String? uid;
  final String? registerid;
  PostDatabaseService({this.postid, this.petid, this.uid, this.registerid});

  //collection reference
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  //get post stream
  Stream<List<PostData>> get postdata {
    return postCollection
        .where('pet_ID', isEqualTo: petid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  List<PostData> _postListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return PostData(
            post_ID: doc.id,
            post_name: doc.get('post_name'),
            post_desc: doc.get('post_desc'),
            post_location: doc.get('post_location'),
            post_start: doc.get('post_start'),
            post_end: doc.get('post_end'),
            post_contact: doc.get('post_contact'),
            post_age: doc.get('post_age'),
            post_color: doc.get('post_color'),
            post_type: doc.get('post_type'),
            post_gender: doc.get('post_gender'),
            post_vaccinated: doc.get('post_vaccinated'),
            post_dewormed: doc.get('post_dewormed'),
            post_spayed: doc.get('post_spayed'),
            post_health: doc.get('post_health'),
            myrole: doc.get('myrole'),
            post_numAdoption: doc.get('post_numAdoption'),
            post_image: doc.get('post_image'),
            pet_ID: doc.get('pet_ID'),
            pet_owner: doc.get('post_owner'),
            post_date: doc.get('post_date'));
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future createPosts(PostData postData, File? image, BuildContext buildContext,
      String date) async {
    DocumentReference postDocument = postCollection.doc();
    return await postDocument.set({
      'post_name': postData.post_name,
      'post_desc': postData.post_desc,
      'post_location': postData.post_location,
      'post_start': postData.post_start,
      'post_end': postData.post_end,
      'post_contact': postData.post_contact,
      'post_age': postData.post_age,
      'post_color': postData.post_color,
      'post_type': postData.post_type,
      'post_gender': postData.post_gender,
      'post_vaccinated': postData.post_vaccinated,
      'post_dewormed': postData.post_dewormed,
      'post_spayed': postData.post_spayed,
      'post_health': postData.post_health,
      'myrole': postData.myrole,
      'post_numAdoption': postData.post_numAdoption,
      'post_image': '',
      'pet_ID': petid,
      'post_owner': postData.pet_owner,
      'post_date': date
    }).then((value) async {
      await uploadPostImage(image, buildContext, postDocument.id);
    });
  }

  Future updatePostData(
      PostData postData, File? image, BuildContext buildContext) async {
    if (image != null) {
      return await postCollection.doc(postid).update({
        'post_name': postData.post_name,
        'post_desc': postData.post_desc,
        'post_location': postData.post_location,
        'post_start': postData.post_start,
        'post_end': postData.post_end,
        'post_contact': postData.post_contact,
        'post_age': postData.post_age,
        'post_color': postData.post_color,
        'post_type': postData.post_type,
        'post_gender': postData.post_gender,
        'post_vaccinated': postData.post_vaccinated,
        'post_dewormed': postData.post_dewormed,
        'post_spayed': postData.post_spayed,
        'post_health': postData.post_health,
        'myrole': postData.myrole,
        'post_numAdoption': postData.post_numAdoption,
      }).then((value) async {
        await uploadPostImage(image, buildContext, postid!);
      });
    } else {
      return await postCollection.doc(postid).update({
        'post_name': postData.post_name,
        'post_desc': postData.post_desc,
        'post_location': postData.post_location,
        'post_start': postData.post_start,
        'post_end': postData.post_end,
        'post_contact': postData.post_contact,
        'post_age': postData.post_age,
        'post_color': postData.post_color,
        'post_type': postData.post_type,
        'post_gender': postData.post_gender,
        'post_vaccinated': postData.post_vaccinated,
        'post_dewormed': postData.post_dewormed,
        'post_spayed': postData.post_spayed,
        'post_health': postData.post_health,
        'myrole': postData.myrole,
        'post_numAdoption': postData.post_numAdoption,
      });
    }
  }

  Future uploadPostImage(File? image, BuildContext context, String id) async {
    if (petid != null) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('pets')
          .child('${petid!}/post')
          .child(id)
          .child("post_$postID");

      await ref.putFile(image!);
      String postPoster = await ref.getDownloadURL();

      //upload url to cloudfirestore
      await firebaseFirestore
          .collection('posts')
          .doc(id)
          .update({'post_image': postPoster});
    } else {
      return null;
    }
  }

  Future deletePost() async {
    DocumentReference postDocument = postCollection.doc(postid);
    return await FirebaseFirestore.instance
        .runTransaction((transaction) async => transaction.delete(postDocument))
      ;
  }

  //registration.......................................................
  Stream<RegisterData> get registerData {
    return registerCollection
        .doc(uid)
        .snapshots()
        .map(_registerDataFromSnapshot);
  }

  final CollectionReference registerCollection =
      FirebaseFirestore.instance.collection('registers');

  Future registerPost(
      String time, RegisterData registerData, PostData postData) async {
    return await registerCollection.doc().set({
      'post_ID': postid,
      'user_ID': uid,
      'app_fname': registerData.app_fname,
      'app_lname': registerData.app_lname,
      'app_cfname': registerData.app_cfname,
      'app_clname': registerData.app_clname,
      'app_email': registerData.app_email,
      'app_HPno': registerData.app_HPno,
      'app_gender': registerData.app_gender,
      'app_gender1': registerData.app_gender1,
      'app_occupation': registerData.app_occupation,
      'app_occupation1': registerData.app_occupation1,
      'app_addStreet1': registerData.app_addStreet1,
      'app_addStreet2': registerData.app_addStreet2,
      'app_addPostcode': registerData.app_addPostcode,
      'app_addCity': registerData.app_addCity,
      'app_addState': registerData.app_addState,
      'app_q1': registerData.app_q1,
      'app_q2': registerData.app_q2,
      'app_q3': registerData.app_q3,
      'app_q4': registerData.app_q4,
      'app_q5': registerData.app_q5,
      'app_q6': registerData.app_q6,
      'app_q7': registerData.app_q7,
      'app_q8': registerData.app_q8,
      'app_q9': registerData.app_q9,
      'app_status': 'Pending',
      'app_time': time,
      'pet_category': postData.post_type,
      'postowner_contact': registerData.postowner_contact,
    });
  }

  Future updateRegisterStatus(
      String time, RegisterData registerData, BuildContext buildContext) async {
    return await registerCollection.doc(registerid).update({
      'app_status': registerData.app_status,
      'app_time': time,
    });
  }

  Future deleteRegistration() async {
    DocumentReference registerDocument = registerCollection.doc(registerid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(registerDocument));
  }

  Future cancelRegistration(
      RegisterData registerData, BuildContext buildContext) async {
    return await registerCollection.doc(registerid).update({
      'app_status': 'Request Cancel',
    });
  }

  RegisterData _registerDataFromSnapshot(DocumentSnapshot snapshot) {
    return RegisterData(
        register_ID: registerid,
        post_ID: snapshot['post_ID'],
        user_ID: snapshot['user_ID'],
        app_fname: snapshot['app_fname'],
        app_lname: snapshot['app_lname'],
        app_cfname: snapshot['app_cfname'],
        app_clname: snapshot['app_clname'],
        app_email: snapshot['app_email'],
        app_HPno: snapshot['app_HPno'],
        app_gender: snapshot['app_gender'],
        app_gender1: snapshot['app_gender1'],
        app_occupation: snapshot['app_occupation'],
        app_occupation1: snapshot['app_occupation1'],
        app_addStreet1: snapshot['app_addStreet1'],
        app_addStreet2: snapshot['app_addStreet2'],
        app_addPostcode: snapshot['app_addPostcode'],
        app_addCity: snapshot['app_addCity'],
        app_addState: snapshot['app_addState'],
        app_q1: snapshot['app_q1'],
        app_q2: snapshot['app_q2'],
        app_q3: snapshot['app_q3'],
        app_q4: snapshot['app_q4'],
        app_q5: snapshot['app_q5'],
        app_q6: snapshot['app_q6'],
        app_q7: snapshot['app_q7'],
        app_q8: snapshot['app_q8'],
        app_q9: snapshot['app_q9'],
        app_status: snapshot['app_status'],
        app_time: snapshot['time'],
        pet_category: snapshot['pet_category'],
        postowner_contact: snapshot['postowner_contact']);
  }

  List<RegisterData> _registerListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return RegisterData(
            register_ID: doc.id,
            post_ID: doc.get('post_ID'),
            user_ID: doc.get('user_ID'),
            app_fname: doc.get('app_fname'),
            app_lname: doc.get('app_lname'),
            app_cfname: doc.get('app_cfname'),
            app_clname: doc.get('app_clname'),
            app_email: doc.get('app_email'),
            app_HPno: doc.get('app_HPno'),
            app_gender: doc.get('app_gender'),
            app_gender1: doc.get('app_gender1'),
            app_occupation: doc.get('app_occupation'),
            app_occupation1: doc.get('app_occupation1'),
            app_addStreet1: doc.get('app_addStreet1'),
            app_addStreet2: doc.get('app_addStreet2'),
            app_addPostcode: doc.get('app_addPostcode'),
            app_addCity: doc.get('app_addCity'),
            app_addState: doc.get('app_addState'),
            app_q1: doc.get('app_q1'),
            app_q2: doc.get('app_q2'),
            app_q3: doc.get('app_q3'),
            app_q4: doc.get('app_q4'),
            app_q5: doc.get('app_q5'),
            app_q6: doc.get('app_q6'),
            app_q7: doc.get('app_q7'),
            app_q8: doc.get('app_q8'),
            app_q9: doc.get('app_q9'),
            app_status: doc.get('app_status'),
            app_time: doc.get('app_time'),
            pet_category: doc.get('pet_category'),
            postowner_contact: doc.get('postowner_contact'));
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<RegisterData>> get registerDatalist {
    return registerCollection.snapshots().map(_registerListFromSnapshot);
  }

  Stream<List<RegisterData>> get registerdata {
    return registerCollection
        .where('post_ID', isEqualTo: postid)
        .snapshots()
        .map(_registerListFromSnapshot);
  }

//collection reference
  final CollectionReference completedCollection =
      FirebaseFirestore.instance.collection('adopted');

  Future createCompleteAdoption(CompleteAdoption completeAdoption) async {
    DocumentReference completedDocument = completedCollection.doc();
    return await completedDocument.set({
      'register_id': completeAdoption.register_id,
      'pet_category': completeAdoption.pet_category,
    }).then((value) async {
      await deleteRegistration();
    });
  }
}
