import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/article.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/screens/article/article_image.dart';
import 'package:pet_adoption_system/services/access_right_database.dart';
import 'package:pet_adoption_system/services/article_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

import 'package:provider/provider.dart';

class RegisterArticle extends StatefulWidget {
  RegisterArticle({Key? key}) : super(key: key);

  @override
  State<RegisterArticle> createState() => _RegisterArticleState();
}

class _RegisterArticleState extends State<RegisterArticle> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // bool _checked = false;
  String noImageSelect = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  // final TextEditingController categoryController = TextEditingController();
  String error = '';
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return StreamBuilder<List<function>>(
        stream: AccessRightDatabaseService().functionlist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<function>? functionList = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: buildAppBar(context, 'Article'),
              body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              if (_imageFile == null) {
                                final imageFile = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => articleImage()),
                                );
                                setState(() {
                                  _imageFile = imageFile;
                                });
                              } else {
                                final imageFile = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => articleImage(
                                          selectImage: _imageFile)),
                                );
                                setState(() {
                                  _imageFile = imageFile;
                                });
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.indigo)),
                                height: 200,
                                child: _imageFile == null
                                    ? const Center(
                                        child: Text('No Image Selected'))
                                    : Image.file(_imageFile!,
                                        fit: BoxFit.fill)),
                          ),
                          Text(noImageSelect,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0)),
                          const SizedBox(height: 20.0),
                          buildForm(titleController, 'Article Name',
                              titleValidator, Icons.article),
                          const SizedBox(height: 20.0),
                          buildLongForm(contentController, 'Article Content',
                              contentValidator, Icons.drafts),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_imageFile == null) {
                                setState(() {
                                  noImageSelect = 'Article Image is required !';
                                });
                              } else {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  ArticleData articleData = ArticleData(
                                      article_title: titleController.text,
                                      article_content: contentController.text);
                                  dynamic result = await ArticleDatabaseService(
                                          uid: user!.uid)
                                      .createArticleData(articleData,
                                          _imageFile, context, functionList)
                                      .whenComplete(() {
                                    Navigator.of(context).pop();
                                    showSuccessSnackBar(
                                        'Article Registered !', context);
                                  }).catchError((e) => print(e));

                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not register a article, please try again';
                                      isLoading = false;
                                    });
                                  }
                                }
                              } /* else {
                                    showFailedSnackBar(
                                        'Make sure you checked the acknowledgement',
                                        context);
                                  } */
                              //   }
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.8, 45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            child: const Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return loadingIndicator();
          }
        });
  }

  TextFormField buildForm(TextEditingController controller, String hintText,
      String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      controller: controller,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
        labelText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }

  TextFormField buildLongForm(TextEditingController controller, String hintText,
      String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 1,
      maxLines: null,
      controller: controller,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
        labelText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }

}
