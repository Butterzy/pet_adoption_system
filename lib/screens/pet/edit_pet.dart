
// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/services/pet_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

class EditPet extends StatefulWidget {
  PetData petData;
  EditPet({Key? key, required this.petData}) : super(key: key);

  @override
  State<EditPet> createState() => _EditPetState();
}

class _EditPetState extends State<EditPet> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstLoad = true;
  String error = '';
  String noImageSelect = '';

  //controller
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  // TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      nameController.text = widget.petData.pet_name??"";
      categoryController.text = widget.petData.pet_category??"";
      isFirstLoad = false;
    }
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Edit Pet'),
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
                        buildForm(nameController, 'Pet Name', petNameValidator,
                            Icons.groups_rounded),
                        const SizedBox(height: 20.0),
                        buildDropDownButton(categoryController, 'Pet Category',
                            Icons.title_sharp, petCategory),
                        const SizedBox(height: 20.0),
                        Text(error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0)),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);

                              PetData petData = PetData(
                                  pet_name: nameController.text,
                                  pet_category: categoryController.text);

                              dynamic result = PetDatabaseService(
                                      petid: widget.petData.pet_ID)
                                  .updatePetData(petData, context)
                                  .whenComplete(() {
                                showSuccessSnackBar(
                                    'Pet Updated Successfully !', context);
                                Navigator.of(context).pop();
                              }).catchError((e) => showFailedSnackBar(
                                      e.toString(), context));
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not update pet, please try again';
                                  isLoading = false;
                                });
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
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
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
      value: controller.text,
      validator: (value) => value == null ? "Please select a category" : null,
    );
  }
}
