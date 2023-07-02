import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_system/models/post.dart';
import 'package:pet_adoption_system/services/post_database.dart';
import 'package:pet_adoption_system/shared/constants.dart';

class EditStatus extends StatefulWidget {
  RegisterData registerData;
  EditStatus({Key? key, required this.registerData}) : super(key: key);

  @override
  State<EditStatus> createState() => _EditStatusState();
}

class _EditStatusState extends State<EditStatus> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstLoad = true;
  String error = '';
  TextEditingController statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      statusController.text = widget.registerData.app_status!;
      isFirstLoad = false;
    }

    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Edit Status'),
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
                            buildDropDownButton(statusController, 'Status',
                                Icons.title_sharp, statusGroup),
                            const SizedBox(height: 20.0),
                            Text(error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14.0)),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String time = DateTime.now().toString();
                                  setState(() => isLoading = true);

                                  RegisterData registerData = RegisterData(
                                    app_status: statusController.text,
                                  );

                                  dynamic result = PostDatabaseService(
                                          registerid:
                                              widget.registerData.register_ID)
                                      .updateRegisterStatus(
                                          time, registerData, context)
                                      .whenComplete(() {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    showSuccessSnackBar(
                                        'Status Updated !', context);
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
      value: controller.text,
      onChanged: (value) {
        controller.text = value!;
      },
      validator: (value) =>
          value == null ? "This field can't leave empty!" : null,
    );
  }
}
