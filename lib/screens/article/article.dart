import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pet_adoption_system/mainpage.dart';
import 'package:pet_adoption_system/mainpage.dart';
import 'package:pet_adoption_system/models/article.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/screens/article/add_article.dart';
import 'package:pet_adoption_system/screens/article/article_list.dart';
import 'package:pet_adoption_system/screens/pet/pet_list.dart';
import 'package:pet_adoption_system/screens/pet/add_pet.dart';
import 'package:pet_adoption_system/services/article_database.dart';
import 'package:provider/provider.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/user.dart';

import 'package:pet_adoption_system/services/access_right_database.dart';
import 'package:pet_adoption_system/services/pet_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

import '../../widgets/widgets.dart';

enum ArticleSwitch { allarticle, myarticle }

class ManageArticleScreen extends StatefulWidget {
  ManageArticleScreen({Key? key}) : super(key: key);

  @override
  State<ManageArticleScreen> createState() => _ManageArticleScreenState();
}

class _ManageArticleScreenState extends State<ManageArticleScreen> {

  ArticleSwitch selectedArticleSwitch = ArticleSwitch.allarticle;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return Scaffold(
      
      body: Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
      Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  opacity: 0.1,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          Positioned(
              child: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.indigo,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.indigo,
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
          )),
          Positioned(
              bottom: 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height / 14,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(150),
                      topRight: Radius.circular(150)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.indigo,
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors
                                        .indigo, //background color of button
                                    //border width and color
                                    elevation: 3, //elevation of button
                                    shape: RoundedRectangleBorder(
                                      //to set border radius to button
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(150),
                                          topRight: Radius.circular(150)),
                                    ),
                                    padding: EdgeInsets.all(
                                        20) //content padding inside button
                                    ),
                                onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterArticle()),
                                );
                              },
                                child: Text("Add Article")),
              )),
          Positioned(
            top: 60.0,
            left: 30,
            child: Container(
              width: MediaQuery.of(context).size.width - 100,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      "Your Articles",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          Positioned(
            top: 120.0,
            bottom: 130.0,
            left: 30,
            right: 30,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:  MultiProvider(
      providers: [
        StreamProvider<List<ArticleData>>.value(
            value: ArticleDatabaseService().articledatalist, initialData: []),
            StreamProvider<List<function>>.value(
            initialData: [],
            value: AccessRightDatabaseService().functionlist),
        StreamProvider<List<accessRight>>.value(
            initialData: [],
            value: AccessRightDatabaseService().accessdatalist),
        
      ],
      child: SingleChildScrollView(child: 
      Container(child: ArticleList(isMyArticle: true,)),),
/*         child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ContainerSelection(
                    context, ArticleSwitch.allarticle, 'All Article'),
                ContainerSelection(
                    context, ArticleSwitch.myarticle, 'My Article'),
              ],
            ),
            buildGradientLine(
              selectedArticleSwitch == ArticleSwitch.allarticle
                  ? Colors.blue
                  : Colors.white,
              selectedArticleSwitch == ArticleSwitch.myarticle
                  ? Colors.blue
                  : Colors.white,
            ),
            buildGradientLine(Colors.blue, Colors.indigo),
            Container(child: ArticleList(isMyArticle: true,)),
            const SizedBox(height: 10.0)
          ],
        ),
      ), */
      ), 
            ),
          ),
          //indigoContainer
        ],
      )
      ],
    ),
    );
  }
/* 
   Container ContainerSelection(
      BuildContext context, ArticleSwitch ArticleSwitch, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.vertical(top: Radius.elliptical(75, 150)),
        color: selectedArticleSwitch == ArticleSwitch ? Colors.indigo : Colors.white,
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextButton(
          onPressed: () {
            setState(() => selectedArticleSwitch = ArticleSwitch);
          },
          child: Text(
            title,
            style: TextStyle(
                color: selectedArticleSwitch == ArticleSwitch
                    ? Colors.white
                    : Colors.indigo),
          )),
    );
  }

  Widget getCustomContainer() {
    switch (selectedArticleSwitch) {
      case ArticleSwitch.allarticle:
        return ArticleList(isMyArticle: false,);
      case ArticleSwitch.myarticle:
        return ArticleList(isMyArticle: true,);
    }
  } */
 
}

