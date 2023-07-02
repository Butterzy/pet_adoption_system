import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/article.dart';
import 'package:pet_adoption_system/screens/article/article_tile.dart';
import 'package:provider/provider.dart';

class ArticleList extends StatefulWidget {
  final bool isMyArticle;
  ArticleList({Key? key, required this.isMyArticle}) : super(key: key);

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    final articles = Provider.of<List<ArticleData>>(context);

    if (articles.isNotEmpty) {
      List<ArticleData> myarticlelist = [];

      for (var i = 0; i < articles.length; i++) {
        myarticlelist.add(articles[i]);
        myarticlelist.sort((a, b) {
          return b.article_title!.compareTo(a.article_title!);
        });
      }
      if (widget.isMyArticle) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: myarticlelist.length,
          itemBuilder: (context, index) {
            return ArticleTile(
              articleData: myarticlelist[index],
              isMyArticle: widget.isMyArticle,
            );
          },
        );
      } else {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return ArticleTile(
              articleData: articles[index],
              isMyArticle: widget.isMyArticle,
            );
          },
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Center(
          child: const Text('No Article',
              style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),),
        ),
      );
    }
  }
}
