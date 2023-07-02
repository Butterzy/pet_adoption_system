import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pet_adoption_system/models/article.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/services/article_database.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

class EditArticle extends StatefulWidget {
  ArticleData articleData;

  EditArticle({Key? key, required this.articleData}) : super(key: key);

  @override
  State<EditArticle> createState() => _EditArticleState();
}

class _EditArticleState extends State<EditArticle> {
  final _formKey = GlobalKey<FormState>();
    File? _imageFile;
  bool isLoading = false;
  bool isFirstLoad = true;
  String error = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      titleController.text = widget.articleData.article_title!;
      contentController.text = widget.articleData.article_content!;
      isFirstLoad = false;
    }

    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Edit Article'),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildForm(titleController, 'Article Name',
                              titleValidator, Icons.article),
                          const SizedBox(height: 20.0),

                          buildLongForm(contentController, 'Article Content',
                              contentValidator, Icons.drafts),
                          const SizedBox(height: 20.0),
                            Text(error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0)),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String time = DateTime.now().toString();
                                  setState(() => isLoading = true);
                                  ArticleData articleData = ArticleData(
                                    article_title: titleController.text,
                                    article_content: contentController.text,
                                  );
                                  dynamic result = ArticleDatabaseService(
                                          articleid:widget.articleData.article_ID)
                                              
                                      .updateArticleData(
                                          articleData, _imageFile ,context)
                                      .whenComplete(() {
                                    showSuccessSnackBar(
                                        'Article Updated !', context);
                                    Navigator.of(context).pop();
                                  }).catchError((e) => showFailedSnackBar(
                                          e.toString(), context));
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not update the article, please try again';
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.8,
                                    45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ))),
              ),
            ),
          );
  }

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  String? postNameValidator(value) {
    if (value.isEmpty) {
      return 'The post name is required !';
    } else if (value.contains(' ')) {
      return null;
    } else {
      return 'Please input valid post name';
    }
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
