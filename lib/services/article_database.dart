import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/article.dart';

class ArticleDatabaseService {
  final String? uid;
  final String? articleid;
  ArticleDatabaseService({this.uid,this.articleid});

  //collection reference
  final CollectionReference articleCollection =
      FirebaseFirestore.instance.collection('articles');

  Future createArticleData(ArticleData articleData, File? image,
      BuildContext buildContext, List<function>? functionList) async {
    DocumentReference articleDocument = articleCollection.doc();
    return await articleDocument.set({
      'article_title': articleData.article_title,
      'article_content': articleData.article_content,
      'article_registerDate': DateTime.now().toString(),
      'article_image': '',
      'staffID' : uid,
    }).then((value) async {
      await uploadImage(image, buildContext, articleDocument.id);
    });
  }

  Future updateArticleData(
      ArticleData articleData, File? image, BuildContext buildContext) async {
    if (image != null) {
      return await articleCollection.doc(articleid).update({
        'article_title': articleData.article_title,
        'article_content': articleData.article_content,
      }).then((value) async {
        await uploadImage(image, buildContext, articleid!);
      });
    } else {
      return await articleCollection.doc(articleid).update({
        'article_title': articleData.article_title,
        'article_content': articleData.article_content,
      });
    }
  }

  ArticleData _articleDataFromSnapshot(DocumentSnapshot snapshot) {
    return ArticleData(
      article_ID: articleid,
      article_title: snapshot['article_title'],
      article_content: snapshot['article_content'],
      article_registerDate: snapshot['article_registerDate'],
      article_image: snapshot['article_image'],
    );
  }

  // articlelist from snapshot
  List<ArticleData> _articleListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return ArticleData(
          article_ID: doc.id,
          article_title: doc.get('article_title'),
          article_registerDate: doc.get('article_registerDate'),
          article_content: doc.get('article_content'),
          article_image: doc.get('article_image'),
        );
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  //get article list stream
  Stream<List<ArticleData>> get articledatalist {
    return articleCollection
        .where('staffID', isEqualTo: uid)
        .snapshots()
        .map(_articleListFromSnapshot);
  }

  Stream<ArticleData> get articledata {
    return articleCollection
        .doc(articleid)
        .snapshots()
        .map(_articleDataFromSnapshot);
  }

  Future uploadImage(File? image, BuildContext context, String id) async {
    if (id != null) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('articles')
          .child('${id}/logo')
          .child("logo_$postID");

      await ref.putFile(image!);
      String logo = await ref.getDownloadURL();

      //upload url to cloudfirestore
      await firebaseFirestore
          .collection('articles')
          .doc(id)
          .update({'article_image': logo});
    } else {
      return null;
    }
  }

  Future deleteArticle() async {
    DocumentReference articleDocument = articleCollection.doc(articleid);
    return await FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.delete(articleDocument));
  }
}
