import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_adoption_system/models/user.dart';

class UserDatabaseService {
  final String? uid; //uid = user id
  final String? chatid;
  UserDatabaseService({this.uid, this.chatid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUserData(String firstname, String lastname, String email) async {
    return await userCollection.doc(uid).set({
      'user_name': firstname,
      'user_lastName': lastname,
      'user_email': email,
      'user_HPno': '',
      'user_gender': '',
      'user_addStreet1': '',
      'user_addStreet2': '',
      'user_addPostcode': '',
      'user_addCity': '',
      'user_addState': '',
      'user_photo': '',
      'user_role': 'surrender',
    });
  }

  Future updateUserData(UserData userData) async {
    return await userCollection.doc(uid).update({
      'user_name': userData.user_name,
      'user_lastName': userData.user_lastName,
      'user_HPno': userData.user_HPno,
      'user_gender': userData.user_gender,
      'user_addStreet1': userData.user_addStreet1,
      'user_addStreet2': userData.user_addStreet2,
      'user_addPostcode': userData.user_addPostcode,
      'user_addCity': userData.user_addCity,
      'user_addState': userData.user_addState
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        user_ID: uid,
        user_name: snapshot['user_name'],
        user_lastName: snapshot['user_lastName'],
        user_email: snapshot['user_email'],
        user_photo: snapshot['user_photo'],
        user_HPno: snapshot['user_HPno'],
        user_gender: snapshot['user_gender'],
        user_addStreet1: snapshot['user_addStreet1'],
        user_addStreet2: snapshot['user_addStreet2'],
        user_addPostcode: snapshot['user_addPostcode'],
        user_addCity: snapshot['user_addCity'],
        user_addState: snapshot['user_addState'],
        user_role: snapshot['user_role']);
  }

  // userlist from snapshot
  List<UserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return UserData(
          user_ID: doc.id,
          user_name: doc.get('user_name'),
          user_lastName: doc.get('user_lastName'),
          user_email: doc.get('user_email'),
          user_photo: doc.get('user_photo'),
          user_HPno: doc.get('user_HPno'),
          user_gender: doc.get('user_gender'),
          user_addStreet1: doc.get('user_addStreet1'),
          user_addStreet2: doc.get('user_addStreet2'),
          user_addPostcode: doc.get('user_addPostcode'),
          user_addCity: doc.get('user_addCity'),
          user_addState: doc.get('user_addState'),
          user_role: doc.get('user_role'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get user list stream
  Stream<List<UserData>> get userDataList {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Future uploadImage(File? image, BuildContext context) async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user')
        .child('${uid!}/images')
        .child("images_$postID");

    await ref.putFile(image!);
    String profilePicture = await ref.getDownloadURL();

    //upload url to cloudfirestore
    await firebaseFirestore
        .collection('users')
        .doc(uid)
        .update({'user_photo': profilePicture});
  }

  Future<int> getTotalDocuments() async {
    QuerySnapshot snapshot = await userCollection.get();
    int count = snapshot.size;
    return count;
  }

Future deleteAccount() async {
    DocumentReference userDocument = userCollection.doc(uid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(userDocument));
  }
  /*  //message.......................................................

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');

  Future sendMessage(MessageData messageData,String messageTime,BuildContext buildContext,
      List<function>? functionList) async {
    return await messageCollection.doc().set({
      'sender_ID': uid,
      'messageTime': messageTime,
      'message_content': messageData.message_content,
      //'receiver_ID' : receiverID,
    });
  }

  MessageData _messageDataFromSnapshot(DocumentSnapshot snapshot) {
    return MessageData(
      chat_ID: chatid,
      sender_ID: snapshot['sender_ID'],
      messageTime: snapshot['messageTime'],
      message_content: snapshot['message_content']
    );
  }


  List<MessageData> _messageListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return MessageData(
          chat_ID: doc.id,
          sender_ID: doc.get('sender_ID'),
          message_content: doc.get('message_content'),
          messageTime: doc.get('messageTime'),
        //  receiver_ID: doc.get('receiver_ID'),
          
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<List<MessageData>> get messageDatalist {
    return messageCollection.snapshots().map(_messageListFromSnapshot);
  }

  Stream<MessageData> get messagedata {
    return messageCollection
        .doc(chatid)
        .snapshots()
        .map(_messageDataFromSnapshot);
  }

    Future deleteMessage() async {
    DocumentReference messageDocument = messageCollection.doc(chatid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(messageDocument));
  } */
}
