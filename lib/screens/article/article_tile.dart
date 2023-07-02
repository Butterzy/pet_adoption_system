// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/article.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/screens/article/edit_article.dart';
import 'package:pet_adoption_system/services/article_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:provider/provider.dart';

class ArticleTile extends StatelessWidget {
  ArticleData articleData;
  final bool isMyArticle;

  ArticleTile({Key? key, required this.articleData, required this.isMyArticle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser>(context);
    final functionList = Provider.of<List<function>>(context);

    return SingleChildScrollView(
      child: GestureDetector(
        child: InkWell(
          splashColor: Colors.indigo[100],
          child: Stack(children: [
            Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                          boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                        ),
                       
                      ),
                    ),
             Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 430,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0)), // Image border
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(48), // Image radius
                                child: Image.network(
                        articleData.article_image!,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width*0.9,
                        height: 500,
                      ),
                              ),
                            )
                        ),
                      ),
                    ),
                     Positioned(
                        bottom:20.0,
                        left: 40,
                        child: SizedBox(
                          height: 80,
                          width: MediaQuery.of(context).size.width-160,
                          child: 
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  '${articleData.article_title}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.indigo),
                                    
                                ),
                              ),
                              
                              
                            
                        )),
          ],),
          onTap: () {
            if (isMyArticle) {
              _showEditPanel(articleData, context, functionList);
            } else {
              _showInfoPanel(articleData, user, context);
            }
          },
        ),
      ),
    );
  }

  void _showEditPanel(ArticleData articleData, BuildContext context,
      List<function> functionList) {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (context) {
          return Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                    child: Container(
                        height: 5.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.indigo))),
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: const Text(
                      'Edit ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Colors.indigo),
                    ),
                  ),
                  InkWell(
                    child: _buildListItem('Edit Article', context),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditArticle(
                                    articleData: articleData,
                                  )));
                    },
                  ),
                  const SizedBox(width: 10.0),
                  InkWell(
                    child: _buildDeleteItem(context),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Are you Sure?'),
                          elevation: 3.0,
                          actions: [
                            TextButton(
                                onPressed: () {
                                  ArticleDatabaseService(
                                          articleid: articleData.article_ID)
                                      .deleteArticle()
                                      .whenComplete(() {
                                    showFailedSnackBar(
                                        'Article Deleted', context);
                                    Navigator.of(context).pop();
                                  }).catchError((e) => showFailedSnackBar(
                                          e.toString(), context));
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
                ],
              ),
            ],
          );
        });
  }

  Container _buildListItem(String text, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Container _buildDeleteItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }

  void _showInfoPanel(
      ArticleData articleData, thisUser user, BuildContext context) {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        builder: (context) {
          return Scaffold(
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                      child: Container(
                          height: 5.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0)))),
                    ),

                    //---------------------------------PHOTO------------------------------------
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15.0),
                      child: Image.network(
                        articleData.article_image!,
                        fit: BoxFit.fill,
                      ),
                    ),
                    //--------------------------------PET INFO------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Text(
                          articleData.article_title!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.indigo),
                        ),
                        children: [
                          SingleChildScrollView(
                            child: Text('${articleData.article_content}'),
                          )
                        ],
                      ),
                    )
                  ],
                ),

                //---------------------------END OF NARVAR----------------------
              ),
            ),
          );
        });
  }
}
/* Card(
          elevation: 2.0,
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text('${articleData?.article_title}'),
            children: [
              Row(
                children: [
                  Text('${articleData?.article_content}'),
                ],
              )
            ],
            // trailing: IconButton(
            // tooltip: 'Cancel Registration',
            // onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => PositionForm(
            //               club_ID: club_ID,
            //               positionData: positionData,
            //               accessData: accessData,
            //               functionList: functionList,
            //             )));
            // },
            // iconSize: 25,
            // icon: const Icon(Icons.delete_forever)),
          ),
        ), */