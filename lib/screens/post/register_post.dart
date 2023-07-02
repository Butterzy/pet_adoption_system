import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/screens/post/post_image.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/services/user_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

import 'package:provider/provider.dart';

class CreatePosts extends StatefulWidget {
  String pet_ID;
  CreatePosts({Key? key, required this.pet_ID}) : super(key: key);

  @override
  State<CreatePosts> createState() => _CreatePostsState();
}

class _CreatePostsState extends State<CreatePosts> {
  get userData => UserData();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String error = '';
  String noImageSelect = '';
  String formattedStartDate = '';
  String formattedEndDate = '';
  var phoneFormatter = MaskTextInputFormatter(
      mask: '6##########', filter: {"#": RegExp(r'[0-9]')});

  DateTime postStart = DateTime.now();
  DateTime postEnd = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  TextEditingController titleController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateRangeController = TextEditingController();
/*   TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController(); */
  TextEditingController contactController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController vaccinatedController = TextEditingController();
  TextEditingController dewormedController = TextEditingController();
  TextEditingController healthController = TextEditingController();
  TextEditingController spayedController = TextEditingController();
  TextEditingController myroleController = TextEditingController();

  TextEditingController numberAdoptionController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context, 'Create New Post'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: StreamBuilder<UserData>(
              stream: UserDatabaseService(uid: user!.uid).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data!;
                  return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (_imageFile == null) {
                                final imageFile = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostImage()),
                                );
                                setState(() {
                                  _imageFile = imageFile;
                                });
                              } else {
                                final imageFile = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PostImage(selectImage: _imageFile)),
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
                          const SizedBox(height: 20),
                          buildNameForm(titleController, 'Name',
                              postNameValidator, Icons.pets),
                          const SizedBox(height: 20.0),
                          buildForm(captionController, 'Description',
                              petDescValidator, MdiIcons.imageText),
                          const SizedBox(height: 20.0),
                          buildLocationForm(locationController, 'Location',
                              locationValidator, Icons.location_on_outlined),
                          const SizedBox(height: 20.0),
                          buildForm(
                            ageController,
                            'Pet Age',
                            petAgeValidator,
                            Icons.pets,
                          ),
                          const SizedBox(height: 20.0),
                          buildForm(colorController, 'Pet Color',
                              petColorValidator, MdiIcons.paw),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(typeController, 'Pet Type',
                              Icons.pets, petCategory),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(genderController, 'Pet Gender',
                              MdiIcons.genderNonBinary, genderGroup),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(vaccinatedController,
                              'Vaccinated', MdiIcons.needle, optionList),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(dewormedController, 'Dewormed',
                              MdiIcons.medication, optionList),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(spayedController, 'Spayed',
                              MdiIcons.pawOff, optionList),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(healthController, 'Health',
                              MdiIcons.armFlex, healthdGroup),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(myroleController, 'My Role',
                              MdiIcons.accountTie, roleGroup),
                          const SizedBox(height: 20.0),
                          buildphoneForm(contactController, phoneNoValidator),
                          const SizedBox(height: 20.0),
                          buildDateForm(dateRangeController, 'Date Range',
                              Icons.date_range_outlined),
                          const SizedBox(height: 20.0),
                          buildNumberForm(numberAdoptionController,
                              'Number of Adoption', Icons.numbers),
                          const SizedBox(height: 20.0),
                          Text(error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0)),
                          ElevatedButton(
                            onPressed: () async {
                              if (_imageFile == null) {
                                setState(() {
                                  noImageSelect = 'Post Poster is required !';
                                });
                              } else {
                                setState(() => noImageSelect = '');
                                if (_formKey.currentState!.validate()) {
                                  String date = DateTime.now().toString();
                                  setState(() => isLoading = true);
                                  PostData postData = PostData(
                                    post_name: titleController.text,
                                    post_desc: captionController.text,
                                    post_location: locationController.text,
                                    post_start: postStart.toString(),
                                    post_end: postEnd.toString(),
                                    post_age: ageController.text,
                                    post_color: colorController.text,
                                    post_type: typeController.text,
                                    post_gender: genderController.text,
                                    post_vaccinated: vaccinatedController.text,
                                    post_dewormed: dewormedController.text,
                                    post_spayed: spayedController.text,
                                    post_health: healthController.text,
                                    myrole: myroleController.text,
                                    post_numAdoption: int.parse(
                                        numberAdoptionController.text),
                                    post_contact: contactController.text,
                                    pet_owner: userData.user_name,
                                  );
                                  dynamic result = await PostDatabaseService(
                                          petid: widget.pet_ID)
                                      .createPosts(
                                          postData, _imageFile, context, date)
                                      .whenComplete(() {
                                    showSuccessSnackBar(
                                        'Post Published !', context);

                                    Navigator.of(context).pop();
                                  }).catchError((e) => showFailedSnackBar(
                                          e.toString(), context));

                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not publish the post, please try again';
                                      isLoading = false;
                                    });
                                  }
                                }
                              }
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
                        ],
                      ));
                } else {
                  return loadingIndicator();
                }
              }),
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

  TextFormField buildNameForm(TextEditingController controller, String hintText,
      String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      controller: controller,
      maxLength: 20, // Set the maximum character limit here
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  TextFormField buildLocationForm(TextEditingController controller,
      String hintText, String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      controller: controller,
      maxLength: 20, // Set the maximum character limit here
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  TextFormField buildDateForm(
      TextEditingController controller, String labelText, IconData icons) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDateRangePicker(
            initialDateRange: DateTimeRange(start: postStart, end: postEnd),
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 5));
        if (pickedDate != null) {
          postStart = pickedDate.start;
          postEnd = pickedDate.end;
          formattedStartDate =
              DateFormat('dd-MMM-yyyy').format(pickedDate.start);
          formattedEndDate = DateFormat('dd-MMM-yyyy').format(pickedDate.end);
          controller.text = '$formattedStartDate - $formattedEndDate';
        }
      },
      onSaved: (value) {
        controller.text = value!;
      },
      validator: (value) => value!.isEmpty
          ? "The available adoption date range is required !"
          : null,
      decoration: textInputDecoration.copyWith(
          labelText: labelText, prefixIcon: Icon(icons)),
    );
  }

  TextFormField buildTimeForm(TextEditingController controller,
      String labelText, IconData icons, bool isStartTime) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: (value) =>
          value!.isEmpty ? "The post time is required !" : null,
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: isStartTime ? startTime : endTime,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          if (isStartTime) {
            startTime = pickedTime;
            postStart = join(postStart, pickedTime);
          } else {
            endTime = pickedTime;
            postEnd = join(postEnd, pickedTime);
          }
          String formattedTime = pickedTime.format(context);
          controller.text = formattedTime;
        }
      },
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: labelText, prefixIcon: Icon(icons)),
    );
  }

  TextFormField buildNumberForm(
      TextEditingController controller, String hintText, IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: controller,
      validator: (value) =>
          value!.isEmpty ? "Please state number of audience" : null,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: Icon(icon)),
    );
  }

  TextFormField buildphoneForm(
      TextEditingController controller, String? validator(value)) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: controller,
      inputFormatters: [phoneFormatter],
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: 'Phone Number',
          prefixIcon: const Icon(Icons.phone_android_outlined)),
    );
  }

  DropdownButtonFormField2<String> buildDropDownButton(
      TextEditingController controller,
      String labelText,
      IconData icon,
      List dropDownItem) {
    return DropdownButtonFormField2(
      hint: Text(labelText),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, size: 24),
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 20, bottom: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: dropDownItem
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (value) {
        controller.text = value!;
      },
      validator: (value) =>
          value == null ? "This field can't leave empty!" : null,
    );
  }
}
