
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/pet.dart';
import 'package:pet_adoption_system/models/user.dart';
import 'package:pet_adoption_system/services/access_right_database.dart';
import 'package:pet_adoption_system/services/pet_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';
import 'package:provider/provider.dart';

class RegisterPet extends StatefulWidget {
  RegisterPet({Key? key}) : super(key: key);

  @override
  State<RegisterPet> createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {
   final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // bool _checked = false;
  String noImageSelect = '';
  final TextEditingController nameController = TextEditingController();
  // final TextEditingController descController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String error = '';

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
              appBar: buildAppBar(context, 'Pet'),
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
                          buildForm(nameController, 'Pet Name',
                              postNameValidator, Icons.groups_rounded),
                          const SizedBox(height: 20.0),
                          categoryDropDownButton('Pet Category', Icons.pets,
                            petCategory, categoryController),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                PetData petData = PetData(
                                  pet_name: nameController.text,
                                  pet_category: categoryController.text,
                                );
                                dynamic result =
                                    await PetDatabaseService(uid: user!.uid)
                                        .createPetData(
                                            petData, context, functionList)
                                        .whenComplete(() {
                                  Navigator.of(context).pop();
                                  showSuccessSnackBar(
                                      'Pet Registered !', context);
                                }).catchError((e) => print(e));

                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Could not register a pet, please try again';
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
                            ,
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.8, 45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            child: const Text(
                              'Register',
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

   DropdownButtonFormField2<String> categoryDropDownButton(String labelText,
      IconData icon, List dropDownItem, TextEditingController controller) {
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
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

}
