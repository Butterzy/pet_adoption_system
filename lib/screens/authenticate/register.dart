import 'package:flutter/material.dart';
import 'package:pet_adoption_system/services/auth.dart';
import 'package:pet_adoption_system/shared/constants.dart';

class Register extends StatefulWidget {
  final toggleView;

  const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool isLoading = false;
  bool isObsure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.indigo[100],
            
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Registration',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  widget.toggleView();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.indigo),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      opacity: 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 50,
                  right:  50,
                  child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                      bottomLeft: Radius.circular(45),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 3.0),
                          blurRadius: 5.0),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height - 450,
                  width: MediaQuery.of(context).size.width - 100,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                        child: Text(
                          "Sign Up",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 20.0),
                            buildEmailForm(
                                emailController, 'Email', emailValidator),
                            const SizedBox(height: 20.0),
                            buildNameForm(firstNameController, 'First Name',
                                firstNameValidator),
                            const SizedBox(height: 20.0),
                            buildNameForm(lastNameController, 'Last Name',
                                lastNameValidator),
                            const SizedBox(height: 20.0),
                            buildPasswordForm(passwordController, 'Password',
                                passwordValidator, TextInputAction.next),
                            const SizedBox(height: 20.0),
                            buildPasswordForm(
                                confirmPasswordController,
                                'Confirm Password',
                                confirmPasswordValidator,
                                TextInputAction.done),
                            const SizedBox(height: 30.0),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          emailController.text,
                                          passwordController.text,
                                          firstNameController.text,
                                          lastNameController.text);
                                  if (result == null) {
                                    setState(() {
                                      error = 'Please supply a valid email';
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width /4,45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.indigo),
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
                    ],
                  ),
                              ),
                ),]
            ),
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
      style: const TextStyle(color: Colors.white),
      decoration: textInputDecoration.copyWith(
        enabled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: false,
        prefixIcon: const Icon(
          Icons.mail_sharp,
          color: Colors.white,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  TextFormField buildPasswordForm(
      TextEditingController controller,
      String hintText,
      String? validator(value),
      TextInputAction textInputAction) {
    return TextFormField(
      controller: controller,
      obscureText: isObsure,
      textInputAction: textInputAction,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: textInputDecoration.copyWith(
          enabled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: hintText,
          labelStyle: const TextStyle(color: Colors.white),
          filled: false,
          prefixIcon: const Icon(
            Icons.vpn_key_sharp,
            color: Colors.white,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObsure = !isObsure;
                  if (textFieldFocusNode.hasPrimaryFocus) return;
                  textFieldFocusNode.canRequestFocus = false;
                });
              },
              child: Icon(
                isObsure ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ))),
    );
  }

  TextFormField buildNameForm(TextEditingController controller, String hintText,
      String? validator(value)) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: controller,
      textInputAction: TextInputAction.next,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: textInputDecoration.copyWith(
        enabled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: false,
        prefixIcon: const Icon(
          Icons.account_circle_rounded,
          color: Colors.white,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  String? confirmPasswordValidator(value) {
    if (value.isEmpty) {
      return 'Confirm password is required';
    }
    if (passwordController.text.compareTo(value) == 0) {
      return null;
    } else {
      return 'Confirm Password Must Same As Password';
    }
  }
}
