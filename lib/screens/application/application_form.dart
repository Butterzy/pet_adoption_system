import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/services/post_database.dart';

import 'package:provider/provider.dart';
import 'package:pet_adoption_system/models/access_right.dart';
import 'package:pet_adoption_system/models/user.dart';

import 'package:pet_adoption_system/services/access_right_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

class ApplicationForm extends StatefulWidget {
  final PostData postData;
  const ApplicationForm({
    Key? key,
    required this.postData,
  }) : super(key: key);

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  var phoneFormatter = MaskTextInputFormatter(
      mask: '6##########', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

// adopter controller
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController cfnameController = TextEditingController();
  final TextEditingController clnameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController gender1Controller = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController occupation1Controller = TextEditingController();

//contact controller
  TextEditingController HPnoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  //address controller
  TextEditingController street1Controller = TextEditingController();
  TextEditingController street2Controller = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  //question and considerations controller
  TextEditingController q1Controller = TextEditingController();
  TextEditingController q2Controller = TextEditingController();
  TextEditingController q3Controller = TextEditingController();
  TextEditingController q4Controller = TextEditingController();
  TextEditingController q5Controller = TextEditingController();
  TextEditingController q6Controller = TextEditingController();
  TextEditingController q7Controller = TextEditingController();
  TextEditingController q8Controller = TextEditingController();
  TextEditingController q9Controller = TextEditingController();
  TextEditingController q10Controller = TextEditingController();
  TextEditingController ownerHPnoController = TextEditingController();

  String error = '';

  bool isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    double horizontalSpace = MediaQuery.of(context).size.width * 0.05;
    if (isFirstLoad) {
      ownerHPnoController.text = widget.postData.post_contact!;
      isFirstLoad = false;
    }

    final user = Provider.of<thisUser?>(context);
    return StreamBuilder<List<function>>(
        stream: AccessRightDatabaseService().functionlist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  '${widget.postData.post_name}\'s Application Form',
                  style: const TextStyle(color: Colors.white), //<-- SEE HERE
                ),
              ),

              //---------------------------APPLICATION FORM STARTS HERE-----------------
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
//-------------------------Post--------------------------
                          buildDivider('${widget.postData.post_name}'),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 500,
                            child: CachedNetworkImage(
                              imageUrl: widget.postData.post_image!,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 30),
                            ),
                          ),

                          const SizedBox(height: 20.0),
                          //-------------------------Adopter--------------------------
                          buildDivider('Adopter'),
                          const SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: buildForm(fnameController, 'First Name',
                                    firstNameValidator, Icons.person),
                              ),
                              SizedBox(width: horizontalSpace),
                              Flexible(
                                  child: buildForm(lnameController, 'Last Name',
                                      lastNameValidator, Icons.person))
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(
                              'Gender',
                              MdiIcons.genderMaleFemale,
                              genderGroup,
                              genderController),

                          const SizedBox(height: 20.0),
                          buildForm(occupationController, 'Occupation',
                              occupationValidator, Icons.work),

//-------------------------CO-Adopter--------------------------
                          const SizedBox(height: 20.0),
                          buildDivider('Co-Adopter'),
                          const SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: buildForm(cfnameController, 'First Name',
                                    firstNameValidator, Icons.person),
                              ),
                              SizedBox(width: horizontalSpace),
                              Flexible(
                                  child: buildForm(
                                      clnameController,
                                      'Last Name',
                                      lastNameValidator,
                                      Icons.person))
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          buildDropDownButton(
                              'Gender',
                              MdiIcons.genderMaleFemale,
                              genderGroup,
                              gender1Controller),
                          /* const SizedBox(height: 20.0),
                          DropDownButton('Gender', Icons.games_rounded,
                              genderGroup, genderController), */

                          const SizedBox(height: 20.0),
                          buildForm(occupation1Controller, 'Occupation',
                              occupationValidator, Icons.work),

//-------------------------Address--------------------------
                          const SizedBox(height: 20.0),
                          buildDivider('Address'),

                          const SizedBox(height: 20.0),
                          buildForm(street1Controller, 'Street 1',
                              streetValidator, Icons.home_outlined),
                          const SizedBox(height: 20.0),
                          buildForm(street2Controller, 'Street 2',
                              streetValidator, Icons.home_outlined),
                          const SizedBox(height: 20.0),
                          buildForm(cityController, 'City', cityValidator,
                              Icons.location_city_outlined),
                          const SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              Flexible(
                                  child: buildNumberForm(
                                      postcodeController,
                                      'Postcode',
                                      postcodeValidator,
                                      Icons.location_on_outlined)),
                              SizedBox(width: horizontalSpace),
                              Flexible(
                                  child: buildDropDownButton(
                                      'State',
                                      Icons.flag_outlined,
                                      stateGroup,
                                      stateController))
                            ],
                          ),

                          const SizedBox(height: 20.0),
                          buildDivider('Contact'),

                          const SizedBox(height: 20.0),
                          buildphoneForm(HPnoController, phoneNoValidator),

                          const SizedBox(height: 20.0),
                          buildEmailForm(
                              emailController, 'Email', emailValidator),

                          const SizedBox(height: 20.0),
                          buildDivider('Questions & Considerations'),

                          const SizedBox(height: 20.0),
                          buildDropDownButton('Do you currently have any pets?',
                              Icons.person, optionList, q1Controller),
/*                           buildForm(
                              q1Controller,
                              'Do you currently have any pets?',
                              questionValidator,
                              Icons.person), */

                          /* const SizedBox(height: 20.0),
                          DropDownButton('Do you currently have any pets?',
                              Icons.pets, optionList, q1Controller), */

                          const SizedBox(height: 20.0),
                          buildDropDownButton(
                              'Is your place of residence suited for a pet?',
                              Icons.person,
                              optionList,
                              q2Controller),

                          /* buildForm(
                              q2Controller,
                              'Is your place of residence suited for a pet?',
                              questionValidator,
                              Icons.person), */

                          /* const SizedBox(height: 20.0),
                          DropDownButton(
                              'Is your place of residence suited for a pet?',
                              Icons.pets,
                              optionList,
                              q2Controller), */

                          const SizedBox(height: 20.0),
                          buildDropDownButton(
                              'Does your social/work life allow for a pet?',
                              Icons.person,
                              optionList,
                              q3Controller),

                          /* buildForm(
                              q3Controller,
                              'Does your social/work life allow for a pet?',
                              questionValidator,
                              Icons.person), */

                          /* const SizedBox(height: 20.0),
                          DropDownButton(
                              'Does your social/work life allow for a pet?',
                              Icons.pets,
                              optionList,
                              q3Controller), */

                          const SizedBox(height: 20.0),
                          buildDropDownButton(
                              'How many adults are in your household?',
                              Icons.location_city_outlined,
                              peopleGroup,
                              q4Controller),
                          /* buildForm(
                              q4Controller,
                              'How many adults are in your household?',
                              questionValidator,
                              Icons.location_city_outlined), */

                          const SizedBox(height: 20.0),
                          buildDropDownButton(
                              'How many children are in your household?',
                              Icons.person,
                              peopleGroup,
                              q5Controller),

                          /* buildForm(
                              q5Controller,
                              'How many children are in your household?',
                              questionValidator,
                              Icons.location_city_outlined), */

                          const SizedBox(height: 20.0),

                          buildForm(
                              q6Controller,
                              'Who will be the pet\'s primary caregiver?',
                              questionValidator,
                              Icons.pets),

                          const SizedBox(height: 20.0),
                          buildDropDownButton(
                              'Are all members of your household in agreement with this adoption?',
                              Icons.person,
                              optionList,
                              q7Controller),

/*                           buildForm(
                              q7Controller,
                              'Are all members of your household in agreement with this adoption?',
                              questionValidator,
                              Icons.person), */

                          /* const SizedBox(height: 20.0),
                          DropDownButton(
                            'Are all members of your household in agreement with this adoption?',
                            Icons.pets,
                            optionList,
                            q7Controller,
                          ), */
                          const SizedBox(height: 20.0),
                          buildDropDownButton(
                              'Do you know about any allergies?',
                              Icons.person,
                              optionList,
                              q8Controller),

/*                           buildForm(
                              q8Controller,
                              'Do you know about any allergies?',
                              questionValidator,
                              Icons.person), */

                          /* const SizedBox(height: 20.0),
                          DropDownButton('Do you know about any allergies?',
                              Icons.pets, optionList, q8Controller), */

                          const SizedBox(height: 20.0),

                          buildForm(
                              q9Controller,
                              'Why do you want to own a pet?',
                              questionValidator,
                              Icons.pets),

                          const SizedBox(height: 20.0),
/*                           CheckboxListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            dense: true,
                            title: const Text(
                              'Please make sure the pet information are all true.',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: _checked,
                            onChanged: (bool? value) {
                              setState(() {
                                _checked = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ), */
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String time = DateTime.now().toString();
                                setState(() => isLoading = true);
                                RegisterData registerData = RegisterData(
                                  app_fname: fnameController.text,
                                  app_lname: lnameController.text,
                                  app_cfname: cfnameController.text,
                                  app_clname: clnameController.text,
                                  app_email: emailController.text,
                                  app_HPno: HPnoController.text,
                                  app_gender: genderController.text,
                                  app_gender1: gender1Controller.text,
                                  app_occupation: occupationController.text,
                                  app_occupation1: occupation1Controller.text,
                                  app_addStreet1: street1Controller.text,
                                  app_addStreet2: street2Controller.text,
                                  app_addPostcode: postcodeController.text,
                                  app_addCity: cityController.text,
                                  app_addState: stateController.text,
                                  app_q1: q1Controller.text,
                                  app_q2: q2Controller.text,
                                  app_q3: q3Controller.text,
                                  app_q4: q4Controller.text,
                                  app_q5: q5Controller.text,
                                  app_q6: q6Controller.text,
                                  app_q7: q7Controller.text,
                                  app_q8: q8Controller.text,
                                  app_q9: q9Controller.text,
                                  postowner_contact: ownerHPnoController.text,
                                );
                                dynamic result = PostDatabaseService(
                                        postid: widget.postData.post_ID,
                                        uid: user!.uid)
                                    .registerPost(
                                        time, registerData, widget.postData)
                                    .whenComplete(() {
                                  Navigator.of(context).pop();
                                  showSuccessSnackBar('Applied !', context);
                                }).catchError((e) => print(e));

                                if (result == null) {
                                  setState(() {
                                    error = 'Could not apply  please try again';
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.8, 45),
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(height: 12.0),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.indigo, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //---------------------REGISTER FORM ENDS HERE-------------------------
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

  Row buildDivider(String label) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: const Divider(color: Colors.black38, height: 36)),
      ),
      Text(label),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: const Divider(color: Colors.black38, height: 36)),
      ),
    ]);
  }

  TextFormField buildNumberForm(TextEditingController controller,
      String hintText, String? validator(value), IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.number,
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

  DropdownButtonFormField2<String> buildDropDownButton(String labelText,
      IconData icon, List dropDownItem, TextEditingController controller) {
    return DropdownButtonFormField2(
      hint: Text(labelText),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, size: 24),
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 20, right: 10),
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
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      onChanged: (value) {
        controller.text = value!;
      },
    );
  }

  TextFormField buildEmailForm(TextEditingController controller,
      String hintText, String? validator(value)) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      decoration: textInputDecoration.copyWith(
          labelText: hintText, prefixIcon: const Icon(Icons.mail_sharp)),
    );
  }

  String? dobValidator(value) {
    return null;
  }
}
